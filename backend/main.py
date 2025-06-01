import base64
from datetime import datetime
from fastapi import FastAPI, UploadFile, HTTPException, Form, File
from pydantic import BaseModel
import google.generativeai as genai
import os
from pydub import AudioSegment
import tempfile
from dotenv import load_dotenv
from langchain.text_splitter import RecursiveCharacterTextSplitter
from langchain_google_genai import GoogleGenerativeAIEmbeddings
from langchain_core.documents import Document
from langchain_core.runnables import Runnable
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.output_parsers import StrOutputParser
from langchain_google_genai import ChatGoogleGenerativeAI
from langchain_community.vectorstores import Chroma

# load_dotenv()  

# app = FastAPI()

# # Configure Gemini API
# # genai.configure(api_key=os.getenv("GEMINI_API_KEY"))
# genai.configure(api_key="AIzaSyAosrV3zlOslho5KhVHQIxHrli1lTPaCxw")
# generation_config = {
#     "temperature": 0.1,
#     "top_p": 0,
#     "top_k": 40,
#     "max_output_tokens": 1024,
#     "response_mime_type": "text/plain",
# }

# model = genai.GenerativeModel(
#     model_name="gemini-2.0-flash",
#     generation_config=generation_config,
# )

# # Temporary storage for transcriptions
# transcription_cache = {}

# # Function to transcribe audio
# async def transcribe_audio_file(file: UploadFile):
#     print("Received content-type:", file.content_type)

#     if not file:
#         raise HTTPException(status_code=400, detail="No file uploaded.")

#     allowed_mime_types = ["audio/wav", "audio/mpeg", "audio/ogg", "audio/webm", "audio/opus", "audio/mp4", "audio/x-m4a", "application/octet-stream"]

#     if file.content_type not in allowed_mime_types:
#         raise HTTPException(status_code=400, detail="Invalid file type. Supported types: wav, mp3, ogg, webm, opus")

#     try:
#         audio_bytes = await file.read()
#         encoded_audio = base64.b64encode(audio_bytes).decode("utf-8")

#         response = model.generate_content(
#             [
#                 "Transcribe the following audio to text:",
#                 {
#                     "mime_type": file.content_type,
#                     "data": encoded_audio,
#                 },
#             ]
#         )

#         return response.text  # Extract the transcribed text
#     except Exception as e:
#         import traceback
#         print(traceback.format_exc())  # Print full error details in the terminal
#         raise HTTPException(status_code=500, detail=f"Internal server error: {str(e)}")

# # Function to summarize text
# async def summarize_text(text: str):
#     """Function to summarize text using Gemini AI."""
#     try:
#         response = model.generate_content(f"Summarize this: {text}")
#         return response.text  # Extract summarized text
#     except Exception as e:
#         raise HTTPException(status_code=500, detail=f"Error summarizing text: {e}")

# # Function to enhance text
# async def enhance_text(text: str):
#     """Function to improve grammar and clarity of transcribed text."""
#     try:
#         response = model.generate_content(f"Enhance the grammar and clarity of this text: {text}")
#         return response.text  # Extract enhanced text
#     except Exception as e:
#         raise HTTPException(status_code=500, detail=f"Error enhancing text: {e}")
        
# # Function to detect topics
# async def detect_topics(text: str):
#     response = model.generate_content(
#         f"List only the main topics discussed in this text as bullet points. No explanations:\n{text}"
#     )
#     return response.text

# # Endpoint to transcribe and store the text
# @app.post("/transcribe/")
# async def transcribe(file: UploadFile = File(...)):
#     try:
#         transcription = await transcribe_audio_file(file)

#         # 1. Extract language
#         language_response = model.generate_content(
#             f"Identify the language of the following text. Respond only with the language name \n\n{transcription}"
#         )
#         language = language_response.text.strip()

#         # 2. Extract main point
#         main_point_response = model.generate_content(
#             f"What is the main point of this text? do not write any intro just give the main point:\"\n\n{transcription}"
#         )
#         main_point = main_point_response.text.strip()

