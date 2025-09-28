#!/usr/bin/env bash
set -euo pipefail

REPORT_FILE="../REPORT.md"

echo "# FAT vs SLIM — Comparison" > "$REPORT_FILE"
echo >> "$REPORT_FILE"
echo "Generated on: $(date)" >> "$REPORT_FILE"
echo >> "$REPORT_FILE"

echo "## Summary table" >> "$REPORT_FILE"
echo >> "$REPORT_FILE"

# Print header
printf "| %-14s | %-9s | %-11s |\n" "Image name" "Size (MB)" "# of layers" >> "$REPORT_FILE"
printf "|%-16s|%-11s|%-13s|\n" "---------------" "-----------" "-------------" >> "$REPORT_FILE"

# Collect image info
for img in mobilenet-fat mobilenet-slim; do
  if docker image inspect "$img:latest" >/dev/null 2>&1; then
    size=$(docker image inspect "$img:latest" --format='{{.Size}}')
    size_mb=$(( size / 1024 / 1024 ))
    layers=$(docker history "$img:latest" --no-trunc | wc -l)
    printf "| %-14s | %-9s | %-11s |\n" "$img" "$size_mb" "$layers" >> "$REPORT_FILE"
  else
    printf "| %-14s | %-9s | %-11s |\n" "$img" "N/A" "N/A" >> "$REPORT_FILE"
  fi
done

echo >> "$REPORT_FILE"
echo "## Observations" >> "$REPORT_FILE"
echo "- **FAT**: Larger image, includes compilers, build tools, package managers." >> "$REPORT_FILE"
echo "- **SLIM**: Smaller multi-stage build, reduced attack surface, fewer layers." >> "$REPORT_FILE"

echo >> "$REPORT_FILE"
echo "## Raw docker history outputs" >> "$REPORT_FILE"
for img in mobilenet-fat mobilenet-slim; do
  if docker image inspect "$img:latest" >/dev/null 2>&1; then
    echo >> "$REPORT_FILE"
    echo "### $img" >> "$REPORT_FILE"
    docker history "$img:latest" >> "$REPORT_FILE"
  fi
done

echo >> "$REPORT_FILE"
echo "## Further optimization ideas" >> "$REPORT_FILE"
echo "- Clean pip cache, remove build deps after install." >> "$REPORT_FILE"
echo "- Build custom minimal wheels for torch/torchvision (CPU-only)." >> "$REPORT_FILE"
echo "- Consider ONNX Runtime or TorchScript Lite for inference." >> "$REPORT_FILE"
echo "- Apply quantization to shrink model size." >> "$REPORT_FILE"
echo "- Use distroless or fedora-minimal runtime images." >> "$REPORT_FILE"

echo
echo "✅ Report generated: $REPORT_FILE"