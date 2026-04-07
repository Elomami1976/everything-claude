<![CDATA[# Chrome Extension Rules (Manifest V3)

Best practices for building Chrome extensions with Manifest V3.

## 1. Manifest V3 Structure

**Required manifest.json structure:**

```json
{
  "manifest_version": 3,
  "name": "Extension Name",
  "version": "1.0.0",
  "description": "Clear, benefit-focused description under 132 chars",
  
  "permissions": [],
  "host_permissions": [],
  
  "background": {
    "service_worker": "background.js",
    "type": "module"
  },
  
  "action": {
    "default_popup": "popup.html",
    "default_icon": {
      "16": "icons/icon16.png",
      "48": "icons/icon48.png",
      "128": "icons/icon128.png"
    }
  },
  
  "icons": {
    "16": "icons/icon16.png",
    "48": "icons/icon48.png",
    "128": "icons/icon128.png"
  }
}
```

**Permission rules:**
- Request ONLY permissions you need
- Use optional_permissions for features
- Prefer activeTab over broad host permissions
- Document why each permission is needed

---

## 2. Background Service Worker

**Service workers are NOT persistent — plan for termination:**

```javascript
// background.js

// Good: Store state in chrome.storage, not variables
let cachedData; // BAD: Lost when service worker terminates

// Initialize on startup
chrome.runtime.onInstalled.addListener(async () => {
  await chrome.storage.local.set({ 
    settings: defaultSettings,
    version: chrome.runtime.getManifest().version
  });
});

// Wake up handler
chrome.runtime.onStartup.addListener(async () => {
  // Re-initialize any necessary state from storage
  const { settings } = await chrome.storage.local.get('settings');
  initializeWithSettings(settings);
});

// Handle messages from popup/content scripts
chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
  // IMPORTANT: Return true to indicate async response
  handleMessage(message, sender).then(sendResponse);
  return true; // Keep message channel open
});

async function handleMessage(message, sender) {
  switch (message.action) {
    case 'getData':
      return await fetchData(message.params);
    case 'saveSettings':
      await chrome.storage.sync.set({ settings: message.settings });
      return { success: true };
    default:
      throw new Error(`Unknown action: ${message.action}`);
  }
}
```

**Alarms for scheduled tasks:**
```javascript
// Set up alarm (minimum 1 minute in production)
chrome.alarms.create('checkUpdates', { periodInMinutes: 60 });

chrome.alarms.onAlarm.addListener(async (alarm) => {
  if (alarm.name === 'checkUpdates') {
    await checkForUpdates();
  }
});
```

---

## 3. Content Script Best Practices

**manifest.json:**
```json
{
  "content_scripts": [
    {
      "matches": ["https://example.com/*"],
      "js": ["content.js"],
      "css": ["content.css"],
      "run_at": "document_idle"
    }
  ]
}
```

**content.js:**
```javascript
// Namespace everything to avoid conflicts
(function() {
  'use strict';
  
  // Check if already injected
  if (window.__myExtensionInjected) return;
  window.__myExtensionInjected = true;
  
  // Shadow DOM for isolated styles
  function createIsolatedUI() {
    const host = document.createElement('div');
    host.id = 'my-extension-root';
    const shadow = host.attachShadow({ mode: 'closed' });
    
    shadow.innerHTML = `
      <style>
        /* Styles are isolated */
        .panel { background: white; padding: 16px; }
      </style>
      <div class="panel">Extension UI</div>
    `;
    
    document.body.appendChild(host);
    return shadow;
  }
  
  // Wait for DOM
  function init() {
    if (document.readyState === 'loading') {
      document.addEventListener('DOMContentLoaded', setup);
    } else {
      setup();
    }
  }
  
  function setup() {
    const ui = createIsolatedUI();
    observePageChanges();
  }
  
  // Handle SPAs with MutationObserver
  function observePageChanges() {
    const observer = new MutationObserver((mutations) => {
      // React to DOM changes
    });
    
    observer.observe(document.body, {
      childList: true,
      subtree: true
    });
  }
  
  init();
})();
```

---

## 4. Storage Decisions

**sync vs local:**

| Feature | sync | local |
|---------|------|-------|
| Max size | 100KB total, 8KB per item | 10MB |
| Syncs across devices | Yes | No |
| Use for | User settings, preferences | Cache, large data |

```javascript
// User settings → sync
await chrome.storage.sync.set({ 
  theme: 'dark',
  language: 'en'
});

// Cached data → local
await chrome.storage.local.set({
  cachedResults: largeData,
  lastFetch: Date.now()
});

// Listen for changes
chrome.storage.onChanged.addListener((changes, areaName) => {
  if (areaName === 'sync' && changes.theme) {
    applyTheme(changes.theme.newValue);
  }
});
```

---

## 5. Never Use eval()

**Chrome Web Store WILL REJECT extensions using eval:**

```javascript
// NEVER DO THIS
eval(userInput);
new Function(userInput);
setTimeout(stringCode, 1000);

// Also avoid:
// - Loading remote scripts
// - innerHTML with user content
// - document.write

// INSTEAD: Parse data as JSON
const data = JSON.parse(jsonString);

// For dynamic features, use static mappings
const handlers = {
  bold: (text) => `<strong>${text}</strong>`,
  italic: (text) => `<em>${text}</em>`
};

handlers[userChoice](text); // Safe
```

---

## 6. Message Passing Patterns

**Popup ↔ Background:**
```javascript
// popup.js
async function getDataFromBackground() {
  return await chrome.runtime.sendMessage({ 
    action: 'getData',
    params: { userId: 123 }
  });
}

// background.js
chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
  if (message.action === 'getData') {
    getData(message.params).then(sendResponse);
    return true; // Async response
  }
});
```

**Background ↔ Content Script:**
```javascript
// background.js - Send to specific tab
async function sendToTab(tabId, message) {
  return await chrome.tabs.sendMessage(tabId, message);
}

// Send to active tab
const [tab] = await chrome.tabs.query({ active: true, currentWindow: true });
await chrome.tabs.sendMessage(tab.id, { action: 'extract' });

// content.js
chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
  if (message.action === 'extract') {
    const data = extractPageData();
    sendResponse(data);
  }
  return true;
});
```

**Long-lived connections:**
```javascript
// popup.js - For streaming data
const port = chrome.runtime.connect({ name: 'popup' });
port.onMessage.addListener((msg) => {
  console.log('Received:', msg);
});
port.postMessage({ action: 'subscribe' });

// background.js
chrome.runtime.onConnect.addListener((port) => {
  if (port.name === 'popup') {
    port.onMessage.addListener((msg) => {
      // Handle subscription
    });
  }
});
```

---

## 7. BYOK (Bring Your Own Key) Pattern

**For AI-powered extensions, let users provide their own API keys:**

```javascript
// settings.js
async function saveApiKey(key) {
  // Validate key format first
  if (!/^sk-[a-zA-Z0-9]{32,}$/.test(key)) {
    throw new Error('Invalid API key format');
  }
  
  // Store in sync storage (encrypted by Chrome)
  await chrome.storage.sync.set({ apiKey: key });
}

// background.js
async function callAI(prompt) {
  const { apiKey } = await chrome.storage.sync.get('apiKey');
  
  if (!apiKey) {
    throw new Error('API key not configured');
  }
  
  const response = await fetch('https://api.openai.com/v1/chat/completions', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${apiKey}`,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      model: 'gpt-4',
      messages: [{ role: 'user', content: prompt }]
    })
  });
  
  return await response.json();
}
```

---

## 8. Chrome Web Store Requirements

**Before submission:**
- [ ] Icons: 16x16, 48x48, 128x128 PNG
- [ ] Screenshots: 1280x800 or 640x400 PNG/JPEG
- [ ] Description: Clear, benefit-focused, under 132 chars
- [ ] Privacy policy URL (if using any permissions)
- [ ] Minimal permissions (justify each one)
- [ ] No obfuscated code
- [ ] No eval() or remote code
- [ ] Single purpose

**Store listing checklist:**
- [ ] Promotional images
- [ ] Demo video (optional but helps)
- [ ] Category selected
- [ ] Language/localization

---

## 9. File Structure

```
my-extension/
├── manifest.json
├── background.js
├── popup/
│   ├── popup.html
│   ├── popup.js
│   └── popup.css
├── content/
│   ├── content.js
│   └── content.css
├── options/
│   ├── options.html
│   └── options.js
├── icons/
│   ├── icon16.png
│   ├── icon48.png
│   └── icon128.png
└── lib/
    └── utils.js
```

---

## Quick Checklist

- [ ] Using Manifest V3
- [ ] Background is service worker with proper lifecycle handling
- [ ] State stored in chrome.storage, not variables
- [ ] Content scripts namespaced and isolated
- [ ] No eval(), remote scripts, or obfuscated code
- [ ] Minimal permissions requested
- [ ] Messages handled with async pattern
- [ ] Storage choice appropriate (sync vs local)
]]>