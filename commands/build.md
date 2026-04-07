<![CDATA[# /build Command

Generate a complete build prompt from a natural language product description.

## Usage

```
/build <product description>
```

## Input

Natural language description of what you want to build. Include:
- What the product does
- Target audience
- Key features
- Any specific technologies (optional)

## Examples

```
/build A Chrome extension that highlights all prices on Amazon and shows price history

/build A web tool that converts PDF files to images, privacy-first, runs in browser

/build A SaaS for tracking daily habits with streaks and social accountability
```

## Output Format

The command generates a structured build prompt with:

---

### 1. PROJECT OVERVIEW

```markdown
## Project: [Name]

**Type**: [Web Tool / Chrome Extension / SaaS / API]
**Description**: [One-sentence summary]
**Target Users**: [Who will use this]

### Success Criteria
- [ ] [Measurable outcome 1]
- [ ] [Measurable outcome 2]
- [ ] [Measurable outcome 3]
```

### 2. TECH STACK

```markdown
## Recommended Stack

**Frontend**: [Framework/Approach]
**Backend**: [Framework/Approach or "N/A"]
**Database**: [Database or "localStorage/IndexedDB"]
**Auth**: [Auth solution or "N/A"]
**Payments**: [Payment solution or "N/A"]
**Deployment**: [Hosting solution]

### Why This Stack
- [Reason 1]
- [Reason 2]
- [Reason 3]
```

### 3. FILE STRUCTURE

```markdown
## Project Structure

project-name/
├── [file/folder structure]
├── ...
└── ...

### Key Files
- `[file]`: [Purpose]
- `[file]`: [Purpose]
- `[file]`: [Purpose]
```

### 4. IMPLEMENTATION STEPS

```markdown
## Build Steps

### Phase 1: Foundation
1. [ ] [Step with specific details]
2. [ ] [Step with specific details]
3. [ ] [Step with specific details]

### Phase 2: Core Features
1. [ ] [Step with specific details]
2. [ ] [Step with specific details]
3. [ ] [Step with specific details]

### Phase 3: Polish
1. [ ] [Step with specific details]
2. [ ] [Step with specific details]
3. [ ] [Step with specific details]

### Phase 4: Launch
1. [ ] [Step with specific details]
2. [ ] [Step with specific details]
3. [ ] [Step with specific details]
```

### 5. KEY IMPLEMENTATION DETAILS

```markdown
## Implementation Notes

### [Feature 1]
- Approach: [How to implement]
- Libraries: [Recommended libraries]
- Code pattern:
\`\`\`javascript
// Example implementation
\`\`\`

### [Feature 2]
- Approach: [How to implement]
- Libraries: [Recommended libraries]
- Gotchas: [Common issues to avoid]
```

---

## Full Example

### Input
```
/build A Chrome extension that blocks social media during work hours
```

### Output
```markdown
## Project: FocusGuard

**Type**: Chrome Extension (Manifest V3)
**Description**: Browser extension that blocks distracting social media sites during customizable work hours
**Target Users**: Knowledge workers, students, anyone struggling with social media focus

### Success Criteria
- [ ] Blocks configured sites during set hours
- [ ] Shows motivational message on blocked pages
- [ ] Tracks time saved from blocked visits
- [ ] Syncs settings across devices

---

## Recommended Stack

**Frontend**: HTML + CSS + Vanilla JS (no framework needed)
**Backend**: N/A (all client-side)
**Database**: chrome.storage.sync for settings, chrome.storage.local for stats
**Auth**: N/A
**Payments**: N/A (or Stripe + Supabase for premium features)
**Deployment**: Chrome Web Store

### Why This Stack
- Chrome extension APIs handle everything needed
- No server means no ongoing costs
- Sync storage enables cross-device settings
- Simple codebase = easier maintenance

---

## Project Structure

focusguard/
├── manifest.json
├── background.js
├── popup/
│   ├── popup.html
│   ├── popup.js
│   └── popup.css
├── blocked/
│   ├── blocked.html
│   └── blocked.js
├── options/
│   ├── options.html
│   └── options.js
├── icons/
│   ├── icon16.png
│   ├── icon48.png
│   └── icon128.png
└── lib/
    └── storage.js

### Key Files
- `background.js`: Service worker that intercepts requests
- `popup/`: Quick toggle and status display
- `blocked/`: Page shown when site is blocked
- `options/`: Full settings configuration

---

## Build Steps

### Phase 1: Foundation (Day 1)
1. [ ] Create manifest.json with permissions
2. [ ] Set up background service worker
3. [ ] Create basic popup UI with toggle

### Phase 2: Core Features (Day 2-3)
1. [ ] Implement URL blocking with webRequest/declarativeNetRequest
2. [ ] Create blocked page with motivational messages
3. [ ] Add work hours scheduling
4. [ ] Build site blocklist management

### Phase 3: Polish (Day 4)
1. [ ] Add time-saved statistics
2. [ ] Implement quick-add for current site
3. [ ] Add keyboard shortcuts
4. [ ] Create options page for advanced settings

### Phase 4: Launch (Day 5)
1. [ ] Create store assets (screenshots, description)
2. [ ] Test on Windows/Mac/Linux
3. [ ] Submit to Chrome Web Store
4. [ ] Set up feedback collection

---

## Implementation Notes

### URL Blocking (Manifest V3)
Use declarativeNetRequest for efficient blocking:
\`\`\`javascript
// background.js
chrome.declarativeNetRequest.updateDynamicRules({
  removeRuleIds: [1],
  addRules: [{
    id: 1,
    priority: 1,
    action: { type: 'redirect', redirect: { extensionPath: '/blocked/blocked.html' }},
    condition: { urlFilter: '*://twitter.com/*', resourceTypes: ['main_frame'] }
  }]
});
\`\`\`

### Work Hours Check
\`\`\`javascript
function isWorkTime() {
  const now = new Date();
  const { schedule } = await chrome.storage.sync.get('schedule');
  const day = now.getDay();
  const time = now.getHours() * 100 + now.getMinutes();
  
  const todaySchedule = schedule[day];
  return todaySchedule && 
         time >= todaySchedule.start && 
         time <= todaySchedule.end;
}
\`\`\`

### Motivational Messages
Store array in blocked.js, random selection:
\`\`\`javascript
const messages = [
  "Stay focused! You've got this 💪",
  "Your future self will thank you",
  "Distractions are just temptations in disguise"
];
document.getElementById('message').textContent = 
  messages[Math.floor(Math.random() * messages.length)];
\`\`\`
```

---

## Processing Logic

When `/build` is invoked:

1. **Parse description** for:
   - Product type (tool, extension, SaaS, API)
   - Features mentioned
   - Target platform
   - Technical constraints

2. **Select appropriate template**:
   - Web Tool → Single HTML architecture
   - Chrome Extension → Manifest V3 template
   - SaaS → Next.js + Supabase + Stripe
   - API → FastAPI + database

3. **Generate tech stack** based on:
   - Required features
   - Target platform
   - Scalability needs
   - Developer experience

4. **Create file structure** with:
   - All necessary files
   - Proper organization
   - Clear naming

5. **Write implementation steps** that:
   - Are actionable and specific
   - Follow logical order
   - Include estimated time
   - Consider edge cases
]]>