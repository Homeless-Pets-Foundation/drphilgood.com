# DrPhilGood.com Website Build Plan

## Context

DrPhilGood.com is the professional website for **Dr. Phil Good, DVM** — a veterinarian and animal rescue advocate in Marietta, Georgia. He operates **Beyond Pets Animal Hospital** and directs the **Homeless Pets Foundation**. The site is built with Bricks Builder 2.2, ACSS v3.3.6, and Rank Math SEO, managed via the Bricks MCP plugin over REST API calls.

**Mission:** Showcase Dr. Good's 45+ years of compassionate veterinary care, his rescue work through the Homeless Pets Foundation, and provide a digital home for his professional legacy.

**Brand assets exist:** Photos of Dr. Good, clinic images, rescue animal photos, Beyond Pets logo. Colors, fonts, and design language are established.

---

## Phase 0: Foundation Setup

### 0A. Configure ACSS Color Variables
Since ACSS is installed and owns the CSS variable layer, configure these in ACSS settings (manual or via `bricks/manage-options`):
- **Primary**: `#1E40AF` (blue)
- **Primary light**: `#3B82F6` (blue-500)
- **Accent green**: `#10B981` (emerald)
- **Accent purple**: `#7C3AED` (violet)
- **Base/Text**: `#1F2937` (gray-800)
- **Text muted**: `#6B7280` (gray-500)
- **Background**: `#F9FAFB` (gray-50)
- **Surface**: `#F3F4F6` (gray-100)
- **White**: `#ffffff`
- **Dark surface**: `#1E3A5F` (dark blue)
- **Dark deep**: `#0F172A` (slate-900)

### 0B. Design System Setup via MCP
Call `bricks/setup-design-system` with:
- **Style**: `professional-warm`
- **apply**: `true`
- **apply_site_style_memory**: `true`

Then override the generated palette with DrPhilGood's actual brand colors via `bricks/update-global-settings`.

### 0C. Typography (via Bricks Theme Styles)
Call `bricks/update-global-settings` to set theme styles:
- **Heading font**: `Plus Jakarta Sans` (weight 600-700, line-height 1.2)
- **Body font**: `Inter` (weight 400, line-height 1.6)
- **Body size**: `18px`
- **Type scale**: 1.25 Major Third (h1: 49px, h2: 39px, h3: 31px, h4: 25px)
- **Text color**: `#1F2937`
- **Link color**: `#1E40AF`
- **Link hover**: `#3B82F6`

