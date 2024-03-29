# https://nixos.org/manual/nixos/stable/index.html#module-security-acme
{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.elevate.security.tls-certificates;
in
{
  options.elevate.security.tls-certificates = {
    enable = mkEnableOption "Automatically get TLS certificates";
  };

  config = mkIf cfg.enable {
    security.acme.acceptTerms = true;
    security.acme.defaults = {
      webroot = "/var/lib/acme/acme-challenge";
      email = "mathias@magnusson.space";
    };

    users.users.nginx.extraGroups = [ "acme" ];
  };
}
