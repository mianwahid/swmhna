import streamlit as st
import os
from Foundry.Foundry import foundry
from InvariantGenerator.InvariantGenerator import InvariantGenerator

# from CompilingAgent.CompilingAgent import CompilingAgent


current_dir = os.getcwd()
def sideBar():
    with st.sidebar:
        st.title("🔍🔒 Smart Auditor Pro")

        llmModel = st.selectbox("Select a model:", ["gemini-1.0-pro","gemini-1.5-advanced","gpt-4","gpt-3.5"])
        prompt_technique = st.selectbox("Select Prompt :", ["zero-shot","few-shot","Prompt chaining"])

        st.markdown("---")
        st.markdown(
            "## How to use\n"
            "1. Upload Smart contract file 📄\n"
            "2. Provide description to customize invariants 💬\n"
        )
        return llmModel,prompt_technique


def remappinginput():
    # Initialize the input_text variable in st.session_state
    if 'input_text' not in st.session_state:
        st.session_state.input_text = ''

    # Get multiline input from the user
    user_input = st.text_area("Add remappings:", value=st.session_state.input_text, key='1')

    # Row for buttons
    col1, col2,col3 = st.columns([1, 1,1])
    with col1:
        auto_remapping_button = st.button("Auto Remapping")
        if auto_remapping_button:
            foundry.auto_remappings()
            remappingtext=""
            with open(f'{os.getcwd()}/FoundryProject/remappings.txt', 'r') as file:
                remappingtext = file.read()
            st.session_state.input_text = remappingtext
            st.success("Auto Remapping Successful.")
            st.rerun()

    with col2:
        # Center-align the button
        add_button = st.button("Add Remapping")
        if add_button:
            # Check if user input is not empty
            if user_input.strip():
                # File path
                current_dir = os.getcwd()
                file_path = f'{current_dir}/FoundryProject/remappings.txt'

                # Create file if it doesn't exist
                if not os.path.exists(file_path):
                    open(file_path, 'w').close()

                # Append user input to the file
                with open(file_path, "w") as file:
                    file.write(user_input.strip() + "\n")

                st.success("Remappings Successfully Added.")
                # Clear text_area


                st.rerun()

    with col3:

        clear_button = st.button("Clear Remappings")
        if clear_button:
            # File path
            current_dir = os.getcwd()
            file_path = f'{current_dir}/FoundryProject/remappings.txt'

            # Clear the content of the file
            with open(file_path, "w") as file:
                pass
            del st.session_state.input_text
            st.success("Remappings Cleared.")
            # Clear text.")
            # Clear text_area
            st.rerun()

# Function to handle input src zip file
def input_files():
    # Project Input: User uploads a .zip file
    uploaded_zip = st.file_uploader("Choose your project's .zip file", type="zip")
    
    # If a .zip file is uploaded
    if uploaded_zip is not None:
        remappinginput()
        with st.spinner("Compiling the contracts..."):
            if st.button("Compile Project"):
                # Foundry project path
                foundry_path = f'{current_dir}/FoundryProject/src/'
                # Create Foundry project
                if foundry.dir_existence(foundry_path) == False:
                    foundry.clear_foundry()
                    foundry.create_src(uploaded_zip, foundry_path)
                else:
                    foundry.clear_foundry()
                    foundry.create_src(uploaded_zip, foundry_path)
                # Compile Project
                output=(foundry.forge_build())

                if "Error" in output:
                    st.error(output)
                    st.session_state.compilable=False
                    return False
                else:
                    st.success(output)
                    st.session_state.compilable=True
                    st.session_state.custom_invariants = {}
                    return True
    else:
        st.session_state.compilable=False
        st.session_state.generated=False
        st.session_state.custom_invariants = {}

def generate_invariants(llmmodel,prompt_technique):
    foundry_path = f'{current_dir}/FoundryProject/'

    try:
        if 'custom_invariants' not in st.session_state.keys():
            print("Not in state")
            st.session_state.custom_invariants = {}

        contracts_file_name = "src/"

        # Get list of smart contract filenames
        contractpath = st.text_input("Enter the path of the contracts files")
        contracts_file_name = contracts_file_name + contractpath

        contract_files = [file for file in os.listdir(os.path.join(foundry_path, contracts_file_name)) if file.endswith('.sol')]

        selected_contract = st.selectbox("Select a contract:", contract_files,key="selectbox")

        # Initialize custom invariants for the selected contract if it doesn't exist
        value=""
        if selected_contract in st.session_state.custom_invariants.keys():
            if st.session_state.custom_invariants[selected_contract]:
                value=st.session_state.custom_invariants[selected_contract]
            else:
                del st.session_state.custom_invariants[selected_contract]

        # Text area for custom invariants
        custom_invariants_text = st.text_area(f"Enter custom invariants for {selected_contract}:", key=selected_contract, value=value)


        if st.button("Add Custom Invariants"):
            # Update custom invariants for the selected contract
            if custom_invariants_text.strip():
                st.session_state.custom_invariants[selected_contract] =  custom_invariants_text.strip()
                st.success("Custom invariants added successfully.")
                print(st.session_state.custom_invariants)
        checked_files = {}

        # Display checkboxes and store their state
        st.text("Select files to create test invariants:")
        for file in contract_files:
            checked_files[file] = st.checkbox(file)

        # Filter the selected files
        selected_files = [file for file, checked in checked_files.items() if checked]

        if st.button("Generate Invariants"):
            with st.spinner("Generating invariants..."):
                # Pass custom invariants dictionary to InvariantGenerator
                IG = InvariantGenerator(foundry_path, contracts_file_name, llmmodel)
                IG.process_contracts(
                    st.session_state.custom_invariants if "custom_invariants" in st.session_state else {},
                    prompt_technique,selected_files)
                print(st.session_state.custom_invariants)
                st.success("Invariants generated successfully.")
                st.session_state.generated = True
                IG.view_test_contract()





    except Exception as e:
        st.session_state.generated = False
        st.error(f"Error: {e}")

def compile_invariants():
    foundry_path = f'{current_dir}/FoundryProject/'
    try:
        contracts_file_name="src/"
        if st.button("Compile Invariants"):
            with st.spinner("Compiling invariants..."):
                # compiling_agent = CompilingAgent(current_dir,"FoundryProject","src/")
                # result = compiling_agent.interact_with_agent()
                st.success("Invariants compiled successfully.")
    except Exception as e:
        st.error(f"Error: {e}")

# Function to zip a folder


#openzeppelin/contracts/=lib/openzeppelin-contracts/contracts/
if __name__ == '__main__':
    if 'compilable' not in st.session_state:
        st.session_state.compilable = False
    if 'generated' not in st.session_state:
        st.session_state.generated = False

    llmmodel,prompt_technique=sideBar()
    #  Main page
    st.title("🔍🔒 Smart Auditor Pro")
    input_files()
    if st.session_state.compilable:
        generate_invariants(llmmodel,prompt_technique)
    # if st.session_state.generated:
        # compile_invariants()