### 0D. Global Classes
Create via `bricks/create-global-class` — complementing (not duplicating) ACSS utilities:
- `dpg-section-padding` — 96px top/bottom desktop, 64px tablet, 48px mobile
- `dpg-section-dark` — dark slate background (#0F172A), white text
- `dpg-section-surface` — gray-100 background
- `dpg-container` — max-width 1200px, centered
- `dpg-container-narrow` — max-width 720px, centered
- `dpg-gradient-hero` — blue gradient background (135deg, #1E40AF -> #3B82F6)
- `dpg-card` — white bg, 16px radius, soft shadow, hover elevation
- `dpg-btn-primary` — green bg (#10B981), white text, 12px/24px padding, 10px radius, hover darken
- `dpg-btn-secondary` — outline style, blue border, blue text, hover fill
- `dpg-btn-ghost` — transparent, blue text, hover bg tint
- `dpg-overline` — 12px uppercase, 500 weight, +0.1em letter-spacing, blue color
- `dpg-heading-display` — 49px Plus Jakarta Sans, -0.02em letter-spacing
- `dpg-prose` — max-width 720px, 18px Inter, 1.6 line-height

---

## Phase 1: Templates (Header + Footer)

### 1A. Header Template
Create via `bricks/create-template` (type: header, entire site condition).

**Structure:**
- Sticky header, white background, subtle bottom shadow on scroll
- **Left**: Dr. Phil Good logo/name (link to home)
- **Center**: Nav menu — About Me | My Practice | Rescue & Community | Our Legacy | Contact
- **Right**: "Schedule Visit" primary button (green accent `#10B981`)
- **Mobile**: Hamburger menu, logo centered, CTA button visible
- Padding: 16px top/bottom, 24px sides

### 1B. Footer Template
Create via `bricks/create-template` (type: footer, entire site condition).

**Structure — 4-column layout on dark surface (#0F172A):**
- **Column 1**: Dr. Phil Good, DVM + tagline "Compassionate veterinary care since 1979" + Beyond Pets logo
- **Column 2**: Practice — About Me, My Practice, Our Legacy, News
- **Column 3**: Community — Rescue & Community, Homeless Pets Foundation, Volunteer, Donate
- **Column 4**: Contact — Address (Marietta, GA), Phone, Email, Hours
- **Bottom bar**: Copyright + social icons (Facebook, Instagram, LinkedIn)

---

## Phase 2: Homepage (Post ID: 1581)

**Page purpose**: Introduce Dr. Phil Good, showcase his practice and rescue mission, and invite visitors to connect. Tell the story: who he is -> what he does -> his impact -> get in touch.

**Narrative flow — 8 sections:**

### Section 1: Hero (gradient background)
- **Layout**: Split — text left, image right (Dr. Phil Good headshot or with animals)
- **Overline**: "VETERINARIAN & ANIMAL RESCUE ADVOCATE"
- **H1**: "Compassionate Care for Every Animal"
- **Subheadline**: "For over 45 years, Dr. Phil Good has been dedicated to providing exceptional veterinary care and giving rescue animals a second chance at life in Marietta, Georgia."
- **CTA**: "Schedule a Visit" (green button) + "Learn Our Story" (ghost button)
- **Visual**: Dr. Phil Good headshot (attachment 1725) or holding dogs (attachment 1726)

### Section 2: Stats Bar (white background)
- **Layout**: 4-column stats row
- **Stats**: "45+ Years of Practice" | "10,000+ Animals Treated" | "3,000+ Rescues Placed" | "1 Unwavering Mission"

### Section 3: About Preview (surface background)
- **Layout**: Split — image left (Dr. Phil examining cat, attachment 1727), text right
- **Overline**: "MEET DR. PHIL GOOD"
- **H2**: "A Lifetime Devoted to Animals"
- **Body**: Brief introduction — veterinarian, practice owner, rescue advocate, community leader. His journey from founding the practice in 1979 to directing the Homeless Pets Foundation.
- **CTA**: "Read My Story" link to /about-me/

### Section 4: Services Overview (white background)
- **Layout**: 3-column card grid with icons
- **H2**: "Full-Service Veterinary Care"
- **Cards**:
  1. **Wellness & Prevention** — Annual exams, vaccinations, parasite prevention
  2. **Surgery & Dental** — Soft tissue surgery, dental cleanings, extractions
  3. **Diagnostics & Treatment** — In-house lab, digital X-ray, ultrasound
- **CTA**: "Explore Our Practice" link to /my-practice/

### Section 5: Rescue Mission (dark section)
- **Layout**: Split — text left, image right (HPF dogs, attachment 1737 or 1738)
- **Overline**: "HOMELESS PETS FOUNDATION"
- **H2**: "Giving Every Animal a Second Chance"
- **Body**: Overview of the Homeless Pets Foundation — rescue, rehabilitation, and rehoming. How Dr. Good's practice and the foundation work hand-in-hand.
- **Stats**: "3,000+ Animals Rescued" | "500+ Volunteers"
- **CTA**: "Our Rescue Mission" (green button) + "Donate" (ghost button, white)

### Section 6: Legacy (surface background)
- **Layout**: Timeline-style or split with Dr. Michael Good photo (attachment 1733)
- **Overline**: "OUR LEGACY"
- **H2**: "A Family Tradition of Care"
- **Body**: Brief history — Dr. Michael Good founded Town & Country Veterinary Hospital, and Phil continued the legacy with Beyond Pets Animal Hospital. Three generations of commitment to animal welfare.
- **CTA**: "Our Full Story" link to /our-legacy/

### Section 7: Testimonials (white background)
- **Layout**: 3-column card grid
- **H2**: "What Our Community Says"
- **Placeholder testimonials** (3):
  1. "Dr. Good has been our family vet for 20 years. His genuine love for animals shines through in everything he does."
  2. "The team at Beyond Pets went above and beyond for our senior dog. We couldn't ask for better care."
  3. "Adopting through the Homeless Pets Foundation changed our lives. Thank you, Dr. Good, for everything you do."

### Section 8: Final CTA (dark gradient)
- **Layout**: Centered text on gradient
- **H2**: "Ready to Experience Compassionate Care?"
- **Body**: "Whether you're looking for a trusted veterinarian or want to support our rescue mission, we'd love to hear from you."
- **CTA**: "Schedule a Visit" (green button) + "Contact Us" (white ghost button)

---

## Phase 3: About Me Page (Post ID: 1746)

**Purpose**: Dr. Phil Good's personal and professional story.

**Sections:**
1. **Hero**: "About Dr. Phil Good" — headshot, credentials, brief bio
2. **Professional Journey**: Career timeline — education, founding the practice, milestones
3. **Philosophy**: His approach to veterinary medicine — compassion, community, rescue
4. **Personal**: Beyond the clinic — family, interests, community involvement
5. **CTA**: Contact or schedule visit

---

## Phase 4: My Practice Page (Post ID: 1747)

**Purpose**: Showcase Beyond Pets Animal Hospital services and facilities.

**Sections:**
1. **Hero**: "Beyond Pets Animal Hospital" — clinic exterior photo (attachment 1728), tagline
2. **Services Grid**: Comprehensive list of veterinary services with icons
3. **Facilities**: Photos of the clinic, equipment, exam rooms
4. **Team**: Staff introductions (if available)
5. **Location & Hours**: Map, address, business hours
6. **CTA**: Schedule appointment

---

## Phase 5: Rescue & Community Page (Post ID: 1748)

**Purpose**: Homeless Pets Foundation mission, adoption info, volunteer opportunities.

**Sections:**
1. **Hero**: "Rescue & Community" — rescue dog photos
2. **HPF Mission**: What the foundation does, impact stats
3. **How to Help**: Adopt, Foster, Volunteer, Donate — 4-column card grid
4. **Success Stories**: Adoption stories with photos
5. **Events**: Upcoming community events
6. **CTA**: Volunteer or donate

---

## Phase 6: Our Legacy Page (Post ID: 1749)

**Purpose**: Family history and the evolution of the practice.

**Sections:**
1. **Hero**: "Our Legacy" — historical photo or family photo
2. **Timeline**: Key milestones from Dr. Michael Good to Dr. Phil Good
3. **Community Impact**: Numbers and stories over the decades
4. **Looking Forward**: Vision for the future
5. **CTA**: Join the legacy

---

## Phase 7: Contact Page (Post ID: 1750)

**Purpose**: Easy ways to reach Dr. Good and Beyond Pets.

**Sections:**
1. **Hero**: "Get in Touch"
2. **Split layout**: Contact form (left) + contact details, map, & hours (right)
3. **Emergency info**: After-hours emergency contacts

---

## Phase 8: SEO Meta (via Rank Math + MCP)

Set via `bricks/manage-seo-meta` for each page:

| Page | SEO Title | Meta Description |
|------|-----------|-----------------|
| Home | "Dr. Phil Good, DVM — Veterinarian & Animal Rescue Advocate in Marietta, GA" | "45+ years of compassionate veterinary care at Beyond Pets Animal Hospital. Founder of the Homeless Pets Foundation. Marietta, Georgia." |
| About Me | "About Dr. Phil Good — Veterinarian in Marietta, GA" | "Meet Dr. Phil Good, DVM — a dedicated veterinarian and animal rescue advocate serving Marietta and Metro Atlanta since 1979." |
| My Practice | "Beyond Pets Animal Hospital — Full-Service Vet Clinic in Marietta" | "Comprehensive veterinary care including wellness exams, surgery, dental, diagnostics, and more. Beyond Pets Animal Hospital, Marietta, GA." |
| Rescue & Community | "Rescue & Community — Homeless Pets Foundation" | "Dr. Phil Good's Homeless Pets Foundation rescues, rehabilitates, and rehomes animals. Learn how to adopt, foster, volunteer, or donate." |
| Our Legacy | "Our Legacy — A Family Tradition of Veterinary Care" | "From Dr. Michael Good to Dr. Phil Good — a multi-generational commitment to compassionate veterinary care and animal rescue." |
| Contact | "Contact Dr. Phil Good — Beyond Pets Animal Hospital" | "Schedule a visit, ask a question, or learn how to support the Homeless Pets Foundation. Located in Marietta, Georgia." |

---

## Brand Assets

- **Dr. Phil Good Headshot**: attachment ID 1725
- **Dr. Phil Holding Dogs**: attachment ID 1726
- **Dr. Phil Examining Cat**: attachment ID 1727
- **Clinic Building**: attachment ID 1728
- **Clinic Hero Image**: attachment ID 1729
- **Beyond Pets Logo**: attachment ID 1730
- **Colors**: Blue primary (#1E40AF), Green accent (#10B981), Near-black text (#1F2937)
- **Fonts**: Plus Jakarta Sans (headings), Inter (body)

## Style DNA Profile

**`professional-warm`** — aligns with Dr. Phil Good's approachable, trusted, professional brand:
- Tight radius (8-12px), subtle shadows
- Warm color accents against professional blue base
- Real photography — authentic, not stock
- Professional without being clinical
- Emphasizes trust, warmth, and community

## Key Design Decisions

- **ACSS + Bricks coexistence**: Use ACSS utility classes for spacing/sizing where natural, Bricks global classes for component patterns (cards, buttons, sections)
- **Green CTA buttons**: Stand out against blue brand color — all primary CTAs use green `#10B981`
- **Real photography**: Use actual photos of Dr. Good, the clinic, and rescue animals — no stock photos
- **Responsive**: Every section gets tablet (1024px) and mobile (478px) overrides per MCP spacing rules
- **Personal storytelling**: The site tells Dr. Good's story — warm, first-person where appropriate, emphasizing the human-animal bond
