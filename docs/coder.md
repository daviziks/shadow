# Coder

Coder is the control plane for task-based development workspaces on Shadow.

## URL

The first deployment listens on the tailnet-reachable URL:

```text
http://shadow:7080
```

The port is open only through the `tailscale0` firewall interface.

## Data

Persistent service data lives under:

```text
/var/lib/coder
```

Template sources live under:

```text
/home/daviziks/dev/.services/coder/templates
```

PostgreSQL is managed locally by the NixOS `services.coder` module.

## Bootstrap

After the service is running, create the first admin user from Shadow:

```sh
sudo -u coder coder server create-admin-user \
  --username daviziks \
  --email davioliveira.java@gmail.com \
  --password '<password>'
```

Then log in from a trusted machine:

```sh
coder login http://shadow:7080
```

## Workspace runtime

The Coder service user belongs to the `podman` group so templates can use the
Docker-compatible Podman socket:

```text
unix:///run/podman/podman.sock
```
