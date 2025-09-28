# FAT vs SLIM — Comparison

Generated on: Sun Sep 28 04:17:55 AM EEST 2025

## Summary table

| Image name     | Size (MB) | # of layers |
|--------------- |-----------|-------------|
| mobilenet-fat  | 1247      | 11          |
| mobilenet-slim | 888       | 12          |

## Observations
- **FAT**: Larger image, includes compilers, build tools, package managers.
- **SLIM**: Smaller multi-stage build, reduced attack surface, fewer layers.

## Raw docker history outputs

### mobilenet-fat
IMAGE          CREATED         CREATED BY                                      SIZE      COMMENT
560e9eca8e72   5 minutes ago   ENTRYPOINT ["python3" "inference.py"]           0B        buildkit.dockerfile.v0
<missing>      5 minutes ago   COPY model.pt /app/model.pt # buildkit          14.5MB    buildkit.dockerfile.v0
<missing>      5 minutes ago   COPY inference.py /app/inference.py # buildk…   2.01kB    buildkit.dockerfile.v0
<missing>      5 minutes ago   WORKDIR /app                                    0B        buildkit.dockerfile.v0
<missing>      5 minutes ago   RUN /bin/sh -c dnf -y update &&     dnf -y i…   1.11GB    buildkit.dockerfile.v0
<missing>      5 minutes ago   ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFER…   0B        buildkit.dockerfile.v0
<missing>      13 days ago     CMD ["/bin/bash"]                               0B        buildkit.dockerfile.v0
<missing>      13 days ago     ADD fedora-20250914.tar / # buildkit            182MB     buildkit.dockerfile.v0
<missing>      13 days ago     ENV DISTTAG=f41container FGC=f41 FBR=f41        0B        buildkit.dockerfile.v0
<missing>      13 days ago     LABEL maintainer=Clement Verna <cverna@fedor…   0B        buildkit.dockerfile.v0

### mobilenet-slim
IMAGE          CREATED         CREATED BY                                      SIZE      COMMENT
b2e5ee94d3e4   2 minutes ago   ENTRYPOINT ["python3" "/app/inference.py"]      0B        buildkit.dockerfile.v0
<missing>      2 minutes ago   COPY /opt/app /app # buildkit                   14.5MB    buildkit.dockerfile.v0
<missing>      2 minutes ago   WORKDIR /app                                    0B        buildkit.dockerfile.v0
<missing>      2 minutes ago   ENV PATH=/opt/venv/bin:/usr/local/sbin:/usr/…   0B        buildkit.dockerfile.v0
<missing>      2 minutes ago   COPY /opt/venv /opt/venv # buildkit             674MB     buildkit.dockerfile.v0
<missing>      2 minutes ago   RUN /bin/sh -c dnf -y update &&     dnf -y i…   60.8MB    buildkit.dockerfile.v0
<missing>      2 minutes ago   ENV PYTHONDONTWRITEBYTECODE=1 PYTHONUNBUFFER…   0B        buildkit.dockerfile.v0
<missing>      13 days ago     CMD ["/bin/bash"]                               0B        buildkit.dockerfile.v0
<missing>      13 days ago     ADD fedora-20250914.tar / # buildkit            182MB     buildkit.dockerfile.v0
<missing>      13 days ago     ENV DISTTAG=f41container FGC=f41 FBR=f41        0B        buildkit.dockerfile.v0
<missing>      13 days ago     LABEL maintainer=Clement Verna <cverna@fedor…   0B        buildkit.dockerfile.v0

## Further optimization ideas
- Clean pip cache, remove build deps after install.
- Build custom minimal wheels for torch/torchvision (CPU-only).
- Consider ONNX Runtime or TorchScript Lite for inference.
- Apply quantization to shrink model size.
- Use distroless or fedora-minimal runtime images.
