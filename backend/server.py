
# from fastapi import FastAPI, UploadFile, HTTPException
# from pydantic import BaseModel
# import google.generativeai as genai
# import base64

# app = FastAPI()

# # Configure Gemini API
# genai.configure(api_key="AIzaSyBiJX66BNRcwjqUlsQsOE-q1pHQZ_IP5fA")  # استبدل بمفتاحك الفعلي

# generation_config = {
#     "temperature": 1,
#     "top_p": 0.95,
#     "top_k": 40,
#     "max_output_tokens": 8192,
#     "response_mime_type": "text/plain",
# }

# model = genai.GenerativeModel(
#     model_name="gemini-2.0-flash",
#     generation_config=generation_config,
# )

# # دالة تلخيص النص
# class TextRequest(BaseModel):
#     text: str

# @app.post("/summarize-text/")
# async def summarize_text(request: TextRequest):
#     """تلخيص النص المستلم من Flutter"""
#     try:
#         response = model.generate_content(f"Summarize this: {request.text}")
#         return {"summary": response.text}  # إرسال الملخص إلى Flutter
#     except Exception as e:
#         raise HTTPException(status_code=500, detail=f"Error summarizing text: {e}")

# # دالة تفريغ الصوت (إذا كنت لا تزال بحاجة إليها)
# async def transcribe_audio_file(file: UploadFile):
#     """تحويل الصوت إلى نص"""
#     if not file:
#         raise HTTPException(status_code=400, detail="No file uploaded.")

#     allowed_mime_types = ["audio/wav", "audio/mpeg", "audio/ogg", "audio/webm", "audio/opus"]
#     if file.content_type not in allowed_mime_types:
#         raise HTTPException(status_code=400, detail="Invalid file type. Supported: wav, mp3, ogg, webm, opus")

#     try:
#         audio_bytes = await file.read()
#         encoded_audio = base64.b64encode(audio_bytes).decode("utf-8")

#         response = model.generate_content(
#             [
#                 "Transcribe the following audio to text:",
#                 {"mime_type": file.content_type, "data": encoded_audio},
#             ]
#         )

#         return response.text  # إرجاع النص المفرغ
#     except Exception as e:
#         raise HTTPException(status_code=500, detail=f"Error transcribing audio: {e}")

# # دالة تفريغ وتلخيص الصوت
# @app.post("/transcribe-and-summarize/")
# async def transcribe_and_summarize(file: UploadFile):
#     """تفريغ الصوت ثم تلخيصه"""
#     try:
#         transcription = await transcribe_audio_file(file)  # تفريغ الصوت
#         summary = await summarize_text(TextRequest(text=transcription))  # تلخيص النص المفرغ

#         return {"transcription": transcription, "summary": summary["summary"]}
#     except Exception as e:
#         raise HTTPException(status_code=500, detail=f"Error processing request: {e}")






# from fastapi import FastAPI, UploadFile, HTTPException
# from pydantic import BaseModel
# import google.generativeai as genai
# import base64

# app = FastAPI()

# # ⚠️ استبدل بمفتاحك الفعلي
# genai.configure(api_key="AIzaSyCyN5hM76l464zwPUZqJ3Gd0fz57SYVrH0")

# generation_config = {
#     "temperature": 1,
#     "top_p": 0.95,
#     "top_k": 40,
#     "max_output_tokens": 8192,
#     "response_mime_type": "text/plain",
# }

# model = genai.GenerativeModel(
#     model_name="gemini-2.0-flash",
#     generation_config=generation_config,
# )

# # ✅ دالة تلخيص النص
# class TextRequest(BaseModel):
#     text: str

# @app.post("/summarize-text/")
# async def summarize_text(request: TextRequest):
#     """تلخيص النص المستلم من Flutter"""
#     try:
#         response = model.generate_content(f"Summarize this: {request.text}")
#         return {"summary": response.text}  # إرسال الملخص إلى Flutter
#     except Exception as e:
#         raise HTTPException(status_code=500, detail=f"Error summarizing text: {e}")

# # ✅ دالة تفريغ الصوت
# async def transcribe_audio_file(file: UploadFile):
#     """تحويل الصوت إلى نص"""
#     if not file:
#         raise HTTPException(status_code=400, detail="No file uploaded.")

