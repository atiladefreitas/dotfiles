# Arch Linux Packages for Neovim Setup

This document outlines all packages required to run your Neovim configuration on Arch Linux.

## System Packages

Install using `pacman`:

```bash
sudo pacman -S neovim git gcc make nodejs npm python python-pip lua xclip
```

| Package | Purpose | Required |
|---------|---------|----------|
| `neovim` | Text editor | ✅ Yes |
| `git` | Version control | ✅ Yes |
| `gcc` | C compiler | ✅ Yes |
| `make` | Build tool | ✅ Yes |
| `nodejs` | JavaScript runtime | ✅ Yes |
| `npm` | Node package manager | ✅ Yes |
| `python` | Python support | ✅ Yes |
| `python-pip` | Python package manager | ✅ Yes |
| `lua` | Lua runtime | ✅ Yes |
| `xclip` | Clipboard support | ⭐ Recommended |
| `fd` | Fast find alternative | ⭐ Recommended |
| `ripgrep` | Fast grep replacement | ⭐ Recommended |

## Optional System Packages

For improved performance and features:

```bash
sudo pacman -S fd ripgrep
```

### Why These?
- **fd**: Speeds up file searching in Telescope plugin
- **ripgrep**: Enables fast `live_grep` functionality in Telescope
- **xclip**: Ensures proper clipboard integration with system

## Language Servers (npm Global)

Install via npm:

```bash
npm install -g @vtsls/language-server
npm install -g @tailwindcss/language-server
npm install -g vscode-langservers-extracted
npm install -g @biomejs/biome
npm install -g prettier
npm install -g emmet-ls
```

| Package | Language | Purpose |
|---------|----------|---------|
| `@vtsls/language-server` | TypeScript/JavaScript | LSP server (recommended) |
| `@tailwindcss/language-server` | Tailwind CSS | CSS framework LSP |
| `vscode-langservers-extracted` | HTML/CSS | HTML & CSS LSP |
| `@biomejs/biome` | JavaScript/TypeScript | Linter & formatter |
| `prettier` | Multiple | Code formatter |
| `emmet-ls` | HTML/CSS | Emmet abbreviation support |

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

## Language Servers (Optional but Recommended)

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
sudo pacman -S neovim git gcc make nodejs npm python python-pip lua xclip fd ripgrep rust

echo "Installing npm global packages..."
npm install -g @vtsls/language-server
npm install -g @tailwindcss/language-server
npm install -g vscode-langservers-extracted
npm install -g @biomejs/biome
npm install -g prettier
npm install -g emmet-ls

echo "Installing Python formatters..."
pip install --user black isort

echo "Installing Rust tools..."
cargo install rustywind
cargo install stylua

echo "Installing AUR packages (requires yay)..."
yay -S lua-language-server marksman

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

# Check language servers
vtsls --version
biome --version
prettier --version

# Check formatters
black --version
stylua --version
rustywind --version
lua-language-server --version
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
| System Packages | 9 core + 3 optional | 9 core |
| npm Packages | 6 | 6 |
| Python Packages | 2 | 1 (black) |
| Rust/Cargo Tools | 2 | 2 |
| AUR Packages | 2 | 2 |
| **Total** | **~24** | **~20** |

## Notes

- All npm packages should be installed globally (`-g` flag)
- Python packages can be installed per-user (`--user` flag) to avoid permission issues
- Rust/Cargo tools are optional but recommended for formatting
- Some AUR packages require `yay` or another AUR helper
- After installation, restart Neovim to load all language servers
