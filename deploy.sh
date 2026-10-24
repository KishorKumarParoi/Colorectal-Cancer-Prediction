#!/usr/bin/env bash
# ==============================================================================
# 🚀 COLORECTAL CANCER PREDICTION & CLINICAL INFERENCE PLATFORM LAUNCHER
# Supported Flags:
#   ./deploy.sh            # Standard Docker Compose Deployment
#   ./deploy.sh --quick    # Standalone Container Mode
#   ./deploy.sh --host     # Host Native Python execution
# ==============================================================================

set -eo pipefail

BOLD='\033[1m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$ROOT_DIR"

MODE="compose"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --quick) MODE="quick"; shift ;;
    --host) MODE="host"; shift ;;
    --compose) MODE="compose"; shift ;;
    *) echo -e "${YELLOW}Unknown flag $1; defaulting to compose.${NC}"; shift ;;
  esac
done

echo -e "${CYAN}${BOLD}"
cat << "EOF"
================================================================================
  🩺 COLORECTAL CANCER SURVIVAL PREDICTION SERVICE DEPLOYMENT
================================================================================
EOF
echo -e "${NC}"

run_compose() {
  if docker compose version &>/dev/null; then
    docker compose "$@"
  elif command -v docker-compose &>/dev/null; then
    docker-compose "$@"
  elif sudo docker compose version &>/dev/null; then
    sudo docker compose "$@"
  else
    sudo docker-compose "$@"
  fi
}

# 1. Host Native Mode
if [ "$MODE" = "host" ]; then
  echo -e "${YELLOW}[*] Launching in Host Python Mode...${NC}"
  export PORT="${PORT:-5001}"

  if [ -d ".venv" ]; then
    source .venv/bin/activate
  fi

  python3 main.py
  exit 0
fi

# 2. Standalone Container Mode
if [ "$MODE" = "quick" ]; then
  echo -e "${CYAN}[*] Building standalone container...${NC}"
  docker build -t colorectal-cancer-prediction:latest .
  docker rm -f colorectal-cancer-app 2>/dev/null || true
  docker run -d --name colorectal-cancer-app \
    -p 5001:5001 \
    -e PORT=5001 \
    colorectal-cancer-prediction:latest

  echo -e "${GREEN}✓ Cancer Prediction App running at http://localhost:5001${NC}"
  exit 0
fi

# 3. Docker Compose Mode
echo -e "${CYAN}[*] Starting services via Docker Compose...${NC}"
run_compose up -d --build

echo -e "${YELLOW}[*] Verifying service health...${NC}"
for i in {1..30}; do
  if curl -sf http://localhost:5001/health >/dev/null 2>&1; then
    echo -e "${GREEN}✓ Colorectal Cancer Service is UP and HEALTHY!${NC}"
    echo -e "  - Web UI:       http://localhost:5001"
    echo -e "  - Health Check: http://localhost:5001/health"
    echo -e "  - API Predict:  POST http://localhost:5001/api/predict"
    echo -e "  - Metrics:      http://localhost:5001/metrics"
    exit 0
  fi
  sleep 1
done

echo -e "${RED}[!] Health check timed out after 30s. Checking logs:${NC}"
run_compose logs --tail=20
exit 1
