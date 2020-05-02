{ pkgs ? import <nixpkgs> {} }:

let
  ormoluSrc = builtins.fetchTarball "https://github.com/tweag/ormolu/tarball/0.0.5.0";
  ormolu = (import ormoluSrc {}).ormolu;
  ghcideSrc = builtins.fetchTarball "https://github.com/cachix/ghcide-nix/tarball/master";
  ghcide = (import ghcideSrc {}).ghcide-ghc865;
in

pkgs.mkShell {
  buildInputs = with pkgs; [
    cabal-install
    haskell.compiler.ghc865
    haskellPackages.hpack
    ghcid
    zlib.dev

    ghcide
    ormolu
  ];
}