#         # 3. Extract tags
#         tags_response = model.generate_content(
#             f"Extract at most 5 significant keywords from the following text. Do not write any introduction. just Provide the keywords as a Python list : [tag1 , tag2 , ...] \n\n{transcription}"
#         )

#         # Attempt to parse tags as list
#         raw_tags = tags_response.text.strip().replace("\n", "").replace("-", "")
#         tags = [tag.strip() for tag in raw_tags.split(",") if tag.strip()]

#         # 4. Save with metadata
#         transcription_cache["latest"] = {
#             "text": transcription,
#             "metadata": {
#                 "language": language,
#                 "main_point": main_point,
#                 "tags": tags,
#                 "filename": file.filename,
#                 "upload_date": datetime.now().isoformat()
#             }
#         }

#         return {
#             "transcription": transcription,
#             "metadata": transcription_cache["latest"]["metadata"]
#         }

#     except Exception as e:
#         raise HTTPException(status_code=500, detail=f"Error processing audio: {e}")

# # Endpoint to summarize the latest transcribed text
# @app.get("/summarize/")
# async def summarize_latest():
#     """Fetches the latest transcribed text and summarizes it."""
#     if "latest" not in transcription_cache:
#         raise HTTPException(status_code=400, detail="No transcribed text found. Please transcribe an audio file first.")

#     try:
#         summary = await summarize_text(transcription_cache["latest"]["text"])
#         return {
#             "summary": summary,
#         }
#     except Exception as e:
#         raise HTTPException(status_code=500, detail=f"Error summarizing text: {e}")
    
# # Endpoint to enhance the latest transcribed text
# async def enhance_text(text: str):
#     """Function to improve grammar and clarity of transcribed text."""
#     try:
#         response = model.generate_content(f"Improve the following text by correcting grammar, enhancing clarity, and making it more natural-sounding. "
#             "Do not add new content or remove important meaning. Just return the improved version without any comments, notes, or explanation:\n\n"
#             f"{text}")
#         return response.text  # Extract enhanced text
#     except Exception as e:
#         raise HTTPException(status_code=500, detail=f"Error enhancing text: {e}")
# @app.get("/enhance/")
# async def enhance_latest():
#     """Enhances the grammar and clarity of the latest transcribed text."""
#     if "latest" not in transcription_cache:
#         raise HTTPException(status_code=400, detail="No transcribed text found. Please transcribe an audio file first.")

#     try:
#         enhanced_text = await enhance_text(transcription_cache["latest"]["text"])
#         return {
#             "enhanced_text": enhanced_text,
#         }
#     except Exception as e:
#         raise HTTPException(status_code=500, detail=f"Error enhancing text: {e}")

# @app.get("/detect_topics/")
# async def detect_topics_latest():
#     if "latest" not in transcription_cache:
#         raise HTTPException(status_code=400, detail="No transcribed text found.")
    
#     try:
#         topics = await detect_topics(transcription_cache["latest"]["text"])
#         return {"topics": topics}
#     except Exception as e:
#         raise HTTPException(status_code=500, detail=f"Error extracting topics: {e}")

# @app.get("/extract_tasks/")
# async def extract_tasks():
#     """Extracts actionable tasks from the latest transcribed text."""
#     if "latest" not in transcription_cache:
#         raise HTTPException(status_code=400, detail="No transcribed text found.")

#     try:
#         prompt = f"""
#         Extract all actionable tasks from this text:
#         {transcription_cache["latest"]["text"]}

#         Return only a list of tasks, each on a new line, without extra explanations.
#         """
#         response = model.generate_content(prompt)
#         tasks = response.text.strip()
#         return {"tasks": tasks}
#     except Exception as e:
#         raise HTTPException(status_code=500, detail=f"Error extracting tasks: {e}")

# @app.post("/speaking_analysis/")
# async def speaking_analysis(file: UploadFile = File(...)):
#     """
#     Analyze speaking performance using audio duration and transcribed text.
#     """
#     if "latest" not in transcription_cache:
#         raise HTTPException(status_code=400, detail="No transcribed text found. Please transcribe an audio file first.")

