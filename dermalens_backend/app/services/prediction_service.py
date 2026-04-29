import io
import torch
import torchvision.transforms as transforms
from PIL import Image
from app.services.model_service import model

# Standard ImageNet transforms typically used for EfficientNet
preprocess = transforms.Compose([
    transforms.Resize(256),
    transforms.CenterCrop(224),
    transforms.ToTensor(),
    transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225]),
])

# Actual condition names based on dataset folders.
# Note: PyTorch's ImageFolder sorts directories alphabetically by default. 
# So folder "10" comes right after "1".
CLASS_NAMES = [
    "Eczema",                        # 1
    "Viral Infections",              # 10
    "Melanoma",                      # 2
    "Atopic Dermatitis",             # 3
    "Basal Cell Carcinoma",          # 4
    "Melanocytic Nevi",              # 5
    "Benign Keratosis",              # 6
    "Psoriasis & Lichen Planus",     # 7
    "Seborrheic Keratoses",          # 8
    "Fungal Infections",             # 9
]

def predict_image(image_bytes: bytes):
    """
    Takes raw image bytes, runs them through the EfficientNet model, 
    and returns the predicted condition and confidence score.
    """
    if model is None:
        raise RuntimeError("Model is not loaded.")
        
    try:
        # Convert bytes to a PIL Image
        img = Image.open(io.BytesIO(image_bytes)).convert("RGB")
        
        # Preprocess the image and add batch dimension (B, C, H, W)
        input_tensor = preprocess(img)
        input_batch = input_tensor.unsqueeze(0)
        
        # Run prediction
        with torch.no_grad():
            output = model(input_batch)
            
        # Calculate probabilities using Softmax
        probabilities = torch.nn.functional.softmax(output[0], dim=0)
        
        # Get the top prediction
        top_prob, top_catid = torch.topk(probabilities, 1)
        
        class_index = top_catid.item()
        confidence = top_prob.item()
        
        predicted_condition = CLASS_NAMES[class_index]
        
        return {
            "condition": predicted_condition,
            "confidence": confidence,
            "class_index": class_index
        }
    except Exception as e:
        print(f"Error during prediction: {e}")
        raise e
