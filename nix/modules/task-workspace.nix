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
    BUN_INSTALL_CACHE_DIR = "/home/daviziks/dev/.cache/pkg/bun";
    npm_config_cache = "/home/daviziks/dev/.cache/pkg/npm";
    COREPACK_HOME = "/home/daviziks/dev/.cache/pkg/corepack";
  };

  environment.systemPackages = [
    (pkgs.writeShellScriptBin "devel" (builtins.readFile ../../scripts/devel))
  ];
}
