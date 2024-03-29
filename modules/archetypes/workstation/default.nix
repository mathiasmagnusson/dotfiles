{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.elevate.archetypes.workstation;
in
{
  options.elevate.archetypes.workstation = {
    enable = mkEnableOption "indicates that the machine is used to do stuff";
  };

  config = mkIf cfg.enable {
    elevate.sets.base.enable = true;
    elevate.sets.ctf.enable = true;
    elevate.sets.desktop.enable = true;
    elevate.sets.devops.enable = true;
    elevate.sets.gaming.enable = true;
    elevate.sets.programming.enable = true;

    environment.systemPackages = with pkgs; [
      ffmpeg
      man-pages
    ];

    elevate.apps.syncthing.enable = true;
    elevate.apps.syncthing.homeDirs = true;
    elevate.cli-apps.ssh.enable = true;
    elevate.cli-apps.typst.enable = true;
    elevate.security.yubikey.enable = true;
    elevate.system.networking.enable = true;
    elevate.system.printing.enable = true;
    elevate.system.sound.enable = true;
    elevate.virtualisation.oci-containers.enable = true;
    elevate.virtualisation.virt-manager.enable = true;

    services.mullvad-vpn.enable = true;
    hardware.flipperzero.enable = true;

    elevate.user.groups = [ "dialout" ];
  };
}
