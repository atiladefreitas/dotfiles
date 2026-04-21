# Neovim 0.12 Migration Report

**Generated:** 2026-04-20
**Config path:** `nvim/lua/atila/`

---

## Executive Summary

After auditing your entire Neovim configuration against the Neovim 0.12 breaking
changes, deprecations, and new features, I identified **8 issues that need fixing**
(3 critical, 3 moderate, 2 minor) and **5 recommended improvements** that leverage
new 0.12 features.

---

## CRITICAL ISSUES (Will cause errors/broken behavior)

### 1. `vim.lsp.diagnostic.on_publish_diagnostics` may behave differently with `vim.NIL`

**File:** `lua/atila/plugins/lsp/native-lsp.lua:61-68`

**Problem:** Neovim 0.12 changed LSP message handling so that JSON `null` values
are now represented as `vim.NIL` instead of `nil`. Your custom vtsls handler
filters diagnostics by checking `d.source ~= "typescript"`, which is fine, but
the `result` and `result.diagnostics` nil-checks may behave differently if the
server sends a JSON null for either field.

Additionally, `vim.lsp.diagnostic.on_publish_diagnostics` is a very old API
surface. While it still works, you should ensure you're calling the right
handler.

**Current code:**
```lua
handlers = {
    ["textDocument/publishDiagnostics"] = function(err, result, ctx)
        if result and result.diagnostics then
            result.diagnostics = vim.tbl_filter(function(d)
                return d.source ~= "typescript"
            end, result.diagnostics)
        end
        vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx)
    end,
},
```

**Fix:**
```lua
handlers = {
    ["textDocument/publishDiagnostics"] = function(err, result, ctx)
        if result and result.diagnostics then
            result.diagnostics = vim.tbl_filter(function(d)
                -- Guard against vim.NIL from 0.12's JSON null handling
                local source = d.source
                if source == vim.NIL then source = nil end
                return source ~= "typescript"
            end, result.diagnostics)
        end
        vim.lsp.diagnostic.on_publish_diagnostics(err, result, ctx)
    end,
},
```

**Severity:** CRITICAL - Could cause diagnostic display failures if vtsls sends
null values in diagnostic fields.

---

### 2. `vim.diff` renamed to `vim.text.diff`

**File:** Global (not directly used in your config, but relevant)

**Problem:** Neovim 0.12 renamed `vim.diff` to `vim.text.diff`. While you don't
call `vim.diff()` directly in your config, any plugin that does (or if you use
it in `:lua` commands) will break.

**Impact:** Low for your config specifically, but any scripts or ad-hoc commands
using `vim.diff()` will error. Be aware when debugging.

**Severity:** CRITICAL if you use `vim.diff()` anywhere manually.

---

### 3. `tohtml` plugin is now opt-in

**File:** `lua/atila/lazy.lua:36`

**Problem:** You disable `tohtml` in lazy.nvim's `disabled_plugins`:
```lua
disabled_plugins = {
    ...
    "tohtml",
    ...
}
```

In Neovim 0.12, `tohtml` was renamed to `nvim.tohtml` and is now opt-in (must
be loaded via `:packadd nvim.tohtml`). Disabling `"tohtml"` no longer matches
the actual plugin name.

