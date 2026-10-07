# nvim

Personal Neovim config, [lazy.nvim](https://github.com/folke/lazy.nvim)-based. Normally used as
a submodule of [sekkeizu](https://github.com/scorsi/sekkeizu) (home-manager symlinks
`~/.config/nvim` straight to it), but it's a standalone repo and works on its own too.

## Layout

```
init.lua              entry point: options → keymaps → lazy.nvim → load plugins/
lua/core/
  options.lua          vim.opt settings
  keymaps.lua           global keymaps (splits, window navigation)
lua/lazy-init.lua       bootstraps lazy.nvim itself
lua/plugins/            one file per plugin, returning its lazy.nvim spec
lazy-lock.json          plugin versions, pinned by lazy.nvim, committed
```

Adding a plugin means adding a file under `lua/plugins/` — lazy.nvim loads the whole directory.

## No mason

LSP servers (`lua/plugins/lspconfig.lua`) and formatters/linters (`conform.lua`, `lint.lua`) are
*not* installed by this config — they're expected on `$PATH`, provided by Nix
(`modules/home/neovim.nix` in sekkeizu, feature `neovim-dev`). A server/tool only activates if its
binary is actually present, so the same config works both on a machine with full dev tooling and
on one without it.

## Standalone use

```bash
git clone git@github.com:scorsi/nvim.git ~/.config/nvim
```

Without the Nix-provided tools, LSP/formatting/linting stay inactive; everything else (theme,
pickers, git signs, etc.) works as-is.
