import subprocess
import os
import shutil
import zipfile

class Foundry:
    def __init__(self):
        self.current_dir=os.getcwd()
        pass

    @staticmethod
    def dir_existence(directory_path):
        return os.path.isdir(directory_path)

    @staticmethod
    def run_subprocess(cmd, base_directory):
        try:
            subprocess.run(cmd, shell=True, check=True)
            print(f"Command '{cmd}' executed successfully in {base_directory}.")
        except subprocess.CalledProcessError as e:
            print(f"Error executing command: {e}")

    def create_foundry(self):
        current_dir = self.current_dir
        self.run_subprocess("forge init FoundryProject --no-commit", current_dir)
        foundry_path = os.path.join(current_dir, "FoundryProject")
        self.run_subprocess("rm -rf src/*", foundry_path)
        self.run_subprocess("rm -rf test/*", foundry_path)

    def clear_foundry(self):
        current_dir = self.current_dir
        foundry_path = os.path.join(current_dir, "FoundryProject")
        os.chdir(current_dir)
        self.run_subprocess("rm -r Output/*", foundry_path)
        os.chdir(foundry_path)
        self.run_subprocess("rm -r src/*", foundry_path)
        self.run_subprocess("rm -r test/*", foundry_path)
        os.chdir(current_dir)

    def auto_remappings(self):
        current_dir = self.current_dir
        foundry_path = os.path.join(current_dir, "FoundryProject")
        os.chdir(foundry_path)
        self.run_subprocess("forge remappings > remappings.txt", foundry_path)
        self.run_subprocess("echo 'openzeppelin/contracts/=lib/openzeppelin-contracts/contracts/' >> remappings.txt", foundry_path)
        os.chdir(current_dir)

    def clear_test(self):
        current_dir = self.current_dir
        foundry_path = os.path.join(current_dir, "FoundryProject")
        os.chdir(foundry_path)
        self.run_subprocess("rm -r test/*", foundry_path)
        os.chdir(current_dir)

    @staticmethod
    def create_src(uploaded_zip, foundry_path):
        with zipfile.ZipFile(uploaded_zip, 'r') as zf:
            zf.extractall(foundry_path)

    def forge_build(self):
        current_dir = self.current_dir
        base_directory = os.path.join(current_dir, "FoundryProject")
        os.chdir(base_directory)
        self.run_subprocess("forge build 2>&1 | sed -r 's/\x1B\[[0-9;]*[mK]//g' > ../Output/build_output.txt", base_directory)
        os.chdir(current_dir)
        with open(os.path.join(current_dir, "Output/build_output.txt"), "r") as file:
            return file.read()

    def forge_test(self):
        current_dir = self.current_dir
        base_directory = os.path.join(current_dir, "FoundryProject")
        os.chdir(base_directory)
        self.run_subprocess("forge test", base_directory)
        os.chdir(current_dir)

    def delete_foundry(self):
        current_dir = self.current_dir
        base_directory = os.path.join(current_dir, "FoundryProject")
        try:
            shutil.rmtree(base_directory)
            print(f"Foundry project at {base_directory} has been deleted.")
        except FileNotFoundError:
            print(f"Foundry project at {base_directory} not found.")
        except Exception as e:
            print(f"Error deleting Foundry project: {e}")

    @staticmethod
    def move_to_main_dir():
        os.chdir("../..")
        os.chdir("../..")
        print(f"Current directory moved up two levels: {os.getcwd()}")

    @staticmethod
    def create_and_write_to_test(test_folder_path, content):
        file_path = os.path.join(test_folder_path, "Test.t.sol")
        with open(file_path, "w") as file:
            file.write(content)
        print(f"File 'Test.t.sol' created and content written in {test_folder_path}.")



foundry=Foundry()