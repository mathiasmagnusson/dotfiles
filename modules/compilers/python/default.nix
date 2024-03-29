{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.elevate.compilers.python;

  # is it possible to not add these packageses scripts to PATH?
  python = (pkgs.python3.withPackages (p: with p; [
    virtualenv
    pycryptodome
    numpy
    matplotlib
    gmpy2
    requests
  ]));
in
{
  options.elevate.compilers.python = {
    enable = mkEnableOption "configured python interpreter with some packages";
  };

  config = mkIf cfg.enable {
    environment.variables = {
      PYTHONSTARTUP = pkgs.writeText "pythonstartup.py" (builtins.readFile ./pythonstartup.py);
    };

    environment.systemPackages = [ python ];
  };
}
