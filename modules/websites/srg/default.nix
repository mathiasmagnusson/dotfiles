{ config, pkgs, lib, helpers, ... }:
with lib;
let
  cfg = config.elevate.websites.srg;

  domainName = "xn--srskildakommandorrelsegruppen-0pc88c.se";
in
{
  options.elevate.websites.srg = {
    enable = mkEnableOption "Särskilda kommandorörelsegruppen";
  };

  config = mkIf cfg.enable {
    services.nginx.virtualHosts."särskildakommandorörelsegruppen.se" = {
      forceSSL = true;
      useACMEHost = domainName;
      serverName = domainName;

      root = pkgs.writeTextFile {
        name = "srg static files";
        destination = "/index.html";
        text = builtins.readFile ./index.html;
      };
      locations."/" = {
        index = "index.html";
      };

    };

    security.acme.certs.${domainName} = {
      extraDomainNames = [ "*.${domainName}" ];
    };
  };
}
