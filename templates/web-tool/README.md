# Web Tool Template

A complete single-file web tool template — privacy-first, no server, no dependencies.

## Usage

1. Copy `index.html` to your project
2. Update the title, subtitle, and file types in the `<input accept="">` attribute  
3. Replace the `processFile()` function with your logic
4. Open in a browser — done

## What's Included

- Drag-and-drop file input
- File reader with progress bar
- Output display with copy + download buttons
- Reset flow
- Privacy badge
- Mobile-responsive layout
- Zero dependencies — pure HTML/CSS/JS

## Customization

```javascript
// Replace this function with your logic
function processFile(content, filename) {
  // content = file text content
  // filename = original filename
  return processedResult;
}
```

To support binary files (images, PDFs), change:
```javascript
reader.readAsText(file);
// → reader.readAsArrayBuffer(file);
// → reader.readAsDataURL(file);
```

## See Also

- [web-tool-builder skill](../../skills/web-tool-builder.md)
- [web-tool-agent](../../agents/web-tool-agent.md)
