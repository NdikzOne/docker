#!/bin/bash
cd /home/container

# Make internal Docker IP address available to processes.
INTERNAL_IP=$(ip route get 1 | awk '{print $(NF-2);exit}')
export INTERNAL_IP

# Logging setup
echo "────────────────────────────────────────────────────────────"
echo "                     Server Container                       "
echo "────────────────────────────────────────────────────────────"

# System Information
echo "• System Information:"
echo "  Node.js    : $(node -v)"
echo "  NPM        : $(npm -v)"
echo "  PM2        : $(pm2 --version 2>/dev/null || echo 'Not available')"
echo "  PNPM       : $(pnpm --version 2>/dev/null || echo 'Not available')"
echo "  Internal IP: ${INTERNAL_IP}"
echo "  Directory  : $(pwd)"

# Directory contents for debugging
echo ""
echo "• Directory Structure:"
ls -la

# Replace Startup Variables
MODIFIED_STARTUP=$(echo -e ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')

echo ""
echo "• Startup Configuration:"
echo "  Command: ${MODIFIED_STARTUP}"

echo ""
echo "────────────────────────────────────────────────────────────"
echo "                     Starting Server...                     "
echo "────────────────────────────────────────────────────────────"

# Run the Server
eval ${MODIFIED_STARTUP}

# Log exit code when server stops
EXIT_CODE=$?
echo ""
echo "────────────────────────────────────────────────────────────"
echo "                 Server Process Completed                   "
echo "  Exit Code: ${EXIT_CODE}"
echo "────────────────────────────────────────────────────────────"