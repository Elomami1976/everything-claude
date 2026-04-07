# Chrome Extension Builder Skill

Build production-ready Chrome extensions with Manifest V3, AI capabilities, and optional subscriptions.

## When to Use

Use this skill when building:
- Browser productivity tools
- AI-powered page assistants (BYOK pattern)
- Content enhancers or modifiers
- Tab and session managers
- Developer utilities
- Subscription-based browser tools

---

## Architecture Decisions

Choose your UI surface based on the use case:

| Surface | When to Use |
|---|---|
| **Popup** | Quick actions, status, settings — opens on toolbar click |
| **Side Panel** | Persistent UI alongside page content |
| **Content Script** | Reading or modifying the current page's DOM |
| **Background (Service Worker)** | API calls, alarms, state management |
| **Options Page** | User settings, API key configuration |

---

## Implementation Steps

### Step 1: Manifest V3 setup

Start with `manifest.json`. Declare only what you need — Chrome's review rejects over-permissioned extensions.

```json
{
  "manifest_version": 3,
  "name": "Extension Name",
  "version": "1.0.0",
  "permissions": ["storage", "activeTab"],
  "background": { "service_worker": "background.js" },
  "action": { "default_popup": "popup/popup.html" }
}
```

### Step 2: Background service worker

Handle all API calls and state in the background script — popup and content scripts are short-lived.

```javascript
chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
  handleMessage(message).then(sendResponse).catch(e => sendResponse({ error: e.message }));
  return true; // Required for async response
});

async function handleMessage({ action, payload }) {
  if (action === 'CALL_AI') return callOpenAI(payload.text);
  throw new Error(`Unknown action: ${action}`);
}
```

### Step 3: BYOK (Bring Your Own Key) pattern

For AI-powered extensions, let users supply their own API keys instead of billing them directly. This avoids needing a payment backend and passes App Store-style reviews more easily.

```javascript
// Save key (options page)
await chrome.storage.sync.set({ openaiApiKey: key });

// Use key (background script)
const { openaiApiKey } = await chrome.storage.sync.get('openaiApiKey');
if (!openaiApiKey) throw new Error('No API key configured — visit extension options');
```

### Step 4: Content script communication

Content scripts can read the DOM but cannot call Chrome APIs directly. Use message passing:

```javascript
// content.js → background.js
const result = await chrome.runtime.sendMessage({ action: 'CALL_AI', payload: { text: selectedText } });

// background.js → content.js (push update)
chrome.tabs.sendMessage(tabId, { action: 'SHOW_RESULT', payload: result });
```

### Step 5: Stripe one-time payments (optional)

For paid extensions, use Stripe Payment Links or a minimal backend. Store the purchase receipt in `chrome.storage.sync` after verification.

```javascript
// After successful payment redirect, verify + store
const verified = await verifyPurchaseWithBackend(sessionId);
if (verified) await chrome.storage.sync.set({ isPro: true, purchasedAt: Date.now() });
```

---

## Pre-Submit Checklist

Before publishing to Chrome Web Store:

- [ ] `manifest.json` requests minimum required permissions
- [ ] No inline scripts (CSP violation)
- [ ] All external API domains listed in `host_permissions`
- [ ] Options page accessible via right-click on toolbar icon
- [ ] Extension works when popup is closed (background handles state)
- [ ] Tested in Incognito mode if `incognito: "spanning"` is set
- [ ] Privacy policy URL added to store listing

---

## Output Deliverables

1. `manifest.json` with minimal permissions
2. `background.js` with message handler pattern
3. Popup UI (HTML + JS + CSS)
4. Options page for API key configuration
5. Content script (if DOM access needed)
6. Privacy policy template
7. Chrome Web Store listing copy