#     try:
#         # Save the uploaded audio file temporarily
#         with tempfile.NamedTemporaryFile(delete=False, suffix=file.filename) as tmp:
#             audio_bytes = await file.read()
#             tmp.write(audio_bytes)
#             tmp_path = tmp.name

#         # Use pydub to load the audio file and get duration
#         audio = AudioSegment.from_file(tmp_path)
#         duration_minutes = audio.duration_seconds / 60  # more accurate than len()/1000

#         # Get the transcription text and word count
#         text = transcription_cache["latest"]["text"]
#         word_count = len(text.split())
#         words_per_minute = round(word_count / max(duration_minutes, 0.01), 2)

#         return {
#             "audio_duration_minutes": round(duration_minutes, 2),
#             "word_count": word_count,
#             "words_per_minute": words_per_minute,
#         }
#     except Exception as e:
#         raise HTTPException(status_code=500, detail=f"Error during speaking analysis: {e}")





# #Rag
    
# @app.post("/rag_store/")
# async def store_to_rag():
#     if "latest" not in transcription_cache:
#         raise HTTPException(status_code=400, detail="No transcription found.")

#     text = transcription_cache["latest"]["text"]
#     text_splitter = RecursiveCharacterTextSplitter(chunk_size=300, chunk_overlap=50)
#     chunks = text_splitter.split_text(text)

#     documents = [Document(page_content=chunk) for chunk in chunks]

#     vectorstore = Chroma.from_documents(
#         documents,
#         embedding_model,
#         persist_directory=VECTOR_DB_PATH
#     )
#     vectorstore.persist()

#     return {"message": f"Stored {len(documents)} chunks to Chroma vector store."}

# @app.get("/rag_answer/")
# async def rag_ask(question: str):
#     try:
#         vectorstore = Chroma(
#             embedding_function=embedding_model,
#             persist_directory=VECTOR_DB_PATH
#         )
#         retriever = vectorstore.as_retriever()

#         rag_prompt = ChatPromptTemplate.from_template(
#             """
#             Use the context below to answer the question:
#             ---
#             {context}
#             ---
#             Question: {question}
#             Answer:
#             """
#         )

#         rag_chain: Runnable = (
#             {"context": retriever, "question": lambda x: x["question"]}
#             | rag_prompt
#             | chat_model
#             | StrOutputParser()
#         )

#         response = rag_chain.invoke({"question": question})
#         return {"answer": response}

#     except Exception as e:
#         raise HTTPException(status_code=500, detail=f"Error answering question: {e}")
    
# # Embedding and chat models for RAG
# embedding_model = GoogleGenerativeAIEmbeddings(model="models/embedding-001")
# chat_model = ChatGoogleGenerativeAI(model="gemini-2.0-flash", temperature=0.3)

# # Vector DB directory
# VECTOR_DB_PATH = "transcribed_audio_chunks_chroma"


















import base64
from datetime import datetime
from fastapi import FastAPI, UploadFile, HTTPException, Form, File
import google.generativeai as genai
import os
from langchain.schema import Document
from dotenv import load_dotenv
from langchain_community.vectorstores import Chroma
from langchain_google_genai import GoogleGenerativeAIEmbeddings
from langchain_core.runnables import Runnable
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.output_parsers import StrOutputParser
from langchain_google_genai import ChatGoogleGenerativeAI
import re
from fastapi import FastAPI, Form, HTTPException
from pydantic import BaseModel
from email_sender import send_email_via_sendgrid

load_dotenv()

app = FastAPI()

# Configure Gemini API
os.environ["GOOGLE_API_KEY"] = "AIzaSyDUoABlR_TAkDcyrjCWKvIxJFAZWpBF_1I"
genai.configure(api_key=os.environ["GOOGLE_API_KEY"]) 

# Gemini Flash for transcription and NLP tasks
generation_config = {
    "temperature": 0.1,
    "top_p": 0,
    "top_k": 40,
    "max_output_tokens": 1024,
    "response_mime_type": "text/plain",
}

model = genai.GenerativeModel(
    model_name="gemini-2.0-flash",
    generation_config=generation_config,
)

