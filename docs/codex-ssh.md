# Codex SSH Host

Shadow installs the Codex CLI system-wide as `codex`.

The Codex app can use Shadow as an SSH host when:

1. Your local machine has a concrete SSH alias, for example:

   ```sshconfig
   Host shadow
     HostName shadow
     User daviziks
   ```

2. SSH works from the machine running the Codex app:

   ```sh
   ssh shadow
   ```

3. Codex is authenticated on Shadow:

   ```sh
   ssh shadow
   codex login
   codex doctor
   ```

After that, open the Codex app settings, add the SSH host, and choose a project
folder on Shadow.
