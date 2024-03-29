{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.elevate.compilers.go;

  GOPATH = "$HOME/.local/share/go";
in
{
  options.elevate.compilers.go = {
    enable = mkEnableOption "configured go environment";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ go_1_22 /* gopls (doesn't currently work with go 1.22.0) */ ];

    environment.variables = {
      inherit GOPATH;
      PATH = [ "${GOPATH}/bin" ];
    };
  };
}