# Embedding and chat models for RAG
embedding_model = GoogleGenerativeAIEmbeddings(model="models/embedding-001")
chat_model = ChatGoogleGenerativeAI(model="gemini-2.0-flash", temperature=0.3)

# Vector DB directory
VECTOR_DB_PATH = "transcribed_audio_chunks_chroma"

# Temporary storage for transcriptions
transcription_cache = {}

# Function to transcribe audio
async def transcribe_audio_file(file: UploadFile):
    if not file:
        raise HTTPException(status_code=400, detail="No file uploaded.")

    allowed_mime_types = ["audio/wav", "audio/mpeg", "audio/ogg", "audio/webm", "audio/opus"]

    if file.content_type not in allowed_mime_types:
        raise HTTPException(status_code=400, detail="Invalid file type. Supported types: wav, mp3, ogg, webm, opus")

    try:
        print(f"Received file: {file.filename}, type: {file.content_type}")  

        audio_bytes = await file.read()
        encoded_audio = base64.b64encode(audio_bytes).decode("utf-8")

        print(f"Audio file encoded. Size (base64): {len(encoded_audio)} characters")
        response = model.generate_content([ 
            "Transcribe the following audio to text:",
            {
                "mime_type": file.content_type,
                "data": encoded_audio,
            },
        ]) 

        print("Transcription completed.") 

        return response.text
    except Exception as e:
        print(f"Error during transcription: {e}") 
        raise HTTPException(status_code=500, detail=f"Internal server error: {e}")

def get_vectorstore():
    return Chroma(
        persist_directory=VECTOR_DB_PATH,
        embedding_function=embedding_model,
    )

retriever = get_vectorstore().as_retriever(search_type="similarity", search_kwargs={"k": 5})

async def store_to_chroma(text: str):
    text_splitter = RecursiveCharacterTextSplitter(chunk_size=300, chunk_overlap=50)
    chunks = text_splitter.split_text(text)

    documents = [Document(page_content=chunk) for chunk in chunks]
    print(f"Storing {len(documents)} chunks")
    vectorstore = Chroma.from_documents(
        documents,
        embedding_model,
        persist_directory=VECTOR_DB_PATH
    )
    vectorstore.persist()
    print("Chunks stored and persisted.")

    return len(documents)

# NLP Features
async def summarize_text(text: str):
    try:
        response = model.generate_content(f"Summarize this: {text}")
        return response.text
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error summarizing text: {e}")

async def enhance_text(text: str):
    try:
        response = model.generate_content(
            f"Improve the following text by correcting grammar, enhancing clarity, and making it more natural-sounding.\n\n{text}"
        )
        return response.text
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error enhancing text: {e}")

async def detect_topics(text: str):
    try:
        response = model.generate_content(f"List only the main topics discussed in this text as bullet points. No explanations:\n{text}")
        return response.text
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error extracting topics: {e}")
    
@app.post("/transcribe/") 
async def transcribe(file: UploadFile = File(...)):
    try:
        transcription = await transcribe_audio_file(file)

        language_response = model.generate_content(f"Identify the language of the following text. Respond only with the language name \n\n{transcription}")
        language = language_response.text.strip()

        main_point_response = model.generate_content(f"What is the main point of this text? Do not write any intro.\n\n{transcription}")
        main_point = main_point_response.text.strip()

        tags_response = model.generate_content(f"Extract at most 5 significant keywords from the following text. Just provide as Python list: [tag1, tag2, ...]\n\n{transcription}")
        raw_tags = tags_response.text.strip().replace("\n", "").replace("-", "")
        tags = [tag.strip() for tag in raw_tags.split(",") if tag.strip()]

        transcription_cache["latest"] = {
            "text": transcription,
            "metadata": {
                "language": language,
                "main_point": main_point,
                "tags": tags,
                "filename": file.filename,
                "upload_date": datetime.now().isoformat()
            }
        }

        stored_chunks = await store_to_chroma(transcription)

        return {
            "transcription": transcription,
            "metadata": transcription_cache["latest"]["metadata"],
            "message": f"Stored {stored_chunks} chunks to Chroma vector store."
        }

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error processing audio: {e}")

