# dotfiles

Minimal personal configuration files for Ghostty and Vim.

## Structure

```text
.
├── ghostty/
│   └── config     # Ghostty terminal emulator config
├── vimrc          # Vim editor config (Gruvbox Material)
├── install.sh     # Symlink setup script
└── README.md
```

## Setup

Run the installation script:

```bash
./install.sh
```

This will:
1. Symlink `vimrc` to `~/.vimrc`.
2. Symlink `ghostty/config` to `~/.config/ghostty/config`.
3. Clone the `gruvbox-material` Vim theme into `~/.vim/pack/themes/start/gruvbox-material` if it is not already present.
