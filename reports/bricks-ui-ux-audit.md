# Bricks MCP UI/UX Audit Report

**Date:** 2026-03-20
**Site:** https://drphilgood.com
**Auditor:** Claude Code (Opus 4.6) via Playwright MCP
**Pages Audited:** Home (/), My Practice (/my-practice/)
**Viewports:** Desktop (1440x900), Tablet (768x1024), Mobile (390x844)

---

## 1. Executive Summary

This audit evaluated the DrPhilGood.com website across two representative pages (Home and My Practice) at three viewport sizes using Playwright browser automation. The site is well-built with Bricks Builder + ACSS, demonstrating clean heading hierarchy, good body text contrast, fast loading, and responsive behavior with zero horizontal overflow.

**Critical finding:** The Bricks MCP server was NOT connected to this Claude Code session. No Bricks/WordPress tools were available, meaning page creation was impossible. This is the single largest workflow gap — without MCP connectivity, automated page building cannot occur.

**Key strengths:** Fast performance (FCP ~1.7s), excellent heading structure, WCAG-compliant body text contrast, responsive layouts that adapt cleanly, professional design language.

**Key weaknesses:** Scroll-reveal animations make automated visual QA nearly impossible, hero background image is dated and reused across pages, home page cards underutilize desktop width with single-column layout, 15+ third-party scripts loaded for a brochure site.

---

## 2. Environment & MCP Tool Inventory

### Available MCP Servers
| Server | Status | Tools Available |
|--------|--------|----------------|
| **Bricks MCP (WordPress)** | **NOT CONNECTED** | 0 tools |
| Playwright | Connected | 20+ browser automation tools |
| Notion | Connected | 12+ tools (not relevant) |
| Gmail | Connected | (not relevant) |
| Google Calendar | Connected | (not relevant) |
| Trigger.dev | Connected | (not relevant) |
| VS Code IDE | Connected | 2 tools |

### Impact of Missing Bricks MCP
- Could not create the two planned demo pages ("UX Audit Demo - Landing Page" and "UX Audit Demo - Service Detail Page")
- Could not modify any existing page content
- Could not test the Bricks MCP authoring workflow end-to-end
- Switched to auditing existing pages as the best available alternative

---

## 3. Pages Audited

Since the Bricks MCP server was unavailable, I audited the two existing pages that best match the requested patterns:

| Page | URL | Post ID | Pattern Match |
|------|-----|---------|---------------|
| Home | / | 1581 | Landing page (hero, cards, stats, quote, CTA) |
| My Practice | /my-practice/ | 1747 | Service detail (hero, about, service cards, training, CTA) |

---

## 4. Page-by-Page Findings

### Home Page (/)

#### Heading Structure (GOOD)
```
H1: Dr. Phil Good, DVM
  H2: What I Do
    H3: My Practice
    H3: Rescue Mission
    H3: Our Legacy
  H2: Let's Connect
  H3: Dr. Phil Good, DVM (footer)
    H4: Quick Links
    H4: Contact
    H4: Links
```
- Clean, logical hierarchy with no skipped levels
- Single H1 establishes page topic
- Footer H3 is acceptable convention

