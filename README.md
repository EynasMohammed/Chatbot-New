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

Start the backend app first using:

```
uvicorn backend:app --reload
```

And then use 
```
streamlit run chatbot.py
```
to run the streamlit app. Make sure that always start the backend first!