# 🛠️ Dotfiles

Welcome to your modern, modular, and safe dotfiles repository. This repository manages system configuration files cleanly from a single location.

## 🚀 Repository Structure

The root directory contains only the installation tooling and documentation to keep things pristine:

```
.
├── dotfiles/          # Directory containing active config files (no dot prefixes)
│   ├── bash_profile   # Shell login profile
│   ├── config/        # Custom application configurations
│   │   └── ghostty/config # Ghostty terminal configurations
│   ├── tmux.conf      # tmux terminal multiplexer config
│   ├── vim/           # Vim configuration directory
│   │   └── colors/solarized8.vim
│   └── vimrc          # Vim text editor preferences
├── install.sh         # Safe installation and deployment script
├── .gitignore         # File patterns to exclude from Git
└── README.md          # This documentation
```

---

## 💻 Included Configurations

| `dotfiles/bash_profile` | `~/.bash_profile` | Configures Homebrew, Google Cloud SDK, customized paths, and loads `.bashrc`. |
| `dotfiles/config/ghostty/config` | `~/.config/ghostty/config` | High-fidelity Ghostty terminal styling and preferences. |
| `dotfiles/tmux.conf` | `~/.tmux.conf` | Basic multiplexer behaviors like mouse mode. |
| `dotfiles/vim/` | `~/.vim/` | Vim configuration directory containing the Solarized theme. |
| `dotfiles/vimrc` | `~/.vimrc` | Standard Vim preferences (dark Solarized style, 2-space tabs, numbering, backup disabling, and backspace fixes). |

---

## ⚡ Deployment & Installation

We use a safe install script that establishes symlinks from this repository back to your home directory (`~`).

### How to Run:

1. Open your terminal in this repository.
2. Run the installation script:
   ```bash
   ./install.sh
   ```

### 🛡️ Safety & Backups:
If the installer encounters existing files or links that don't point here, **it will not overwrite them**. Instead, it automatically creates a secure backup folder:
`~/.dotfiles_backup/<timestamp>/`
Your original configuration is preserved there so nothing is ever lost.
