# CLAUDE.md

Guidance for Claude Code when working in this repo. See [README.md](README.md) for what it is.

## Conventions

- **Comments: English, why not what.** Only comment non-obvious reasoning (an upstream quirk, a
  version constraint, why something is disabled) — never restate what the code already says.
- **One plugin, one file** under `lua/plugins/`, named after the plugin and returning its
  lazy.nvim spec table directly (`return { "author/name", ... }`). Don't group unrelated plugins
  in one file or split one plugin's config across several.
- Formatting follows `.stylua.toml` (4-space indent) — run `stylua` (provided by Nix via sekkeizu,
  not vendored here) before considering a change done, if available.
- Don't add `mason.nvim` or hardcode an LSP/formatter/linter install step: these tools are assumed
  to be on `$PATH`, supplied by the Nix config that consumes this repo. A server/tool should only
  be enabled when its binary is actually found (see the `vim.fn.executable` check in
  `lua/plugins/lspconfig.lua`).
- `lazy-lock.json` is committed on purpose — it pins plugin versions. Don't hand-edit it; let
  lazy.nvim regenerate it (`:Lazy update`) when actually bumping versions.

## This repo vs. the sekkeizu submodule

This clone (`~/repositories/nvim`) and the `files/nvim` submodule inside `sekkeizu` are two
separate checkouts of the same remote (`git@github.com:scorsi/nvim.git`) — editing one does not
update the other. A change made here needs its own commit/push, and `sekkeizu`'s submodule
pointer (`git -C files/nvim ...`) only moves when that's done deliberately on that checkout.

## Testing changes

There's no build step. After an edit, the practical check is opening Neovim and confirming it
starts without errors (`:checkhealth`, `:Lazy` for plugin status) — ask the user to do this if no
running Neovim instance is available to verify against.
