# Arch Linux Packages for Neovim Setup

This document outlines all packages required to run your Neovim configuration on Arch Linux.

> **Note:** This config uses **Mason** to manage language servers. Most LSPs listed below
> are auto-installed by Mason on first launch (see `lua/atila/plugins/lsp/mason.lua`).
> You only need to install LSPs manually if you prefer system-wide binaries.

## System Packages

Install using `pacman`:

```bash
sudo pacman -S neovim git gcc make nodejs npm python python-pip lua xclip imagemagick
```

| Package | Purpose | Required |
|---------|---------|----------|
| `neovim` | Text editor | ✅ Yes |
| `git` | Version control | ✅ Yes |
| `gcc` | C compiler (treesitter parsers) | ✅ Yes |
| `make` | Build tool (telescope-fzf-native, treesitter) | ✅ Yes |
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
| `biome` | JavaScript/TypeScript/JSON | Linter & formatter |
| `html` | HTML | HTML LSP (vscode-langservers-extracted) |
| `cssls` | CSS | CSS LSP (vscode-langservers-extracted) |
| `tailwindcss` | Tailwind CSS | CSS framework LSP |
| `lua_ls` | Lua | Lua language server |
| `marksman` | Markdown | Markdown LSP |
| `jinja_lsp` | Jinja2 | Jinja template LSP |

### Manual install (alternative to Mason)

If you prefer system-wide binaries instead of Mason-managed ones:

```bash
npm install -g @vtsls/language-server
npm install -g @tailwindcss/language-server
npm install -g vscode-langservers-extracted
npm install -g @biomejs/biome
npm install -g prettier
```

```bash
npm install -g @vtsls/language-server @tailwindcss/language-server vscode-langservers-extracted @biomejs/biome prettier
```

## Formatters & Build Tools

### Python Formatters
```bash
pip install --user black isort
```

### Lua Formatter (from AUR)
```bash
yay -S stylua
```
Or with cargo:
```bash
cargo install stylua
```

### Tailwind CSS Formatter (from Cargo)
```bash
cargo install rustywind
```

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

## Rust (Required for rustywind & stylua)

Install Rust toolchain:

```bash
sudo pacman -S rust
```

Then install tools:
```bash
cargo install rustywind
cargo install stylua
```

## Quick Installation Script

Save this as `install-neovim-deps.sh`:

```bash
#!/bin/bash

echo "Installing Arch system packages..."
sudo pacman -S neovim git gcc make nodejs npm python python-pip lua xclip fd ripgrep rust imagemagick

echo "Installing Python formatters..."
pip install --user black isort

echo "Installing Rust tools..."
cargo install rustywind
cargo install stylua

echo "LSPs (vtsls, biome, html, cssls, tailwindcss, lua_ls, marksman, jinja_lsp)"
echo "are auto-installed by Mason on first Neovim launch — no manual step needed."

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
python --version
lua -v

# Check optional tools
fd --version
rg --version
magick --version  # imagemagick (for image.nvim)

# Check formatters (system-installed)
black --version
stylua --version
rustywind --version

# Mason-managed LSPs: open Neovim and run :Mason to see install status
```

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
| System Packages | 10 core + 3 optional | 10 core |
| Mason-managed LSPs | 8 | auto-installed |
| Python Packages | 2 | 1 (black) |
| Rust/Cargo Tools | 2 | 2 |
| AUR Packages (optional) | 2 | 0 (Mason handles) |
| **Total to install manually** | **~17** | **~15** |

## Notes

- Language servers are auto-installed by **Mason** — no manual install step required
- Python packages can be installed per-user (`--user` flag) to avoid permission issues
- Rust/Cargo tools are required for `stylua` (Lua formatting) and `rustywind` (Tailwind sorting)
- AUR packages are only needed if you prefer system binaries over Mason
- `imagemagick` is required by `image.nvim` if you use markdown image previews
- After installation, restart Neovim and Mason will fetch all LSPs on first launch
