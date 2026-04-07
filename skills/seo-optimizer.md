<![CDATA[# SEO Optimizer Skill

Optimize web pages for search engines and AI-powered search platforms (GEO).

## When to Use

Use this skill when:
- Launching a new website or landing page
- Improving search rankings
- Optimizing for AI search engines (ChatGPT, Perplexity)
- Adding structured data
- Fixing SEO issues
- Preparing content for viral distribution

---

## How It Works

### SEO vs GEO

```
Traditional SEO                    GEO (Generative Engine Optimization)
     │                                        │
     ▼                                        ▼
┌─────────────┐                    ┌─────────────────────┐
│ Google Bot  │                    │ AI Search Engines   │
│ Bing Bot    │                    │ - ChatGPT + Bing    │
│             │                    │ - Perplexity        │
└──────┬──────┘                    │ - Google AI Overview│
       │                           └──────────┬──────────┘
       ▼                                      ▼
 Keywords +                          Clear, direct answers +
 Backlinks +                         Structured data +
 Technical SEO                       Credibility signals
```

---

## Implementation Steps

### Step 1: Meta Tags

```html
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  
  <!-- Primary Meta Tags -->
  <title>Primary Keyword - Secondary Keyword | Brand Name</title>
  <meta name="title" content="Primary Keyword - Secondary Keyword | Brand Name">
  <meta name="description" content="Compelling description with keywords, 150-160 chars. Include call-to-action.">
  <meta name="keywords" content="keyword1, keyword2, keyword3">
  <meta name="author" content="Author Name">
  
  <!-- Canonical URL -->
  <link rel="canonical" href="https://yourdomain.com/page">
  
  <!-- Open Graph / Facebook -->
  <meta property="og:type" content="website">
  <meta property="og:url" content="https://yourdomain.com/page">
  <meta property="og:title" content="Title for Social Sharing">
  <meta property="og:description" content="Description for social sharing. Can be longer.">
  <meta property="og:image" content="https://yourdomain.com/og-image.jpg">
  <meta property="og:image:width" content="1200">
  <meta property="og:image:height" content="630">
  
  <!-- Twitter -->
  <meta property="twitter:card" content="summary_large_image">
  <meta property="twitter:url" content="https://yourdomain.com/page">
  <meta property="twitter:title" content="Title for Twitter">
  <meta property="twitter:description" content="Description for Twitter.">
  <meta property="twitter:image" content="https://yourdomain.com/twitter-image.jpg">
  
  <!-- Robots -->
  <meta name="robots" content="index, follow">
  <meta name="googlebot" content="index, follow">
</head>
```

### Step 2: Schema.org Structured Data

**SoftwareApplication Schema (for tools):**
```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "SoftwareApplication",
  "name": "PDF Tool Name",
  "description": "Detailed description of what the tool does",
  "url": "https://yourdomain.com/pdf-tool",
  "applicationCategory": "UtilitiesApplication",
  "operatingSystem": "Any (Web-based)",
  "offers": {
    "@type": "Offer",
    "price": "0",
    "priceCurrency": "USD"
  },
  "aggregateRating": {
    "@type": "AggregateRating",
    "ratingValue": "4.8",
    "ratingCount": "1250"
  },
  "author": {
    "@type": "Organization",
    "name": "Your Company"
  }
}
</script>
```

**FAQPage Schema:**
```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "FAQPage",
  "mainEntity": [
    {
      "@type": "Question",
      "name": "How do I convert PDF to Word?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Upload your PDF file, click 'Convert', and download the Word document. The conversion is free and happens in your browser."
      }
    },
    {
      "@type": "Question",
      "name": "Is my data secure?",
      "acceptedAnswer": {
        "@type": "Answer",
        "text": "Yes, all processing happens locally in your browser. Your files never leave your device."
      }
    }
  ]
}
</script>
```

**HowTo Schema:**
```html
<script type="application/ld+json">
{
  "@context": "https://schema.org",
  "@type": "HowTo",
  "name": "How to Merge PDF Files",
  "description": "Step-by-step guide to merge multiple PDF files into one",
  "totalTime": "PT2M",
  "step": [
    {
      "@type": "HowToStep",
      "position": 1,
      "name": "Upload PDF files",
      "text": "Click 'Upload' or drag and drop your PDF files into the upload area."
    },
    {
      "@type": "HowToStep",
      "position": 2,
      "name": "Arrange order",
      "text": "Drag files to rearrange them in your preferred order."
    },
    {
      "@type": "HowToStep",
      "position": 3,
      "name": "Merge and download",
      "text": "Click 'Merge' and download your combined PDF file."
    }
  ]
}
</script>
```

### Step 3: GEO Optimization

**Optimize for AI search by:**

1. **Direct Answers First**
   ```html
   <!-- Start with the direct answer -->
   <p class="answer">
     To convert PDF to Word: Upload your PDF, click 'Convert', then download. 
     Processing is free and happens entirely in your browser for privacy.
   </p>
   
   <!-- Then provide detail -->
   <section class="detailed-guide">
     <!-- More comprehensive explanation -->
   </section>
   ```

2. **Structured Content**
   ```html
   <article>
     <h1>PDF to Word Converter</h1>
     
     <section id="what">
       <h2>What is PDF to Word conversion?</h2>
       <p>PDF to Word conversion transforms...</p>
     </section>
     
     <section id="how">
       <h2>How to convert PDF to Word</h2>
       <ol>
         <li>Upload your PDF file</li>
         <li>Wait for processing</li>
         <li>Download Word document</li>
       </ol>
     </section>
     
     <section id="faq">
       <h2>Frequently Asked Questions</h2>
       <!-- FAQ items -->
     </section>
   </article>
   ```

3. **Credibility Signals**
   ```html
   <!-- Author information -->
   <div class="author-info">
     <img src="author-photo.jpg" alt="Author Name">
     <span>Written by <a href="/about/author">Author Name</a></span>
     <span>Updated: January 2024</span>
     <span>Reviewed by: Expert Name, Title</span>
   </div>
   
   <!-- Trust badges -->
   <div class="trust-signals">
     <span>✓ Privacy-first processing</span>
     <span>✓ Used by 100,000+ users</span>
     <span>✓ Featured in TechCrunch</span>
   </div>
   ```

### Step 4: Core Web Vitals

```javascript
// Optimize Largest Contentful Paint (LCP)
// - Preload critical images
<link rel="preload" as="image" href="hero-image.jpg">

// - Lazy load below-fold images
<img loading="lazy" src="below-fold.jpg" alt="Description">

// Optimize Cumulative Layout Shift (CLS)
// - Set dimensions on images
<img width="800" height="600" src="image.jpg" alt="Description">

// - Reserve space for dynamic content
<div class="ad-container" style="min-height: 250px;"></div>

// Optimize First Input Delay (FID)
// - Defer non-critical JavaScript
<script defer src="analytics.js"></script>

// - Split large tasks
function processLargeData(data) {
  const chunks = chunkArray(data, 100);
  chunks.forEach((chunk, i) => {
    setTimeout(() => processChunk(chunk), i * 0);
  });
}
```

### Step 5: Technical SEO

```html
<!-- Robots.txt -->
User-agent: *
Allow: /
Disallow: /api/
Disallow: /admin/
Sitemap: https://yourdomain.com/sitemap.xml

<!-- XML Sitemap -->
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url>
    <loc>https://yourdomain.com/</loc>
    <lastmod>2024-01-15</lastmod>
    <changefreq>weekly</changefreq>
    <priority>1.0</priority>
  </url>
  <url>
    <loc>https://yourdomain.com/pdf-converter</loc>
    <lastmod>2024-01-10</lastmod>
    <changefreq>monthly</changefreq>
    <priority>0.8</priority>
  </url>
</urlset>
```

---

## SEO Checklist

### Technical SEO
- [ ] HTTPS enabled
- [ ] Mobile responsive
- [ ] Fast loading (<3s)
- [ ] Valid HTML
- [ ] Sitemap submitted
- [ ] Robots.txt configured
- [ ] Canonical URLs set
- [ ] 404 page exists

### On-Page SEO
- [ ] Title tag optimized (50-60 chars)
- [ ] Meta description written (150-160 chars)
- [ ] H1 tag with primary keyword
- [ ] H2-H6 hierarchy logical
- [ ] Alt text on images
- [ ] Internal linking
- [ ] External links to authoritative sources

### Structured Data
- [ ] Schema.org markup added
- [ ] Schema validates (use Google's tool)
- [ ] Appropriate schema type chosen
- [ ] Required fields populated

### GEO Optimization
- [ ] Direct answers provided
- [ ] Content well-structured
- [ ] Author/expertise signals
- [ ] FAQ section included
- [ ] Clear, concise language

---

## Output

Deliverables:
1. Optimized meta tags
2. Schema.org JSON-LD markup
3. Technical SEO recommendations
4. Core Web Vitals checklist
5. GEO optimization guide
]]>