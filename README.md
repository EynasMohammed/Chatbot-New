# SDA-bootcamp-project

Stage 1 - Basic Chatbot

A basic chatbot using streamlit and openai api.

Store your `OPENAI_API_KEY` in `.env` file. Run

```
streamlit run chatbot.py
```
to run the app.
Stage 2 - Basic Chatbot with FastAPI

A basic chatbot using streamlit and openai api. At this stage we move the call to openai to the backend using FastAPI

Store your `OPENAI_API_KEY` in `.env` file.

Stage 3 - Chatbot with Chat History

A basic chatbot using Streamlit and FastAPI. At this stage, we will store the chat history on the local path and also log the corresponding chat ID, chat name and chat history file path in a database. In this case, every time we open our chatbot, it will automatically load the previous chat history.

In this stage I create a table called `chats` in the database using the following schema:
```
CREATE TABLE IF NOT EXISTS chats (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    file_path TEXT NOT null,
    last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)
```

Please store your `OPENAI_API_KEY` and **Database Credentials** in `.env` file.

Now the `.env` file should look like:
```
OPENAI_API_KEY=YOUR-OPENAI-API-KEY
DB_NAME = YOUR-DB-NAME
DB_USER = YOUR-DB-USER
DB_PASSWORD = YOUR-DB-PASSWORD
DB_HOST = YOUR-DB-HOST
DB_PORT = YOUR-DB-PORT
```

Start the backend app first using:

```
uvicorn backend:app --reload
=======
uvicorn Backend:app --reload
```

And then use 
```
streamlit run chatbot.py
```
to run the streamlit app. Make sure that always start the backend first!
streamlit run app.py
```
to run the Streamlit app. Make sure that you always start the backend first!
