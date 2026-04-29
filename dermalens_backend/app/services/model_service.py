import os
import torch
import torchvision.models as models

# Define the number of classes based on user input
NUM_CLASSES = 10

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
