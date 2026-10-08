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
  vscode-langservers-extracted # jsonls, cssls
  # nixpkgs' astro-ls requires `typescript` at load time without shipping it, so it dies before
  # reading the project. This TypeScript only lets it start: a project's own (node_modules) is still
  # the one it analyses with. Wrapped rather than overridden, so the server isn't rebuilt.
  (symlinkJoin {
    name = "astro-language-server-with-typescript";
    paths = [ astro-language-server ];
    nativeBuildInputs = [ makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/astro-ls --prefix NODE_PATH : ${typescript}/lib/node_modules
    '';
  })
  svelte-language-server
  typescript-language-server
  # ts_ls's fallback when a project has no typescript of its own (astro and svelte use the project's).
  typescript
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
