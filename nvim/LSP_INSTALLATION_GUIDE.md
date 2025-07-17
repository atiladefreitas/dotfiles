# LSP Server Installation Guide

Since we've moved to a native LSP setup without Mason, you'll need to install the language servers manually. Here's how to install each one:

## Prerequisites

Make sure you have Node.js and npm installed for most language servers.

## Language Servers to Install

### 1. TypeScript/JavaScript (vtsls) - Recommended
```bash
npm install -g @vtsls/language-server
```

#### Alternative: TypeScript Language Server (ts_ls)
```bash
npm install -g typescript typescript-language-server
```

### 2. Tailwind CSS
```bash
npm install -g @tailwindcss/language-server
```

### 3. HTML
```bash
npm install -g vscode-langservers-extracted
```

### 4. CSS
```bash
# CSS language server is included in vscode-langservers-extracted (already installed above)
```

### 5. Emmet
```bash
npm install -g emmet-ls
```

### 6. Lua (lua_ls)

#### Option A: Using Homebrew (macOS/Linux)
```bash
brew install lua-language-server
```

#### Option B: Manual Installation
1. Download the latest release from [lua-language-server releases](https://github.com/LuaLS/lua-language-server/releases)
2. Extract and add to your PATH

### 7. Biome
```bash
npm install -g @biomejs/biome
```

### 8. Marksman (Markdown) - Optional
```bash
# Download from releases page: https://github.com/artempyanykh/marksman/releases
# Or use package manager
brew install marksman  # macOS
```

## Formatters and Tools

### Prettier
```bash
npm install -g prettier
```

### Stylua (Lua formatter)
```bash
# Using Homebrew
brew install stylua

# Using Cargo
cargo install stylua
```

### ESLint (if using)
```bash
npm install -g eslint
```

## Verification

After installation, verify that the language servers are available:

```bash
# Check VTSLS (recommended)
vtsls --version

# Or check TypeScript Language Server (if using ts_ls)
typescript-language-server --version

# Check Tailwind CSS Language Server
tailwindcss-language-server --version

# Check Biome
biome --version

# Check Lua Language Server
lua-language-server --version

# Check Prettier
prettier --version

# Check Stylua
stylua --version
```

## Project-Specific Installation

For project-specific configurations, you might want to install some tools locally:

```bash
# In your project directory
npm install --save-dev prettier eslint @biomejs/biome
```

## Configuration Files

Create configuration files in your project root as needed:

### Prettier (.prettierrc)
```json
{
  "semi": true,
  "trailingComma": "es5",
  "singleQuote": true,
  "printWidth": 80,
  "tabWidth": 2
}
```

### Biome (biome.json)
```json
{
  "$schema": "https://biomejs.dev/schemas/1.4.1/schema.json",
  "organizeImports": {
    "enabled": true
  },
  "linter": {
    "enabled": true,
    "rules": {
      "recommended": true
    }
  },
  "formatter": {
    "enabled": true,
    "indentStyle": "space"
  }
}
```

### Tailwind (tailwind.config.js)
```javascript
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./src/**/*.{js,jsx,ts,tsx}",
    "./public/index.html"
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
```

## Troubleshooting

### LSP Server Not Found
If Neovim can't find a language server:
1. Check if it's installed: `which <server-name>`
2. Ensure it's in your PATH
3. Restart Neovim after installation

### Permission Issues
If you get permission errors with npm global installs:
```bash
# Set up npm to install packages globally without sudo
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
# Add to your shell profile: export PATH=~/.npm-global/bin:$PATH
```

### Alternative Package Managers

#### Using pnpm instead of npm:
```bash
pnpm install -g typescript typescript-language-server
pnpm install -g @tailwindcss/language-server
# ... etc
```

#### Using yarn:
```bash
yarn global add typescript typescript-language-server
yarn global add @tailwindcss/language-server
# ... etc
```

## TypeScript LSP Comparison

### VTSLS (Recommended)
- ✅ **Faster performance** and better memory usage
- ✅ **Enhanced IntelliSense** with better completions
- ✅ **Modern architecture** with active development
- ✅ **Better support** for monorepos and large projects
- ✅ **Experimental features** like server-side fuzzy matching

### TS_LS (Traditional)
- ⚠️ **Older architecture** but stable
- ⚠️ **Slower performance** on large projects
- ⚠️ **Limited features** compared to VTSLS

## Notes

- This native setup gives you more control over LSP server versions
- You can install different versions for different projects
- Some language servers may require additional configuration files
- Check the official documentation for each language server for advanced configuration options 