import json
from openai import OpenAI
import os
import sqlite3
from time import time

print("Running db_bot.py (Pizza Restaurant)!")

fdir = os.path.dirname(__file__)
def getPath(fname):
    return os.path.join(fdir, fname)

# SQLITE
sqliteDbPath = getPath("aidb.sqlite")
setupSqlPath = getPath("setup.sql")
setupSqlDataPath = getPath("setupData.sql")

# Erase previous db
if os.path.exists(sqliteDbPath):
    os.remove(sqliteDbPath)

sqliteCon = sqlite3.connect(sqliteDbPath)  # create new db
sqliteCursor = sqliteCon.cursor()
with (
    open(setupSqlPath, encoding="utf-8") as setupSqlFile,
    open(setupSqlDataPath, encoding="utf-8") as setupSqlDataFile
):
    setupSqlScript = setupSqlFile.read()
    setupSQlDataScript = setupSqlDataFile.read()

sqliteCursor.executescript(setupSqlScript)  # setup tables and keys
sqliteCursor.executescript(setupSQlDataScript)  # seed data

def runSql(query):
    result = sqliteCursor.execute(query).fetchall()
    return result

# OPENAI
configPath = getPath("config.json")
print(configPath)
with open(configPath) as configFile:
    config = json.load(configFile)

openAiClient = OpenAI(api_key=config["openaiKey"])
openAiClient.models.list()  # quick key check

def getChatGptResponse(content):
    stream = openAiClient.chat.completions.create(
        model="gpt-4o",
        messages=[{"role": "user", "content": content}],
        stream=True,
    )
    responseList = []
    for chunk in stream:
        if chunk.choices[0].delta.content is not None:
            responseList.append(chunk.choices[0].delta.content)
    return "".join(responseList)

# -----------------------------------------------------------------
# strategies
commonSqlOnlyRequest = (
    " Give me a sqlite SELECT statement that answers the question. "
    "Only respond with sqlite syntax. If there is an error do not explain it!"
)

strategies = {
    "zero_shot": setupSqlScript + commonSqlOnlyRequest,
    "single_domain_double_shot": (
        setupSqlScript
        + " Example: List all crust names.\n"
        + " SELECT name FROM Crust ORDER BY name;\n "
        + commonSqlOnlyRequest
    ),
    "cross_domain_double_shot": (
        setupSqlScript
        + " Example 1: Find average rating of books published after 2015.\n"
        + " SELECT AVG(rating) FROM books WHERE publish_year > 2015;\n\n"
        + " Example 2: List employees who joined after 2020.\n"
        + " SELECT emp_id, name FROM employees WHERE hire_date > '2020-01-01';\n\n"
        + " Now: Which store has the highest total sales?\n"
        + " SELECT s.name, SUM(o.total_amount) AS total "
        + "FROM 'Order' o JOIN Store s ON s.store_id = o.store_id "
        + "GROUP BY s.store_id, s.name ORDER BY total DESC LIMIT 1;\n "
        + commonSqlOnlyRequest
    ),
}

questions = [
    "Which store has the highest total sales?",
    "List each customer and how many orders they have placed.",
    "Which orders were deliveries and to which cities?",
    "Show each pizza with its size and a comma-separated list of toppings.",
    "What are the top 3 most popular toppings by usage count?",
    "For each store, how many pizzas were sold?",
]

def sanitizeForJustSql(value):
    gptStartSqlMarker = "```sql"
    gptEndSqlMarker = "```"
    if gptStartSqlMarker in value:
        value = value.split(gptStartSqlMarker)[1]
    if gptEndSqlMarker in value:
        value = value.split(gptEndSqlMarker)[0]
    return value.strip()

for strategy in strategies:
    responses = {"strategy": strategy, "prompt_prefix": strategies[strategy]}
    questionResults = []
    print("########################################################################")
    print(f"Running strategy: {strategy}")
    for question in questions:
        print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
        print("Question:")
        print(question)
        error = "None"
        try:
            prompt = strategies[strategy] + " " + question
            sqlSyntaxResponse = getChatGptResponse(prompt)
            sqlSyntaxResponse = sanitizeForJustSql(sqlSyntaxResponse)
            print("SQL Syntax Response:")
            print(sqlSyntaxResponse)
            queryRawResponse = str(runSql(sqlSyntaxResponse))
            print("Query Raw Response:")
            print(queryRawResponse)
            friendlyResultsPrompt = (
                'I asked a question "'
                + question
                + '" and the response was "'
                + queryRawResponse
                + '" Please, just give a concise response in a more friendly way? '
                "Please do not give any other suggests or chatter."
            )
            
            friendlyResponse = getChatGptResponse(friendlyResultsPrompt)
            print("Friendly Response:")
            print(friendlyResponse)
        except Exception as err:
            error = str(err)
            print(err)

        questionResults.append(
            {
                "question": question,
                "sql": sqlSyntaxResponse,
                "queryRawResponse": queryRawResponse,
                "friendlyResponse": friendlyResponse,
                "error": error,
            }
        )

    responses["questionResults"] = questionResults
    with open(getPath(f"response_{strategy}_{time()}.json"), "w") as outFile:
        json.dump(responses, outFile, indent=2)

sqliteCursor.close()
sqliteCon.close()
print("Done!")