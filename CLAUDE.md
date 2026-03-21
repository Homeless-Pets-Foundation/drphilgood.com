# CLAUDE.md — DrPhilGood.com

## Project Purpose

This is a dedicated Claude Code project for building and improving **DrPhilGood.com** — a WordPress website powered by Bricks Builder, Automatic.css (ACSS), and the Bricks MCP plugin. All site design, content structuring, page building, and iterative improvements are driven through Claude Code using the Bricks MCP tools via the REST API.

This project exists separately from the Bricks MCP plugin repository itself. The plugin is installed and active on this WordPress instance — this project focuses on **using** those tools to build a world-class website.

## About Dr. Phil Good

**DrPhilGood.com** is the personal biographical website of Dr. Phil Good. It serves as a professional online presence showcasing his background, expertise, accomplishments, and interests. The site is designed to be a central hub for anyone looking to learn more about Dr. Phil Good — his career, projects, and contributions.

### Site Purpose
- **Professional biography** — career history, education, credentials, and expertise
- **Project showcase** — highlight current and past projects, ventures, and initiatives
- **Contact hub** — provide a professional point of contact
- **Personal brand** — establish a polished, authoritative online presence

### Brand Identity
- **Tone:** Professional, approachable, authentic, and confident
- **Design style:** Clean, modern, personal brand aesthetic — elegant typography, generous whitespace, high-quality imagery
- **Primary CTA:** "Get in Touch" / "Contact"

## Site Structure

| Page | Purpose |
|------|---------|
| Home | Hero + "What I Do" cards + stats + quote + CTA |
| About Me | Biography, journey, specializations, CTA |
| My Practice | Beyond Pets Animal Hospital — history, services, CTA |
| Rescue & Community | Homeless Pets Foundation, impact stats, how we save lives |
| Our Legacy | Family timeline — Dr. Michael Good to present |
| Contact | Get in Touch hero + hospital info + online links + CTA |
| News | Blog / news posts (old page, needs updating) |

### Templates
| Template | Post ID | Type | Condition |
|----------|---------|------|-----------|
| Site Header | 1760 | header | `{"main": "any"}` |
| Site Footer | 1763 | footer | `{"main": "any"}` |

### Pages
| Page | Post ID | Elements | URL | Status |
|------|---------|----------|-----|--------|
| Home | 1581 | 50 | / | Published (front page) |
| About Me | 1746 | 39 | /about-me/ | Published |
| My Practice | 1747 | 52 | /my-practice/ | Published |
| Rescue & Community | 1748 | 62 | /rescue-mission/ | Published |
| Our Legacy | 1749 | 63 | /our-legacy/ | Published |
| Contact | 1750 | 35 | /contact-me/ | Published |
| News | 770 | 16 | /news/ | Published |
| Builder Test Page | 1724 | 30 | /builder-test/ | Published (test) |
| Bricks #1684 | 1684 | 164 | /bricks-1684/ | Published (old) |

## Website Tech Stack
- **CMS:** WordPress 6.9+
- **Page Builder:** Bricks Builder (all content in Bricks post meta)
- **CSS Framework:** Automatic.css (ACSS) — use ACSS classes and variables wherever possible
- **AI Build Tools:** Bricks MCP plugin (all tools available via REST API)

## Design & Build Guidelines

### General Principles
- Build for a **personal brand / biography website** — clean, elegant, authoritative
- Every page should feel polished and reflect Dr. Phil Good's professional identity
- Use **ACSS classes and custom properties** over inline styles whenever available
- Follow the **8px grid system** for all spacing decisions
- Maintain **WCAG AA accessibility** standards (contrast, focus states, alt text)
- Design **responsive** — looks great on desktop, tablet, and mobile
- Keep the design **sophisticated but approachable** — not flashy, not sterile

### Content Tone Guidelines
- Lead with **who Dr. Phil Good is** and what he brings to the table
- Professional but personable — approachable authority
- Use clear, direct language — no jargon or corporate speak
- Let accomplishments and projects speak for themselves

## Using Bricks MCP Tools

All Bricks MCP tools are available for building this site. Use the full toolkit:

