from openai import OpenAI
import json


# I kept the config file simple
# The default config.json stores your API key, developer message, and previous conversation

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

    # This whole function is kind of crude but it works, could likley be made better though
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


class config:
    def __init__(self):
        self.path = ""
        self.API_KEY = ""
        self.DEV_MESSAGE = ""
        self.MODEL = ""
        self.CONVERSATION = []

    # Load the config file's data
    def loadConfig(self, path: str):
        self.path = path

        with open(path, 'r') as config:
            config_data = json.load(config)

        config.close()
    
        # Sets the api key, developer message, and model
        self.API_KEY = config_data["API_KEY"]
        self.DEV_MESSAGE = config_data["DEV_MESSAGE"]
        self.MODEL = config_data["MODEL"]
        self.CONVERSATION = config_data["CONVERSATION"]

    # Updates the config file with the sessions messages
    # Takes the API key, chat log, path to the config, and if the function has been called
    def saveConversation(self, chat_log):
        with open(self.path, 'r+') as config:
            data = json.load(config)
            data["CONVERSATION"] = chat_log
            config.seek(0)
            json.dump(data, config)
            config.truncate()

class OpenAIRequests:
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

    if choice == "Y" or choice == "N":
        return choice == "Y"
    else:
        yesNo(question)

if __name__ == "__main__":
    myConfig = config()

    myConfig.loadConfig(CONFIG_PATH)

    API_KEY, chatLog = myConfig.API_KEY, myConfig.CONVERSATION

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

            response = OpenAIRequests.makeChatRequest(myConfig.MODEL, chatLog)

            # This is here to keep formatting working
            if response[-1] != '\n':
                print("\n", end="")

            chatLog.append({"role": "assistant", "content": response})

    if yesNo("Would you like to save this conversation?"):
        myConfig.saveConversation(chatLog)
    else:
        myConfig.saveConversation([{"role":"developer", "content": myConfig.DEV_MESSAGE}])