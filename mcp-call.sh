#!/bin/bash
# DrPhilGood.com MCP call helper
# Usage: ./mcp-call.sh '<json-rpc-body>'
# Or with file: ./mcp-call.sh --file /path/to/payload.json
#
# Requires .env file with BRICKS_MCP_URL, BRICKS_MCP_USER, BRICKS_MCP_PASS

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load .env
if [[ -f "$SCRIPT_DIR/.env" ]]; then
    set -a
    source "$SCRIPT_DIR/.env"
    set +a
fi

: "${BRICKS_MCP_URL:?Set BRICKS_MCP_URL in .env}"
: "${BRICKS_MCP_USER:?Set BRICKS_MCP_USER in .env}"
: "${BRICKS_MCP_PASS:?Set BRICKS_MCP_PASS in .env}"

SESSION_ID="${MCP_SESSION_ID:-}"
SESSION_HEADER=""
if [[ -n "$SESSION_ID" ]]; then
    SESSION_HEADER="-H \"Mcp-Session-Id: $SESSION_ID\""
fi

if [ "${1:-}" = "--file" ]; then
    curl -s -X POST "$BRICKS_MCP_URL" \
        -H "Content-Type: application/json" \
        ${SESSION_HEADER:+"$SESSION_HEADER"} \
        -u "$BRICKS_MCP_USER:$BRICKS_MCP_PASS" \
        -d @"$2"
else
    curl -s -X POST "$BRICKS_MCP_URL" \
        -H "Content-Type: application/json" \
        ${SESSION_HEADER:+"$SESSION_HEADER"} \
        -u "$BRICKS_MCP_USER:$BRICKS_MCP_PASS" \
        -d "$1"
fi
