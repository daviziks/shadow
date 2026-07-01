# Herdr

Herdr is the terminal/session multiplexer for Shadow. It keeps panes and agents
alive after disconnects and works naturally over SSH.

Run it on Shadow:

```sh
herdr
```

From another machine, use Herdr's remote mode:

```sh
herdr --remote shadow
```

Useful starting bindings:

- `ctrl+b`, then `v` or `-`: split panes.
- `ctrl+b`, then `c`: create a tab.
- `ctrl+b`, then `w`: switch workspaces.
- `ctrl+b`, then `q`: detach while sessions keep running.

Herdr's documentation recommends Nix installs through its flake. Shadow imports
that flake and installs `herdr` declaratively.
