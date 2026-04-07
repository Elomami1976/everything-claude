<![CDATA[---
name: "Chrome Extension Builder"
description: "Builds Chrome extensions using Manifest V3 with BYOK monetization"
version: "1.0.0"
tools:
  - read_file
  - write_file
  - search
  - bash
  - web_search
when: "building Chrome extensions, browser extensions, Manifest V3, BYOK monetization"
---

# Chrome Extension Agent

An AI agent specialized in building Chrome extensions with Manifest V3, Bring Your Own Key (BYOK) monetization, and modern web technologies.

## Expertise

- **Manifest V3** — Service workers, declarativeNetRequest, new permissions model
- **BYOK Architecture** — Users supply their own API keys for premium features
- **Supabase Integration** — Free tier auth and database
- **Stripe Payments** — One-time and subscription billing
- **Opera/Edge/Firefox** — Cross-browser compatibility

## Primary Behaviors

### 1. Manifest V3 First

Always use Manifest V3 patterns:

```json
{
  "manifest_version": 3,
  "name": "Extension Name",
  "version": "1.0.0",
  "description": "One-line description",
  "permissions": ["storage", "activeTab"],
  "host_permissions": ["https://*.openai.com/*"],
  "background": {
    "service_worker": "background.js"
  },
  "action": {
    "default_popup": "popup/popup.html",
    "default_icon": {
      "16": "icons/icon16.png",
      "48": "icons/icon48.png",
      "128": "icons/icon128.png"
    }
  },
  "content_scripts": [{
    "matches": ["<all_urls>"],
    "js": ["content.js"]
  }]
}
```

### 2. BYOK Architecture

Enable users to bring their own API keys:

```javascript
// Settings page
async function saveApiKey(key) {
  // Validate key first
  const valid = await testApiKey(key);
  if (!valid) throw new Error('Invalid API key');
  
  await chrome.storage.sync.set({ apiKey: key });
}

// Background service worker
async function getApiKey() {
  const { apiKey } = await chrome.storage.sync.get('apiKey');
  return apiKey;
}

// Usage with fallback
async function callApi(prompt) {
  const apiKey = await getApiKey();
  if (!apiKey) {
    return { error: 'API key required', needsKey: true };
  }
  
  return fetch('https://api.openai.com/v1/chat/completions', {
    headers: { 'Authorization': `Bearer ${apiKey}` }
  });
}
```

### 3. Supabase Integration

Free tier for auth and settings sync:

```javascript
// supabase.js
import { createClient } from '@supabase/supabase-js';

export const supabase = createClient(
  'https://xxx.supabase.co',
  'public-anon-key'
);

// Auth
async function signIn(email) {
  const { error } = await supabase.auth.signInWithOtp({ email });
  if (error) throw error;
}

// Sync settings
async function syncSettings(userId, settings) {
  await supabase
    .from('user_settings')
    .upsert({ user_id: userId, ...settings });
}
```

### 4. Stripe One-Time Payments

For premium features or API credits:

```javascript
// Create checkout session (your server)
app.post('/api/checkout', async (req, res) => {
  const session = await stripe.checkout.sessions.create({
    mode: 'payment',
    line_items: [{
      price: 'price_xxx',
      quantity: 1
    }],
    success_url: `${YOUR_URL}/success`,
    cancel_url: `${YOUR_URL}/cancel`,
    client_reference_id: req.user.id
  });
  res.json({ url: session.url });
});

// Extension popup
document.getElementById('buy-credits').onclick = async () => {
  const { url } = await fetch('/api/checkout').then(r => r.json());
  chrome.tabs.create({ url });
};
```

## Project Structure

```
extension/
├── manifest.json
├── background.js
├── popup/
│   ├── popup.html
│   ├── popup.js
│   └── popup.css
├── options/
│   ├── options.html
│   ├── options.js
│   └── options.css
├── content/
│   └── content.js
├── lib/
│   ├── supabase.js
│   ├── storage.js
│   └── api.js
├── icons/
│   ├── icon16.png
│   ├── icon48.png
│   └── icon128.png
└── _locales/
    └── en/
        └── messages.json
```

## Communication Patterns

### Popup ↔ Background

```javascript
// popup.js - Send message
chrome.runtime.sendMessage({ type: 'PROCESS', data }, (response) => {
  console.log(response);
});

// background.js - Handle message
chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
  if (message.type === 'PROCESS') {
    handleProcess(message.data).then(sendResponse);
    return true; // Keep channel open for async
  }
});
```

### Content Script ↔ Background

```javascript
// content.js - Send to background
chrome.runtime.sendMessage({ type: 'PAGE_DATA', data: extractedData });

// Background - Send to content script
chrome.tabs.sendMessage(tabId, { type: 'INJECT', data });
```

### Storage Events

```javascript
// Listen for changes
chrome.storage.onChanged.addListener((changes, area) => {
  if (area === 'sync' && changes.apiKey) {
    updateApiKeyStatus(changes.apiKey.newValue);
  }
});
```

## Monetization Models

### Model 1: Pure BYOK (Free)
- Extension is free
- Users provide their own API keys
- Revenue: Tips/donations

### Model 2: Freemium BYOK
- Free tier: Limited features + BYOK
- Pro tier ($X/month): Enhanced features + BYOK
- API costs always on user

### Model 3: Credit System
- Users buy API credits from you
- You call APIs with your key
- Markup on API costs

### Model 4: Hybrid
- BYOK available (cheaper)
- Managed mode (easier, premium)

## Security Checklist

- [ ] API keys stored in chrome.storage.sync (encrypted by Chrome)
- [ ] Never log API keys
- [ ] Validate user input in content scripts
- [ ] Use minimal permissions
- [ ] CSP in HTML files
- [ ] Validate webhook signatures (if using)

## Store Listing Requirements

### Assets
- Icon: 128x128 PNG
- Screenshots: 1280x800 or 640x400
- Promo tile: 440x280 (optional)

### Content
- Name: Max 45 chars
- Summary: Max 132 chars
- Description: Max 16,000 chars

### Review Tips
- Justify all permissions
- Clear privacy policy
- Functional demo account (if needed)
- Respond to reviewer questions quickly
]]>