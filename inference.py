import argparse
import json
import os
import urllib.request

import torch
from PIL import Image
from torchvision import transforms

IMAGENET_IDX_URL = "https://raw.githubusercontent.com/pytorch/hub/master/imagenet_classes.txt"
LABELS_TXT = "imagenet_classes.txt"

preprocess = transforms.Compose([
    transforms.Resize(256),
    transforms.CenterCrop(224),
    transforms.ToTensor(),
    transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225]),
])

def ensure_labels():
    if not os.path.exists(LABELS_TXT):
        print("Downloading ImageNet labels...")
        urllib.request.urlretrieve(IMAGENET_IDX_URL, LABELS_TXT)
    with open(LABELS_TXT, "r", encoding="utf-8") as f:
        labels = [line.strip() for line in f.readlines()]
    return labels


def predict(image_path: str, model_path: str = "model.pt", topk: int = 3):
    if not os.path.exists(model_path):
        raise FileNotFoundError(f"TorchScript model not found at {model_path}. Run export_model.py first.")

    device = torch.device("cpu")
    model = torch.jit.load(model_path, map_location=device)
    model.eval()

    img = Image.open(image_path).convert("RGB")
    x = preprocess(img).unsqueeze(0)

    with torch.inference_mode():
        logits = model(x)
        probs = torch.softmax(logits, dim=1)
        top_probs, top_idxs = probs.topk(topk, dim=1)

    labels = ensure_labels()
    out = [(labels[idx.item()], top_probs[0, i].item()) for i, idx in enumerate(top_idxs[0])]
    return out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("image", help="Path to input image")
    ap.add_argument("--model", default="model.pt", help="Path to TorchScript .pt file")
    ap.add_argument("--topk", type=int, default=3, help="Top-K predictions to display")
    args = ap.parse_args()

    preds = predict(args.image, args.model, args.topk)
    print("Top predictions:")
    for i, (label, p) in enumerate(preds, 1):
        print(f"{i}. {label}: {p:.4f}")

if __name__ == "__main__":
    main()