@app.get("/summarize/") 
async def summarize_latest():
    if "latest" not in transcription_cache:
        raise HTTPException(status_code=400, detail="No transcribed text found.")

    summary = await summarize_text(transcription_cache["latest"]["text"])
    return {"summary": summary}

@app.get("/enhance/") 
async def enhance_latest():
    if "latest" not in transcription_cache:
        raise HTTPException(status_code=400, detail="No transcribed text found.")

    enhanced_text = await enhance_text(transcription_cache["latest"]["text"])
    return {"enhanced_text": enhanced_text}

@app.get("/detect_topics/") 
async def detect_topics_latest():
    if "latest" not in transcription_cache:
        raise HTTPException(status_code=400, detail="No transcribed text found.")

    topics = await detect_topics(transcription_cache["latest"]["text"])
    return {"topics": topics}

@app.get("/extract_tasks/") 
async def extract_tasks():
    if "latest" not in transcription_cache:
        raise HTTPException(status_code=400, detail="No transcribed text found.")

    prompt = f"""
    Extract all actionable tasks from this text:
    {transcription_cache['latest']['text']}

    Return only a list of tasks, each on a new line.
    """
    response = model.generate_content(prompt)
    return {"tasks": response.text.strip()}

@app.post("/ask_question/")
async def ask_question(question: str):
    try:
        vectorstore = Chroma(
            persist_directory=VECTOR_DB_PATH,
            embedding_function=embedding_model,
        )

        raw_docs = vectorstore.get()["documents"]

        print("Total stored docs:", len(raw_docs))

        keywords = re.findall(r'\w+', question.lower())

        matching_docs = []
        for doc in raw_docs:
            doc_lower = doc.lower()
            if all(word in doc_lower for word in keywords):
                matching_docs.append(doc)

        if not matching_docs:
            return {"answer": "No related_paragraphs .", "related_paragraphs": ""}

        context = "\n\n".join([f"PARAGRAPHS{i+1}:\n{doc}" for i, doc in enumerate(matching_docs)])

        prompt = f"""
        form pragraph answer plesss
        {context}

        question: {question}
        answer:        """

        response = model.generate_content(prompt)

        return {
            "answer": response.text.strip(),
            "related_paragraphs": context
        }

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error answering question: {e}")



def send_email_via_sendgrid(to_email: str, subject: str, content: str) -> dict:
    """
    ترسل رسالة نصية عادية (plain-text) باستخدام SendGrid إلى العنوان المحدّد (to_email).
    """
    message = Mail(
        from_email=FROM_EMAIL,
        to_emails=to_email,
        subject=subject,
        plain_text_content=content
    )
    try:
        sg = SendGridAPIClient(SENDGRID_API_KEY)
        response = sg.send(message)
        return {"status": response.status_code, "message": "Email sent successfully"}
    except Exception as e:
        return {"status": 500, "message": f"Failed to send email: {e}"}


class EmailRequest(BaseModel):
    to_email: str


@app.post("/send_transcription/")
async def send_transcription(request: EmailRequest):
    """
    Endpoint يستقبل JSON يحتوي على to_email (الإيميل المستقبل).
    يستخدم أحدث نص مترجم (transcription_cache["latest"]["text"]) ويبعته عبر SendGrid.
    """
    if "latest" not in transcription_cache:
        raise HTTPException(status_code=400, detail="No transcription available.")

    content = transcription_cache["latest"]["text"]
    subject = "Your Spokify Transcription"
    result = send_email_via_sendgrid(request.to_email, subject, content)

    if result["status"] >= 400:
        raise HTTPException(status_code=result["status"], detail=result["message"])
    return result


# ─────────────────────────────────────────────────────────────────────────────
# 8. نقطة البداية لقراءة الحالة (اختبار سريع)
# ─────────────────────────────────────────────────────────────────────────────

@app.get("/")
async def read_root():
    return {"message": "Spokify API is running. Use /docs for interactive API docs."}