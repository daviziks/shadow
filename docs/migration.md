# Shadow NixOS Migration

## Strategy

1. Keep the current Fedora Silverblue install as the bootstrap environment.
2. Maintain the new NixOS/home-manager config in this `shadow` repo.
3. Build and test `.#shadow-vm` before touching bare metal.
4. When the VM is good, boot a NixOS installer and apply `nixosConfigurations.shadow` to the real disks.

## Fedora Bootstrap Notes

Fedora Silverblue 44 uses a composefs root. The Determinate Nix installer currently fails to create `/nix` on this host because its `nix-directory.service` runs `chattr -i /`, which composefs does not support. Fedora's `rpm-ostree install nix nix-daemon` path also fails because rpm-ostree rejects packages that import `/nix/store` paths.

Because of that, the low-risk bootstrap is to use a Nix container for VM builds instead of forcing host Nix onto Fedora.

## Real Install Storage Plan

- Reformat the NVMe: `/dev/disk/by-id/nvme-IM2P33F8ABR2-256GB_KN2229A92E2W`.
- Reformat the 240 GB SATA SSD: `/dev/disk/by-id/ata-KE-SSDIS24G_240202005190394`.
- Preserve the HDD: `/dev/disk/by-id/ata-WDC_WD5000LPVX-08V0TT5_WD-WXC1A24U1416`.
- Mount the dev-state SSD at `/home/daviziks/dev`.


## Bare-Metal Install Runbook

This is destructive for the NVMe and the 240 GB SATA SSD. The HDD is intentionally not referenced by `disko.nix` and should remain untouched.

1. Boot the graphical NixOS installer.
2. Connect networking.
3. Open a terminal and verify disk IDs:

```sh
ls -l /dev/disk/by-id/ | grep -E 'IM2P33F8ABR2|KE-SSDIS24G|WD5000LPVX'
```

Expected destructive targets:

```text
/dev/disk/by-id/nvme-IM2P33F8ABR2-256GB_KN2229A92E2W
/dev/disk/by-id/ata-KE-SSDIS24G_240202005190394
```

Expected preserved disk:

```text
/dev/disk/by-id/ata-WDC_WD5000LPVX-08V0TT5_WD-WXC1A24U1416
```

4. Clone the config and run the install.

If the repo is public:

```sh
sudo -i
nix-shell -p git disko
cd /tmp
git clone https://github.com/daviziks/shadow.git
cd shadow
disko-install --flake .#shadow
```

If the repo is private, authenticate first from the installer. The cleanest path is GitHub CLI:

```sh
sudo -i
nix-shell -p git gh disko
cd /tmp
gh auth login --hostname github.com --git-protocol https
# Pick HTTPS and browser/device login.
gh repo clone daviziks/shadow
cd shadow
disko-install --flake .#shadow
```

5. Reboot when `disko-install` completes.

## First Boot

1. Log in locally through KDE autologin.
2. Open Ghostty or Konsole.
3. Run `sudo tailscale up --ssh` and finish login in the browser.
4. Verify Tailscale SSH from another machine.
5. Set a local password if you want console password login: `sudo passwd daviziks`.

SSH, Caddy, and Sunshine are firewall-allowed only on `tailscale0`. LAN SSH and SSH password authentication are intentionally not opened in the final config.



## Automatic Upgrade Note

`system.autoUpgrade` points at `github:daviziks/shadow#shadow`. This works without extra credentials when the repository is public. If it is made private again later, root's Nix daemon will need GitHub access or automatic upgrades will fail to fetch the flake.

## VM Smoke Test

Validated on Fedora Silverblue via `docker.io/nixos/nix:latest` Podman container.

Commands used conceptually:

```sh
podman run --rm --security-opt label=disable -v "$PWD:/src" -w /src docker.io/nixos/nix:latest \
  sh -lc "git config --global --add safe.directory /src && nix --extra-experimental-features 'nix-command flakes' flake check"

podman run -d --name shadow-nix-vm --device /dev/kvm --security-opt label=disable --net host \
  -v "$PWD:/src" -w /src docker.io/nixos/nix:latest sleep infinity
podman exec shadow-nix-vm sh -lc "git config --global --add safe.directory /src && nix --extra-experimental-features 'nix-command flakes' build .#shadow-vm"
podman exec shadow-nix-vm sh -lc 'QEMU_OPTS="-nographic" ./result/bin/run-shadow-vm-vm'
```

Smoke-tested successfully:

- `nix flake check` passes.
- `.#shadow-vm` builds.
- VM boots as `shadow-vm`.
- VM SSH is reachable on host port `2222` for key-based testing.
- User `daviziks` exists and autologins on the VM console.
- Key tools are present in the VM: fish, git, gh, just, Podman, Docker-compatible CLI, Bun, Node 24, Go, Rustup, uv, Chrome, VS Code, Ghostty.

The persistent Podman build container is named `shadow-nix-vm`. It can be restarted for faster follow-up builds, or removed when no longer needed.

## Fedora Host Caveat

A failed attempt to install Nix directly on Fedora left the booted Silverblue deployment in OSTree `hotfix` unlock mode. This is acceptable for the temporary bootstrap machine, but it is not part of the final NixOS migration path. Rebooting into the non-hotfix deployment or reinstalling NixOS will discard it.
