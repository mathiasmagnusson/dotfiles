{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.elevate.sets.ctf;

  shellInit = pkgs.writeText "fish-init" config.programs.fish.shellInit;

  burpsuite = pkgs.symlinkJoin {
    name = "burpsuite";
    paths = [
      (pkgs.writeTextFile {
        name = "burpsuite.desktop";
        destination = "/share/applications/burpsuite.desktop";
        text = ''
          [Desktop Entry]
          Categories=Development;Security;System
          Comment=An integrated platform for performing security testing of web applications
          Exec=env _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true' burpsuite
          Icon=burpsuite
          Name=Burp Suite Community Edition
          Type=Application
          Version=1.4
        '';
      })
      pkgs.burpsuite
    ];
  };
in
{
  options.elevate.sets.ctf = {
    enable = mkEnableOption "engage hacker mode";
  };

  config = mkIf cfg.enable {
    environment.shellAliases.hack = "set -g hacking 1; set -gx PATH ${pkgs.buildEnv {
      name = "hack";
      paths = with pkgs; [
        binwalk
        exiftool
        one_gadget

        nmap
        gobuster
        aircrack-ng

        hashcat

        (python3.withPackages (p: with p; [
          pwntools
          tqdm
          z3
          requests
          pycryptodome
        ]))
        (symlinkJoin {
          name = "pwndbg-aliased";
          paths = [ pwndbg ];
          postBuild = ''
            ln -s $out/bin/pwndbg $out/bin/gdb
          '';
        })
      ];
    }}/bin $PATH";
    environment.systemPackages = with pkgs; [
      ghidra binary-ninja wireshark burpsuite
    ];
  };
}
