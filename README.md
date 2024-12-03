# Dotfiles

This repository contains my personal configuration files (dotfiles) for various development tools and applications. These configurations are designed to create a consistent and efficient development environment.

## Overview

The dotfiles are organized into several main categories:

### Terminal Emulators
- **Alacritty**: A GPU-accelerated terminal emulator
  - `alacritty.toml`: Main configuration file
  - `catppuccin-mocha.toml`: Catppuccin color scheme configuration

- **Kitty**: Another feature-rich terminal emulator
  - `kitty.conf`: Primary configuration
  - `current-theme.conf`: Active color theme settings

### Neovim Configuration

The Neovim setup is organized using a modular structure with Lazy.nvim as the plugin manager. The configuration is split into logical components:

#### Core Configuration
- `init.lua`: Entry point for Neovim configuration
- `lua/atila/core/`: Core settings and configurations
  - `options.lua`: General Neovim options
  - `keymaps.lua`: Key bindings and mappings

#### Plugin Management
- `lazy.lua`: Plugin manager configuration
- `lazy-lock.json`: Plugin version lock file

#### Plugin Configurations
Notable plugins include:
- LSP integration with Mason for package management
- Treesitter for improved syntax highlighting
- Telescope for fuzzy finding
- Various UI enhancements (bufferline, status line, etc.)
- Git integration through Gitsigns and Lazygit
- Database tools with vim-dadbod
- Markdown support and preview functionality
- Mini plugins suite for enhanced editing capabilities
- Obsidian integration for note-taking

### Additional Tools
- `starship.toml`: Configuration for the Starship prompt
- `tmux/`: TMux terminal multiplexer configuration

## Installation

1. Clone this repository:
```bash
git clone https://github.com/yourusername/dotfiles.git ~/.dotfiles
```

2. Create symbolic links:
```bash
# For Neovim
ln -s ~/.dotfiles/nvim ~/.config/nvim

# For Alacritty
ln -s ~/.dotfiles/alacritty ~/.config/alacritty

# For Kitty
ln -s ~/.dotfiles/kitty ~/.config/kitty

# For Starship
ln -s ~/.dotfiles/starship.toml ~/.config/starship.toml

# For Tmux
ln -s ~/.dotfiles/tmux ~/.config/tmux
```

## Dependencies

To fully utilize these configurations, you'll need:
- Neovim (>= 0.9.0)
- Node.js (for LSP servers)
- Rust (for some tools like Alacritty)
- Git
- Ripgrep (for Telescope)
- A Nerd Font (for icons)

## Key Features

### Neovim Setup
- Modern IDE-like features with LSP integration
- Efficient fuzzy finding and file navigation
- Git integration with inline blame and diff viewing
- Enhanced syntax highlighting and code folding
- Database integration for SQL development
- Markdown preview and note-taking capabilities
- Minimal and focused UI with Zen mode

### Terminal Features
- GPU acceleration with Alacritty
- Rich color schemes with Catppuccin theme
- Configurable layouts and window management
- Unicode and ligature support

## Backup
A backup of the previous Neovim configuration is maintained in the `nvim.bak` directory for reference and recovery purposes.

## Customization

Feel free to modify any of these configurations to suit your needs. The modular structure of the Neovim configuration makes it easy to add or remove plugins by editing the respective files in the `lua/atila/plugins` directory.

## Contributing

If you find any issues or have suggestions for improvements, please feel free to open an issue or submit a pull request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.
