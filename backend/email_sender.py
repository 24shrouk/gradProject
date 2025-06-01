import os
from sendgrid import SendGridAPIClient
from sendgrid.helpers.mail import Mail
from dotenv import load_dotenv

# 1. تحميل متغيرات البيئة
load_dotenv()

SENDGRID_API_KEY = os.getenv("SENDGRID_API_KEY")
FROM_EMAIL = os.getenv("FROM_EMAIL")

def send_email_via_sendgrid(to_email: str, subject: str, content: str) -> dict:
    """
    ترسل رسالة نصية عادية (plain-text) باستخدام SendGrid.
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
        return {
            "status": response.status_code,
            "message": "Email sent successfully"
        }
    except Exception as e:
        # لو حد حصل خطأ في الإرسال
        return {
            "status": 500,
            "message": f"Failed to send email: {e}"
        }

