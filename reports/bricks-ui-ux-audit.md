# Bricks MCP UI/UX Audit Report — v2

**Date:** 2026-03-20
**Site:** https://drphilgood.com
**Auditor:** Claude Code (Opus 4.6) via Playwright MCP + Bricks MCP REST API
**Pages Created:** UX Audit Demo – Landing Page (ID 1777), UX Audit Demo – Service Detail (ID 1779)
**Viewports:** Desktop (1440x900), Tablet (1024x768), Mobile (478x844)
**Bricks MCP Version:** 1.8.9 (89 tools)
**CSS Framework:** Automatic.css 3.3.6

---

## 1. Executive Summary

The Bricks MCP `build-page-from-brief` tool produced structurally sound page scaffolding but **critically failed at content generation**. Both pages rendered the brief instructions as literal page content instead of using the brief as a generation prompt. The two pages — requested with different section types and layouts — produced identical 7-section structures with generic placeholder headings ("Social Proof Bar", "Problem", "Final Cta") and no real copy. Zero content images were generated. The underlying layout framework (responsive stacking, header/footer inheritance, ACSS integration) works well, but the content generation pipeline needs fundamental rework.

---

## 2. Environment and MCP Tool Inventory

| Component | Version/Detail |
|-----------|---------------|
| WordPress | 6.9.4 |
| PHP | 8.4.18 |
| Bricks Builder | 2.3 |
| Bricks MCP Plugin | 1.8.9 |
| Automatic.css | 3.3.6 |
| Total MCP Tools | 89 |
| MCP Connection | REST API via curl (not registered as MCP server in `.mcp.json`) |
| Playwright | Available via MCP server |

**Tool categories (89 total):**
- Page CRUD: create-page, update-page, delete-page, duplicate-page, list-pages
- Build automation: build-page-from-brief, build-site-from-brief, run-design-loop, polish-page
- Element management: get-page-elements, set-page-elements, update-page-elements, bulk-update
- Design system: setup-design-system, validate-design, validate-site-design, detect-css-framework
- Quality assurance: score-hero, analyze-page-rhythm, audit-contrast-site, audit-spacing-site
- Media: search-stock-images, import-stock-image, upload-media, list-media, direct-image-treatment
- Templates: create-template, list-templates, get/set/update-template-elements
- Style memory: get-site-style-memory, update-site-style-memory, get-style-dna, capture-site-style-baseline
- Responsive: get-preview-targets, validate-responsive-cascade, get-render-checklist
- WordPress: execute-php, manage-options, wp-query, manage-seo-meta

**Site Style Memory:** NOT CONFIGURED — `get-site-style-memory` returns `{"status": "not_configured"}`. This means `reuse_design_system: true` has no brand colors, CTA text, or fonts to consume.

---

## 3. Pages Created and Build Scores

### Page 1: UX Audit Demo – Landing Page (ID 1777)

| Metric | Initial | After Design Loop | Threshold | Status |
|--------|---------|-------------------|-----------|--------|
| Design Score (build-time) | 25 | 25 | >= 60 | **FAIL** |
| Design Score (validate-design) | 0 | — | >= 60 | **FAIL** |
| Hero Score | 63 → 78 | 78 | >= 70 | **PASS** |
| Polish Score | 76 | 100 | >= 40 | **PASS** |
| Element Count | 64 | 64 | — | — |

### Page 2: UX Audit Demo – Service Detail (ID 1779)

| Metric | Initial | After Design Loop | Threshold | Status |
|--------|---------|-------------------|-----------|--------|
| Design Score (build-time) | 29 | 29 | >= 60 | **FAIL** |
| Design Score (validate-design) | 1 | — | >= 60 | **FAIL** |
| Hero Score | 63 → 78 | 78 | >= 70 | **PASS** |
| Polish Score | 84 | 100 | >= 40 | **PASS** |
| Element Count | 55 | 55 | — | — |

**Note:** There is a significant discrepancy between the build-time design score (25/29) and the `validate-design` score (0/1). These appear to use different scoring criteria.

---

## 4. Brief Fidelity Validation Results

