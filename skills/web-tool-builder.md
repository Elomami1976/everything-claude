# Web Tool Builder Skill

Build privacy-first browser-based tools as single HTML files with no server dependencies.

## When to Use

Use this skill when building:
- PDF tools (merge, split, compress, convert)
- Text utilities (formatters, converters, generators)
- Image tools (resize, convert, optimize)
- Calculators and converters
- Data format converters (JSON/YAML/CSV)
- Encoding/decoding tools
- File diff/compare tools
- Generators (UUID, password, lorem ipsum)

**Key principles:**
- Everything runs in the browser — no data leaves the user's device
- Single HTML file means maximum portability and simple sharing
- Zero server dependencies means zero server costs and zero data breach risk

---

## Architecture

A web tool is a **single `.html` file** with all CSS and JavaScript inline. No build step, no server required.

| Layer | Implementation |
|---|---|
| File reading | File API — `file.text()`, `file.arrayBuffer()` |
| File downloads | Blob API — `URL.createObjectURL(blob)` |
| Image processing | Canvas API — `ctx.drawImage()`, `canvas.toDataURL()` |
| Heavy work | Web Workers — keeps UI responsive during long operations |
| User settings | `localStorage` — persists across browser sessions |
| Large data | IndexedDB — for files over ~5MB |

All processing stays on the user's machine. The tool sends nothing to any server.

---

## Implementation

### Privacy-First File Processing

```javascript
async function processFile(file) {
  const content = await file.text();   // read locally
  const result = transform(content);   // process locally

  const blob = new Blob([result], { type: 'text/plain' });
  const url = URL.createObjectURL(blob);

  const a = document.createElement('a');
  a.href = url;
  a.download = 'result.txt';
  a.click();

  URL.revokeObjectURL(url);  // clean up memory
}
```

### HTML Structure

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Tool Name - Free Online Tool</title>
  <meta name="description" content="Tool description for SEO">
  <style>/* All CSS inline */</style>
</head>
<body>
  <main>
    <h1>Tool Name</h1>
    <div class="tool-container">
      <div id="drop-zone">Drop files here or click to upload</div>
      <div id="output"></div>
      <button id="process">Process</button>
      <button id="download">Download</button>
    </div>
  </main>
  <footer>All processing happens in your browser.</footer>
  <script>/* All JS inline */</script>
</body>
</html>
```

### Drag and Drop File Handler

```javascript
const dropZone = document.getElementById('drop-zone');
const fileInput = document.getElementById('file-input');

dropZone.addEventListener('dragover', (e) => {
  e.preventDefault();
  dropZone.classList.add('drag-over');
});

dropZone.addEventListener('dragleave', () => dropZone.classList.remove('drag-over'));

dropZone.addEventListener('drop', (e) => {
  e.preventDefault();
  dropZone.classList.remove('drag-over');
  handleFiles(e.dataTransfer.files);
});

dropZone.addEventListener('click', () => fileInput.click());
fileInput.addEventListener('change', (e) => handleFiles(e.target.files));

async function handleFiles(files) {
  for (const file of files) await processFile(file);
}
```

### Persist User Settings

```javascript
const defaultSettings = { indent: 2, sortKeys: false };

function saveSettings(settings) {
  localStorage.setItem('toolSettings', JSON.stringify(settings));
}

function loadSettings() {
  const saved = localStorage.getItem('toolSettings');
  return saved ? JSON.parse(saved) : defaultSettings;
}

document.addEventListener('DOMContentLoaded', () => applySettings(loadSettings()));
```

### Download Result

```javascript
function downloadResult(content, filename, mimeType = 'text/plain') {
  const blob = new Blob([content], { type: mimeType });
  const url = URL.createObjectURL(blob);

  const a = document.createElement('a');
  a.href = url;
  a.download = filename;
  document.body.appendChild(a);
  a.click();
  document.body.removeChild(a);
  URL.revokeObjectURL(url);
}
```

---

## Output Format

The deliverable is a single `.html` file. Target under 100KB total. It should be ready to:
- Open directly in any browser with no server
- Host on GitHub Pages, Netlify, or any static file host
- Share as an email attachment
- Deploy as a PWA

See `templates/web-tool/index.html` for a complete working example.

---

## Checklist

- [ ] Single HTML file — all CSS and JS inline, no external dependencies
- [ ] All processing is client-side only
- [ ] Privacy notice visible to the user
- [ ] Mobile responsive
- [ ] Keyboard accessible
- [ ] Clear error messages for invalid input
- [ ] Download functionality works
- [ ] User settings saved to `localStorage`
- [ ] File size under 100KB
