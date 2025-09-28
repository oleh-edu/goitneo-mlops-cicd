import torch
from torchvision import models

# Export a pretrained MobileNetV2 to TorchScript (.pt)

def main():
    weights = models.MobileNet_V2_Weights.DEFAULT
    model = models.mobilenet_v2(weights=weights)
    model.eval()

    # Example input for tracing
    example = torch.randn(1, 3, 224, 224)

    # Convert to TorchScript via tracing (sufficient for inference)
    traced = torch.jit.trace(model, example)
    traced.save("model.pt")
    print("Saved TorchScript model to model.pt")

if __name__ == "__main__":
    main()
