args@
{ sources ? import ./nix/sources.nix
, nixpkgs ? sources.nixpkgs
}:
let
  default = import ./. args;
  inherit (default) project pkgs;
in project.shellFor { packages = (ps: [ ps.hsnix ]); buildInputs = [ pkgs.cabal-install project.ghcid.components.exes.ghcid ]; }
