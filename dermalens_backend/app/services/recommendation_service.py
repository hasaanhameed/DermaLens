from langchain_groq import ChatGroq
from langchain_core.prompts import ChatPromptTemplate
from langchain_core.output_parsers import StrOutputParser
from app.core.config import settings
from app.services.rag_service import get_relevant_context


llm = ChatGroq(
    groq_api_key=settings.groq_api_key,
    model_name="llama-3.1-8b-instant",
    temperature=0.2, # Lower temperature for more factual output
)

def get_skincare_recommendations(condition: str, severity: str) -> str:
    """
    Generates personalized skincare advice grounded in the RAG knowledge base.
    """
    try:
        # 1. Fetch relevant clinical context from the DB
        # We search specifically for the condition name
        context = get_relevant_context(query=f"Treatment and routine for {condition}", condition_name=condition)

        # 2. Build the RAG prompt
        prompt = ChatPromptTemplate.from_messages([
            ("system", (
                "You are an AI Dermatological Assistant. "
                "You must provide advice ONLY based on the provided Context. "
                "STRICT RULE: Use PLAIN TEXT ONLY. Do not use markdown, bolding (**), or quotes. "
                "If the context doesn't contain specific info, give general safe advice. "
                "Keep it to 3-4 concise points. "
                "Context: {context}"
            )),
            ("user", "The patient has {condition} with a {severity} risk level. Provide immediate skincare steps."),
        ])


        chain = prompt | llm | StrOutputParser()

        return chain.invoke({
            "condition": condition, 
            "severity": severity,
            "context": context if context else "No specific clinical data available."
        }) 

    except Exception as e:
        print(f"RAG Recommendation Error: {e}")
        return "Keep the area clean, avoid irritation, and consult a dermatologist for a clinical evaluation."

