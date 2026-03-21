#!/usr/bin/env bash
#
# DrPhilGood.com Website Build Script
# Wraps MCP JSON-RPC calls to drphilgood.com via Bricks MCP plugin
#
# Usage:
#   export MCP_AUTH="philgood:xxxx xxxx xxxx xxxx xxxx xxxx"
#   ./scripts/drphilgood-build.sh
#
# Or pass individual tool calls:
#   source scripts/drphilgood-build.sh
#   mcp_call "tools/call" '{"name":"bricks/get-site-info","arguments":{}}'

set -euo pipefail

MCP_URL="https://drphilgood.com/wp-json/bricks-mcp/v1/mcp"
MCP_AUTH="${MCP_AUTH:-}"
MCP_SESSION=""
REQUEST_ID=0

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

log() { echo -e "${CYAN}[MCP]${NC} $1"; }
ok()  { echo -e "${GREEN}[OK]${NC} $1"; }
err() { echo -e "${RED}[ERR]${NC} $1" >&2; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }

# Base64 encode auth if not already encoded
get_auth_header() {
    if [[ -z "$MCP_AUTH" ]]; then
        err "MCP_AUTH not set. Export as 'username:application-password'"
        return 1
    fi
    echo -n "$MCP_AUTH" | base64
}

# Make a raw MCP JSON-RPC call
# Usage: mcp_raw '{"jsonrpc":"2.0",...}'
mcp_raw() {
    local payload="$1"
    local auth_b64
    auth_b64=$(get_auth_header) || return 1

    curl -s -X POST "$MCP_URL" \
        -H "Content-Type: application/json" \
        -H "Authorization: Basic $auth_b64" \
        -d "$payload"
}

# Make an MCP method call with auto-incrementing ID
# Usage: mcp_call "method" '{"param":"value"}'
mcp_call() {
    local method="$1"
    local params="${2:-{}}"
    REQUEST_ID=$((REQUEST_ID + 1))

    local payload
    payload=$(cat <<EOF
{"jsonrpc":"2.0","method":"$method","params":$params,"id":$REQUEST_ID}
EOF
)
    mcp_raw "$payload"
}

# Call a tool by name with arguments
# Usage: mcp_tool "bricks/get-site-info" '{}'
mcp_tool() {
    local tool_name="$1"
    local tool_args="${2:-{}}"

    mcp_call "tools/call" "{\"name\":\"$tool_name\",\"arguments\":$tool_args}"
}

# Pretty-print the text content from an MCP tool response
# Usage: mcp_tool "bricks/get-site-info" '{}' | mcp_extract_text
mcp_extract_text() {
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

# Initialize MCP session
mcp_init() {
    log "Initializing MCP session..."
    local resp
    resp=$(mcp_call "initialize" '{"protocolVersion":"2024-11-05","capabilities":{},"clientInfo":{"name":"drphilgood-builder","version":"1.0"}}')

    MCP_SESSION=$(echo "$resp" | python3 -c "
import sys, json
data = json.load(sys.stdin)
if 'result' in data:
    print(data['result'].get('sessionId', ''))
" 2>/dev/null || true)

    if [[ -n "$MCP_SESSION" ]]; then
        ok "Session: $MCP_SESSION"
    else
        warn "No session ID returned (may still work)"
        echo "$resp" | python3 -m json.tool 2>/dev/null || echo "$resp"
    fi
}

# ─── Build Functions ──────────────────────────────────────────────

phase0_foundation() {
    log "Phase 0: Foundation Setup"

    # 0C. Design system
    log "Setting up design system..."
    mcp_tool "bricks/setup-design-system" '{
        "style": "modern",
        "style_dna_id": "professional-warm",
        "apply": true,
        "apply_site_style_memory": true
    }' | mcp_extract_text
    echo ""

    # 0D. Override with DrPhilGood brand colors + typography
    log "Overriding palette with DrPhilGood brand colors..."
    mcp_tool "bricks/update-global-settings" '{
        "setting": "color_palette",
        "value": [
            {"id": "dpg-primary", "label": "Primary Blue", "color": "#1E40AF"},
            {"id": "dpg-primary-light", "label": "Primary Light", "color": "#3B82F6"},
            {"id": "dpg-accent-green", "label": "Accent Green", "color": "#10B981"},
            {"id": "dpg-accent-purple", "label": "Accent Purple", "color": "#7C3AED"},
            {"id": "dpg-text", "label": "Text", "color": "#1F2937"},
            {"id": "dpg-text-muted", "label": "Text Muted", "color": "#6B7280"},
            {"id": "dpg-bg", "label": "Background", "color": "#F9FAFB"},
            {"id": "dpg-surface", "label": "Surface", "color": "#F3F4F6"},
            {"id": "dpg-white", "label": "White", "color": "#ffffff"},
            {"id": "dpg-dark", "label": "Dark Surface", "color": "#1E3A5F"},
            {"id": "dpg-dark-deep", "label": "Dark Deep", "color": "#0F172A"}
        ]
    }' | mcp_extract_text
    echo ""

    log "Setting typography theme styles..."
    mcp_tool "bricks/update-global-settings" '{
        "setting": "theme_styles",
        "value": {
            "typography": {
                "font-family": "Inter",
                "font-size": "18px",
                "line-height": "1.6",
                "color": "#1F2937"
            },
            "headings": {
                "font-family": "Plus Jakarta Sans",
                "font-weight": "700",
                "line-height": "1.2",
                "color": "#1F2937"
            },
            "h1": {"font-size": "49px"},
            "h2": {"font-size": "39px"},
            "h3": {"font-size": "31px"},
            "h4": {"font-size": "25px"},
            "links": {
                "color": "#1E40AF",
                "color-hover": "#3B82F6"
            }
        }
    }' | mcp_extract_text
    echo ""

    ok "Phase 0 foundation complete"
}

