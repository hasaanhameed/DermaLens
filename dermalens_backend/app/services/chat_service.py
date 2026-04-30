from langchain_groq import ChatGroq
from langchain_core.prompts import ChatPromptTemplate, MessagesPlaceholder
from langchain_core.output_parsers import StrOutputParser
from langchain_core.messages import HumanMessage, AIMessage
from app.core.config import settings
from app.services.rag_service import get_relevant_context

llm = ChatGroq(
    groq_api_key=settings.groq_api_key,
    model_name="llama-3.1-8b-instant",
    temperature=0.4, # Changed it to slightly higher for a more natural conversation
)

def generate_chat_response(message: str, history: list, condition: str) -> str:
    """
    Handles conversational RAG. 
    'history' should be a list of dicts: [{"role": "user", "content": "..."}, {"role": "assistant", "content": "..."}]
    """
    try:
        # 1. Fetch Context from RAG based on the NEW user message
        # We still filter by the diagnosed condition to keep it focused
        context = get_relevant_context(query=message, condition_name=condition, top_k=5)

        # 2. Convert raw history dicts to LangChain Message objects
        chat_history = []
        for h in history:
            if h["role"] == "user":
                chat_history.append(HumanMessage(content=h["content"]))
            else:
                chat_history.append(AIMessage(content=h["content"]))

        # 3. Create the Prompt with History and Context
        prompt = ChatPromptTemplate.from_messages([
            ("system", (
                "You are DermaLens AI, a helpful and professional dermatological assistant. "
                "The user has been diagnosed with {condition}. "
                "Use the following Context to answer their questions. If the answer isn't in the context, "
                "politely say you don't have that specific information and suggest consulting a doctor. "
                "\n\nContext:\n{context}"
            )),
            MessagesPlaceholder(variable_name="history"),
            ("user", "{message}"),
        ])

        # 4. Invoke Chain
        chain = prompt | llm | StrOutputParser()
        
        response = chain.invoke({
            "condition": condition,
            "context": context if context else "No specific clinical data found for this query.",
            "history": chat_history,
            "message": message
        })

        return response

    except Exception as e:
        print(f"Chat Service Error: {e}")
        return "I'm having trouble connecting to my knowledge base. Please try again in a moment."