- **Read tools** — inspect existing page content, templates, global classes, settings
- **Write tools** — create and update page elements, manage content areas
- **Design tools** — set up and validate the design system, generate page blueprints, apply templates
- **Reference tools** — look up Bricks element documentation and best practices
- **Beauty tools** — score and improve page aesthetics using style DNA profiles
- **Render tools** — capture and analyze page renders across breakpoints
- **Visual effects** — apply animations, transitions, and interactive effects
- **Media/Stock tools** — manage and import images
- **WordPress tools** — manage options, menus, and site-level settings

### ACSS Integration
Automatic.css is active on this site. Always:
- Check for ACSS classes before creating custom styles
- Use ACSS spacing variables (--space-xs through --space-xxl)
- Use ACSS color variables when they map to the brand palette
- Follow ACSS naming conventions for custom utility classes
- Leverage ACSS responsive utilities over custom media queries

### Design System Setup
When setting up or modifying the design system:
- Use `setup-design-system` with `apply` mode for initial configuration
- Store style decisions in site style memory via `update-site-style-memory`
- Validate design consistency with `validate-design-system` (37-check validation)

### Quality Workflow
For each page or major section:
1. Build with blueprints or templates as a starting point
2. Customize content and styling to match brand guidelines
3. Run beauty scoring to identify aesthetic improvements
4. Use render tools to verify cross-breakpoint consistency
5. Validate against the design system
6. Apply fixes via `apply-fix-batch` for any issues found

### Bricks MCP Critical Rules (learned from experience)

1. **Content key is `text`, NOT `_text`** — underscore-prefix keys are styling only. `_text` does NOT render content.
2. **`_maxWidth` does NOT render as CSS** — use `_cssCustom: "%root% { max-width: 100%; }"` instead.
3. **`settings_merge` must be the settings object** — NOT a boolean. Pass the actual settings to merge as the value.
4. **`insert_before`/`insert_after` need explicit `parent`** — defaults to `parent: 0` (root), does NOT inherit from target.
5. **Use `action`/`target_id`** for update operations — NOT `type`/`element_id`.
6. **Elements need `children` arrays** — parent elements must have `children: [id1, id2]`. Without them, sections render empty.
7. **Template conditions for entire site** — use `{"main": "any"}`, NOT `"entireSite"`.
8. **Header elements** go in `_bricks_page_header_2`, **footer** in `_bricks_page_footer_2` — NOT `_bricks_page_content_2`.
9. **Use `text` element for raw HTML** — NOT `code` element (which escapes HTML and wraps in `<pre>`).
10. **Cache clearing** — Redis + nginx-helper active. After meta updates: `wp_cache_flush()`, `clean_post_cache()`, `do_action("rt_nginx_helper_purge_all")`.
11. **ACSS classes** — use ACSS utility classes where appropriate alongside custom global classes.

### Common Workflows

**Read before editing:** Always `bricks/get-page-elements` first, note the `content_hash`, pass it back on writes for optimistic locking.

**Incremental updates:** Use `bricks/update-page-elements` with operations: `append`, `insert_before`, `insert_after`, `update` (with `settings_merge`), `remove`.

**Full page rewrites:** Use `bricks/set-page-elements` — replaces all elements in an area.

**Design validation:** Run `bricks/validate-design` after changes, fix until score >= 80.

**Visual review:** Use Playwright MCP for screenshots, then `bricks/interpret-render-report` for AI-powered visual issue detection.

### Workarounds

- **`create-template` has a bug** — use `bricks/execute-php` with `wp_insert_post` instead.
- **`execute-php` blocks many functions** — `file_get_contents`, `array_filter`, `fopen`, `wp_remote_get` all blocked. Stage data via `manage-options` + `get_option()`.

## Updating the Bricks MCP Plugin

**CRITICAL: NEVER deactivate or delete the plugin via the WP REST API.** The plugin updates itself in-place using `bricks/update-plugin`. Deleting it removes the MCP endpoint and you lose all remote management ability.

### Steps

1. **Build the zip** (from `/home/philgood/projects/bricks-MCP`):
   ```
   php -l includes/class-workflow-tools.php   # lint changed files
   vendor/bin/phpunit --testdox               # 6 known failures in manage-options/execute-php
   bash build.sh                              # outputs dist/brickslabs-bricks-mcp-X.Y.Z.zip
   ```

