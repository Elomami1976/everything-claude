// Background Service Worker (Manifest V3)
// Runs in the background, persists across browser sessions via chrome.storage

chrome.runtime.onInstalled.addListener(({ reason }) => {
  if (reason === 'install') {
    console.log('Extension installed');
    // Set default settings
    chrome.storage.sync.set({
      enabled: true,
      // Add your default settings here
    });
  }
});

// Message handler — receives messages from popup or content scripts
chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
  switch (message.type) {
    case 'GET_STATUS':
      handleGetStatus(sendResponse);
      return true; // Keep channel open for async response

    case 'DO_ACTION':
      handleAction(message.data, sendResponse);
      return true;

    default:
      sendResponse({ error: 'Unknown message type' });
  }
});

async function handleGetStatus(sendResponse) {
  const { enabled } = await chrome.storage.sync.get('enabled');
  sendResponse({ enabled });
}

async function handleAction(data, sendResponse) {
  try {
    // Your action logic here
    sendResponse({ success: true });
  } catch (error) {
    sendResponse({ error: error.message });
  }
}
