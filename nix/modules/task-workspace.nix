{
  config,
  lib,
  pkgs,
  ...
}:
{
  systemd.tmpfiles.rules = [
    "d /home/daviziks/dev 0755 daviziks users -"
    "d /home/daviziks/dev/.cache 0755 daviziks users -"
    "d /home/daviziks/dev/.cache/git 0755 daviziks users -"
    "d /home/daviziks/dev/.cache/pkg 0755 daviziks users -"
    "d /home/daviziks/dev/.containers 0755 daviziks users -"
    "d /home/daviziks/dev/.containers/storage 0700 daviziks users -"
    "d /home/daviziks/dev/.gateways 0755 daviziks users -"
    "d /home/daviziks/dev/.task-templates 0755 daviziks users -"
    "d /home/daviziks/dev/.services 0755 daviziks users -"
    "d /home/daviziks/dev/.services/executor 0700 daviziks users -"
    "d /home/daviziks/dev/.devel 0755 daviziks users -"
  ];

  environment.variables = {
    SHADOW_DEV_ROOT = "/home/daviziks/dev";
    SHADOW_SERVICE_PROFILE_ROOT = "/etc/shadow-dev/service-profiles";
    BUN_INSTALL_CACHE_DIR = "/home/daviziks/dev/.cache/pkg/bun";
    npm_config_cache = "/home/daviziks/dev/.cache/pkg/npm";
    COREPACK_HOME = "/home/daviziks/dev/.cache/pkg/corepack";
  };

  environment.etc."shadow-dev/service-profiles/node-web.compose.yaml".source =
    ../../service-profiles/node-web.compose.yaml;
  environment.etc."shadow-dev/service-profiles/sqlserver-minio-centrifugo.compose.yaml".source =
    ../../service-profiles/sqlserver-minio-centrifugo.compose.yaml;

  environment.systemPackages = [
    (pkgs.writeShellScriptBin "devel" (builtins.readFile ../../scripts/devel))
  ];
}
