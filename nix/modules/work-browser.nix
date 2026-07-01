{ ... }:
{
  systemd.tmpfiles.rules = [
    "d /home/daviziks/dev/.services/work-browser 0700 daviziks users -"
  ];

  virtualisation.oci-containers.containers.work-browser = {
    image = "lscr.io/linuxserver/firefox:latest";
    autoStart = true;
    ports = [
      "7081:3000"
      "7443:3001"
    ];
    volumes = [ "/home/daviziks/dev/.services/work-browser:/config" ];
    environment = {
      PUID = "1000";
      PGID = "100";
      TZ = "America/Cayenne";
      TITLE = "Shadow Work Browser";
      CUSTOM_USER = "daviziks";
    };
  };
}
