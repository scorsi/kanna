# Installs kanna and owns ~/.config/nvim. Two modes:
#   devPath = null   ~/.config/nvim is the config copied into the store: frozen, reproducible;
#                    init.lua keeps the lockfile in stdpath("state") and restores plugins from it.
#   devPath = "<p>"  ~/.config/nvim links to a writable clone at <p>: Lua edits apply at the next
#                    start, without a rebuild, and lazy.nvim writes lazy-lock.json into the clone.
{ configDir }:
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.kanna;
in
{
  options.programs.kanna = {
    devPath = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      example = "/home/me/repositories/kanna";
      description = "Absolute path of a kanna clone to link ~/.config/nvim to; null uses the config from the store.";
    };
    withDevTools = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Also install the LSP servers, formatters and linters the config can use.";
    };
  };

  config = {
    home.packages = [
      (pkgs.callPackage ./package.nix { })
    ]
    ++ lib.optionals cfg.withDevTools (import ./dev-tools.nix pkgs);

    home.sessionVariables.EDITOR = "nvim";

    xdg.configFile."nvim".source =
      if cfg.devPath != null then config.lib.file.mkOutOfStoreSymlink cfg.devPath else configDir;
  };
}