#     # ⚠️ التحقق من نوع الملف المدعوم
#     allowed_mime_types = ["audio/wav", "audio/mpeg", "audio/ogg", "audio/webm", "audio/opus"]
#     if file.content_type not in allowed_mime_types:
#         raise HTTPException(status_code=400, detail="Invalid file type. Supported: wav, mp3, ogg, webm, opus")

#     try:
#         audio_bytes = await file.read()

#         # 🔹 طباعة حجم الملف للتأكد أنه ليس فارغًا
#         print(f"📢 Received audio file size: {len(audio_bytes)} bytes")

#         if len(audio_bytes) == 0:
#             raise HTTPException(status_code=400, detail="Uploaded audio file is empty.")

#         # ✅ استخدام base64.urlsafe_b64encode بدلاً من base64.b64encode
#         encoded_audio = base64.urlsafe_b64encode(audio_bytes).decode("utf-8")

#         response = model.generate_content(
#             [
#                 "Transcribe the following audio to text:",
#                 {"mime_type": file.content_type, "data": encoded_audio},
#             ]
#         )

#         if not response.text:
#             raise HTTPException(status_code=500, detail="Empty response from Gemini API.")

#         return response.text  # إرجاع النص المفرغ
#     except Exception as e:
#         raise HTTPException(status_code=500, detail=f"Error transcribing audio: {e}")

# # ✅ دالة تفريغ وتلخيص الصوت
# @app.post("/transcribe-and-summarize/")
# async def transcribe_and_summarize(file: UploadFile):
#     """تفريغ الصوت ثم تلخيصه"""
#     try:
#         transcription = await transcribe_audio_file(file)  # تفريغ الصوت
#         summary = await summarize_text(TextRequest(text=transcription))  # تلخيص النص المفرغ

#         return {"transcription": transcription, "summary": summary["summary"]}
#     except Exception as e:
#         raise HTTPException(status_code=500, detail=f"Error processing request: {e}")  


import base64

from fastapi import FastAPI, UploadFile, HTTPException, Form
from pydantic import BaseModel
import google.generativeai as genai
import os
from dotenv import load_dotenv # type: ignore

load_dotenv()  

app = FastAPI()

# Configure Gemini API
genai.configure(api_key=os.getenv("AIzaSyBiJX66BNRcwjqUlsQsOE-q1pHQZ_IP5fA" ))

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
        audio_bytes = await file.read()
        encoded_audio = base64.b64encode(audio_bytes).decode("utf-8")

        response = model.generate_content(
            [
                "Transcribe the following audio to text:",
                {
                    "mime_type": file.content_type,
                    "data": encoded_audio,
                },
            ]
        )

        return response.text  # Extract the transcribed text
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Internal server error: {e}")

# Function to summarize text
async def summarize_text(text: str):
    """Function to summarize text using Gemini AI."""
    try:
        response = model.generate_content(f"Summarize this: {text}")
        return response.text  # Extract summarized text
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error summarizing text: {e}")

# Endpoint to transcribe and store the text
@app.post("/transcribe/")
async def transcribe(file: UploadFile):
    """Transcribes an audio file and stores the result."""
    try:
        transcription = await transcribe_audio_file(file)
        transcription_cache["latest"] = transcription  # Store transcription in cache
        return {"transcription": transcription}
    except HTTPException as e:
        raise e
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error processing audio: {e}")

# Endpoint to summarize the latest transcribed text
@app.get("/summarize/")
async def summarize_latest():
    """Fetches the latest transcribed text and summarizes it."""
    if "latest" not in transcription_cache:
        raise HTTPException(status_code=400, detail="No transcribed text found. Please transcribe an audio file first.")

    try:
        summary = await summarize_text(transcription_cache["latest"])
        return {
            "summary": summary,
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error summarizing text: {e}")


async def enhance_text(text: str):
    """Function to improve grammar and clarity of transcribed text."""
    try:
        response = model.generate_content(f"Enhance the grammar and clarity of this text: {text}")
        return response.text  # Extract enhanced text
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error enhancing text: {e}")
        

# Endpoint to enhance the latest transcribed text
@app.get("/enhance/")
async def enhance_latest():
    """Enhances the grammar and clarity of the latest transcribed text."""
    if "latest" not in transcription_cache:
        raise HTTPException(status_code=400, detail="No transcribed text found. Please transcribe an audio file first.")

    try:
        enhanced_text = await enhance_text(transcription_cache["latest"])
        return {
            "enhanced_text": enhanced_text,
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error enhancing text: {e}")


