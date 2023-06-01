{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.elevate.services.sshd;
in
{
  options.elevate.services.sshd = {
    enable = mkEnableOption "configured ssh daemon";
  };

  config = mkIf cfg.enable {
    elevate.user.sshKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPC69ml72mqbn7L3QkpsCJuWdrKFYFNd0MaS5xERbuSF mathias@pingu-arch"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAO88bhtrgWXg4zY8jIAVqzyHKa+PNJRpLbyk86y4Glc mathias@taplop"
      "ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBEdUe7mxGdV/Q37RKndPzDHisFb7q/xm+L97jcGluSDOA8MGt/+wTxpyGxfyEqaMvwV2bakaMVHTB3711dDu5kE= black yubikey"
    ];
    services.openssh = {
      enable = true;
      ports = [ 69 ];
      settings.PermitRootLogin = "no";
      settings.PasswordAuthentication = false;
    };
  };
}
