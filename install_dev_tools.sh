#!/usr/bin/env bash
set -euo pipefail

LOG_FILE="install.log"
exec > >(tee -a "$LOG_FILE") 2>&1

# -------- Helpers --------
need_cmd() { command -v "$1" >/dev/null 2>&1; }
ver() { printf '%s\n' "$1" | awk -F. '{ printf("%d%03d%03d\n", $1,$2,$3); }'; }

say() { echo -e "[INFO] $*"; }
warn() { echo -e "[WARN] $*"; }

require_sudo() {
  if [[ $EUID -ne 0 ]]; then
    if need_cmd sudo; then
      sudo -v || true
    else
      warn "sudo not found. Some steps may fail without root privileges."
    fi
  fi
}

# Detect Fedora
is_dnf() { need_cmd dnf; }

# -------- Docker & Compose --------
install_docker() {
  if need_cmd docker; then
    say "Docker already installed: $(docker --version)"
  else
    say "Installing Docker Engine..."
    if is_dnf; then
      require_sudo
      sudo dnf -y install dnf-plugins-core curl

      # add the official Docker CE repository
      if [[ ! -f /etc/yum.repos.d/docker-ce.repo ]]; then
        sudo curl -fsSL -o /etc/yum.repos.d/docker-ce.repo \
          https://download.docker.com/linux/fedora/docker-ce.repo
      fi

      # Installing Docker Engine + Compose plugin
      sudo dnf -y install docker-ce docker-ce-cli containerd.io \
        docker-buildx-plugin docker-compose-plugin

      sudo systemctl enable --now docker
    else
      warn "Non-dnf OS: please install Docker manually from https://docs.docker.com/engine/install/."
    fi
  fi

  if docker info >/dev/null 2>&1; then
    say "Docker daemon reachable."
  else
    warn "Docker daemon not reachable yet. Start it and re-run if needed."
  fi

  if docker compose version >/dev/null 2>&1; then
    say "Docker Compose v2 present: $(docker compose version | head -n1)"
  else
    if need_cmd docker-compose; then
      say "Legacy docker-compose present: $(docker-compose --version)"
    else
      warn "Docker Compose not found. Installed with docker-compose-plugin above."
    fi
  fi
}

# -------- Python & pip --------
install_python() {
  local py_bin="python3"
  local min_ver="3.9.0"

  # install python3 if not present
  if ! need_cmd $py_bin; then
    say "Installing Python3 via dnf..."
    if is_dnf; then
      require_sudo
      sudo dnf -y install python3
    else
      warn "Non-dnf OS: please install Python manually."
    fi
  fi

  # detect current version
  local py_ver
  py_ver="$($py_bin -c 'import sys; print("%d.%d.%d"%sys.version_info[:3])')" || py_ver="0.0.0"
  say "System Python: $py_ver"

  # if Python 3.13 → install Python 3.12 for compatibility (torch, Django etc.)
  if [[ "$py_ver" == 3.13.* ]]; then
    say "Python 3.13 detected → installing Python 3.12 for compatibility..."
    require_sudo
    sudo dnf -y install python3.12
    py_bin="python3.12"
  elif [[ $(ver "$py_ver") -lt $(ver "$min_ver") ]]; then
    warn "Python $py_ver < $min_ver. Please install newer Python manually (e.g., via pyenv)."
  fi

  say "Python in use: $($py_bin --version)"

  # ensure pip is available
  if ! "$py_bin" -m pip --version >/dev/null 2>&1; then
    say "Bootstrapping pip with ensurepip..."
    "$py_bin" -m ensurepip --upgrade || true
  fi

  # upgrade pip in user mode
  "$py_bin" -m pip install --user --upgrade pip

  # export selected Python binary for later use
  export PY_BIN="$py_bin"
}

install_libs() {
  say "Installing Python libs (user mode): torch, torchvision, pillow, Django"

  # install torch, torchvision, pillow via pip (CPU wheels)
  "$PY_BIN" -m pip install --user --upgrade \
    torch torchvision --index-url https://download.pytorch.org/whl/cpu \
    pillow

  # try to install Django via pip
  if ! "$PY_BIN" -m pip install --user --upgrade Django; then
    warn "Django installation via pip failed. Falling back to system package..."
    require_sudo
    if is_dnf; then
      sudo dnf install -y python3-django
    else
      warn "Non-dnf OS: please install Django manually."
    fi
  fi
}

# -------- Verify --------
verify() {
  say "--- Versions ---"
  need_cmd docker && docker --version || true
  docker compose version 2>/dev/null || docker-compose --version 2>/dev/null || true

  # use the selected Python binary
  "$PY_BIN" --version
  "$PY_BIN" -m pip --version

  "$PY_BIN" -c "
import sys
print('python', sys.version)
try:
    import torch, torchvision, PIL, django
    print('torch', torch.__version__)
    print('torchvision', torchvision.__version__)
    print('Pillow', PIL.__version__)
    print('Django', django.get_version())
except ImportError as e:
    print('ImportError:', e)
"
}

main() {
  install_docker
  install_python
  install_libs
  verify
  say "All set. Log saved to $LOG_FILE"
}

main "$@"