### CRITICAL FAILURE: Brief Rendered as Page Content

The build tool treated the brief text as literal page content instead of a generation prompt.

**Evidence — Landing Page:**
- H1: "Build a modern, conversion-focused landing page for this business" (= first line of brief)
- Subheadline: "Include these sections in order: (1) A hero section with a compelling headline..." (= brief instructions)
- H3 elements: "A problem/pain", "A how", "A testimonial section with 2" (= fragments of brief)

**Evidence — Service Page:**
- H1: "Build a content-rich service detail page" (= first line of brief)
- Subheadline: "Include these sections in order: (1) A hero section with a clear service headline..." (= brief instructions)
- H3 element: "An FAQ section with 5" (= brief fragment)

### CRITICAL FAILURE: Both Pages Are Structurally Identical

Despite requesting 8 different sections for the landing page and 6 different sections for the service page, both produced the same 7-section scaffolding:

| # | Landing Sections | Service Sections | Same? |
|---|-----------------|-----------------|-------|
| 1 | hero-section | hero-section | Yes |
| 2 | social-proof-bar-section | social-proof-bar-section | Yes |
| 3 | problem-section | problem-section | Yes |
| 4 | solution-features-section | solution-features-section | Yes |
| 5 | testimonials-section | testimonials-section | Yes |
| 6 | details-section | details-section | Yes |
| 7 | final-cta-section | final-cta-section | Yes |

**Structural overlap: 100%**

### Section Count Check

| Page | Requested | Generated | Matched Brief |
|------|-----------|-----------|---------------|
| Landing | 8 (hero, trust bar, problem, how-it-works, features, testimonials, FAQ, final CTA) | 7 | 0 |
| Service | 6 (hero, value prop, process, image/text blocks, FAQ, CTA) | 7 | 0 |

### Other Fidelity Checks

| Check | Result | Severity |
|-------|--------|----------|
| Content uniqueness | FAIL — 100% identical section names | CRITICAL |
| Brief-as-content | FAIL — brief rendered verbatim | CRITICAL |
| Brand colors | Uncertain — style memory not configured | HIGH |
| CTA text | Generic ("Get Started", "Contact Us") — no stored values | MEDIUM |
| Content images | FAIL — 0 content images on either page | HIGH |

---

## 5. Page-by-Page Findings

### Landing Page — What Was Requested vs What Was Generated

| Brief Section | Generated? | What Appeared Instead |
|--------------|-----------|----------------------|
| Hero with compelling headline | Partial — hero section exists but H1 is the brief instruction text | "Build a modern, conversion-focused landing page for this business" |
| Primary + secondary CTA | Partial — only 1 CTA ("Get Started"), brief requested 2 | Missing secondary CTA |
| Social proof/trust bar | Partial — section exists with stats, but stats are brief fragment numbers (4, 3, 3, 6) | Numbers from brief parsed as stat values |
| Problem/pain-point section | Scaffolding only | "Problem" heading + "Use this section to support the problem narrative" |
| How-it-works (3 steps) | Not generated | Merged into generic "Solution Features" |
| Features (3-4 cards) | Scaffolding only | Cards contain brief fragments as content |
| Testimonials (2-3 quotes) | Partial — 3 quotes present but they ARE brief text fragments | "or trust bar with 3-4 stats or partner logos" rendered as a quote |
| FAQ accordion (4-6 questions) | Not generated | Missing entirely |
| Final CTA with dark background | Scaffolding only | Light gray background, not dark/gradient |

### Service Page — What Was Requested vs What Was Generated

| Brief Section | Generated? | What Appeared Instead |
|--------------|-----------|----------------------|
| Hero with service headline | Partial — hero exists, H1 is brief instruction | "Build a content-rich service detail page" |
| Value proposition (3-4 cards) | Not generated | Generic "Social Proof Bar" instead |
| Step-by-step process (4-5 steps) | Not generated | Generic "Problem" section |
| Alternating image/text blocks | Not generated | Generic "Solution Features" |
| FAQ (5-8 questions) | Not generated | H3 "An FAQ section with 5" (brief fragment) |
| Contact/conversion CTA | Scaffolding only | "Contact Us" button in generic section |

