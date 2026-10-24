#!/usr/bin/env bash
# ==============================================================================
# 🚀 ZERO-TOUCH CLOUD BOOTSTRAPPER: COLORECTAL CANCER PREDICTION
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/KishorKumarParoi/Colorectal-Cancer-Prediction/main/bootstrap.sh | bash
# ==============================================================================

set -eo pipefail

BOLD='\033[1m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

REPO_NAME="Colorectal-Cancer-Prediction"
REPO_URL="https://github.com/KishorKumarParoi/Colorectal-Cancer-Prediction.git"
INSTALL_DIR="$HOME/$REPO_NAME"

echo -e "${CYAN}${BOLD}"
cat << "EOF"
================================================================================
   🩺 COLORECTAL CANCER PREDICTION - ONE-CLICK CLOUD BOOTSTRAPPER
================================================================================
EOF
echo -e "${NC}"

echo -e "${YELLOW}[1/4] Detecting runtime environment & system dependencies...${NC}"

if command -v apt-get &>/dev/null; then
  sudo apt-get update -y
  sudo apt-get install -y git curl ca-certificates
elif command -v yum &>/dev/null; then
  sudo yum install -y git curl ca-certificates
fi

if ! command -v docker &>/dev/null; then
  echo -e "${YELLOW}[!] Docker not found. Installing Docker engine...${NC}"
  curl -fsSL https://get.docker.com | sh
  sudo usermod -aG docker "$USER" 2>/dev/null || true
  sudo systemctl enable --now docker 2>/dev/null || true
fi

echo -e "${YELLOW}[2/4] Cloning or updating repository at $INSTALL_DIR...${NC}"
if [ -d "$INSTALL_DIR/.git" ]; then
  cd "$INSTALL_DIR"
  git fetch origin main
  git reset --hard origin/main
else
  git clone "$REPO_URL" "$INSTALL_DIR"
  cd "$INSTALL_DIR"
fi

chmod +x deploy.sh clear.sh bootstrap.sh

echo -e "${YELLOW}[3/4] Triggering automated deployment pipeline...${NC}"
./deploy.sh

echo -e "${GREEN}${BOLD}"
cat << "EOF"
================================================================================
  🎉 BOOTSTRAP COMPLETED SUCCESSFULLY!
================================================================================
  • Web Interface:    http://localhost:5001
  • Health Endpoint:  http://localhost:5001/health
  • REST API:         POST http://localhost:5001/api/predict
  • Prometheus Stats: http://localhost:5001/metrics
  • Teardown Command: ./clear.sh
================================================================================
EOF
echo -e "${NC}"
