# SEO Optimizer Skill

Optimize web pages for both traditional search engines and AI-powered search platforms (GEO).

## When to Use

Use this skill when:
- Launching a new website or landing page
- Improving organic search rankings
- Optimizing for AI search engines (ChatGPT, Perplexity, Google AI Overviews)
- Adding structured data / schema markup
- Diagnosing why a page isn't ranking
- Preparing content for viral distribution

---

## SEO vs GEO

| Factor | Traditional SEO | GEO (AI Search) |
|---|---|---|
| **Goal** | Rank in blue links | Appear in AI-generated answers |
| **Key signals** | Keywords, backlinks, technical SEO | Clear answers, structured data, credibility |
| **Tools** | Google Search Console | None yet — test manually |
| **Content style** | Keyword-optimized prose | Direct, factual, question-answering |

Both share the same foundation: fast, accessible, well-structured content. Optimize for both together.

---

## Implementation Steps

### Step 1: Meta Tags

```html
<head>
  <title>Primary Keyword - Secondary Keyword | Brand Name</title>
  <meta name="description" content="150-160 character description. Include primary keyword. State the value clearly.">
  <link rel="canonical" href="https://yourdomain.com/page">

  <!-- Open Graph (social sharing) -->
  <meta property="og:title" content="Same as title tag">
  <meta property="og:description" content="Same as meta description">
  <meta property="og:image" content="https://yourdomain.com/og-image.png">
  <meta property="og:url" content="https://yourdomain.com/page">

  <!-- Twitter Card -->
  <meta name="twitter:card" content="summary_large_image">
</head>
```

### Step 2: Structured Data (Schema.org)

Add JSON-LD for tools, articles, or local businesses. This is the single highest-impact GEO optimization.

**For a web tool:**

```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "SoftwareApplication",
  "name": "Tool Name",
  "description": "What the tool does in one sentence",
  "applicationCategory": "UtilitiesApplication",
  "operatingSystem": "Any (Web-based)",
  "offers": { "@type": "Offer", "price": "0", "priceCurrency": "USD" }
}
</script>
```

**For FAQ content (GEO boost):**

```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {
      "@type": "Question",
      "name": "How does [tool] work?",
      "acceptedAnswer": { "@type": "Answer", "text": "Direct, complete answer in 1-3 sentences." }
    }
  ]
}
</script>
```

### Step 3: Content Structure

Structure content so both humans and AI models can extract key facts quickly:

- **H1**: One per page — exact match for primary keyword
- **H2/H3**: Use question-format headings ("How to X", "What is Y")
- **First 100 words**: State who it's for and what it does — directly
- **Lists and tables**: Preferred by AI models for extracting structured facts
- **FAQ section**: Answer the top 5 questions users search around this topic

### Step 4: Technical SEO

| Check | Target |
|---|---|
| **Page speed** | Largest Contentful Paint under 2.5s |
| **Mobile** | Google Mobile-Friendly Test: pass |
| **HTTPS** | Required — HTTP pages penalized |
| **Crawlability** | No `noindex` on pages you want ranked |
| **Sitemap** | `/sitemap.xml` submitted to Google Search Console |
| **Core Web Vitals** | LCP < 2.5s, INP < 200ms, CLS < 0.1 |

### Step 5: Link Building

Backlinks are still the #1 ranking signal. Priority targets:

1. **Product Hunt** — launch for an instant 50–200 high-quality backlinks
2. **Indie Hackers / Hacker News** — community posts with genuine value
3. **Directories** — submit to relevant awesome-lists and tool directories
4. **Guest content** — write for newsletters or blogs in your niche
5. **HARO / Qwoted** — respond to journalist queries for press mentions

---

## GEO Optimization Rules

To appear in AI-generated answers:

- **Answer directly** — put the answer in the first sentence, not at the end
- **Be factual** — AI models favor verifiable, specific claims over vague descriptions
- **Include numbers** — "Saves 3 hours per week" beats "saves time"
- **Add a FAQ** — question-answer format is the most common AI citation pattern
- **Cite sources** — external references signal credibility to AI models
- **Keep sentences short** — under 25 words per sentence for extractability

---

## Output Deliverables

1. SEO-optimized title and meta description
2. Open Graph + Twitter Card tags
3. JSON-LD structured data (SoftwareApplication or Article schema)
4. FAQ section (5 questions + answers)
5. Technical SEO audit checklist
6. Heading structure with primary/secondary keywords
7. Page speed recommendations
