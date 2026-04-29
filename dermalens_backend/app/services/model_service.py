import os
import io
import torch
import torchvision.models as models
import torchvision.transforms as transforms
from PIL import Image

# Define the number of classes based on user input
NUM_CLASSES = 10

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

def load_model():
    print("Loading deep learning model...")
    
    # 1. Initialize EfficientNet-B0 with no pre-trained weights
    model = models.efficientnet_b0(weights=None)
    
    # 2. Replace the classifier head to match NUM_CLASSES
    in_features = model.classifier[1].in_features
    model.classifier[1] = torch.nn.Linear(in_features, NUM_CLASSES)
    
    # 3. Locate and load the custom weights
    current_dir = os.path.dirname(os.path.abspath(__file__))
    model_path = os.path.join(current_dir, "..", "models", "best_efficientnet_b0.pth")
    
    if os.path.exists(model_path):
        try:
            # map_location='cpu' allows loading a GPU-trained model on a CPU machine
            loaded_data = torch.load(model_path, map_location=torch.device('cpu'), weights_only=False)
            
            # Handle both `torch.save(model.state_dict())` and `torch.save(model)`
            if isinstance(loaded_data, dict):
                model.load_state_dict(loaded_data)
                print(f"Model state_dict successfully loaded from {model_path}")
            else:
                model = loaded_data
                print(f"Full model successfully loaded from {model_path}")
        except Exception as e:
            print(f"Failed to load model weights: {e}")
    else:
        print(f"WARNING: Model file not found at {model_path}")
        
    # 4. Set to evaluation mode
    model.eval()
    return model

# Load the model once when this module is imported
try:
    model = load_model()
except Exception as e:
    print(f"Error initializing model: {e}")
    model = None

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
