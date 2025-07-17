# LSP and Autocompletion Setup Report

## Overview

This Neovim configuration uses a modern LSP setup with Mason for server management, nvim-lspconfig for server configuration, nvim-cmp for autocompletion, and Treesitter for enhanced syntax highlighting and parsing. The setup is modular and well-organized across multiple files.

## Architecture

### Core Components

1. **Plugin Manager**: Lazy.nvim
2. **LSP Server Management**: Mason + Mason-LSPConfig + Mason-Tool-Installer  
3. **LSP Configuration**: nvim-lspconfig
4. **Autocompletion**: nvim-cmp with multiple sources
5. **Syntax Highlighting**: nvim-treesitter
6. **Code Formatting**: conform.nvim

---

## 1. Plugin Management (`lua/atila/lazy.lua`)

Uses **Lazy.nvim** as the plugin manager with:
- Automatic plugin installation
- Change detection disabled for performance
- Checker enabled but notifications disabled
- Imports from multiple plugin directories for organization

```lua
require("lazy").setup({
  { import = "atila.plugins" },
  { import = "atila.plugins.lsp" },
  { import = "atila.plugins.mini" },
  { import = "atila.plugins.deFreitas" },
})
```

---

## 2. LSP Server Management (`lua/atila/plugins/lsp/mason.lua`)

### Mason Configuration
- **Mason**: Core package manager for LSP servers, formatters, and linters
- **Mason-LSPConfig**: Bridge between Mason and nvim-lspconfig
- **Mason-Tool-Installer**: Automatic installation of additional tools

### Installed LSP Servers:
- `html` - HTML language server
- `tailwindcss` - Tailwind CSS language server  
- `lua_ls` - Lua language server
- `emmet_ls` - Emmet for HTML/CSS abbreviations
- `biome` - JavaScript/TypeScript toolchain

### Additional Tools:
- `prettier` - Code formatter
- `eslint_d` - Fast ESLint daemon
- `rustywind` - Tailwind CSS class sorter

---

## 3. LSP Configuration (`lua/atila/plugins/lsp/lspconfig.lua`)

### Key Features:

#### Auto-attach Keybindings
When LSP attaches to a buffer, the following keybindings are automatically configured:

| Keymap | Function | Description |
|--------|----------|-------------|
| `gR` | `Telescope lsp_references` | Show LSP references |
| `gD` | `vim.lsp.buf.declaration` | Go to declaration |
| `gd` | `Telescope lsp_definitions` | Show LSP definitions |
| `gi` | `Telescope lsp_implementations` | Show LSP implementations |
| `gt` | `Telescope lsp_type_definitions` | Show LSP type definitions |
| `<leader>ca` | `vim.lsp.buf.code_action` | See available code actions |
| `<leader>rn` | `vim.lsp.buf.rename` | Smart rename |
| `<leader>D` | `Telescope diagnostics` | Show buffer diagnostics |
| `<leader>d` | `vim.diagnostic.open_float` | Show line diagnostics |
| `[d` | `vim.diagnostic.goto_prev` | Go to previous diagnostic |
| `]d` | `vim.diagnostic.goto_next` | Go to next diagnostic |
| `K` | `vim.lsp.buf.hover` | Show documentation |
| `<leader>rs` | `:LspRestart` | Restart LSP |

#### Diagnostic Icons
Custom diagnostic symbols in the sign column:
- Error: ` ` 
- Warn: ` `
- Hint: `󰠠 `
- Info: ` `

#### Server-Specific Configurations:

**TypeScript (`ts_ls`)**:
- Inlay hints enabled when supported
- Enhanced capabilities for autocompletion
- Debug output for server capabilities

**Emmet (`emmet_ls`)**:
- Configured for web development filetypes:
  - HTML, TypeScript React, JavaScript React
  - CSS, Sass, SCSS, Less

**Lua (`lua_ls`)**:
- Recognizes `vim` as a global variable
- Enhanced completion with call snippets

**Biome (`biome`)**:
- Custom formatting command: `:BiomeFormat`
- Experimental AI features configured
- Spell check enabled

---

## 4. Autocompletion (`lua/atila/plugins/lsp/cmp.lua`)

### nvim-cmp Configuration

#### Dependencies:
- `hrsh7th/cmp-buffer` - Buffer text completion
- `hrsh7th/cmp-path` - File system path completion
- `L3MON4D3/LuaSnip` - Snippet engine
- `saadparwaiz1/cmp_luasnip` - LuaSnip integration
- `rafamadriz/friendly-snippets` - VSCode-style snippets
- `onsails/lspkind.nvim` - VSCode-like pictograms

#### Completion Sources (Priority Order):
1. `nvim_lsp` - LSP server completions
2. `luasnip` - Snippet completions
3. `buffer` - Text from current buffer
4. `path` - File system paths

#### Key Mappings:

| Keymap | Function | Mode | Description |
|--------|----------|------|-------------|
| `<C-k>` | Select previous item | Insert | Navigate up in completion menu |
| `<C-j>` | Select next item | Insert | Navigate down in completion menu |
| `<C-b>` | Scroll docs up | Insert | Scroll documentation popup |
| `<C-f>` | Scroll docs down | Insert | Scroll documentation popup |
| `<C-Space>` | Complete | Insert | Trigger completion |
| `<C-e>` | Abort | Insert | Close completion menu |
| `<CR>` | Confirm | Insert | Accept selected completion |
| `<Tab>` | Smart navigation | Insert/Select | Navigate or expand snippets |
| `<S-Tab>` | Reverse navigation | Insert/Select | Navigate backwards |
| `<Down>`/`<Up>` | Navigate | Insert | Arrow key navigation |
| `<C-n>`/`<C-p>` | Navigate | Insert | Alternative navigation |

