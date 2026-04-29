from langchain_groq import ChatGroq
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.output_parsers import StrOutputParser
from app.core.config import settings


llm = ChatGroq(
    groq_api_key=settings.groq_api_key,
    model_name="llama-3.1-8b-instant",
    temperature=0.3,
)

def get_skincare_recommendations(condition: str, severity: str) -> str:
    """
    Generates personalized skincare advice.
    """
    try:
        prompt = ChatPromptTemplate.from_messages([
            ("system", (
                "You are a professional Dermatological Assistant. "
                "Provide concise, 3-4 point skincare routines. "
                "Do not use markdown, bolding, or quotes. Use plain text only. "
                "Always end with: 'Note: AI-generated advice. Consult a doctor.'"
            )),
            ("user", "Condition: {condition}, Risk Level: {severity}. Provide immediate steps."),
        ])

        chain = prompt | llm | StrOutputParser()

        return chain.invoke({"condition": condition, "severity": severity}) 

    except Exception as e:
        print(f"LLM Error: {e}")
        return "Please keep the area clean and consult a professional."
