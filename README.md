# kanna (鉋)

The plane: my Neovim and its Lua config ([lazy.nvim](https://github.com/folke/lazy.nvim)), as a
Nix flake. Consumed by [sekkeizu](https://github.com/scorsi/sekkeizu) as a pinned input, and usable
on its own:

```bash
nix run github:scorsi/kanna            # Neovim on this config, nothing to install
nix develop github:scorsi/kanna        # the LSP servers, formatters and linters it can use
```

## Flake outputs

| Output                | What it is                                                                 |
| --------------------- | -------------------------------------------------------------------------- |
| `packages.default`    | Neovim wrapped to start on the config from the store (`-u`), plus the tools plugins build with (git, tree-sitter, cargo, make; gcc on Linux) |
| `homeModules.default` | installs Neovim and those tools, manages `~/.config/nvim`, sets `EDITOR`   |
| `devShells.default`   | LSP servers, formatters, linters (`nix/dev-tools.nix`)                     |

Home-manager options:

- `programs.kanna.devPath` (null or absolute path): null → `~/.config/nvim` is the config in the
  store (frozen, reproducible); a path → `~/.config/nvim` links to that clone (live editing).
- `programs.kanna.withDevTools` (bool): also install the `devShells.default` tools.

## Layout

```
init.lua              entry point: store/dev mode, options → keymaps → lazy.nvim → plugins/
lua/core/             options.lua, keymaps.lua
lua/lazy-init.lua     bootstraps lazy.nvim itself (at its locked commit)
lua/plugins/          one file per plugin, returning its lazy.nvim spec
lazy-lock.json        plugin versions, committed
nix/                  package, home-manager module, dev tools list
```

## lazy-lock.json and the two modes

`init.lua` looks at the directory it runs from:

- **Dev mode** (writable clone, `devPath` set): lazy.nvim reads and writes `lazy-lock.json` in the
  clone. Updating plugins is a deliberate act, here only: `:Lazy update`, try it, commit the lock.
- **Store mode** (read-only, `nix run` or `devPath = null`): the lock is copied to
  `stdpath("state")/lazy-lock.json` at every start; when it differs from the previous start, the
  plugins are brought back to it once (`Lazy restore`). Nothing is ever written next to the config.

The update checker is off in both: plugins only move when the lock does.

## Changing things

- **Lua** (on a machine with `devPath`, e.g. jiban): edit the clone, restart Neovim. No rebuild.
- **Nix** (`flake.nix`, `nix/`): test from sekkeizu against the local clone, without pushing:
  ```bash
  nix run .#switch -- --override-input scorsi-kanna path:$HOME/repositories/kanna
  ```
  Then push kanna, and in sekkeizu: `nix flake update scorsi-kanna`, `nix run .#switch`, commit
  `flake.lock`.

## No mason

LSP servers (`lua/plugins/lspconfig.lua`) and formatters/linters (`conform.lua`, `lint.lua`) are
not installed by the config: they're expected on `$PATH` (`devShells.default`, or `withDevTools`).
Each one only activates when its binary is found, so the same config works with or without them.