phase0e_global_classes() {
    log "Phase 0E: Creating global classes..."

    local classes=(
        '{"name":"dpg-section-padding","settings":{"_padding":{"top":"96","right":"24","bottom":"96","left":"24"},"tablet_portrait:_padding":{"top":"64","right":"20","bottom":"64","left":"20"},"mobile_portrait:_padding":{"top":"48","right":"16","bottom":"48","left":"16"}}}'
        '{"name":"dpg-section-dark","settings":{"_background":{"color":"#0F172A"},"_color":"#ffffff"}}'
        '{"name":"dpg-section-surface","settings":{"_background":{"color":"#F3F4F6"}}}'
        '{"name":"dpg-container","settings":{"_width":"1200px","_maxWidth":"100%","_margin":{"top":"0","right":"auto","bottom":"0","left":"auto"}}}'
        '{"name":"dpg-container-narrow","settings":{"_width":"720px","_maxWidth":"100%","_margin":{"top":"0","right":"auto","bottom":"0","left":"auto"}}}'
        '{"name":"dpg-gradient-hero","settings":{"_background":{"image":{"type":"gradient","gradient":"linear-gradient(135deg, #1E40AF 0%, #3B82F6 100%)"}}}}'
        '{"name":"dpg-card","settings":{"_background":{"color":"#ffffff"},"_borderRadius":"16","_boxShadow":"0 1px 3px 0 rgba(0,0,0,0.1), 0 1px 2px -1px rgba(0,0,0,0.1)","_padding":{"top":"32","right":"32","bottom":"32","left":"32"},"_transition":"all 0.2s ease",":hover:_boxShadow":"0 10px 15px -3px rgba(0,0,0,0.1), 0 4px 6px -4px rgba(0,0,0,0.1)",":hover:_transform":"translateY(-2px)"}}'
        '{"name":"dpg-btn-primary","settings":{"_background":{"color":"#10B981"},"_color":"#ffffff","_padding":{"top":"12","right":"24","bottom":"12","left":"24"},"_borderRadius":"10","_typography":{"font-weight":"600","font-size":"16px"},"_transition":"all 0.2s ease",":hover:_background":{"color":"#059669"}}}'
        '{"name":"dpg-btn-secondary","settings":{"_background":{"color":"transparent"},"_border":{"width":"2","style":"solid","color":"#1E40AF"},"_color":"#1E40AF","_padding":{"top":"12","right":"24","bottom":"12","left":"24"},"_borderRadius":"10","_typography":{"font-weight":"600","font-size":"16px"},"_transition":"all 0.2s ease",":hover:_background":{"color":"#1E40AF"},":hover:_color":"#ffffff"}}'
        '{"name":"dpg-btn-ghost","settings":{"_background":{"color":"transparent"},"_color":"#1E40AF","_padding":{"top":"12","right":"24","bottom":"12","left":"24"},"_borderRadius":"10","_typography":{"font-weight":"600","font-size":"16px"},"_transition":"all 0.2s ease",":hover:_background":{"color":"rgba(30,64,175,0.08)"}}}'
        '{"name":"dpg-overline","settings":{"_typography":{"font-size":"12px","font-weight":"500","text-transform":"uppercase","letter-spacing":"0.1em"},"_color":"#1E40AF"}}'
        '{"name":"dpg-heading-display","settings":{"_typography":{"font-family":"Plus Jakarta Sans","font-size":"49px","font-weight":"700","letter-spacing":"-0.02em","line-height":"1.1"},"tablet_portrait:_typography":{"font-size":"39px"},"mobile_portrait:_typography":{"font-size":"31px"}}}'
        '{"name":"dpg-prose","settings":{"_maxWidth":"720px","_typography":{"font-family":"Inter","font-size":"18px","line-height":"1.6"}}}'
    )

    for class_json in "${classes[@]}"; do
        local name
        name=$(echo "$class_json" | python3 -c "import sys,json; print(json.load(sys.stdin)['name'])")
        log "  Creating class: $name"
        mcp_tool "bricks/create-global-class" "$class_json" | mcp_extract_text
    done

    ok "Global classes created"
}

# ─── Main ─────────────────────────────────────────────────────────

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # Running as script (not sourced)
    if [[ -z "$MCP_AUTH" ]]; then
        err "Set MCP_AUTH environment variable first:"
        echo "  export MCP_AUTH='philgood:xxxx xxxx xxxx xxxx xxxx xxxx'"
        exit 1
    fi

    mcp_init
    phase0_foundation
    phase0e_global_classes

    ok "Foundation setup complete. Run individual phase functions or continue with Phase 1."
fi
