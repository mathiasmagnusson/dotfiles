{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.elevate.apps.syncthing;

  user = config.elevate.user.name;
  homeDir = "/home/${user}";
in
{
  options.elevate.apps.syncthing = {
    enable = mkEnableOption "configured syncthing";
    homeDirs = mkEnableOption "sync home directories";
  };

  config = mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      inherit user;
      dataDir = homeDir;
      configDir = "${homeDir}/.config/syncthing";
      openDefaultPorts = true;

      settings.devices = {
        chonk.id = "N6CY7HR-KBEBJY5-ZMS3U2B-TMJY4H7-MVW47VN-UK3YMWT-GLWR7PR-NJT5PQI";
        taplop.id = "JOOVGP7-BNR6OTA-H5W53FT-EUY6O3T-KZSP5MT-EFZR7QL-WOZA6RT-ANKZOQ3";
        pixel.id = "UP3GOP5-FVUATIH-ZVKLRU7-WBK6XTB-LFRT6J3-KGZGJTQ-JD27LFA-XGX6QAA";
        space.id = "7ZNQWDC-TTSO2IY-POBKWWW-DZJSRD6-TKYF2LC-CWDPGEG-WPZC6JS-BKD2AQR";
        space.addresses = [ "tcp://syncthing.magnusson.space" ];
      };

      settings.folders = lib.optionalAttrs cfg.homeDirs (pkgs.lib.genAttrs [
        "Desktop"
        "Documents"
        "Memes"
        "Music"
        "Videos"
        "Pictures"
      ] (name: {
        path = "${homeDir}/${name}";
        devices = ["chonk" "taplop"];
      })) // {
        Passage = {
          devices = ["chonk" "taplop" "space"];
          path = "${homeDir}/.local/share/passage/store";
        };
        Obsidian = {
          devices = ["chonk" "taplop" "space"];
          path = "${homeDir}/.local/share/obsidian-vault";
        };
      };
    };
  };
}
