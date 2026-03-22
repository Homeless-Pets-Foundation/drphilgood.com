#!/bin/bash
# Thin MCP wrapper — sources credentials, manages session, calls tools
# Usage: source scripts/mcp.sh && mcp_init && mcp_tool "bricks/get-site-info" '{}'
set -euo pipefail

export BRICKS_MCP_URL="https://drphilgood.com/wp-json/bricks-mcp/v1/mcp"
export BRICKS_MCP_USER="philgood"
export BRICKS_MCP_PASS="IyeC KywV YhAK DNTK DTVs P3sT"
export MCP_SESSION=""
export MCP_ID=0

mcp_init() {
    curl -s -D /tmp/mcp_h.txt -X POST "$BRICKS_MCP_URL" \
        -H "Content-Type: application/json" \
        -u "$BRICKS_MCP_USER:$BRICKS_MCP_PASS" \
        -d '{"jsonrpc":"2.0","method":"initialize","params":{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"claude-code","version":"1.0"}},"id":0}' > /dev/null
    MCP_SESSION=$(grep -i 'mcp-session-id' /tmp/mcp_h.txt | tr -d '\r' | awk '{print $2}')
    echo "Session: $MCP_SESSION"
}

mcp_call() {
    local method="$1" params="${2:-\{\}}"
    MCP_ID=$((MCP_ID + 1))
    python3 -c "
import json, sys
payload = {'jsonrpc':'2.0','method':'$method','params':$params,'id':$MCP_ID}
json.dump(payload, open('/tmp/mcp_payload.json','w'))
"
    curl -s -X POST "$BRICKS_MCP_URL" \
        -H "Content-Type: application/json" \
        -H "Mcp-Session-Id: $MCP_SESSION" \
        -u "$BRICKS_MCP_USER:$BRICKS_MCP_PASS" \
        -d @/tmp/mcp_payload.json
}

mcp_tool() {
    local name="$1" args="${2:-\{\}}"
    MCP_ID=$((MCP_ID + 1))
    # Write args to temp file to avoid shell escaping issues
    echo "$args" > /tmp/mcp_args.json
    python3 -c "
import json
args = json.load(open('/tmp/mcp_args.json'))
payload = {
    'jsonrpc':'2.0',
    'method':'tools/call',
    'params':{'name':'$name','arguments':args},
    'id':$MCP_ID
}
json.dump(payload, open('/tmp/mcp_payload.json','w'))
"
    curl -s -X POST "$BRICKS_MCP_URL" \
        -H "Content-Type: application/json" \
        -H "Mcp-Session-Id: $MCP_SESSION" \
        -u "$BRICKS_MCP_USER:$BRICKS_MCP_PASS" \
        -d @/tmp/mcp_payload.json
}

# Extract text content from MCP response — pipe: | jt
jt() {
    python3 -c "
import sys, json
data = json.load(sys.stdin)
if 'result' in data and 'content' in data['result']:
    for c in data['result']['content']:
        if c.get('type') == 'text':
            try:
                parsed = json.loads(c['text'])
                print(json.dumps(parsed, indent=2))
            except:
                print(c['text'])
elif 'error' in data:
    print(f\"ERROR {data['error'].get('code','?')}: {data['error'].get('message','?')}\", file=sys.stderr)
else:
    print(json.dumps(data, indent=2))
"
}

# Save raw JSON response: | jsave filename
jsave() {
    python3 -c "
import sys, json
data = json.load(sys.stdin)
with open('/tmp/mcp_${1:-result}.json', 'w') as f:
    json.dump(data, f, indent=2)
print('Saved to /tmp/mcp_${1:-result}.json')
# Also show summary
if 'result' in data and 'content' in data['result']:
    for c in data['result']['content']:
        if c.get('type') == 'text':
            text = c['text']
            try:
                parsed = json.loads(text)
                if isinstance(parsed, dict):
                    print(f'Keys: {list(parsed.keys())[:10]}')
                elif isinstance(parsed, list):
                    print(f'Array of {len(parsed)} items')
            except:
                print(text[:200])
            break
elif 'error' in data:
    print(f\"ERROR: {data['error'].get('message','?')}\")
"
}
