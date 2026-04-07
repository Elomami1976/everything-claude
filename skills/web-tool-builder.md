<![CDATA[# Web Tool Builder Skill

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
- Everything runs in the browser
- No data leaves the user's device
- Single HTML file = maximum portability
- Zero dependencies = zero vulnerabilities

---

## How It Works

### Architecture Pattern

```
┌─────────────────────────────────────────────────────────┐
│                    Single HTML File                      │
├─────────────────────────────────────────────────────────┤
│  <!DOCTYPE html>                                         │
│  <html>                                                  │
│    <head>                                                │
│      <style>/* All CSS inline */</style>                 │
│    </head>                                               │
│    <body>                                                │
│      <!-- UI Components -->                              │
│      <script>/* All JS inline */</script>               │
│    </body>                                               │
│  </html>                                                 │
└─────────────────────────────────────────────────────────┘
                          │
                          ▼
    ┌─────────────────────────────────────────────┐
    │           Browser APIs Used                  │
    ├─────────────────────────────────────────────┤
    │  • File API (reading uploads)               │
    │  • Blob API (creating downloads)            │
    │  • Canvas API (image manipulation)          │
    │  • Web Workers (heavy processing)           │
    │  • localStorage (saving preferences)        │
    │  • IndexedDB (larger data storage)          │
    └─────────────────────────────────────────────┘
```

### Privacy-First Design

```javascript
// All processing happens client-side
async function processFile(file) {
  // Read file locally
  const content = await file.text();
  
  // Process locally
  const result = transform(content);
  
  // Create download (no upload)
  const blob = new Blob([result], { type: 'text/plain' });
  const url = URL.createObjectURL(blob);
  
  // Trigger download
  const a = document.createElement('a');
  a.href = url;
  a.download = 'result.txt';
  a.click();
  
  // Clean up
  URL.revokeObjectURL(url);
}
```

---

## Implementation Steps

### Step 1: HTML Structure

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Tool Name - Free Online Tool</title>
  <meta name="description" content="Tool description for SEO">
  <style>
    /* Styles go here */
  </style>
</head>
<body>
  <main>
    <h1>Tool Name</h1>
    <p class="subtitle">Brief description of what it does</p>
    
    <div class="tool-container">
      <div class="input-area">
        <!-- Drag & drop zone or text input -->
      </div>
      
      <div class="output-area">
        <!-- Results display -->
      </div>
      
      <div class="actions">
        <button id="process">Process</button>
        <button id="download">Download</button>
        <button id="clear">Clear</button>
      </div>
    </div>
    
    <section class="instructions">
      <h2>How to Use</h2>
      <ol>
        <li>Step 1</li>
        <li>Step 2</li>
        <li>Step 3</li>
      </ol>
    </section>
  </main>
  
  <footer>
    <p>Your privacy matters. All processing happens in your browser.</p>
  </footer>
  
  <script>
    /* JavaScript goes here */
  </script>
</body>
</html>
```

### Step 2: Drag & Drop File Handler

```javascript
const dropZone = document.getElementById('drop-zone');
const fileInput = document.getElementById('file-input');

// Drag events
dropZone.addEventListener('dragover', (e) => {
  e.preventDefault();
  dropZone.classList.add('drag-over');
});

dropZone.addEventListener('dragleave', () => {
  dropZone.classList.remove('drag-over');
});

dropZone.addEventListener('drop', (e) => {
  e.preventDefault();
  dropZone.classList.remove('drag-over');
  const files = e.dataTransfer.files;
  handleFiles(files);
});

// Click to upload
dropZone.addEventListener('click', () => fileInput.click());
fileInput.addEventListener('change', (e) => handleFiles(e.target.files));

async function handleFiles(files) {
  for (const file of files) {
    await processFile(file);
  }
}
```

### Step 3: localStorage for Settings

```javascript
// Save user preferences
function saveSettings(settings) {
  localStorage.setItem('toolSettings', JSON.stringify(settings));
}

function loadSettings() {
  const saved = localStorage.getItem('toolSettings');
  return saved ? JSON.parse(saved) : defaultSettings;
}

// Apply on load
document.addEventListener('DOMContentLoaded', () => {
  const settings = loadSettings();
  applySettings(settings);
});
```

### Step 4: Download Results

```javascript
function downloadResult(content, filename, mimeType = 'text/plain') {
  const blob = new Blob([content], { type: mimeType });
  const url = URL.createObjectURL(blob);
  
  const link = document.createElement('a');
  link.href = url;
  link.download = filename;
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);
  
  URL.revokeObjectURL(url);
}

// For binary files like images
function downloadBinaryResult(dataUrl, filename) {
  const link = document.createElement('a');
  link.href = dataUrl;
  link.download = filename;
  link.click();
}
```

---

## Example: JSON Formatter Tool

```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>JSON Formatter - Free Online Tool</title>
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body { 
      font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
      background: #f5f5f5; padding: 20px; min-height: 100vh;
    }
    .container { max-width: 1200px; margin: 0 auto; }
    h1 { color: #333; margin-bottom: 10px; }
    .subtitle { color: #666; margin-bottom: 20px; }
    .editor-container { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
    textarea { 
      width: 100%; height: 400px; padding: 15px; font-family: monospace;
      border: 2px solid #ddd; border-radius: 8px; resize: vertical;
    }
    textarea:focus { border-color: #007bff; outline: none; }
    .actions { margin: 20px 0; display: flex; gap: 10px; }
    button {
      padding: 12px 24px; border: none; border-radius: 6px; cursor: pointer;
      font-size: 16px; transition: background 0.2s;
    }
    .primary { background: #007bff; color: white; }
    .primary:hover { background: #0056b3; }
    .secondary { background: #6c757d; color: white; }
    .error { color: #dc3545; margin-top: 10px; }
    .privacy { 
      margin-top: 30px; padding: 15px; background: #e8f5e9;
      border-radius: 8px; color: #2e7d32;
    }
  </style>
</head>
<body>
  <div class="container">
    <h1>JSON Formatter</h1>
    <p class="subtitle">Beautify and validate JSON data instantly</p>
    
    <div class="editor-container">
      <div>
        <label>Input JSON</label>
        <textarea id="input" placeholder="Paste your JSON here..."></textarea>
      </div>
      <div>
        <label>Formatted Output</label>
        <textarea id="output" readonly></textarea>
      </div>
    </div>
    
    <div class="actions">
      <button class="primary" id="format">Format JSON</button>
      <button class="secondary" id="minify">Minify</button>
      <button class="secondary" id="copy">Copy Output</button>
      <button class="secondary" id="clear">Clear</button>
    </div>
    
    <div id="error" class="error"></div>
    
    <div class="privacy">
      🔒 Privacy first: All processing happens in your browser. Your data never leaves your device.
    </div>
  </div>
  
  <script>
    const input = document.getElementById('input');
    const output = document.getElementById('output');
    const error = document.getElementById('error');
    
    document.getElementById('format').addEventListener('click', () => {
      try {
        const json = JSON.parse(input.value);
        output.value = JSON.stringify(json, null, 2);
        error.textContent = '';
      } catch (e) {
        error.textContent = `Error: ${e.message}`;
      }
    });
    
    document.getElementById('minify').addEventListener('click', () => {
      try {
        const json = JSON.parse(input.value);
        output.value = JSON.stringify(json);
        error.textContent = '';
      } catch (e) {
        error.textContent = `Error: ${e.message}`;
      }
    });
    
    document.getElementById('copy').addEventListener('click', async () => {
      await navigator.clipboard.writeText(output.value);
      alert('Copied to clipboard!');
    });
    
    document.getElementById('clear').addEventListener('click', () => {
      input.value = '';
      output.value = '';
      error.textContent = '';
    });
  </script>
</body>
</html>
```

---

## Output Format

The final deliverable is a single `.html` file that can be:
- Opened directly in any browser (file://)
- Hosted on any static file server
- Deployed to GitHub Pages, Netlify, Vercel
- Shared via email or file transfer

**File size target:** Under 100KB for fast loading

---

## Checklist

- [ ] Single HTML file with inline CSS/JS
- [ ] No external dependencies
- [ ] All processing client-side
- [ ] Privacy notice displayed
- [ ] Mobile responsive
- [ ] Keyboard accessible
- [ ] Clear error messages
- [ ] Download functionality
- [ ] Settings saved to localStorage
]]>