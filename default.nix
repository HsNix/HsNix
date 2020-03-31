{ sources ? import ./nix/sources.nix
, nixpkgs ? sources.nixpkgs
}:
let
  pkgs = import sources.nixpkgs {
    config = import "${sources.haskell-nix}/config.nix" // { allowUnfree = true; };
    overlays = (import "${sources.haskell-nix}/overlays") ++
      [(self: super: {
        haskell-nix = super.haskell-nix //
          { hackageSrc = sources.hackage-nix;
            stackageSrc = sources.stackage-nix;
          };
        niv = import sources.niv {};
      })];
    };
  project = pkgs.haskell-nix.stackProject {
    src = ./.;
    modules = [];
    pkg-def-extras = [];
  };
in project.hsnix.components.all.overrideAttrs (old: { passthru = old.passthru // { inherit project pkgs; }; })
