{
  description = "kanna (鉋, the plane) — Neovim and its Lua config: package, home-manager module, dev shell";

  # Same branch as sekkeizu, which makes this input follow its own nixpkgs anyway.
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";

  outputs =
    { nixpkgs, ... }:
    let
      inherit (nixpkgs) lib;
      forAllSystems = lib.genAttrs [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];
      pkgsFor = system: nixpkgs.legacyPackages.${system};

      # Only what Neovim reads: editing the README or the Nix files doesn't change the config's store path.
      configDir = lib.fileset.toSource {
        root = ./.;
        fileset = lib.fileset.unions [
          ./init.lua
          ./lua
          ./lazy-lock.json
        ];
      };
    in
    {
      packages = forAllSystems (system: {
        default = (pkgsFor system).callPackage ./nix/package.nix { config = configDir; };
      });

      homeModules.default = import ./nix/home-module.nix { inherit configDir; };

      devShells = forAllSystems (
        system:
        let
          pkgs = pkgsFor system;
        in
        {
          default = pkgs.mkShellNoCC { packages = import ./nix/dev-tools.nix pkgs; };
        }
      );

      formatter = forAllSystems (system: (pkgsFor system).nixfmt-tree);
    };
}
