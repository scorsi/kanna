# What the Lua config looks for on PATH (LSP servers, formatters, linters): each one is enabled only
# when its binary is found, so none of this is required. Shared by the dev shell and by the
# home-manager module's `withDevTools`.
pkgs: with pkgs; [
  # LSP
  lua-language-server
  nil
  yaml-language-server
  taplo
  bash-language-server
  nimlangserver
  vscode-langservers-extracted # jsonls
  # Formatters and linters
  stylua
  nixfmt
  shfmt
  yamlfmt
  yamllint
  prettier
  # nimlangserver drives nimsuggest from the compiler, nimpretty ships with it.
  nim
  nimble
]
