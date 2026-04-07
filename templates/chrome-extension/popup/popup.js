// Popup script — runs in the popup window context

document.addEventListener('DOMContentLoaded', async () => {
  await loadState();
  bindEvents();
});

async function loadState() {
  const { enabled } = await chrome.storage.sync.get({ enabled: true });
  document.getElementById('toggle-enabled').checked = enabled;
}

function bindEvents() {
  // Toggle
  document.getElementById('toggle-enabled').addEventListener('change', async (e) => {
    await chrome.storage.sync.set({ enabled: e.target.checked });
    // Notify background
    chrome.runtime.sendMessage({ type: 'GET_STATUS' });
  });

  // Action button
  document.getElementById('action-btn').addEventListener('click', async () => {
    const btn = document.getElementById('action-btn');
    btn.disabled = true;
    btn.textContent = 'Working...';

    try {
      const response = await chrome.runtime.sendMessage({
        type: 'DO_ACTION',
        data: {}
      });

      if (response.error) throw new Error(response.error);
      btn.textContent = 'Done!';
    } catch (error) {
      btn.textContent = 'Error — try again';
      console.error(error);
    } finally {
      setTimeout(() => {
        btn.disabled = false;
        btn.textContent = 'Do Something';
      }, 2000);
    }
  });

  // Settings link
  document.getElementById('settings-link').addEventListener('click', (e) => {
    e.preventDefault();
    chrome.runtime.openOptionsPage();
  });
}