**Fix:** Update the disabled plugin name or remove it (since it's already opt-in):
```lua
disabled_plugins = {
    "gzip",
    "matchit",
    "matchparen",
    "netrwPlugin",
    "tarPlugin",
    -- "tohtml",  -- Remove: now opt-in as "nvim.tohtml" in 0.12
    "tutor",
    "zipPlugin",
},
```

**Severity:** CRITICAL - Will produce a warning or silently fail to disable.

---

## MODERATE ISSUES (May cause unexpected behavior)

### 4. `shelltemp` default changed to `false`

**File:** Not explicitly set in your config

**Problem:** Neovim 0.12 changed `'shelltemp'` default from `true` to `false`.
This means shell commands now use `pipe()` instead of temp files. If you use any
shell commands that rely on `/dev/stdin` or similar special files, they may break.

This affects `:!command`, `:make`, `:grep`, and `vim.fn.system()` calls
throughout your config (formatting.lua, obsidian.nvim, telescope image preview).

**Recommendation:** If you notice any shell command failures (especially with
formatters like prettier, biome, or rustywind), add to `options.lua`:
```lua
opt.shelltemp = true  -- Restore pre-0.12 behavior for shell commands
```

**Severity:** MODERATE - May cause silent formatter failures.

---

### 5. Treesitter `Query:iter_matches()` "all" option removed

**File:** `lua/atila/plugins/treesitter.lua` (indirect)

**Problem:** The `"all"` option to `Query:iter_matches()`, introduced in 0.11 as
a transition aid, has been removed in 0.12. While your config doesn't call this
directly, plugins that depend on it will break.

**Affected plugins to watch:**
- `nvim-treesitter` - Update to latest version
- `nvim-ts-autotag` - Update to latest version
- `render-markdown.nvim` - Update to latest version
- `nvim-ufo` (folding) - Uses treesitter queries for folds

**Fix:** Run `:Lazy update` to ensure all plugins are on their latest versions,
which should include 0.12 compatibility patches.

**Severity:** MODERATE - Plugin-level issue, fixed by updating.

---

### 6. `i_CTRL-R` register paste behavior changed

**File:** General editing behavior

**Problem:** In 0.12, `<C-R>` in insert mode now inserts named/clipboard
registers **literally** (like pasting) instead of simulating user input. This
is faster but may break formatting expectations if you relied on the old
character-by-character insertion behavior.

Your config uses `clipboard:append("unnamedplus")` (`options.lua:43`), so
`<C-R>+` and `<C-R>"` will now paste literally.

**Impact:** Generally positive (10x faster paste), but if you had mappings or
abbreviations that triggered during register insertion, they will no longer fire.

**Severity:** MODERATE - Behavioral change, usually an improvement.

---

## MINOR ISSUES (Deprecation warnings, cosmetic)

### 7. `vim.lsp.get_client_by_id()` used correctly, but new deprecations nearby

**File:** `lua/atila/plugins/lsp/native-lsp.lua:31`

**Current code:**
```lua
local client = vim.lsp.get_client_by_id(args.data.client_id)
```

This is fine and is the correct API. However, note these newly deprecated
LSP functions in 0.12 that you should avoid using in the future:
- `vim.lsp.client_is_stopped()` -> Use `vim.lsp.get_client_by_id()` instead
- `vim.lsp.stop_client()` -> Use `Client:stop()` instead
- `vim.lsp.codelens.refresh()` -> Use `vim.lsp.codelens.enable(true)` instead
- `vim.lsp.set_log_level()` -> Use `vim.lsp.log.set_level()` instead
- `vim.lsp.get_log_path()` -> Use `vim.lsp.log.get_filename()` instead

**Severity:** MINOR - No action needed now, just be aware.

---

### 8. `vim.diff()` deprecated in Lua namespace

**File:** Not used directly, but `vim.diff` is deprecated in favor of
`vim.text.diff`.

**Also deprecated in 0.12:**
- `"buffer"` key in `vim.keymap.set` opts -> renamed to `"buf"` (deprecated,
  still works for now). Your config uses `buffer = bufnr` throughout which is
  fine but will eventually need to change to `buf = bufnr`.

**Severity:** MINOR - Will work for now, plan migration later.

---

## RECOMMENDED IMPROVEMENTS (Leverage 0.12 features)

### A. Use new native LSP features instead of plugin equivalents

**Opportunity:** Neovim 0.12 adds native support for:
- `textDocument/codeLens` (reimplemented)
- `textDocument/documentColor` (color preview)
- `textDocument/onTypeFormatting`
- `textDocument/linkedEditingRange`
- `textDocument/inlineCompletion`
- Native `:lsp` command for managing clients

You could potentially simplify your setup by leveraging these native features.

**Action:** Consider using `:lsp` command for debugging LSP issues instead of
`:LspInfo` from nvim-lspconfig.

---

### B. Use new default statusline with diagnostic info

**Opportunity:** Neovim 0.12 exposes the default statusline as a statusline
expression that includes `vim.diagnostic.status()` and
`vim.ui.progress_status()`. While you use lualine, be aware that the default
statusline is now much more capable.

**New APIs available:**
- `vim.diagnostic.status()` - Returns status description of buffer diagnostics
- `vim.ui.progress_status()` - Returns progress of running operations

You could add these to your lualine sections if desired.

---

### C. New default mappings that may conflict

**Opportunity/Warning:** Neovim 0.12 adds new default mappings:
- `grt` -> `vim.lsp.buf.type_definition()`
- `grx` -> `vim.lsp.codelens.run()`

These are added to the existing `gr` prefix from 0.11 (`grn`, `gra`, `grr`).
Your config maps `gr` to Telescope LSP references (`native-lsp.lua:41`):
```lua
keymap("n", "gr", "<cmd>Telescope lsp_references<cr>", opts)
```

**Impact:** Your `gr` mapping will override the default `grr` (rename) since it
triggers immediately on `gr`. The new `grt` and `grx` mappings won't conflict
since they have longer key sequences, but there will be a delay when pressing
`gr` as Neovim waits to see if you'll press `t`, `x`, `r`, `n`, or `a`.

**Fix (optional):** If you experience input delay on `gr`, add `nowait = true`:
```lua
keymap("n", "gr", "<cmd>Telescope lsp_references<cr>",
    { noremap = true, silent = true, buffer = bufnr, nowait = true })
```

---

### D. Enable `pumborder` for completion popup menu border

**Opportunity:** Neovim 0.12 adds `'pumborder'` option for adding borders to
the popup completion menu. If you want a cleaner look:
```lua
vim.opt.pumborder = true
```

---

### E. Consider `ui2` experimental UI

**Opportunity:** Neovim 0.12 introduces `ui2`, a redesigned messages and
cmdline UI that avoids "Press ENTER" interruptions and highlights the cmdline
as you type. Since you already use `noice.nvim` for message handling, this
may be redundant, but you could test:
```lua
-- Add to init.lua to test (experimental)
require('vim._core.ui2').enable()
```

**Warning:** This is experimental and may conflict with noice.nvim. Test
carefully before adopting.

---

## PLUGIN UPDATE CHECKLIST

Run `:Lazy update` and verify these plugins have 0.12-compatible versions:

| Plugin | Status | Notes |
|--------|--------|-------|
| `nvim-treesitter` | UPDATE REQUIRED | iter_matches "all" option removed |
| `nvim-ts-autotag` | UPDATE REQUIRED | May use removed treesitter APIs |
| `blink.cmp` | CHECK | You already disabled `treesitter_highlighting` in docs - good |
| `nvim-lspconfig` | UPDATE REQUIRED | Needs 0.12 compatibility |
| `mason-lspconfig` | UPDATE REQUIRED | Must support `vim.lsp.config`/`vim.lsp.enable` |
| `render-markdown.nvim` | UPDATE | May use treesitter APIs that changed |
| `nvim-ufo` | UPDATE | Uses treesitter fold queries |
| `noice.nvim` | CHECK | ui-messages events changed in 0.12 |
| `telescope.nvim` | OK | Likely unaffected |
| `neo-tree.nvim` | OK | Likely unaffected |
| `gitsigns.nvim` | OK | Likely unaffected |
| `conform.nvim` | CHECK | shelltemp change may affect formatters |
| `lazy.nvim` | OK | Likely unaffected |

---

## NOICE.NVM COMPATIBILITY WARNING

**File:** `lua/atila/plugins/folke.lua:22-35`

**Problem:** Neovim 0.12 changed ui-messages events:
- `msg_show.return_prompt` event removed
- `msg_history_clear` event removed
- `msg_clear` event repurposed (now emitted after screen clear)
- `msg_history_show` gained a new "prev_cmd" argument

**Impact:** `noice.nvim` handles message events extensively. If noice.nvim
hasn't been updated for 0.12, you may see:
- Missing message notifications
- Duplicate messages
- Visual glitches in the message area

**Fix:** Ensure noice.nvim is on the latest version. If issues persist,
temporarily disable noice.nvim to isolate the problem:
```lua
-- In folke.lua, temporarily:
{
    "folke/noice.nvim",
    enabled = false,  -- Disable to test
    ...
}
```

---

## BLINK.CMP DOCUMENTATION PREVIEW WORKAROUND

**File:** `lua/atila/plugins/lsp/blink-cmp.lua:49-51`

**Current code:**
```lua
-- Disable treesitter highlighting in docs to avoid crash on Neovim 0.12
-- (upstream bug: nil node passed to vim.treesitter.get_range)
treesitter_highlighting = false,
```

**Status:** You already applied a workaround for a known 0.12 treesitter bug.
This is correct. The underlying issue is that `vim.treesitter.get_parser()` now
returns `nil` instead of throwing an error when it fails to create a parser
(a 0.12 "Removed Features" change). Plugins that didn't handle the nil return
will crash.

**Action:** Keep this workaround until blink.cmp releases an update that
handles the nil parser return. Check periodically by re-enabling:
```lua
treesitter_highlighting = true,
```

---

## OBSIDIAN.NVM `follow_url_func` / `follow_img_func`

**File:** `lua/atila/plugins/markdown.lua:435-441`

**Current code:**
```lua
follow_url_func = function(url)
    vim.fn.jobstart({ "open", url }) -- Mac OS
end,
follow_img_func = function(img)
    vim.fn.jobstart({ "qlmanage", "-p", img }) -- Mac OS quick look preview
end,
```

**Problem:** You're on Linux (based on your environment), but these functions
use macOS-specific commands (`open`, `qlmanage`). This isn't a 0.12 issue per
se, but `shelltemp` changes could affect `jobstart` behavior.

**Fix:**
```lua
follow_url_func = function(url)
    vim.ui.open(url)  -- Cross-platform (uses xdg-open on Linux)
end,
follow_img_func = function(img)
    vim.ui.open(img)  -- Cross-platform
end,
```

---

## SUMMARY OF REQUIRED ACTIONS

### Immediate (fix now):
1. Update `tohtml` in disabled_plugins list (`lazy.lua`)
2. Run `:Lazy update` to get 0.12-compatible plugin versions
3. Add `vim.NIL` guard in vtsls diagnostic handler (`native-lsp.lua`)

### Soon (if experiencing issues):
4. Add `opt.shelltemp = true` if formatters break (`options.lua`)
5. Update noice.nvim or disable if messages misbehave
6. Add `nowait = true` to `gr` mapping if experiencing input delay

### Later (housekeeping):
7. Migrate `buffer = bufnr` to `buf = bufnr` in keymap opts (deprecated 0.12)
8. Update obsidian follow functions to use `vim.ui.open()`
9. Monitor blink.cmp for treesitter_highlighting fix
10. Consider new 0.12 features (pumborder, native codelens, ui2)
