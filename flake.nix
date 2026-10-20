{
  description = "lazygit with a GitHub pull requests tab";

  # The patch targets one lazygit version, so this nixpkgs must ship that version
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

  outputs =
    { self, nixpkgs }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [
        "aarch64-darwin"
        "x86_64-darwin"
        "aarch64-linux"
        "x86_64-linux"
      ];
    in
    {
      overlays.default = final: prev: {
        lazygit = prev.lazygit.overrideAttrs (old: {
          patches = (old.patches or [ ]) ++ [ ./pr-tab.patch ];
        });
      };

      packages = forAllSystems (system: {
        default =
          (import nixpkgs {
            inherit system;
            overlays = [ self.overlays.default ];
          }).lazygit;
      });
    };
}