2. **Initialize an MCP session** — every call needs a session ID:
   ```
   AUTH=$(echo -n "philgood:$(grep BRICKS_MCP_PASS .env | cut -d= -f2)" | base64)
   curl -s -D - -X POST "https://drphilgood.com/wp-json/bricks-mcp/v1/mcp" \
     -H "Authorization: Basic $AUTH" \
     -H "Content-Type: application/json" \
     -d '{"jsonrpc":"2.0","method":"initialize","params":{"protocolVersion":"2025-03-26","capabilities":{},"clientInfo":{"name":"cli-updater","version":"1.0"}},"id":0}'
   ```
   Copy the `Mcp-Session-Id` response header.

3. **Upload the plugin** via base64-encoded zip (too large for inline curl):
   ```
   base64 -w0 dist/brickslabs-bricks-mcp-X.Y.Z.zip > /tmp/plugin-b64.txt

   python3 -c "
   import json
   with open('/tmp/plugin-b64.txt') as f: b64 = f.read().strip()
   payload = {'jsonrpc':'2.0','method':'tools/call','params':{'name':'bricks/update-plugin','arguments':{'zip_base64':b64}},'id':999}
   with open('/tmp/plugin-upload.json','w') as f: json.dump(payload, f)
   "

   curl -s -X POST "https://drphilgood.com/wp-json/bricks-mcp/v1/mcp" \
     -H "Authorization: Basic $AUTH" \
     -H "Content-Type: application/json" \
     -H "Mcp-Session-Id: YOUR_SESSION_ID" \
     -d @/tmp/plugin-upload.json --max-time 120
   ```
   Success: `{"success": true, "message": "Plugin updated successfully.", "new_version": "X.Y.Z"}`

4. **Verify** — re-initialize and check `serverInfo.version`.

5. **Clean up**: `rm -f /tmp/plugin-b64.txt /tmp/plugin-upload.json`

### Troubleshooting
- **Missing Mcp-Session-Id** → run initialize first (step 2)
- **Argument list too long** → use `-d @file` not inline base64
- **Old version still shows** → PHP opcache; wait 30-60s or restart PHP-FPM
- **Session ID stops working** → re-run step 2 for a fresh session

## WordPress Credentials

- **Site URL:** https://drphilgood.com
- **API User:** philgood
- **Auth:** WordPress application password (stored in `.env`)

## Audit Status (2026-03-20)

### Phase 1 — Contrast & Accessibility (Complete)
- All 6 content pages pass WCAG AA contrast (29 failures → 0)
- Blue buttons: `#3b82f6` → `#2563EB` (ratio 3.68 → 5.17)
- Green buttons: `#10b981` → `#047857` (ratio 2.54 → 4.56)
- Muted text: `#64748b` → `#475569` (ratio 4.76 → 7.58)
- Stats headings: `#3b82f6` → `#60a5fa` on dark backgrounds
- CTA section: added dark gradient background overlay
- Footer: responsive wrap at tablet, column stack on mobile
- Rescue page: mobile text sizing overrides

### Phase 2 — Polish & Consistency (Complete)
- Logo added to header (Beyond Pets logo, ID 1730, 40px desktop / 32px mobile)
- Favicon set to Beyond Pets logo (site_icon: 1730)
- Card border-radius standardized to 12px (4 containers updated)
- Box shadows standardized to 2 variants (12 containers updated)
  - Subtle: `0 2px 20px 0 rgba(0,0,0,0.06)`
  - Elevated: `0 8px 30px 0 rgba(0,0,0,0.12)`
- h3 font sizes standardized to 24px desktop / 20px mobile (27 headings updated)
- Test pages unpublished: Builder Test (1724), Bricks #1684 → draft
- News page grid: already had correct responsive collapse (3→2→1 columns)

### Full audit report: `audit/UI-UX-AUDIT-REPORT.md`

## Remaining Work

- Blog setup with educational content
- SEO meta refinement (Rank Math already active)
- Design system formal setup (style DNA, site style memory)
- Beauty scoring and polish pipeline
- Full cross-breakpoint Playwright verification
- Consider adding real photos to hero sections where stock is used