---

## 6. Viewport-by-Viewport Findings

### Desktop (1440px)

- Hero: dark navy gradient (#1E3A5F) background, brief text as H1 is visible but very low contrast (dark text on dark bg)
- Sections: all have identical 120px top/bottom padding — monotonous vertical rhythm
- Section backgrounds alternate between #f1f5f9 and #f8fafc (very subtle difference)
- Massive empty whitespace in sections that only have 1-2 lines of placeholder text
- No horizontal overflow
- Performance: DCL 1.4s, DOM complete 2.1-2.5s, ~38KB transfer

### Tablet (1024px)

- "Contact" nav link hidden (only 4 of 5 nav items visible)
- Hero text wraps appropriately
- Sections remain empty/placeholder with excessive padding
- Stats grid collapses from 4→3 columns (landing) and 3→stacked (service)

### Mobile (478px)

- Hamburger menu present and functional
- Hero heading readable and properly sized
- 4th stat column (landing) clips off-screen
- Sections still have 120px padding — excessive for mobile viewport
- Footer stacks to single column correctly

---

## 7. What Is Working Well

1. **Template inheritance** — Header and footer from site templates (post IDs 1760, 1763) correctly applied to both generated pages
2. **Responsive framework** — Hamburger menu, section stacking, text reflow all work correctly
3. **No overflow or layout breaks** — Zero horizontal overflow at any viewport
4. **Performance** — DCL under 1.5s, small transfer size (~38KB), no console errors
5. **ACSS integration** — Section backgrounds use ACSS-compatible color values, heading sizes follow the ACSS typography scale
6. **Hero visual treatment** — Dark gradient backgrounds with proper section structure
7. **Admin labels** — All sections properly labeled for builder UX
8. **Heading hierarchy** — Technically correct (H1 > H2 > H3), even though content is wrong
9. **Skip links** — Accessibility skip links present
10. **Polish scoring** — Design loop successfully improved polish scores to 100 on both pages
11. **Hero scoring** — Hero score 78 passes threshold, correctly identifies "no-proof-near-cta" anti-pattern

---

## 8. What Is Not Working Well

1. **Content generation is fundamentally broken** — Brief treated as literal content, not a prompt
2. **No structural differentiation** — Both pages use identical scaffolding regardless of brief
3. **No real copy** — Only placeholder text ("Use this section to support the X narrative")
4. **No images** — Zero content images sourced or imported
5. **No brand compliance** — Style memory not configured, generic palette used
6. **Monotonous section padding** — All sections 120px, no variation for rhythm
7. **No mobile padding reduction** — 120px padding excessive on 478px viewport
8. **Hero text contrast** — Dark heading text on dark background (estimated ~1.5:1 ratio)
9. **Design score discrepancy** — Build reports 25/29, validate returns 0/1
10. **Missing requested sections** — FAQ, how-it-works, alternating blocks all absent
11. **Stats are brief fragments** — Numbers from the brief (4, 3, 3, 6) parsed as stat values
12. **Testimonials contain brief text** — Brief instruction phrases rendered as customer quotes

---

## 9. Fixes Applied

No fixes were applied to the generated pages. Per the audit protocol, content generation failures (wrong copy, missing sections) are plugin-level bugs, not page-level fixes. Fixing the content on these pages would obscure the audit's ability to measure the build tool's actual output quality.

The pages were temporarily published for Playwright screenshots, then reverted to draft status.

---

## 10. Plugin Improvement Recommendations (Prioritized)

| ID | Priority | Category | Observed Symptom | Likely Root Cause | Proposed Improvement | Expected Impact | Ideal Behavior |
|----|----------|----------|-----------------|-------------------|---------------------|----------------|----------------|
| R-01 | **CRITICAL** | Content Generation | Brief instructions appear as H1, body text, H3 headings | Build tool does not invoke an LLM to generate content from the brief — it parses the brief text and places fragments directly into elements | Build tool must pass the brief to an LLM (or internal content generation engine) that produces original headlines, body copy, and CTA text derived from the brief's intent and the site's existing content | Would fix the #1 quality gap — every other improvement is moot if the brief is the content | H1 should be "Compassionate Veterinary Care in Marietta", not "Build a modern, conversion-focused landing page" |
| R-02 | **CRITICAL** | Content Generation | Both pages have identical 7-section structure despite different briefs | Build tool uses a single hardcoded section template regardless of brief content | Parse the brief to extract requested section types and generate a page-specific section layout that matches the brief's structure requirements | Would produce structurally distinct pages | Landing page gets 8 distinct sections as requested; service page gets 6 different sections |
| R-03 | **CRITICAL** | Content Generation | Section headings are scaffolding labels ("Social Proof Bar", "Problem") | No content personalization or brand-context injection | Generate section-specific content: real headlines, descriptive body text, specific stats, relevant testimonials drawn from site context | Transforms scaffolding into publish-ready pages | "Problem" section becomes "Many Pet Owners Wait Too Long for Critical Care" |
| R-04 | **HIGH** | Media Pipeline | Zero content images on either page | Build tool does not invoke search-stock-images or import-stock-image | Auto-source images during build: search for relevant stock images, import them, and assign to hero backgrounds, feature cards, and content sections | Eliminates bare/text-only pages | Hero has a relevant veterinary/pet image; feature cards have icons or photos |
| R-05 | **HIGH** | Brand Compliance | Style memory not configured — no brand ground truth available | No prerequisite check for style memory before building with reuse_design_system:true | Require or auto-run setup-design-system / update-site-style-memory before build; fail or warn if not configured | Ensures brand colors, CTA text, and fonts are available | Build tool consumes stored brand values or refuses to proceed without them |
| R-06 | **HIGH** | Design System | All sections use identical 120px padding — monotonous rhythm | Hardcoded default padding with no variation logic | Vary section padding based on section type: hero (120px), content (80-96px), CTA (64-80px), trust bar (48px); use ACSS section spacing classes | Better visual rhythm and page narrative pacing | Sections have 3-4 different padding levels creating visual interest |
| R-07 | **HIGH** | Responsive Quality | 120px section padding on mobile is excessive | No tablet/mobile breakpoint overrides for section padding | Set explicit breakpoint overrides: 80px tablet, 48-64px mobile; or use ACSS section--m/section--l classes which auto-reduce | Prevents excessive whitespace on small screens | Mobile sections have 48px padding, tablet 80px |
| R-08 | **MEDIUM** | Accessibility | H1 is brief instruction text, not meaningful page content | No validation that H1 represents real page content | Add a brief-as-content detection check: if H1 text matches >30% of the brief input, flag it and regenerate | Catches the most visible symptom of content generation failure | Build tool rejects H1 that mirrors the brief |
| R-09 | **MEDIUM** | Design System | Hardcoded _padding values instead of ACSS classes | Build tool generates inline padding settings | Use ACSS section spacing classes (section--m, section--l, section--xl) on section elements | Leverages ACSS responsive scaling automatically | All sections use ACSS classes, no hardcoded padding |
| R-10 | **MEDIUM** | Observability | No way to tell if the build followed the brief without manual inspection | No fidelity metric in build output | Return a `brief_fidelity_score` that measures heading-to-brief similarity, section count match, and content originality | Signals caller to re-run or adjust before publishing | Build output includes `brief_fidelity_score: 0.85` |
| R-11 | **MEDIUM** | Workflow Integration | Build reports design_score 25/29 but validate-design returns 0/1 | Different scoring mechanisms or criteria between build-time and validate-design | Reconcile or clearly document the two scoring systems; ideally use a single consistent metric | Accurate quality signals for automated workflows | Same score from both tools |
| R-12 | **LOW** | Safety | No warning when style memory is unconfigured and reuse_design_system is true | Silent fallback to generic styling | Warn in build output when style memory is empty, suggest running setup-design-system first | Prevents unexpected generic results | Build output includes warning: "style memory not configured — using defaults" |

---

## 11. Recommended Guardrails for Single-Prompt Generation

1. **Pre-flight check**: Before build-page-from-brief, verify site-style-memory is configured. If not, either auto-initialize from existing pages or return an error.

2. **Brief-as-content gate**: After element generation, check if H1 text has >30% overlap with the brief input. If so, regenerate the H1 using the brief as a prompt, not content.

3. **Section structure validation**: Compare generated section types against what the brief requested. Flag missing sections and structural overlap with other recently-generated pages.

4. **Content originality check**: Verify that body text elements don't contain brief instruction fragments. Flag placeholder text ("Use this section to support...").

5. **Image check**: Verify at least 1 content image per page. If zero, auto-invoke search-stock-images + import-stock-image for the hero section at minimum.

6. **Responsive padding**: Never use a single padding value for all sections. Require at least 3 distinct padding levels and enforce mobile overrides.

7. **Score reconciliation**: Use a single design score across all tools. Report it consistently.

8. **Post-build audit**: Auto-run validate-design + score-hero after every build. Include results in the build response.

---

## 12. Remaining Uncertainties

1. **Hero text contrast**: The dark heading text on the dark hero background appears to have very low contrast (~1.5:1), but precise measurement is difficult because the text color inherits from a global setting and the background is a solid color, not an image. Needs manual verification.

2. **ACSS responsive behavior**: Whether ACSS section spacing classes would auto-reduce padding at tablet/mobile breakpoints was not tested because the build tool used hardcoded `_padding` values instead of ACSS classes.

3. **Content generation capability**: It is unclear whether `build-page-from-brief` is designed to generate original content or whether it intentionally produces scaffolding. The tool's internal instructions suggest it should "write realistic, conversion-oriented content," but the observed behavior contradicts this.

4. **Design score meaning**: The discrepancy between build-time scores (25/29) and validate-design scores (0/1) suggests either different scoring criteria or a bug. The actual quality bar for each score is undocumented.

5. **Tablet nav truncation**: The "Contact" nav link disappearing at 1024px may be intentional (space constraint) or a bug. Needs design review.

6. **Service page testimonials**: The service page generated 3 testimonial quotes with attributed names — these are the only elements that appear to contain generated (non-brief) content. It's unclear if this represents partial content generation success or hardcoded template content.

---

## Completion Checklist

- [x] Phase 1: Inspected MCP tool inventory (89 tools) and documented connectivity (REST API)
- [x] Phase 1: Detected CSS framework (ACSS 3.3.6) and read site style memory (not configured)
- [x] Phase 2: Created two pages via build-page-from-brief (IDs 1777, 1779)
- [x] Phase 2: Ran validate-design and score-hero on both pages
- [x] Phase 3: Validated brief fidelity — CRITICAL failures on content uniqueness, brief-as-content, brand colors, CTA text
- [x] Phase 4: Audited both pages on desktop (1440px), tablet (1024px), and mobile (478px) with screenshots
- [x] Phase 4: Checked heading structure, contrast, images, performance, overflow
- [x] Phase 4: Reverted both pages to draft status
- [x] Phase 5: Evaluated all criteria with pass/fail/uncertain status
- [x] Phase 6: Documented why fixes were not applied (plugin-level content generation bugs)
- [x] Phase 7: Produced 12 prioritized plugin recommendations tied to evidence
- [x] Saved all reports and artifacts to reports/

---

## Artifacts

```
reports/
├── bricks-ui-ux-audit.md              # This report
├── bricks-ui-ux-findings.json         # Structured findings
├── screenshots/
│   ├── landing-desktop-full.png
│   ├── landing-desktop-hero.png
│   ├── landing-tablet-full.png
│   ├── landing-mobile-full.png
│   ├── landing-mobile-hero.png
│   ├── service-desktop-full.png
│   ├── service-desktop-hero.png
│   ├── service-tablet-full.png
│   ├── service-mobile-full.png
│   └── service-mobile-hero.png
└── raw-data/
    ├── discovery.json
    ├── brief-fidelity.json
    └── playwright-findings.json
```
