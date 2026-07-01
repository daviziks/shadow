{ pkgs, ... }:
{
  fileSystems."/srv/backup" = {
    device = "/dev/disk/by-uuid/dad335a7-0bfb-4afc-a88f-67fe358da4d6";
    fsType = "ext4";
    options = [
      "nofail"
      "x-systemd.device-timeout=5s"
    ];
  };

  systemd.tmpfiles.rules = [
    "d /srv/backup 0750 daviziks users -"
    "d /srv/backup/shadow 0750 daviziks users -"
    "d /srv/backup/shadow/manual 0750 daviziks users -"
  ];

  environment.systemPackages = [
    (pkgs.writeShellApplication {
      name = "shadow-backup";
      runtimeInputs = with pkgs; [
        coreutils
        rsync
      ];
      text = ''
        target="''${1:-/srv/backup/shadow/manual/$(date +%Y%m%d-%H%M%S)}"
        mkdir -p "$target"

        rsync -a --delete /etc/nixos/ "$target/etc-nixos/"

        if [ -d /home/daviziks/dev/.devel ]; then
          rsync -a --delete /home/daviziks/dev/.devel/ "$target/devel/"
        fi

        if [ -d /home/daviziks/dev/.services ]; then
          rsync -a --delete /home/daviziks/dev/.services/ "$target/services/"
        fi

        printf 'backup written to %s\n' "$target"
      '';
    })
  ];
}
