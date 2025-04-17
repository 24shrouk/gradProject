
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






from fastapi import FastAPI, UploadFile, HTTPException
from pydantic import BaseModel
import google.generativeai as genai
import base64

app = FastAPI()

# ⚠️ استبدل بمفتاحك الفعلي
genai.configure(api_key="AIzaSyCyN5hM76l464zwPUZqJ3Gd0fz57SYVrH0")

generation_config = {
    "temperature": 1,
    "top_p": 0.95,
    "top_k": 40,
    "max_output_tokens": 8192,
    "response_mime_type": "text/plain",
}

model = genai.GenerativeModel(
    model_name="gemini-2.0-flash",
    generation_config=generation_config,
)

# ✅ دالة تلخيص النص
class TextRequest(BaseModel):
    text: str

@app.post("/summarize-text/")
async def summarize_text(request: TextRequest):
    """تلخيص النص المستلم من Flutter"""
    try:
        response = model.generate_content(f"Summarize this: {request.text}")
        return {"summary": response.text}  # إرسال الملخص إلى Flutter
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error summarizing text: {e}")

# ✅ دالة تفريغ الصوت
async def transcribe_audio_file(file: UploadFile):
    """تحويل الصوت إلى نص"""
    if not file:
        raise HTTPException(status_code=400, detail="No file uploaded.")

    # ⚠️ التحقق من نوع الملف المدعوم
    allowed_mime_types = ["audio/wav", "audio/mpeg", "audio/ogg", "audio/webm", "audio/opus"]
    if file.content_type not in allowed_mime_types:
        raise HTTPException(status_code=400, detail="Invalid file type. Supported: wav, mp3, ogg, webm, opus")

    try:
        audio_bytes = await file.read()

        # 🔹 طباعة حجم الملف للتأكد أنه ليس فارغًا
        print(f"📢 Received audio file size: {len(audio_bytes)} bytes")

        if len(audio_bytes) == 0:
            raise HTTPException(status_code=400, detail="Uploaded audio file is empty.")

        # ✅ استخدام base64.urlsafe_b64encode بدلاً من base64.b64encode
        encoded_audio = base64.urlsafe_b64encode(audio_bytes).decode("utf-8")

        response = model.generate_content(
            [
                "Transcribe the following audio to text:",
                {"mime_type": file.content_type, "data": encoded_audio},
            ]
        )

        if not response.text:
            raise HTTPException(status_code=500, detail="Empty response from Gemini API.")

        return response.text  # إرجاع النص المفرغ
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error transcribing audio: {e}")

# ✅ دالة تفريغ وتلخيص الصوت
@app.post("/transcribe-and-summarize/")
async def transcribe_and_summarize(file: UploadFile):
    """تفريغ الصوت ثم تلخيصه"""
    try:
        transcription = await transcribe_audio_file(file)  # تفريغ الصوت
        summary = await summarize_text(TextRequest(text=transcription))  # تلخيص النص المفرغ

        return {"transcription": transcription, "summary": summary["summary"]}
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error processing request: {e}")  


