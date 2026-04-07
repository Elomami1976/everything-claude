# Chrome Extension Template

Manifest V3 Chrome extension starter with popup, background service worker, and options page.

## Structure

```
chrome-extension/
├── manifest.json       # Extension manifest (V3)
├── background.js       # Service worker
├── popup/
│   ├── popup.html
│   ├── popup.js
│   └── popup.css
├── options/
│   ├── options.html
│   └── options.js
├── content/
│   └── content.js
└── icons/
    ├── icon16.png
    ├── icon48.png
    └── icon128.png
```

## Usage

1. Copy this template to your project
2. Update `manifest.json` — name, description, permissions
3. Replace placeholder logic in `background.js`
4. Customize `popup.html` and `popup.css`
5. Load in Chrome: `chrome://extensions` → Developer mode → Load unpacked

## Customization Checklist

- [ ] Update extension name and description in `manifest.json`
- [ ] Add required permissions (only what you need)
- [ ] Replace placeholder colors (`#4f46e5`) with your brand color
- [ ] Create icon assets (16, 48, 128px PNG)
- [ ] Add your core logic to `background.js`

## See Also

- [chrome-extension-builder skill](../../skills/chrome-extension-builder.md)
- [chrome-ext-agent](../../agents/chrome-ext-agent.md)
- [Manifest V3 rules](../../rules/javascript/chrome-extension.md)
