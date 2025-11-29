#!/bin/bash
cd /home/container

# Make internal Docker IP address available to processes.
INTERNAL_IP=$(ip route get 1 | awk '{print $(NF-2);exit}')
export INTERNAL_IP

# Colors for pretty output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Logging setup
echo -e "${PURPLE}╭──────────────────────────────────────────────────────────╮${NC}"
echo -e "${PURPLE}│${CYAN}                    🚀 Server Container                   ${PURPLE}│${NC}"
echo -e "${PURPLE}│${YELLOW}                     by NdikzOne                         ${PURPLE}│${NC}"
echo -e "${PURPLE}╰──────────────────────────────────────────────────────────╯${NC}"

# System Information
echo -e "${BLUE}╭─${CYAN} System Information ${BLUE}─────────────────────────────────────╮${NC}"
echo -e "${BLUE}│${GREEN}  🌟 Node.js    : ${WHITE}$(node -v)${NC}"
echo -e "${BLUE}│${GREEN}  📦 NPM        : ${WHITE}$(npm -v)${NC}"
echo -e "${BLUE}│${GREEN}  ⚡ PM2        : ${WHITE}$(pm2 --version 2>/dev/null || echo 'Not available')${NC}"
echo -e "${BLUE}│${GREEN}  🎯 PNPM       : ${WHITE}$(pnpm --version 2>/dev/null || echo 'Not available')${NC}"
echo -e "${BLUE}│${GREEN}  🌐 Internal IP: ${WHITE}${INTERNAL_IP}${NC}"
echo -e "${BLUE}│${GREEN}  📁 Directory  : ${WHITE}$(pwd)${NC}"
echo -e "${BLUE}╰──────────────────────────────────────────────────────────╯${NC}"

# Directory contents for debugging
echo ""
echo -e "${YELLOW}╭─ Directory Structure ─────────────────────────────────────╮${NC}"
ls -la
echo -e "${YELLOW}╰──────────────────────────────────────────────────────────╯${NC}"

# Replace Startup Variables
MODIFIED_STARTUP=$(echo -e ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')

echo ""
echo -e "${GREEN}╭─ Startup Configuration ───────────────────────────────────╮${NC}"
echo -e "${GREEN}│${CYAN}  💫 Command: ${WHITE}${MODIFIED_STARTUP}${NC}"
echo -e "${GREEN}╰──────────────────────────────────────────────────────────╯${NC}"

echo ""
echo -e "${PURPLE}╭──────────────────────────────────────────────────────────╮${NC}"
echo -e "${PURPLE}│${CYAN}                    🎬 Starting Server...                 ${PURPLE}│${NC}"
echo -e "${PURPLE}╰──────────────────────────────────────────────────────────╯${NC}"
echo ""

# Run the Server
eval ${MODIFIED_STARTUP}

# Log exit code when server stops
EXIT_CODE=$?
if [ $EXIT_CODE -eq 0 ]; then
    EXIT_COLOR=$GREEN
    EXIT_EMOJI="✅"
else
    EXIT_COLOR=$RED
    EXIT_EMOJI="❌"
fi

echo ""
echo -e "${BLUE}╭──────────────────────────────────────────────────────────╮${NC}"
echo -e "${BLUE}│${CYAN}                    📊 Process Completed                  ${BLUE}│${NC}"
echo -e "${BLUE}│${EXIT_COLOR}  ${EXIT_EMOJI} Exit Code: ${WHITE}${EXIT_CODE}${NC}"
echo -e "${BLUE}╰──────────────────────────────────────────────────────────╯${NC}"