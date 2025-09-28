# lesson-3 — TorchScript Inference (MobileNetV2, Fedora 41)

This project demonstrates how to export a pretrained PyTorch model (MobileNetV2) to TorchScript format, build inference containers, and compare **fat** vs **slim** Docker images on **Fedora 41** with Python 3.12.

---

## 1. Environment Setup (local machine)

Run the setup script:

    chmod +x install_dev_tools.sh
    ./install_dev_tools.sh

What it does:

- Installs Docker + Compose plugin (if missing).
- Ensures Python ≥3.9 is available.  
  - If system Python is 3.13 → automatically installs Python 3.12 and uses it for ML libs.
- Installs required Python packages: torch, torchvision, pillow, Django.
- Logs everything into install.log.

---

## 2. Export TorchScript Model

    $PY_BIN export_model.py   # creates model.pt in current directory

By default $PY_BIN is set to the chosen Python interpreter (3.12 on Fedora 41).

---

## 3. Local Inference

    $PY_BIN inference.py image.png --model model.pt --topk 3

Example output:

    Top predictions:
    1. racer: 0.0557
    2. convertible: 0.0548
    3. sports car: 0.0456

---

## 4. Build Containers

### Fat image (Fedora 41, >1GB)

    docker build -f Dockerfile.fat -t mobilenet-fat:latest .

### Slim image (multi-stage, Fedora 41, minimal runtime)

    docker build -f Dockerfile.slim -t mobilenet-slim:latest .

---

## 5. Run Containers

Run inference inside the container with a mounted image:

    docker run --rm -v $PWD:/work -w /work mobilenet-fat:latest images/image.png --model model.pt --topk 3

    docker run --rm -v $PWD:/work -w /work mobilenet-slim:latest images/image.png --model model.pt --topk 3

Note: On first run, inference.py may download imagenet_classes.txt.

---

## 6. Report

Run the helper script to generate `report.md` with image sizes, layer counts, and optimization notes:

    ./generate_report.sh
