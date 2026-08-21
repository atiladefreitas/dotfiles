# Arch Linux Packages for Neovim Setup

This document outlines all packages required to run your Neovim configuration on Arch Linux.

> **Note:** This config uses **Mason** to manage language servers. Most LSPs listed below
> are auto-installed by Mason on first launch (see `lua/atila/plugins/lsp/mason.lua`).
> You only need to install LSPs manually if you prefer system-wide binaries.

> **Plugins** are managed by Neovim's built-in **`vim.pack`** (0.12+), not lazy.nvim, so
> there is no bootstrap step — the first launch clones everything itself. See
> [Plugin management](#plugin-management) below. Requires Neovim **0.12 or newer**.

## System Packages

Install using `pacman`:

```bash
sudo pacman -S neovim git curl gcc make nodejs npm python python-pip lua xclip imagemagick
```

| Package | Purpose | Required |
|---------|---------|----------|
| `neovim` | Text editor | ✅ Yes |
| `git` | Version control — also how `vim.pack` clones and updates plugins | ✅ Yes |
| `gcc` | C compiler (treesitter parsers) | ✅ Yes |
| `curl` | Fetches blink.cmp's pre-built fuzzy-matcher binary | ✅ Yes |
| `make` | Build tool — run by the `PackChanged` hook for telescope-fzf-native | ✅ Yes |
| `nodejs` | JavaScript runtime (LSP servers via Mason) | ✅ Yes |
| `npm` | Node package manager | ✅ Yes |
| `python` | Python support | ✅ Yes |
| `python-pip` | Python package manager | ✅ Yes |
| `lua` | Lua runtime | ✅ Yes |
| `imagemagick` | Required by image.nvim (magick_cli processor) | ✅ Yes (if using image.nvim) |
| `xclip` | Clipboard support | ⭐ Recommended |
| `fd` | Fast find alternative | ⭐ Recommended |
| `ripgrep` | Fast grep replacement | ⭐ Recommended |

> **image.nvim** uses the Kitty graphics protocol (`backend = "kitty"`). For inline image
> rendering you need a compatible terminal — Kitty, Ghostty, or WezTerm.

## Optional System Packages

For improved performance and features:

```bash
sudo pacman -S fd ripgrep
```

### Why These?
- **fd**: Speeds up file searching in Telescope plugin
- **ripgrep**: Enables fast `live_grep` functionality in Telescope
- **xclip**: Ensures proper clipboard integration with system

## Language Servers (Managed by Mason)

The following LSPs are listed in `ensure_installed` in `mason.lua` and will be
auto-installed by Mason on first launch — **no manual install needed**:

| Mason name | Language | Purpose |
|------------|----------|---------|
| `vtsls` | TypeScript/JavaScript | LSP server |
| `html` | HTML | HTML LSP (vscode-langservers-extracted) |
| `cssls` | CSS | CSS LSP (vscode-langservers-extracted) |
| `tailwindcss` | Tailwind CSS | CSS framework LSP |
| `lua_ls` | Lua | Lua language server |
| `marksman` | Markdown | Markdown LSP |
| `jinja_lsp` | Jinja2 | Jinja template LSP |

### What Mason covers

Mason installs **both the language servers and every formatter** this config
uses. `mason-lspconfig`'s `ensure_installed` only understands lspconfig server
names, so the formatters are installed through `mason-registry` directly at the
bottom of `mason.lua` — that is all `mason-tool-installer.nvim` does, without
the extra plugin.

| Tool | Used for | Source |
|------|----------|--------|
| the 7 servers above | LSP | ✅ Mason |
| `prettier` | js/ts/css/html/yaml/markdown | ✅ Mason |
| `rustywind` | Tailwind class sorting | ✅ Mason |
| `stylua` | Lua | ✅ Mason |
| `black`, `isort` | Python | ✅ Mason |

**Nothing here needs an OS package.** Mason's `bin/` is the *first* entry on
Neovim's `PATH` (ahead of `/usr/bin`), so its copies take precedence even if you
also have system-wide ones — you can safely remove those.

To see what conform can reach in the current buffer:

```vim
:ConformInfo
```

> **If a formatter never installs**, check `:MasonLog`. A failed or interrupted
> install can leave a dangling symlink in `~/.local/share/nvim/mason/bin/`,
> after which every retry fails with `"<tool>" is already linked.` Delete the
> stale link and restart:
> ```bash
> rm ~/.local/share/nvim/mason/bin/<tool>
> ```

### Manual install (alternative to Mason)

If you prefer system-wide binaries instead of Mason-managed ones:

```bash
npm install -g @vtsls/language-server
npm install -g @tailwindcss/language-server
npm install -g vscode-langservers-extracted
npm install -g prettier
```

```bash
npm install -g @vtsls/language-server @tailwindcss/language-server vscode-langservers-extracted prettier
```

## Formatters (handled by Mason)

`prettier`, `rustywind`, `stylua`, `black` and `isort` are installed
automatically — see [What Mason covers](#what-mason-covers). **You do not need
to install any of them at the OS level.**

The commands below are only for running these tools *outside* Neovim (in a
pre-commit hook, a Makefile, CI, and so on):

```bash
sudo pacman -S prettier stylua python-black python-isort   # rustywind: AUR or cargo
cargo install rustywind
```

Arch marks its system Python as externally managed (PEP 668), so
`pip install --user black isort` is refused — use `pacman` or `pipx` if you
want them on the system.

## Language Servers (Optional — already handled by Mason)

These are auto-installed by Mason. The AUR alternatives below are only needed
if you want system-wide binaries.

### Lua Language Server
Via AUR:
```bash
yay -S lua-language-server
```

Or manual installation from [releases page](https://github.com/LuaLS/lua-language-server/releases)

### Markdown (Marksman)
Via AUR:
```bash
yay -S marksman
```

### Jinja LSP
Installed automatically by Mason (`jinja-lsp`). For manual install see
[uros-5/jinja-lsp](https://github.com/uros-5/jinja-lsp/releases).

## Rust (optional)

Not required. `rustywind` and `stylua` come from Mason as pre-built binaries,
and blink.cmp downloads its fuzzy matcher rather than compiling it. Install a
toolchain only if you want these tools system-wide:

```bash
sudo pacman -S rust
cargo install rustywind stylua
```

## Quick Installation Script

Save this as `install-neovim-deps.sh`:

```bash
#!/bin/bash

echo "Installing Arch system packages..."
sudo pacman -S neovim git curl gcc make nodejs npm python lua xclip fd ripgrep imagemagick

echo "Language servers AND formatters (prettier, rustywind, stylua,"
echo "black, isort) are auto-installed by Mason on first Neovim launch."
echo "Plugins are cloned by vim.pack on the same launch. No manual step needed."

echo "✅ Installation complete!"
```

Run with:
```bash
chmod +x install-neovim-deps.sh
./install-neovim-deps.sh
```

## Verification

After installation, verify all tools are available:

```bash
# Check core tools
nvim --version
git --version
gcc --version
node --version
npm --version
curl --version
python --version
lua -v

# Check optional tools
fd --version
rg --version
magick --version  # imagemagick (for image.nvim)

# Formatters and LSPs are Mason-managed, not system tools. Check them from
# inside Neovim instead:
#   :Mason         install status for everything
#   :ConformInfo   which formatters the current buffer can actually reach
```

## Plugin management

Plugins are handled by Neovim's built-in `vim.pack` (0.12+). There is no plugin
manager to install and no bootstrap code — the first `nvim` launch clones
everything itself, which takes a minute or two.

| Where | What |
|-------|------|
| `lua/atila/plugins/init.lua` | The plugin list, build hooks and load order |
| `~/.local/share/nvim/site/pack/core/opt/` | Where `vim.pack` installs plugins |
| `~/.local/share/nvim/site/pack/manual/opt/` | Plugins `vim.pack` can't install (see below) |
| `nvim-pack-lock.json` | Pinned revisions — **commit this** to keep machines in sync |

### Commands

`vim.pack` ships no UI, so the config defines these in place of `:Lazy`:

| Command | Purpose |
|---------|---------|
| `:PackUpdate` | Fetch updates and open a review buffer — `:write` applies, `:quit` discards |
| `:PackStatus` | Same review buffer, offline: what's installed vs what's pinned |
| `:PackClean` | Delete plugins this config no longer lists |

There is no automatic update check (lazy.nvim's `checker`); run `:PackUpdate`
when you want one.

### Build steps

Two plugins need compiling after install or update. A `PackChanged` autocmd in
`plugins/init.lua` handles both, which is why `make`, `gcc` and `curl` are
required:

- **telescope-fzf-native** — runs `make`, producing `build/libfzf.so`
- **nvim-treesitter** — runs `:TSUpdate`; parsers land in `~/.local/share/nvim/site/parser/`

blink.cmp downloads a pre-built Rust binary over `curl` instead of compiling,
because it is pinned to a `1.x` release tag rather than a branch.

### jinja.vim is installed separately

`vim.pack` always runs `git submodule update --init --recursive` and offers no
opt-out. `HiPhish/jinja.vim` commits a gitlink at `test/bin` but names its
manifest `.submodules` instead of `.gitmodules`, so that step fails and aborts
the whole install. The config therefore clones it directly into
`pack/manual/opt/` without submodules. Nothing to do manually — `:PackUpdate`
covers it too.

## Troubleshooting

### npm Global Install Issues
If you get permission errors:
```bash
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
```

### Language Server Not Found
1. Verify installation: `which <server-name>`
2. Ensure it's in your PATH
3. Restart Neovim
4. Check `:LspInfo` in Neovim for diagnostics

### Cargo/Rust Issues
Update Rust:
```bash
rustup update
```

## Summary

| Category | Count | Essential |
|----------|-------|-----------|
| System Packages | 11 core + 3 optional | 11 core |
| Neovim plugins | 55 | 0 — `vim.pack` clones them |
| LSP servers | 7 | 0 — Mason |
| Formatters | 5 | 0 — Mason |
| Rust/Cargo Tools | 0 | 0 — no longer needed |
| **Total to install manually** | **11** | **11** |

## Notes

- Requires **Neovim 0.12+** — the config uses `vim.pack`, which does not exist earlier
- Plugins are auto-installed by **`vim.pack`** on first launch — no bootstrap step
- Language servers **and formatters** are auto-installed by **Mason** — nothing to install by hand
- Mason's `bin/` is first on Neovim's `PATH`, so its tools win over any system-wide copies
- A Rust toolchain is **not** required — Mason ships pre-built `stylua`/`rustywind` binaries
- AUR/cargo packages are only needed if you want these tools outside Neovim too
- `imagemagick` is required by `image.nvim` if you use markdown image previews
- First launch clones ~55 plugins, compiles `libfzf.so` and downloads treesitter
  parsers, so expect it to take a minute or two before the dashboard appears
