<![CDATA[# Chrome Extension Builder Skill

Build production-ready Chrome extensions with Manifest V3, subscriptions, and AI capabilities.

## When to Use

Use this skill when building:
- Browser productivity tools
- AI-powered assistants (BYOK pattern)
- Content enhancers/modifiers
- Tab managers and organizers
- Social media tools
- Developer utilities
- Subscription-based extensions

---

## How It Works

### Architecture Decisions

**Popup vs Side Panel vs Content Script:**

| Component | Use When |
|-----------|----------|
| **Popup** | Quick actions, status display, settings |
| **Side Panel** | Persistent UI alongside page content |
| **Content Script** | Modifying or reading page content |
| **Background** | API calls, state management, scheduling |

### BYOK (Bring Your Own Key) Pattern

For AI-powered extensions:

```javascript
// Let users configure their own API keys
// Stored in chrome.storage.sync (encrypted by Chrome)

// options.js
async function saveApiKey(key) {
  await chrome.storage.sync.set({ openaiApiKey: key });
}

// background.js  
async function callOpenAI(prompt) {
  const { openaiApiKey } = await chrome.storage.sync.get('openaiApiKey');
  if (!openaiApiKey) throw new Error('API key not configured');
  
  const response = await fetch('https://api.openai.com/v1/chat/completions', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${openaiApiKey}`,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      model: 'gpt-4',
      messages: [{ role: 'user', content: prompt }]
    })
  });
  
  return response.json();
}
```

---

## Implementation Steps

### Step 1: Project Structure

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

### Step 2: Manifest V3

```json
{
  "manifest_version": 3,
  "name": "Extension Name",
  "version": "1.0.0",
  "description": "Clear benefit-focused description",
  
  "permissions": [
    "storage",
    "activeTab"
  ],
  
  "host_permissions": [
    "https://api.openai.com/*"
  ],
  
  "background": {
    "service_worker": "background.js",
    "type": "module"
  },
  
  "action": {
    "default_popup": "popup/popup.html",
    "default_icon": {
      "16": "icons/icon16.png",
      "48": "icons/icon48.png",
      "128": "icons/icon128.png"
    }
  },
  
  "options_page": "options/options.html",
  
  "content_scripts": [
    {
      "matches": ["<all_urls>"],
      "js": ["content/content.js"],
      "css": ["content/content.css"],
      "run_at": "document_idle"
    }
  ],
  
  "icons": {
    "16": "icons/icon16.png",
    "48": "icons/icon48.png",
    "128": "icons/icon128.png"
  }
}
```

### Step 3: Background Service Worker

```javascript
// background.js

// Initialize on install
chrome.runtime.onInstalled.addListener(async (details) => {
  if (details.reason === 'install') {
    // Set default settings
    await chrome.storage.sync.set({
      enabled: true,
      theme: 'auto'
    });
    
    // Open onboarding
    chrome.tabs.create({ url: 'options/options.html#welcome' });
  }
});

// Handle messages from popup/content scripts
chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
  handleMessage(message, sender)
    .then(sendResponse)
    .catch(error => sendResponse({ error: error.message }));
  return true; // Required for async response
});

async function handleMessage(message, sender) {
  switch (message.action) {
    case 'getSettings':
      return await chrome.storage.sync.get();
    
    case 'processWithAI':
      return await processWithAI(message.text);
    
    case 'checkSubscription':
      return await checkSubscription();
    
    default:
      throw new Error(`Unknown action: ${message.action}`);
  }
}

