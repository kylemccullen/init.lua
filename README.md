# Neovim Config

## Getting Started

1. Clone the repository `git clone https://github.com/kylemccullen/init.lua.git` into `~/.config/nvim/`
2. Install vim-plug: https://github.com/junegunn/vim-plug#neovim
3. Run neovim `nvim`
4. Run `:PlugInstall`
5. Add to `~/.bashrc`:

```bash
export REPOS_PATH=/your/repos/path:/your/other/repos/path
source ~/.config/nvim/scripts/dev.sh
source ~/.config/nvim/scripts/wt.sh
```

See [CLAUDE.md](CLAUDE.md) for Claude Code integration (tmux `[!]` indicator setup).
