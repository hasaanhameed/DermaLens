import os
from sentence_transformers import SentenceTransformer
from app.database.database import supabase
from dotenv import load_dotenv

load_dotenv()

# Configuration
MODEL_NAME = "all-MiniLM-L6-v2"

print(f"Loading embedding model: {MODEL_NAME}...")
model = SentenceTransformer(MODEL_NAME)

def get_relevant_context(query: str, condition_name: str = None, top_k: int = 5) -> str:
    """
    Performs a vector search in Supabase using the 'match_knowledge' RPC function.
    
    Args:
        query (str): The user's question or search term.
        condition_name (str): Optional. If provided, limits search to this specific disease.
        top_k (int): Number of chunks to retrieve.
    """
    try:
        # 1. Generate embedding for the query
        query_embedding = model.encode(query).tolist()

        # 2. Calling the Supabase RPC function 'match_knowledge'
        # This function handles both vector similarity and metadata filtering
        rpc_params = {
            "query_embedding": query_embedding,
            "match_threshold": 0.3, # Adjust this based on how strict you want the search to be
            "match_count": top_k,
            "filter_condition": condition_name # The 'Metadata Filter'
        }

        response = supabase.rpc("match_knowledge", rpc_params).execute()
        
        if not response.data:
            print(f"No relevant context found for: {query} (Condition: {condition_name})")
            return ""

        # 3. Combine retrieved chunks into a single context string
        context_parts = []
        for i, item in enumerate(response.data):
            # We add labels to help the LLM distinguish between chunks
            context_parts.append(f"[Source {i+1}]: {item['content']}")
            
        context = "\n\n".join(context_parts)
        return context

    except Exception as e:
        print(f"RAG Search Error: {e}")
        return ""
