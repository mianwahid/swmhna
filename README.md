# Project Setup Instructions

## 1. Clone the GitHub Repository
First, clone the repository by running the following command:

```bash
git clone https://github.com/mianwahid/swmhna
```
## 2. Navigate to the Project Directory
Change into the cloned repository directory:

```bash
cd swmhna
```
## 3. Install Dependencies
Install all the necessary dependencies by running:

```bash
pip install -r requirements.txt
```
## 4. Add API Keys
You need to add your API keys in the InvariantGenerator.py file at line 16 and 17 :

![image](https://github.com/user-attachments/assets/636f1aab-e2ea-4586-9642-91c20ff47158)


```python
os.environ["GOOGLE_API_KEY"] = "Your Google API Key"
os.environ["OPENAI_API_KEY"] = "Your OpenAI API Key"
```
## 5. Run the Application
To start the application, run the following command in your terminal:

```bash
streamlit run view.py
```

## 6. Access the Application
Once the application is running, open your browser and navigate to:

![image](https://github.com/user-attachments/assets/16b41091-9a8b-4f1c-b93a-1ac4e8e3bd9f)

Local URL: http://localhost:8501
Network URL: Use the provided network URL if you are on a different device on the same network.
## 7. Use the Application

1. **A UI will be visible where you can select your LLM or prompt template from the sidebar.**

      ![image](https://github.com/user-attachments/assets/515ddfc2-0b79-4b4b-af26-f4e569dc0554)


2. **Upload your .zip file containing all the source contracts.**

      ![image](https://github.com/user-attachments/assets/ded7ab0a-a33e-4476-aa46-dff84a651917)


3. **You can choose to auto remaping or add your custom remappings. You can also clear the remappings.**

      ![image](https://github.com/user-attachments/assets/25d26d6c-d0a7-4352-acda-1d23218aa8ff)


4. **Compile your project using compile button.**

      ![image](https://github.com/user-attachments/assets/3dbac575-e543-4bc8-8f5a-3e1616faf433)


5. **Then select the path to your desired directory within the .zip file that contains the contracts.**

      ![image](https://github.com/user-attachments/assets/b664c15d-ccd2-40a5-88d7-4bb54d13fe05)


6. **You have the option to add custom invariants, which will be included in the prompts to LLMs.**

      ![image](https://github.com/user-attachments/assets/181db68c-926f-4a5c-a6e7-c246b3415112)


7. **Select the contracts from the given list for which you want to generate test invariants.**

      ![image](https://github.com/user-attachments/assets/6408d30b-4550-45ee-b6a8-68e6e171f17d)


8. **Click the "Generate Invariants" button.**

      ![image](https://github.com/user-attachments/assets/147cec00-2abe-47ca-a813-4146163b9c9c)


9. **A list of generated invariants will be displayed on the screen.**

      ![image](https://github.com/user-attachments/assets/f8f4ed9a-f7aa-44b2-a19d-85b7e3d94a75)

      ![image](https://github.com/user-attachments/assets/9d108688-02e2-4b76-bb61-53aa01d92b78)


10. **You can download the generated invariants using the provided download link.**

      ![image](https://github.com/user-attachments/assets/309e8947-99d8-451b-9aa7-6eec330da530)
