{
  description = "Outils (LSP, formateurs, linters) attendus par cette config Neovim.";

  # Autonome : pas une dépendance Nix de sekkeizu, juste un `nix develop` pour
  # utiliser cette config sur une machine qui n'a pas déjà ces outils installés.
  # La liste doit rester alignée à la main avec modules/home/neovim.nix (sekkeizu).

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      systems = [
        "aarch64-darwin"
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              # LSP
              lua-language-server
              nil
              yaml-language-server
              taplo
              bash-language-server
              vscode-langservers-extracted # jsonls
              # Formateurs et linters
              stylua
              nixfmt
              shfmt
              yamlfmt
              yamllint
              prettier
              # blink.cmp compile son matcher flou en Rust au premier démarrage.
              cargo
              rustc
            ];
          };
        }
      );
    };
}
