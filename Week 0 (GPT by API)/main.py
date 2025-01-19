from openai import OpenAI
import json

"""
I kept the config file simple
The default config.json stores your API key and past conversations

main.py also has a few constants that can be changed like the developer message
and the model being used for responses

I've also included textFeatures in case I want to add some sort of formatting
later on
"""

CONFIG_PATH = "config.json"

# Options for modifiying text in the console, concatonate with the text
# Not in use, can be added later
class textFeatures:
    PURPLE = '\033[95m'
    CYAN = '\033[96m'
    DARKCYAN = '\033[36m'
    BLUE = '\033[94m'
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    RED = '\033[91m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'
    END = '\033[0m'

    # Codes used by assistant mapped to the text feature
    codeMap = {
        "**": BOLD,
        "__": UNDERLINE
    }

    # For now this is just for 2 character format codes, will change if needed
    def formatText(text: str, previousFormatters: list):
        newString = []

        pointer = 0

        while pointer < len(text):
            if text[pointer:pointer + 2] in textFeatures.codeMap.keys():
                for key in textFeatures.codeMap.keys():
                    if text[pointer:pointer + 2] == key:
                        if key in previousFormatters:
                            newString.append(textFeatures.END)
                            previousFormatters.remove(key)
                            pointer += len(key)
                        else:
                            newString.append(textFeatures.codeMap[key])
                            previousFormatters.append(key)
                            pointer += len(key)
            else:
                newString.append(text[pointer])
                pointer += 1

        return ''.join(newString)


# Currently just a few functions, designed to expand for other parameters and operations
class configOps:
    # Load the config file's data
    # Return the API key and previous conversation
    def loadConfig(path: str):
        with open(path, 'r') as config:
            config_data = json.load(config)

        config.close()
        
        # Returns the API key and chat log
        return config_data["config"]["API_KEY"], [message for message in config_data["config"]["Previous Conversation"]]

    # Updates the config file with the sessions messages
    # Takes the API key, chat log, path to the config, and if the function has been called
    def saveConversation(api_key: str, chat_log: str, path: str):
        with open(path, 'r+') as config:
            data = json.load(config)
            data["config"]["API_KEY"] = api_key
            data["config"]["Previous Conversation"] = chat_log
            config.seek(0)
            json.dump(data, config)
            config.truncate()

class OpenAIRequests:
    # For simplicity, there's just two models to choose from
    GPT_4O = "gpt-4o"
    GPT_4O_MINI = "gpt-4o-mini"

    # Setup for formating messages
    DEVMESSAGE = "Please only use CLI friendly formatting, avoid LaTeX and other special formatting systems. To bold text use **, to underline it use __."

    # Makes a request to the given model
    # Returns the response
    def makeChatRequest(modelSelection: str, message: str):
        stream = client.chat.completions.create(
            model=modelSelection,
            messages=message,
            stream=True
        )

        response = ""

        # Previously seen formating keys
        formatters = []

        for chuck in stream:
            if chuck.choices[0].delta.content != None:
                    delta = chuck.choices[0].delta.content

                    delta = textFeatures.formatText(delta, formatters)

                    print(delta, end="")
                    response += delta

        return response

# Quick helper function for prompting yes/no
# Return bool true for yes, false for no
def yesNo(question: str):
    choice = input(question + " (y/n): ").capitalize()

    if choice != "Y" or choice != "N":
        return choice.capitalize() == "Y"
    else:
        yesNo(question)

if __name__ == "__main__":
    API_KEY, chatLog = configOps.loadConfig(CONFIG_PATH)

    if (API_KEY == None or API_KEY == ""):
        raise Exception("Missing API Key")
    else:
        client = OpenAI(api_key=API_KEY)

    message = ""

    print("To end this conversation type /end.")

    if yesNo("Would you like to load your last conversation?"):
        for message in chatLog:
            match message["role"]:
                case "developer":
                    pass

                case "user":
                    print("You: ", textFeatures.formatText(message["content"], []))
                
                case "assistant":
                    print("AI: ", textFeatures.formatText(message["content"], []))
    else:
        chatLog = []

    # Conversation loop
    while message != '/end':
        message = input(">>> ")
        
        if (message != '/end'):
            chatLog.append({"role": "user", "content": message})

            response = OpenAIRequests.makeChatRequest(OpenAIRequests.GPT_4O_MINI, chatLog)

            # This is here to keep formatting working
            if response[-1] != '\n':
                print("\n", end="")

            chatLog.append({"role": "assistant", "content": response})
    
    if yesNo("Would you like to save this conversation?"):
        configOps.saveConversation(API_KEY, chatLog, CONFIG_PATH)
    else:
        configOps.saveConversation(API_KEY, [{"role":"developer", "content": OpenAIRequests.DEVMESSAGE}], CONFIG_PATH)