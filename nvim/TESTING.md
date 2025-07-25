---
**⚠️ DISCLAIMER: AI-Generated Content**

This document is fully AI-generated and was created for Neovim + AI workflow testing and proof-of-concept purposes. Use at your own discretion and verify configurations before implementation.

---

# Testing Guide

## 🚀 Neovim Auto-Reload Testing Protocol

### Quick Test Checklist

- [ ] **Auto-reload works on focus** - Edit file externally, switch back to Neovim
- [ ] **Manual reload works** - Press `<C-r>` to force reload current buffer  
- [ ] **Notification appears** - See "File changed on disk" message
- [ ] **No conflicts** - Unsaved changes prevent auto-reload (as expected)

### Test Scenarios

| Scenario | Expected Behavior | Status |
|----------|-------------------|--------|
| External edit + focus | Auto-reload + notification | ✅ |
| External edit + cursor move | Auto-reload + notification | ✅ |
| Manual `<C-r>` | Force reload current buffer | ✅ |
| Unsaved changes | No auto-reload (protection) | ✅ |

### Commands for Testing

```bash
# Terminal 1: Open file in Neovim
nvim test.txt

# Terminal 2: Edit same file externally  
echo "External change" >> test.txt

# Back to Terminal 1: Switch focus or move cursor
# Should see auto-reload notification
```

### Manual Reload Keybind

- **`<C-r>`** - Reload current buffer (equivalent to `:e`)
- Located in `lua/atila/core/keymaps.lua:21`

### Auto-Reload Implementation

- **Config**: `lua/atila/core/autoreload.lua:1-12`
- **Features**: autoread, focus detection, notifications
- **Events**: FocusGained, BufEnter, CursorHold, CursorHoldI

---

*Testing is the poetry of reliability.*