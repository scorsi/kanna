# Neovim plus what the plugins build on first install (lazy.nvim clones with git, nvim-treesitter
# compiles parsers with the tree-sitter CLI and a C compiler, blink.cmp builds its matcher with
# cargo, LuaSnip runs make). Appended to PATH, so the user's own versions still win.
#
# With `config`, the binary starts on that Lua config (`-u`): what `nix run` uses. Without it, it
# reads ~/.config/nvim as usual: what the home-manager module installs, since it manages that link.
{
  lib,
  stdenv,
  symlinkJoin,
  makeWrapper,
  neovim,
  git,
  tree-sitter,
  cargo,
  rustc,
  gnumake,
  gcc,
  config ? null,
}:
let
  # macOS gets its compiler from the Command Line Tools; nixpkgs' wrapped clang would add its own
  # SDK flags to every parser build.
  buildTools = [
    git
    tree-sitter
    cargo
    rustc
    gnumake
  ]
  ++ lib.optional stdenv.hostPlatform.isLinux gcc;
in
symlinkJoin {
  name = "kanna-${neovim.version}";
  paths = [ neovim ];
  nativeBuildInputs = [ makeWrapper ];
  postBuild = ''
    wrapProgram $out/bin/nvim --suffix PATH : ${lib.makeBinPath buildTools} ${
      lib.optionalString (config != null) "--add-flags '-u ${config}/init.lua'"
    }
  '';
  meta = {
    description = "Neovim with the kanna config";
    mainProgram = "nvim";
  };
}
