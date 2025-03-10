# SDA-bootcamp-project

Stage 4 - **RAG** Chatbot with Chat history

A RAG chatbot using Streamlit and FastAPI. At this stage, we will add the RAG function to the bot.
Other than creating normal chat, user can upload `pdf` file to the chatbot and ask questions specific to this document 

In this stage, we will create a **new** table called `advanced_chats` in the database using the following schema:
```
CREATE TABLE IF NOT EXISTS advanced_chats (
    id TEXT PRIMARY KEY,
    name TEXT NOT NULL,
    file_path TEXT NOT null,
    last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    pdf_path TEXT,
    pdf_name TEXT,
    pdf_uuid TEXT
)
```
or if you want, you can just add the extra columns in the `chats` database created in stage 3.

Please store your `OPENAI_API_KEY` and **Database Credentials** in `.env` file.

All the requirements are in the `requirements.txt`

To use RAG, we need to start the chromaDB first, using the following command to start the Chroma server:
```
chroma run --path /db_path
```
change `/db_path` to the path you want to store the data, for example: `chromadb`.

Then, start the backend app using:

```
uvicorn backend:app --reload --port 5000
```

> Compared to the last stage, we added a `port` parameter to change the port to `5000`. Since the chromadb will also use port 8000, we added this to avoid port conflict.

And then use 
```
streamlit run chatbot.py
```
to run the Streamlit app.
