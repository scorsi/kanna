# CLAUDE.md

Guidance for Claude Code when working in this repo. See [README.md](README.md) for what it is.

## Conventions

- **Comments: English, why not what.** Only comment non-obvious reasoning (an upstream quirk, a
  version constraint, why something is disabled) — never restate what the code already says.
- **One plugin, one file** under `lua/plugins/`, named after the plugin and returning its
  lazy.nvim spec table directly (`return { "author/name", ... }`). Don't group unrelated plugins
  in one file or split one plugin's config across several.
- Formatting follows `.stylua.toml` (4-space indent) — run `stylua` (from `nix develop`,
  not vendored here) before considering a change done, if available.
- Don't add `mason.nvim` or hardcode an LSP/formatter/linter install step: these tools are assumed
  to be on `$PATH`, supplied by the Nix config that consumes this repo. A server/tool should only
  be enabled when its binary is actually found (see the `vim.fn.executable` check in
  `lua/plugins/lspconfig.lua`).
- `lazy-lock.json` is committed on purpose — it pins plugin versions. Don't hand-edit it; let
  lazy.nvim regenerate it (`:Lazy update`) when actually bumping versions.

## This repo and sekkeizu

sekkeizu consumes this repo as the flake input `kanna = github:scorsi/kanna` (pinned in its
`flake.lock`), not as a submodule. On jiban, `~/.config/nvim` links to this clone
(`~/repositories/kanna`, `programs.kanna.devPath`): Lua edits are live, Nix edits need a push and
`nix flake update kanna` in sekkeizu (README, "Changing things").

`init.lua` must keep working read-only from the store: never write next to the config, and keep
anything lazy.nvim persists (lockfile copy, state) under `stdpath("state")`/`stdpath("data")`.

## Testing changes

Lua: open Neovim and confirm it starts without errors (`:checkhealth`, `:Lazy`). Store mode, from
scratch and without touching the real plugin dirs: point `XDG_{CONFIG,DATA,STATE,CACHE}_HOME` at an
empty temporary directory and run `nix run . -- --headless +qa`, then delete that directory. Nix:
`nix flake check` and `nix fmt`.
