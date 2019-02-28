{ nixpkgs ? import ./nix/nixpkgs.nix
, compiler ? "default"
}:
let
  pkgs = import nixpkgs {};
  # Grab our course derivation
  course = import ./. { inherit nixpkgs compiler; };

  # Override the basic derivation so we can have a more fully feature
  # environment for hacking on the course material
  courseDevEnv = with pkgs; (haskell.lib.addBuildTools course
    ([
      sqlite         # Include the SQLite Database application
      cabal-install  # for cabal-<newcommand>
    ] ++ (with haskellPackages;
    [
      # ghcid  # auto reloading tool
      hlint  # code linter
    ]))
  # We don't want nix to build the thing, we want the environment so we can
  # build the thing.
  ).env;

in
  # Fly, my pretties!
  courseDevEnv
