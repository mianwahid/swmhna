
import os
import re
import streamlit as st
from langchain.prompts import PromptTemplate
from langchain_openai import ChatOpenAI
from langchain_google_genai import GoogleGenerativeAI
from Prompts import prompts
from solidity_parser import parser
import base64
import tiktoken
from zipfile import ZipFile



os.environ["GOOGLE_API_KEY"] = "Your GOOGLE API key"
os.environ["OPENAI_API_KEY"] = "Your OPENAI API Key"


class InvariantGenerator:
    def __init__(self, absolute_path, contracts_file_name,llmmodel):
        self.absolute_path = absolute_path

        self.contracts_file_name = contracts_file_name
        if llmmodel=="gpt-3.5":
            self.modelname= "gpt-3.5"
            self.model = ChatOpenAI(model_name="gpt-3.5-turbo-0125", temperature=0)
        elif llmmodel=="gpt-4":
            self.modelname= "gpt-4"
            self.model = ChatOpenAI(model_name="gpt-4o", temperature=0,max_tokens=4096)
        elif llmmodel=="gemini-1.0-pro":
            self.modelname= "gemini-1.0"
            self.model = GoogleGenerativeAI(model="gemini-1.0-pro", temperature=0,request_timeout=3600)
        else:
            self.modelname= "gemini-1.5"
            self.model = GoogleGenerativeAI(model="gemini-1.5-pro-latest", temperature=0,request_timeout=3600)
        self.chain = PromptTemplate.from_template("{fewshot}") | self.model
        self.strength_chain = PromptTemplate.from_template("{strengthprompt}") | self.model
        self.soundness_chain = PromptTemplate.from_template("{soundnessprompts}") | self.model
        self.folder_path = os.path.join(self.absolute_path, self.contracts_file_name)
        self.contracts = self.read_smart_contracts(self.folder_path)

    def read_smart_contracts(self, folder_path):
        contract_list = []
        print(os.listdir(folder_path))
        print("Reading")
        for filename in os.listdir(folder_path):
            if filename.endswith(".sol"):
                contract_data = {}
                with open(os.path.join(folder_path, filename), "r") as file:
                    contract_data["filename"] = filename
                    contract_data["code"] = file.read()
                    contract_list.append(contract_data)
        return contract_list

    def zip_folder(self,folder_path, zip_path):
        with ZipFile(zip_path, 'w') as zipf:
            for root, _, files in os.walk(folder_path):
                for file in files:
                    file_path = os.path.join(root, file)
                    zipf.write(file_path, os.path.relpath(file_path, folder_path))

    def get_base64_of_bin_file(self,bin_file):
        with open(bin_file, 'rb') as f:
            data = f.read()
        return base64.b64encode(data).decode()

    def view_test_contract(self):
        self.zip_folder(os.path.join(self.absolute_path, 'test'), os.path.join(self.absolute_path, 'test.zip'))
        # st.markdown(f"### [Download Test Invariants]({os.path.join(self.absolute_path, 'test.zip')})")
        zip_base64 = self.get_base64_of_bin_file(os.path.join(self.absolute_path, 'test.zip'))

        # Display download link
        st.markdown(f'<a href="data:application/zip;base64,{zip_base64}" download="output.zip">Download zip file</a>',
                    unsafe_allow_html=True)
        contracts=self.read_smart_contracts(os.path.join(self.absolute_path, 'test'))
        for contract in contracts:
            st.text(contract["filename"])
            st.code(contract["code"])






    def write_smart_contracts(self, folder_path, contracts):
        for contract in contracts:
            filename = contract["filename"]
            code = contract["code"]
            with open(os.path.join(folder_path, filename), "w") as file:
                file.write(code)

    def find_references(self,code):
        parsed=False
        referencecontracts=""
        try:
            ast = parser.parse(code)
            parsed = True
            ast_obj = parser.objectify(ast)
            for i in ast_obj.imports:
                path = i["path"].replace("'", "")
                if os.path.exists(os.path.join(self.folder_path, path)):

                    with open(os.path.join(self.folder_path, path), "r") as file:
                        referencecontracts += i["path"] + ":\n" + file.read() + "\n\n"
        except Exception as e:
            (e)
        if not parsed:
            try:
                code = self.extract_pre_contract(code)
                ast = parser.parse(code)
                ast_obj = parser.objectify(ast)
                for i in ast_obj.imports:
                    path = i["path"].replace("'", "")
                    if os.path.exists(os.path.join(self.folder_path, path)):
                        with open(os.path.join(self.folder_path, path), "r") as file:
                            referencecontracts += i["path"] + ":\n" + file.read() + "\n\n"
            except Exception as e:
               (e)
        return referencecontracts

    def extract_code(self, input_string):
        code_start = input_string.find("```solidity")
        if code_start != -1:
            code_end = input_string.rfind("```")
            if code_end != -1:
                return input_string[code_start + 11 : code_end].strip()

        code_start = input_string.find("```\nsolidity")
        if code_start != -1:
            code_end = input_string.rfind("```")
            if code_end != -1:
                return input_string[code_start + 12 : code_end].strip()

        code_start = input_string.find("```")
        if code_start != -1:
            code_end = input_string.rfind("```")
            if code_end != -1:
                return input_string[code_start + 3 : code_end].strip()

        return input_string

    def extract_pre_contract(self,contract_code):
        lines = contract_code.split('\n')

        contract_start_index = None
        for i, line in enumerate(lines):
            if line.strip().startswith("contract ") or line.strip().startswith("library ") or line.strip().startswith("interface "):
                contract_start_index = i
                break
        if contract_start_index is None:
            return ""

        pre_contract_lines = lines[:contract_start_index]

        return '\n'.join(pre_contract_lines)


    def process_contracts(self, custom_invariants,prompt_technique,selected_files):
        chain_prompts = []
        tempcontracts = []
        encoding = tiktoken.encoding_for_model("gpt-3.5-turbo")
        input_token_count=0
        output_token_count=0


        # for contract in [self.contracts[33]]:
        for contract in [contract for contract in self.contracts if contract["filename"] in selected_files]:
            tempcontracts.append(contract)
            pragma = ""
            custom_invariant=""
            if contract["filename"] in custom_invariants:
                custom_invariant = "\nAlso make some custom test invariants whose detail is as follow:\n"+custom_invariants[contract["filename"]]+"\n\n"
            contract_name = contract["filename"].split(".")[0]
            referencecontracts=""
            parsed=False
            try:
                ast=parser.parse(contract["code"])
                parsed = True
                ast_obj = parser.objectify(ast)
                contract_name = (list(ast_obj.contracts.keys()))[0]
                pragma=ast_obj.pragmas[0]["value"]
                referencecontracts=self.find_references(contract["code"])

            except Exception as e:
                print(e)
            if not parsed:
                try:
                    code=self.extract_pre_contract(contract["code"])
                    ast = parser.parse(code)
                    ast_obj = parser.objectify(ast)
                    pragma = ast_obj.pragmas[0]["value"]
                    referencecontracts=self.find_references(code)
                except Exception as e:
                    version_match = re.search(r'pragma\s+solidity\s+(.*?);', contract["filename"])
                    pragma = version_match.group() if version_match else "pragma solidity ^0.8.0;"
                    print(e)

            tempcontracts[-1]["pragma"]=pragma
            tempcontracts[-1]["contract_name"]=contract_name
            tempcontracts[-1]["referencecontracts"]=referencecontracts
            tempcontracts[-1]["custom_invariant"]=custom_invariant

        self.contracts = tempcontracts

        if prompt_technique=="Prompt chaining":
            prompt1=[]
            for i,t in enumerate(tempcontracts):
                prompttext = prompts.promptchain_1(t["code"],t["referencecontracts"])
                prompt1.append({"fewshot": prompttext})

            res1 = (self.chain.batch(prompt1))
            if not (type(res1[0]) == type("a")):
                for i in range(len(res1)):
                    res1[i] = res1[i].content

            print("Contract functionalities generated.")

            output_contracts=[]

            # saving first resonse in the files
            for i in range(len(res1)):
                extractedcode=res1[i]
                name = self.contracts[i]["filename"].replace(".sol", "1.txt")
                output_contracts.append({"filename": name, "code": extractedcode})
                # output_token_count+=len(encoding.encode(extractedcode))

            self.write_smart_contracts(os.path.join(self.absolute_path, 'test'), output_contracts)

            prompt2=[]
            for i, t in enumerate(tempcontracts):
                prompttext = prompts.promptchain_2(t["code"], t["referencecontracts"],res1[i])
                prompt2.append({"fewshot": prompttext})

            res2 = (self.chain.batch(prompt2))
            if not (type(res2[0]) == type("a")):
                for i in range(len(res2)):
                    res2[i] = res2[i].content

            print("Test invariants lists generated..")

            output_contracts = []

            # saving first resonse in the files
            for i in range(len(res2)):
                extractedcode = res2[i]
                name = self.contracts[i]["filename"].replace(".sol", "2.txt")
                output_contracts.append({"filename": name, "code": extractedcode})
                # output_token_count+=len(encoding.encode(extractedcode))


            self.write_smart_contracts(os.path.join(self.absolute_path, 'test'), output_contracts)

            prompt3=[]
            for i,t in enumerate(tempcontracts):
                prompttext = prompts.promptchain_3(t["code"],t["pragma"], t["contract_name"] ,self.contracts_file_name,t["referencecontracts"],t["custom_invariant"],self.modelname,res2[i])
                prompt3.append({"fewshot": prompttext})
                input_token_count+=len(encoding.encode(prompttext))

            output_contracts = []
            ans = (self.chain.batch(prompt3))
            if not (type(ans[0]) == type("a")):
                for i in range(len(ans)):
                    ans[i] = ans[i].content

            for i in range(len(ans)):
                extractedcode=self.extract_code(ans[i])
                name = self.contracts[i]["filename"].replace(".sol", ".t.sol")
                output_contracts.append({"filename": name, "code": extractedcode})
                output_token_count+=len(encoding.encode(extractedcode))

            self.write_smart_contracts(os.path.join(self.absolute_path, 'test'), output_contracts)
            print("--------------------------------------------")
            print("Total Input token: ",input_token_count)
            print("Total Output token: ",output_token_count)
            print("--------------------------------------------")
        elif prompt_technique=="zero-shot":
            prompt1 = []
            for i, t in enumerate(tempcontracts):
                p1,p2,prompttext = prompts.zeroShot(t["code"], t["pragma"], t["contract_name"], self.contracts_file_name,
                                                   t["referencecontracts"], t["custom_invariant"], self.modelname)
                prompt1.append({"fewshot": prompttext})
                input_token_count += len(encoding.encode(prompttext))

            res1 = (self.chain.batch(prompt1))
            if not (type(res1[0]) == type("a")):
                for i in range(len(res1)):
                    res1[i] = res1[i].content

            output_contracts = []

            # saving first resonse in the files
            for i in range(len(res1)):
                extractedcode = self.extract_code(res1[i])
                name = self.contracts[i]["filename"].replace(".sol", ".t.sol")
                output_contracts.append({"filename": name, "code": extractedcode})
                output_token_count += len(encoding.encode(extractedcode))


            self.write_smart_contracts(os.path.join(self.absolute_path, 'test'), output_contracts)
            print("--------------------------------------------")
            print("Total Input token: ",input_token_count)
            print("Total Output token: ",output_token_count)
            print("--------------------------------------------")
        elif prompt_technique=="few-shot":
            prompt1 = []
            for i, t in enumerate(tempcontracts):
                prompttext = prompts.solady_fewShot(t["code"], t["pragma"], t["contract_name"], self.contracts_file_name,
                                              t["referencecontracts"], t["custom_invariant"], self.modelname)
                prompt1.append({"fewshot": prompttext})
                input_token_count += len(encoding.encode(prompttext))

            res1 = (self.chain.batch(prompt1))
            if not (type(res1[0]) == type("a")):
                for i in range(len(res1)):
                    res1[i] = res1[i].content

            output_contracts = []

            # saving first resonse in the files
            for i in range(len(res1)):
                extractedcode = self.extract_code(res1[i])
                name = self.contracts[i]["filename"].replace(".sol", ".t.sol")
                output_contracts.append({"filename": name, "code": extractedcode})
                output_token_count += len(encoding.encode(extractedcode))

            self.write_smart_contracts(os.path.join(self.absolute_path, 'test'), output_contracts)
            print("--------------------------------------------")
            print("Total Input token: ", input_token_count)
            print("Total Output token: ", output_token_count)
            print("--------------------------------------------")


        return True

# inv=InvariantGenerator("/home/wahid/PycharmProjects/pythonProject/FYPEvaluation/FYP/FoundryProject","src/").process_contracts()


