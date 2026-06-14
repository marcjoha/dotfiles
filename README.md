# dotfiles

A clean, modular, and safe dotfiles repository. It manages system configurations from a single location using dynamic symlinking and post-install hooks.

---

## Architecture

The repository isolates clean configurations from installation tooling and hooks:

```text
.
├── dotfiles/          # System-relative dotfiles (unprefixed)
│   ├── antigravitycli/# Custom scripts for Antigravity statusbar/title
│   ├── bash_profile   # Shell login profile
│   ├── config/        # Application configurations (e.g. ghostty)
│   ├── tmux.conf      # tmux terminal multiplexer config
│   └── vimrc          # Vim text editor preferences (with .vim directory)
├── hooks/             # Post-install hook scripts (e.g. antigravitycli.sh)
├── install.sh         # Dynamic, backup-safe symlinking script
└── README.md          # Documentation
```

---

## Design Principles

* **Zero-Dot Repository Layout**: Files inside the `dotfiles/` directory do not have leading dots. They are mapped dynamically to hidden files (e.g., `dotfiles/vimrc` becomes `~/.vimrc`) on installation.
* **Extensible Hooks**: Application-specific configurations (like merging preferences or generating files) are decoupled into the `hooks/` folder to keep the core installer completely generic.
* **Backup First**: Any pre-existing file or directory in `~` is automatically archived to `~/.dotfiles_backup/<timestamp>/` before creating links.

---

## Installation

To deploy the configurations:

```bash
./install.sh
```

This will dynamically link all active profiles, initialize directories, and sequentially execute all scripts found in the `hooks/` folder.