#### Hero Section
- **Headline:** "Dr. Phil Good, DVM" (42.6px, white, bold 800)
- **Subtitle:** "Veterinarian · Rescue Advocate · Father" (18px, white)
- **Description:** Leading Beyond Pets... since 1979 (18px, white 95% opacity)
- **Primary CTA:** "Learn My Story" (blue #2563EB, 16px, links to /about-me/)
- **Secondary CTA:** "Book Appointment" (outlined white, links to beyondpets.com)
- **Background:** ClinicMainPic.jpg with dark blue overlay

**Strengths:** Clear value proposition, two differentiated CTAs, dark overlay ensures readability.
**Weaknesses:** Background image shows old "Town & Country" signage — feels dated. No photo of Dr. Good himself. Hero is 100vh tall, pushing content below fold.

#### Content Sections
- **What I Do Cards:** Three vertical cards (My Practice, Rescue Mission, Our Legacy) with Themify icons, descriptions, and "Learn More" links
- **Stats Bar:** Dark navy background with "45+", "20,000+", "1" stats — clean and impactful
- **Quote:** Personal quote from Dr. Good with decorative styling. NOTE: Opening quote renders as raw unicode `201C` instead of a styled quotation mark
- **CTA:** "Let's Connect" with dark overlay background, centered "Get in Touch" button
- **Footer:** 4-column layout (bio, quick links, contact info, external links)

### My Practice Page (/my-practice/)

#### Heading Structure (EXCELLENT)
```
H1: Beyond Pets Animal Hospital
  H2: A Practice Built on Family
  H2: Our Services
    H3: Wellness & Prevention
    H3: Internal Medicine
    H3: Surgery
    H3: Dentistry
    H3: Ultrasound & Diagnostics
    H3: Boarding & Grooming
  H2: Training the Next Generation
  H2: Schedule a Visit
```
- Perfect semantic hierarchy
- Each service gets proper H3 under H2 "Our Services"
- "Schedule a Visit" CTA has appropriate H2 weight

#### Hero Section
- **Headline:** "Beyond Pets Animal Hospital" (42.6px, white)
- **Subtitle:** "Formerly Town & Country Veterinary Hospital · Serving Marietta Since 1979"
- **Background:** Same ClinicMainPic.jpg as home page

**Issue:** Same hero image as home — page feels repetitive. No CTA buttons in hero.

#### Content Sections
- **About:** "A Practice Built on Family" — text + clinic photo. Good use of image/text layout.
- **Services:** 6 service cards with icons (heart, stethoscope, scissors, tooth, ultrasound, pet) — clean, centered, single-column
- **Training:** Text section about teaching veterinary students
- **CTA:** "Schedule a Visit" with dark background, link to beyondpets.com

---

## 5. Viewport-by-Viewport Findings

### Desktop (1440x900)

| Criterion | Rating | Notes |
|-----------|--------|-------|
| Hero effectiveness | Good | Clear hierarchy, readable CTAs |
| Content layout | Fair | Cards underutilize 1200px width — single column instead of 3-col grid |
| Navigation | Good | Horizontal links, clear active state (underline on current page) |
| Typography | Good | 18px body, strong heading scale |
| Image quality | Fair | Hero image dated, logo oversized (848px for 141px display) |
| Spacing | Good | Consistent section padding, 8px grid followed |

### Tablet (768x1024)

| Criterion | Rating | Notes |
|-----------|--------|-------|
| Hero effectiveness | Good | Hamburger menu appears, text remains centered and readable |
| Content layout | Good | Cards stack cleanly, same as desktop (already single-col) |
| Navigation | Good | Clean hamburger transition |
| Stats section | Good | Numbers wrap or stack appropriately |
| Footer | Good | Columns wrap to fit viewport |

### Mobile (390x844)

| Criterion | Rating | Notes |
|-----------|--------|-------|
| Hero effectiveness | Good | Text adjusts well, CTAs stack vertically, remain tappable |
| Content layout | Good | Single-column cards with generous touch targets |
| No horizontal overflow | Pass | scrollWidth === clientWidth === 390 |
| Footer | Good | Stacks to single column |
| Service cards | Good | Centered icons with readable text |
| CTA buttons | Good | Full-width, easy to tap |

---

## 6. What Is Working Well

1. **Heading hierarchy** — Both pages have clean, logical heading structures with no skipped levels
2. **Body text contrast** — rgb(51, 65, 85) on white = 7.58:1 ratio (excellent)
3. **Heading contrast** — rgb(15, 23, 42) on white = 17.58:1 ratio
4. **Performance** — FCP at ~1.7s, well under the 2.5s LCP target
5. **No horizontal overflow** — Verified on all 3 viewports for both pages
6. **Responsive navigation** — Clean transition from horizontal nav to hamburger menu
7. **Footer layout** — Adapts well from 4-col (desktop) to stacked (mobile)
8. **Skip links** — Present for "Skip to main content" and "Skip to footer"
9. **Button styling** — Primary (filled blue) and secondary (outlined) CTAs are well-differentiated
10. **Image alt text** — Logo and content images have descriptive alt attributes

---

## 7. What Is Not Working Well

1. **Scroll-reveal animations block automated screenshots** — Content at opacity: 0 until scrolled, making full-page screenshots appear blank
2. **Hero image is dated** — Shows old "Town & Country Veterinary Clinic" signage with cars in parking lot. Not aspirational for a professional biography site
3. **Hero image reused across pages** — Home and My Practice use the same ClinicMainPic.jpg
4. **Home page cards are single-column on desktop** — Wastes 1200px content width that could display 3 cards side by side
5. **Quote section unicode glitch** — Opening quotation mark renders as raw "201C" text instead of styled character
6. **Logo PNG massively oversized** — 848x240px PNG served for 141x40px display (6x oversized). No WebP/AVIF, no srcset
7. **15+ third-party scripts loaded** — GSAP, ScrollTrigger, ScrollSmoother, Swup (5 sub-libraries), New Relic, Google Analytics, BricksForge, BricksExtras for a brochure site
8. **Skip link contrast fails** — 2.67:1 ratio (needs 4.5:1)
9. **No hero CTA on My Practice page** — Hero section has no call-to-action buttons
10. **Cards use div-based markup** — No semantic article/section elements for card patterns

---

## 8. High-Confidence Fixes (Not Applied)

Since the Bricks MCP server was not connected, no fixes could be applied. The following would be applied if write access were available:

| Fix | Effort | Impact |
|-----|--------|--------|
| Fix quote section "201C" unicode rendering | Low | Eliminates visual glitch |
| Add 3-column grid to home page cards on desktop | Medium | Better use of horizontal space |
| Optimize logo PNG (serve at 282x80 or SVG) | Low | Faster LCP, less bandwidth |
| Add preload hint for hero background image | Low | Faster LCP |
| Fix skip link contrast (darker background or lighter text) | Low | WCAG AA compliance |
| Add CTA buttons to My Practice hero | Low | Better conversion funnel |

---

## 9. Priority Recommendations for Bricks MCP Workflow

### Critical
1. **Connect Bricks MCP server** — Without it, zero automated page creation or modification is possible. This is the foundational requirement.

### High
2. **Add animation-disable mode for auditing** — Scroll-reveal animations make automated visual QA impossible. Need a render mode that forces all elements visible.
3. **Image optimization pipeline** — Auto-generate srcset, WebP/AVIF, warn on oversized images, encourage unique images per page.
4. **Responsive grid defaults for card patterns** — Page blueprints should generate 3-col desktop / 2-col tablet / 1-col mobile grids for cards.
5. **Post-generation audit loop** — After creating a page, automatically run heading check, contrast scan, overflow test, and CLS measurement.

### Medium
6. **Performance guardrails** — Warn when page loads 10+ scripts. Identify unused JS libraries per page.
7. **Semantic HTML templates** — Cards as `<article>`, sections with proper landmarks, admin labels as aria-labels.
8. **Quote section template fix** — Use CSS ::before for decorative quotes instead of raw unicode characters.
9. **Skip link accessibility defaults** — Default styling should pass WCAG AA.
10. **Example prompt library** — Provide tested prompts for common page types (landing, service, about, contact).

---

## 10. Recommended Guardrails for Single-Prompt Generation

To reliably produce beautiful pages from a single prompt, the Bricks MCP workflow should enforce:

1. **Heading hierarchy validation** — No skipped levels, single H1, logical nesting
2. **Contrast minimum** — All text/background combinations >= 4.5:1 (AA normal text)
3. **Image optimization** — Max 2x display size, WebP/AVIF format, alt text required
4. **Responsive grid** — Card/feature sections use responsive grid by default
5. **Hero requirements** — At least one CTA, text contrast verified against background
6. **Overflow check** — Verify scrollWidth === clientWidth on mobile before completion
7. **Animation safety** — Ensure content is visible without JS. Respect prefers-reduced-motion
8. **Script budget** — Warn if total JS exceeds 200KB compressed
9. **Semantic HTML** — Use article, section, nav, main, footer elements appropriately
10. **Admin labels** — Auto-assign stable labels to all section-level elements for deterministic updates

---

## 11. Remaining Uncertainties & Manual Review Items

| Item | Why Manual Review Needed |
|------|-------------------------|
| Hero text contrast on image backgrounds | Cannot be programmatically measured — estimated at 7:1+ based on visual inspection of dark overlay |
| prefers-reduced-motion support | Could not verify if animations are disabled for users with motion sensitivity |
| Mobile menu usability | Hamburger menu exists but was not tested for open/close behavior |
| Touch target sizes | Card "Learn More" links appear small (14px font, ~45px height) — needs finger-tap testing |
| Form accessibility | Contact page not audited — forms need label/error state review |
| SEO meta tags | Rank Math active but meta descriptions not inspected |
| Real-world LCP | Lab FCP was ~1.7s but real-world LCP with images may differ |
| CLS on slow connections | No layout shift observed on fast connection, but deferred images may cause shifts |

---

## 12. Screenshots Reference

All screenshots saved to `reports/screenshots/`:

### Home Page
| Viewport | Files |
|----------|-------|
| Desktop | `home-dt-01-hero.png` through `home-dt-07-footer.png` |
| Tablet | `home-tab-01-hero.png` through `home-tab-05-cta-footer.png` |
| Mobile | `home-mob-01-hero.png` through `home-mob-06-cta.png` |

### My Practice Page
| Viewport | Files |
|----------|-------|
| Desktop | `practice-dt-01-hero.png` through `practice-dt-06-footer.png` |
| Tablet | `practice-tab-01-hero.png` through `practice-tab-04-cta-footer.png` |
| Mobile | `practice-mob-01-hero.png` through `practice-mob-05-cta-footer.png` |

### Raw Data
- `reports/raw-data/home-network.txt` — Full network request log
- `reports/bricks-ui-ux-findings.json` — Structured findings data

---

*Report generated by Claude Code (Opus 4.6) using Playwright MCP for browser automation. No Bricks MCP tools were available for page creation or modification.*