async function processWithAI(text) {
  const { openaiApiKey } = await chrome.storage.sync.get('openaiApiKey');
  
  if (!openaiApiKey) {
    throw new Error('Please configure your API key in settings');
  }
  
  const response = await fetch('https://api.openai.com/v1/chat/completions', {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${openaiApiKey}`,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify({
      model: 'gpt-4o-mini',
      messages: [{ role: 'user', content: text }]
    })
  });
  
  if (!response.ok) {
    throw new Error(`API error: ${response.status}`);
  }
  
  const data = await response.json();
  return data.choices[0].message.content;
}
```

### Step 4: Popup UI

```html
<!-- popup/popup.html -->
<!DOCTYPE html>
<html>
<head>
  <link rel="stylesheet" href="popup.css">
</head>
<body>
  <div class="container">
    <h1>My Extension</h1>
    
    <div class="status" id="status">
      <span class="status-dot"></span>
      <span class="status-text">Ready</span>
    </div>
    
    <div class="actions">
      <button id="action-btn" class="primary">Run Action</button>
      <button id="settings-btn" class="secondary">Settings</button>
    </div>
    
    <div class="result" id="result"></div>
  </div>
  
  <script src="popup.js"></script>
</body>
</html>
```

```javascript
// popup/popup.js
document.addEventListener('DOMContentLoaded', async () => {
  const settings = await chrome.runtime.sendMessage({ action: 'getSettings' });
  updateUI(settings);
});

document.getElementById('action-btn').addEventListener('click', async () => {
  const btn = document.getElementById('action-btn');
  const result = document.getElementById('result');
  
  btn.disabled = true;
  btn.textContent = 'Processing...';
  
  try {
    // Get selected text from active tab
    const [tab] = await chrome.tabs.query({ active: true, currentWindow: true });
    const [{ result: selectedText }] = await chrome.scripting.executeScript({
      target: { tabId: tab.id },
      func: () => window.getSelection().toString()
    });
    
    if (!selectedText) {
      result.textContent = 'Select some text first';
      return;
    }
    
    const response = await chrome.runtime.sendMessage({
      action: 'processWithAI',
      text: selectedText
    });
    
    result.textContent = response;
  } catch (error) {
    result.textContent = `Error: ${error.message}`;
  } finally {
    btn.disabled = false;
    btn.textContent = 'Run Action';
  }
});

document.getElementById('settings-btn').addEventListener('click', () => {
  chrome.runtime.openOptionsPage();
});
```

### Step 5: Stripe + Supabase Subscription

```javascript
// subscription.js

const SUPABASE_URL = 'https://your-project.supabase.co';
const SUPABASE_ANON_KEY = 'your-anon-key';

async function checkSubscription() {
  const { userId, accessToken } = await chrome.storage.sync.get(['userId', 'accessToken']);
  
  if (!userId || !accessToken) {
    return { subscribed: false, tier: 'free' };
  }
  
  const response = await fetch(`${SUPABASE_URL}/rest/v1/subscriptions?user_id=eq.${userId}`, {
    headers: {
      'apikey': SUPABASE_ANON_KEY,
      'Authorization': `Bearer ${accessToken}`
    }
  });
  
  const subscriptions = await response.json();
  const active = subscriptions.find(s => s.status === 'active');
  
  return {
    subscribed: !!active,
    tier: active?.tier || 'free',
    expiresAt: active?.current_period_end
  };
}

async function openPaymentPage() {
  const { userId, email } = await chrome.storage.sync.get(['userId', 'email']);
  
  // Open Stripe payment page
  const checkoutUrl = `https://your-domain.com/checkout?user=${userId}&email=${encodeURIComponent(email)}`;
  chrome.tabs.create({ url: checkoutUrl });
}

// Feature gating
async function requirePro() {
  const { subscribed, tier } = await checkSubscription();
  
  if (!subscribed || tier === 'free') {
    throw new Error('This feature requires Pro. Upgrade to continue.');
  }
}
```

### Step 6: Content Script

```javascript
// content/content.js
(function() {
  'use strict';
  
  // Prevent double injection
  if (window.__myExtension) return;
  window.__myExtension = true;
  
  // Listen for messages from background
  chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
    switch (message.action) {
      case 'extractContent':
        sendResponse(extractPageContent());
        break;
      case 'highlightText':
        highlightText(message.text);
        break;
    }
    return true;
  });
  
  function extractPageContent() {
    return {
      title: document.title,
      url: window.location.href,
      text: document.body.innerText.slice(0, 10000)
    };
  }
  
  function highlightText(text) {
    // Add highlight overlay
    const selection = window.getSelection();
    // ... highlighting logic
  }
  
  // Inject UI with Shadow DOM
  function injectUI() {
    const host = document.createElement('div');
    host.id = 'my-extension-root';
    const shadow = host.attachShadow({ mode: 'closed' });
    
    shadow.innerHTML = `
      <style>
        .floating-btn {
          position: fixed;
          bottom: 20px;
          right: 20px;
          width: 50px;
          height: 50px;
          border-radius: 50%;
          background: #007bff;
          border: none;
          cursor: pointer;
          z-index: 999999;
        }
      </style>
      <button class="floating-btn" id="ext-btn">⚡</button>
    `;
    
    shadow.getElementById('ext-btn').addEventListener('click', () => {
      chrome.runtime.sendMessage({ action: 'openPopup' });
    });
    
    document.body.appendChild(host);
  }
  
  // Initialize
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', injectUI);
  } else {
    injectUI();
  }
})();
```

---

## Chrome Web Store Checklist

### Required Assets
- [ ] Icon 16x16 PNG
- [ ] Icon 48x48 PNG  
- [ ] Icon 128x128 PNG
- [ ] Screenshot 1280x800 PNG (at least 1)
- [ ] Promotional tile 440x280 PNG (optional)

### Store Listing
- [ ] Extension name (max 45 chars)
- [ ] Description (detailed, benefit-focused)
- [ ] Category selected
- [ ] Language set

### Compliance
- [ ] Privacy policy URL
- [ ] Minimal permissions justified
- [ ] No remote code loading
- [ ] No obfuscated code
- [ ] Single purpose

### Testing
- [ ] Works in Chrome stable
- [ ] Works on Windows, Mac, Linux
- [ ] Popup opens correctly
- [ ] Content scripts inject properly
- [ ] Message passing works
- [ ] Storage operations work
- [ ] Error handling complete

---

## Output

Deliverables:
1. Complete extension folder ready for Chrome Web Store
2. ZIP file for submission
3. README with installation instructions
4. Privacy policy template
]]>