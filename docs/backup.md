# Backup storage

Shadow has a preserved 500 GB HDD labeled `backup`. It is mounted
declaratively at `/srv/backup` by UUID:

```text
dad335a7-0bfb-4afc-a88f-67fe358da4d6
```

Run an initial manual backup with:

```sh
shadow-backup
```

By default, this writes to:

```text
/srv/backup/shadow/manual/<timestamp>
```

The first backup set includes:

- `/etc/nixos`
- `/home/daviziks/dev/.devel`, when present
- `/home/daviziks/dev/.services`, when present

You can also pass a target directory explicitly:

```sh
shadow-backup /srv/backup/shadow/manual/pre-workspace
```