#### Special Features:
- **Smart Tab behavior**: Handles completion navigation and snippet expansion
- **VSCode-like appearance**: Using lspkind for pictograms
- **Django template support**: HTML snippets extended to htmldjango files
- **Documentation preview**: Integrated documentation popup

---

## 5. Syntax Highlighting (`lua/atila/plugins/treesitter.lua`)

### nvim-treesitter Configuration

#### Installed Parsers:
- JavaScript, TypeScript, TSX
- HTML, CSS
- Lua, JSON

#### Features Enabled:
- **Syntax highlighting**: Enhanced beyond basic vim highlighting
- **Smart indentation**: Context-aware indentation
- **Incremental selection**: Expand selection intelligently
- **Auto-tagging**: Automatic HTML/JSX tag completion via nvim-ts-autotag

#### Selection Keymaps:
- `<C-space>` - Initialize/expand selection
- `<bs>` - Shrink selection

---

## 6. Code Formatting (`lua/atila/plugins/formatting.lua`)

### conform.nvim Configuration

#### Formatters by Filetype:

| Filetype | Formatters | Purpose |
|----------|------------|---------|
| JavaScript/TypeScript | `biome`, `prettier`, `rustywind` | Code + Tailwind class sorting |
| React (JSX/TSX) | `biome`, `prettier`, `rustywind` | Code + Tailwind class sorting |
| Svelte | `biome`, `prettier`, `rustywind` | Code + Tailwind class sorting |
| CSS/HTML | `prettier`, `rustywind` | Code + Tailwind class sorting |
| JSON | `biome` | Fast JSON formatting |
| YAML | `prettier` | YAML formatting |
| Lua | `stylua` | Lua code formatting |
| Python | `isort`, `black` | Import sorting + code formatting |
| Markdown | `prettier` (conditional) | Notes folder only |

#### Special Markdown Configuration:
- Formatting enabled only in `~/Documents/notes`
- Disabled in `~/Documents/notes/articles` subfolder
- Conditional formatting based on file path

#### Key Mappings:
- `<leader>mp` - Format file or selected range

#### Settings:
- **Format on save**: Disabled by default
- **LSP fallback**: Enabled when no formatter available
- **Async formatting**: Non-blocking operation
- **Timeout**: 1000ms maximum

---

## 7. Integration and Workflow

### Telescope Integration
The setup heavily integrates with Telescope for:
- LSP references and definitions
- Diagnostics browsing
- Enhanced navigation experience

### Diagnostics Flow
1. **Real-time diagnostics** from LSP servers
2. **Visual indicators** in sign column with custom icons
3. **Navigation shortcuts** for jumping between issues
4. **Detailed views** via Telescope integration

### Completion Workflow
1. **Trigger**: Automatic on typing or `<C-Space>`
2. **Sources**: LSP → Snippets → Buffer → Paths
3. **Navigation**: Intuitive with multiple key options
4. **Confirmation**: `<CR>` or `<Tab>` for smart selection

### Formatting Workflow
1. **Manual formatting**: `<leader>mp` for on-demand formatting
2. **Multiple formatters**: Biome for speed, Prettier for compatibility
3. **Tailwind sorting**: Automatic class organization
4. **Conditional rules**: Context-aware formatting decisions

---

## 8. Performance Optimizations

### Lazy Loading
- LSP plugins load on `BufReadPre`, `BufNewFile`
- Completion loads on `InsertEnter`
- Treesitter loads on file read events

### Efficient Tools
- **Biome**: Fast alternative to ESLint/Prettier
- **eslint_d**: Daemon mode for faster linting
- **Async operations**: Non-blocking formatting and completion

### Minimal Configuration
- Change detection disabled for Lazy.nvim
- Silent notifications to reduce noise
- Optimized completion settings

---

## 9. Development Experience Features

### Inlay Hints
- Enabled for TypeScript when server supports it
- Provides inline type information

### Code Actions
- Available via `<leader>ca`
- Context-aware suggestions for fixes and refactoring

### Smart Rename
- Cross-file renaming via `<leader>rn`
- LSP-powered for accuracy

### Auto-tagging
- Automatic HTML/JSX tag completion and renaming
- Treesitter-powered for accuracy

---

## Configuration Files Structure

```
lua/atila/
├── plugins/lsp/
│   ├── cmp.lua          # Autocompletion configuration
│   ├── lspconfig.lua    # LSP server configuration  
│   └── mason.lua        # Package management
├── plugins/
│   ├── formatting.lua   # Code formatting
│   ├── treesitter.lua   # Syntax highlighting
│   └── ...
├── core/
│   ├── options.lua      # Core Neovim settings
│   ├── keymaps.lua      # Global keymaps
│   └── ...
└── lazy.lua             # Plugin manager setup
```

This setup provides a complete, modern development environment with robust LSP support, intelligent autocompletion, and efficient code formatting tailored for web development with support for multiple languages and frameworks. 