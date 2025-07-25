---
**⚠️ DISCLAIMER: AI-Generated Content**

This document is fully AI-generated and was created for Neovim + AI workflow testing and proof-of-concept purposes. Use at your own discretion and verify configurations before implementation.

---

````markdown
# Neovim: Auto‑Reload Buffers on External File Changes

When you edit a file outside Neovim (e.g. via an AI tool like Opencode or CURSOR), you want Neovim to detect and reload it automatically. Here’s how to implement reliable auto‑reload behavior.

---

## 🔁 1. Enable Auto‑Read

This option tells Neovim to automatically reload files changed on disk, as long as you haven’t made unsaved edits in the buffer:

```vim
" Vim‑script
set autoread
````

```lua
-- Lua
vim.o.autoread = true
```

---

## ⚡ 2. Force Timestamp Check on Events

Terminal Neovim doesn’t always notice file changes on its own. To force a check when you switch buffers, focus your terminal, or idle:

### Vim‑script

```vim
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | silent! checktime | endif
```

* Uses `checktime` to detect external changes
* Avoids interfering with command‑line mode
  ([Stack Overflow][1], [Super User][2], [Unix & Linux Stack Exchange][3])

### Lua

```lua
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  pattern = "*",
  command = "if mode() ~= 'c' then silent! checktime end",
})
```

Works consistently to reload buffers in Neovim terminal sessions.
([Stack Overflow][1])

---

## 📣 3. Notify on Reload

Optional: Display a message when a file is auto‑reloaded.

### Vim‑script

```vim
autocmd FileChangedShellPost * echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None
```

### Lua

```lua
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  pattern = "*",
  callback = function()
    vim.notify("File changed on disk. Buffer reloaded.", vim.log.levels.WARN)
  end,
})
```

This triggers when the buffer is reloaded and you had no local modifications.
([Stack Overflow][1])

---

## 🛠 4. Manual Reload Commands

* `:e` – reload current buffer, fails if local edits exist
* `:e!` – reload and discard local changes
* `:bufdo e!` or `:bufdo silent! checktime` – reload all buffers
  ([(think)][4])

---

## 🧠 5. Complete Config Examples

```vim
" init.vim

set autoread
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | silent! checktime | endif
autocmd FileChangedShellPost * echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None
```

```lua
-- init.lua or lua/config.lua

vim.o.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  pattern = "*",
  command = "if mode() ~= 'c' then silent! checktime end",
})
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  pattern = "*",
  callback = function()
    vim.notify("File changed on disk. Buffer reloaded.", vim.log.levels.WARN)
  end,
})
```

---

## ✅ Summary Table

| Feature           | Vim‑script                                | Lua variant                                                 |
| ----------------- | ----------------------------------------- | ----------------------------------------------------------- |
| Enable autoreload | `set autoread`                            | `vim.o.autoread = true`                                     |
| Trigger reloads   | `autocmd FocusGained,... checktime`       | `nvim_create_autocmd([...], command=...)`                   |
| Notify on reload  | `autocmd FileChangedShellPost * echo ...` | `nvim_create_autocmd("FileChangedShellPost", callback=...)` |

---

## 💡 Tips

* If using tmux or terminal multiplexers, ensure focus events are enabled (`tmux set‑g focus‑events on`) so FocusGained works in terminal Vim.
  ([Reddit][5], [Unix & Linux Stack Exchange][3], [Stack Overflow][1])
* You can wrap these autocmds in an augroup to avoid duplicates.
* For real time watching, plugins using filesystem events (e.g. LibUV-based watchers) exist, though the simple `checktime` approach is lightweight and effective.
  ([Reddit][5])

---

## 📄 Usage Instructions for AI Tool

Hand this Markdown file to your AI so it can understand:

1. Enable autoread configuration
2. Use event hooks (`FocusGained`, `BufEnter`, etc.) to call `checktime`
3. Optionally notify on reload
4. Provide manual fallback commands

Let me know if you’d like to include toggling keybinds, plugin integration, or watcher-based extensions.

[1]: https://stackoverflow.com/questions/62100785/auto-reload-file-and-in-neovim-and-auto-reload-nerbtree?utm_source=chatgpt.com "Auto reload file and in neovim and auto reload nerbtree"
[2]: https://superuser.com/questions/181377/auto-reloading-a-file-in-vim-as-soon-as-it-changes-on-disk?utm_source=chatgpt.com "Auto-reloading a file in Vim as soon as it changes on disk - Super User"
[3]: https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim?utm_source=chatgpt.com "vim - refresh changed content of file opened in vi(m)"
[4]: https://batsov.com/articles/2025/06/02/how-to-vim-reloading-file-buffers/?utm_source=chatgpt.com "How to Vim: Reloading File Buffers - (think) - Bozhidar Batsov"
[5]: https://www.reddit.com/r/neovim/comments/1i0dg8g/make_neovim_refresh_automatically_when_file/?utm_source=chatgpt.com "Make Neovim refresh automatically when file content is changing"
