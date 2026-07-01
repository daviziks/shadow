set shell := ["sh", "-eu", "-c"]

fmt:
    nix fmt

check:
    nix flake check

show-host:
    nix flake show
