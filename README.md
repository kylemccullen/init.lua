# Neovim Config

## Getting Started

1. Clone the repository `git clone https://github.com/kylemccullen/init.lua.git` into your %APPDATA%/Local/nvim folder
2. Instal Vim-Plug `https://github.com/junegunn/vim-plug?tab=readme-ov-file#neovim`
3. Run neovim `nvim`
4. Plug Install `:PlugInstall`
5. Add this to your `~/.bashrc`

```bash
export REPOS_ROOT=/your/repos/path
source ~/.config/nvim/scripts/dev.sh
```

6. Include the following in your `~/.claude/settings.json` file

```json
{
  "hooks": {
    "PreToolUse": [
      {
        "matcher": "",
        "hooks": [
          {
            "type": "command",
            "command": "tmux rename-window \"$(tmux display-message -p '#W' | sed 's/!$//')!\""
          }
        ]
      }
    ],
    "Stop": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "tmux rename-window \"$(tmux display-message -p '#W' | sed 's/!$//')\""
          }
        ]
      }
    ]
  }
}
```
