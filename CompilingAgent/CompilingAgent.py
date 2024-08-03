import glob
import re
import subprocess
from langchain.agents import initialize_agent, AgentType
import langchain_core.runnables as r
from langchain_core.tools import tool
from langchain.prompts import PromptTemplate
import concurrent.futures
import os
from langchain_openai import ChatOpenAI
import shutil
from FYP.Prompts import prompts
# from Prompts import prompts
from solidity_parser import parser

from langchain_google_genai import ChatGoogleGenerativeAI,GoogleGenerativeAI

os.environ["GOOGLE_API_KEY"] = "Your GEMINI API Key"
os.environ["OPENAI_API_KEY"] = "Your OPENAI API Key"


class CompilingAgent:
    def __init__(self,absolutepath,foundrypath,contractfolder):
        self.absolutepath = os.path.join(absolutepath,foundrypath)#"/home/wahid/Desktop/NewFolder/foundry/"
        self.contractfolder =contractfolder #"src/contracts/libraries"
        self.tempcompiler = self.check_and_copy(absolutepath,foundrypath)#"/home/wahid/PycharmProjects/pythonProject/compiler"

        self.llm = ChatOpenAI(model_name="gpt-4o", temperature=0)
        # self.llm = ChatOpenAI(model_name="gpt-4-0125-preview", temperature=0)
        # self.llm = ChatOpenAI(model_name="gpt-3.5-turbo-0125", temperature=0)
        # self.llm = GoogleGenerativeAI(model="gemini-1.5-pro-latest", temperature=0, request_timeout=1200)

        self.agent_type = AgentType.CHAT_ZERO_SHOT_REACT_DESCRIPTION
        self.check_and_copy(absolutepath,foundrypath)
        self.folder_path = os.path.join(self.absolutepath, self.contractfolder)
        self.remove_text_files()
        # self.llm = ChatGoogleGenerativeAI(
        #     model="gemini-1.5-pro-latest",
        #     convert_system_message_to_human=True,
        #     verbose=True,
        #     temperature=0,
        #     request_timeout=360
        # )

    def remove_text_files(self):
        text_files = glob.glob(os.path.join(self.tempcompiler, '*.txt'))
        for file_path in text_files:
            if os.path.basename(file_path) != 'remappings.txt':
                os.remove(file_path)

    def check_and_copy(self, absolutepath, foundryproject):
        # Combine the last folder name with "Compiler" to create the new folder name
        compiler_folder_name = f"{foundryproject}Compiler"
        compiler_folder = os.path.join(absolutepath, compiler_folder_name)

        if not os.path.exists(compiler_folder):
            # Create the new folder
            os.makedirs(compiler_folder)

        foundry_folder = os.path.join(absolutepath, foundryproject)
        for item in os.listdir(foundry_folder):
            item_path = os.path.join(foundry_folder, item)
            if os.path.isdir(item_path) and item not in ["src", "test"]:
                # Check if destination directory already exists
                dest_dir = os.path.join(compiler_folder, item)
                if not os.path.exists(dest_dir):
                    # Copy directory
                    shutil.copytree(item_path, dest_dir)
                else:
                    print(f"Destination directory '{dest_dir}' already exists. Skipping...")
            elif os.path.isfile(item_path):
                # Copy file
                shutil.copy2(item_path, compiler_folder)

        return compiler_folder

    def read_sol_code(self, path):
        try:
            with open(path, "r") as file:
                sol_code_content = file.read()
                return sol_code_content
        except FileNotFoundError:
            print(f"File '{path}' not found.")
            return ""

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

    def check_directory_existence(self, directory_path):
        return os.path.isdir(directory_path)

    def run_subprocess(self, cmd, base_directory):
        try:
            subprocess.run(cmd, shell=True, check=True)
            print(f"Command '{cmd}' executed successfully in {base_directory}.")
        except subprocess.CalledProcessError as e:
            # Handle error
            pass

    def change_os_directory(self, path):
        os.chdir(path)

    def read_smart_contracts(self):
        folder_path = f"{self.absolutepath}/{self.contractfolder}"
        contract_list = []
        for filename in os.listdir(folder_path):
            if filename.endswith(
                ".sol"
            ):  # Assuming smart contract files have .sol extension
                contract_data = {}
                with open(os.path.join(folder_path, filename), "r") as file:
                    contract_data["filename"] = filename
                    contract_data["code"] = file.read()
                    contract_list.append(contract_data)
        return contract_list

    def extract_pre_contract(self,contract_code):
        lines = contract_code.split('\n')

        contract_start_index = None
        for i, line in enumerate(lines):
            if line.strip().startswith("contract "):
                contract_start_index = i
                break
        if contract_start_index is None:
            return ""

        pre_contract_lines = lines[:contract_start_index]

        return '\n'.join(pre_contract_lines)

    def run_foundry(self, filename):
        # Counter.t.sol
        projectName = "FoundryTest"
        current_dir = os.getcwd()
        base_directory = (
            f"{current_dir}/{projectName}"
            if self.check_directory_existence(f"{current_dir}/{projectName}")
            else f"{current_dir}/"
        )
        base_directory = self.tempcompiler
        outputfile = filename.replace(".t.sol", ".txt")
        self.change_os_directory(base_directory)

        path=os.path.join(self.absolutepath,os.path.join("test",filename))
        if os.path.exists(path):
            self.run_subprocess(
                f"/home/wahid/.foundry/bin/forge compile --contracts {path} 2>&1 | sed -r 's/\x1B\[[0-9;]*[mK]//g' > {outputfile}",
                base_directory,
            )


    def checkcompileable(self,filename):
        outputfiles=[]
        testfiles=[]
        for i in range(len(filename)):
            outputfiles.append(filename[i])
            testfiles.append(filename[i])
            outputfiles[i]=outputfiles[i].replace(".sol",".txt")
            testfiles[i]=testfiles[i].replace(".sol",".t.sol")

        errorfiles=[]
        for i in range(len(testfiles)):
            try:
                self.run_foundry(testfiles[i])
                status = ""
                with open(os.path.join(self.tempcompiler, outputfiles[i]), "r") as file:
                    status = file.read()
                if "error" in status or "Error" in status:
                    errorfiles.append(filename[i])
            except Exception as e:
                pass
        return errorfiles


    def initialize_agent(self, filename):
        @tool
        def compile_testcontractfile(filecontent:str):
            """
            Useful for compiling the solidity code.\
            It will place code in file and run foundry compiler.\
            Also pass import statements \
            It will success message if there is no compiler error in the code and \
            it will return error if there exist some error in the code\
            It take input the source code of the solidity.\
            Use this if you want to find some error in the solidity code.
            """
            try:
                with open(os.path.join(os.path.join(self.absolutepath,"test"),filename), "w") as file:
                    file.write(filecontent)
                self.run_foundry(filename)
                outputfile = filename.replace(".t.sol", ".txt")
                status = ""
                with open(os.path.join(self.tempcompiler,outputfile), "r") as file:
                    status = file.read()
                print(status)
                return status
            except Exception as e:
                return str(e)

        agent = initialize_agent(
            [compile_testcontractfile],
            self.llm,
            agent=self.agent_type,
            handle_parsing_errors=True,
            verbose=True,
            max_execution_time=36000,
        )
        return agent

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
                    print("path exist")
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
                        print("path exist 2")
                        with open(os.path.join(self.folder_path, path), "r") as file:
                            referencecontracts += i["path"] + ":\n" + file.read() + "\n\n"
            except Exception as e:
               (e)
        return referencecontracts

    def interact_with_agent(self):

        contracts = self.read_smart_contracts()

        contractfilename=[]
        for contract in contracts:
            contractfilename.append(contract["filename"])

        File_list=self.checkcompileable(contractfilename)
        contracts = [entry for entry in contracts if entry['filename'] in File_list]
        print(File_list)
        agentsdic = {}

        with concurrent.futures.ThreadPoolExecutor() as executor:
            futures = []
            for contract in contracts:
                testfile = contract["filename"].replace(".sol", ".t.sol")
                tstfile = self.read_sol_code(os.path.join(os.path.join(self.absolutepath,"test"),testfile))
                references=self.find_references(contract["code"])
                prompttemplate = prompts.compiling_agent_prompt(contract["code"],tstfile,references)
                print("------------------------")
                agent = (
                        r.RunnablePassthrough()
                        | prompttemplate
                        | self.initialize_agent(testfile)
                )

                future = executor.submit(agent.invoke, {"input": ""})
                futures.append(future)

            # Wait for all futures to complete
            for future in concurrent.futures.as_completed(futures):
                pass


compiling_agent = CompilingAgent("/home/wahid/PycharmProjects/pythonProject/FYP/","FoundryProject","src/utils/")
result = compiling_agent.interact_with_agent()
print(result)
