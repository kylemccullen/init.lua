# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Setup

This is a Neovim configuration using **vim-plug** as the plugin manager.

**Initial setup:**
1. Clone into `~/.config/nvim/`
2. Install vim-plug: https://github.com/junegunn/vim-plug#neovim
3. Launch nvim and run `:PlugInstall`
4. Add to `~/.bashrc`:
   ```bash
   export REPOS_PATH=/your/repos/path:/your/other/repos/path
   source ~/.config/nvim/scripts/dev.sh
   source ~/.config/nvim/scripts/wt.sh
   ```
   `REPOS_PATH` is colon-separated. `dev <project>` searches left-to-right and opens the first matching folder.

**Adding/updating plugins:** Edit the `vim.call('plug#begin')` block in `init.lua`, then run `:PlugInstall` or `:PlugUpdate` in nvim.

## Claude Code integration (tmux `[!]` indicator)

When Claude needs input, the tmux window name gets `[!]` appended. Two things to set up:

**1. Install the hook script:**
```bash
mkdir -p ~/.claude/hooks
cp ~/.config/nvim/scripts/tmux-notify.sh ~/.claude/hooks/tmux-notify.sh
chmod +x ~/.claude/hooks/tmux-notify.sh
```

**2. Add hooks to `~/.claude/settings.json`** (merge with any existing content):
```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash ~/.claude/hooks/tmux-notify.sh stop",
            "async": true
          }
        ]
      }
    ],
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "bash ~/.claude/hooks/tmux-notify.sh clear",
            "async": true
          }
        ]
      }
    ],
    "PreToolUse": [
      {
        "matcher": "AskUserQuestion",
        "hooks": [
          {
            "type": "command",
            "command": "bash ~/.claude/hooks/tmux-notify.sh stop",
            "async": true
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "matcher": "AskUserQuestion",
        "hooks": [
          {
            "type": "command",
            "command": "bash ~/.claude/hooks/tmux-notify.sh clear",
            "async": true
          }
        ]
      }
    ]
  }
}
```

## Architecture

- **`init.lua`** — Entry point. Sets vim options, global keymaps, and declares all plugins via vim-plug.
- **`after/plugin/`** — Per-plugin configuration files, loaded automatically after plugins initialize. Each file configures one plugin and its keymaps.
- **`scripts/dev.sh`** — Shell helper: `dev <project>` opens a project in a tmux session with nvim. Reads `$REPOS_PATH`.
- **`scripts/wt.sh`** — Shell helper: `wt <branch>` creates/opens a git worktree in a new tmux window with nvim. Also exposed as `:Wt <branch>` inside nvim.

## Plugins and Keymaps

| Plugin | Config file | Key mappings |
|---|---|---|
| vscode.nvim | `colors.lua` | — |
| lualine | `lualine.lua` | — |
| nvim-tree | `nvimtree.lua` | `<leader>f` toggle tree, `<leader>e` reveal file |
| vim-fugitive | *(no config file)* | native fugitive commands |
| telescope | `telescope.lua` | `<leader>fg`/`<C-g>` git files, `<leader>ff` find files, `<leader>sg` live grep, `<leader>fb` buffers, `<leader>gr` branches, `<leader>gb` local branches, `<leader>gs` stash, `<leader>wd` diagnostics |
| nvim-treesitter | `treesitter.lua` | — |
| nerdcommenter | `nerdcommenter.lua` | default bindings |
| vim-maximizer | `vim-maximizer.lua` | `<F3>` toggle maximize |
| harpoon2 | `harpoon.lua` | `<leader>th/tj/tk/tl` toggle terminals 1–4 |

**Leader key:** `<Space>`

**Global keymaps (init.lua):**
- `<C-h/j/k/l>` — window navigation
- `<A-j/k>` — move line/selection up/down
- `<leader>p` — paste without yanking (visual mode)
- `<C-Space>` — exit terminal mode

## Treesitter Languages

Pre-configured: `c_sharp`, `json`, `typescript`, `html`, `tsx`, `lua`, `angular`
