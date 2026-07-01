set shell := ["sh", "-eu", "-c"]

fmt:
    nix fmt

check:
    nix flake check

build-vm:
    nix build .#shadow-vm

run-vm: build-vm
    ./result/bin/run-shadow-vm-vm

show-host:
    nix flake show

store *repos:
    devel store add {{repos}}

store-list:
    devel store list

create slug *repos:
    devel create "{{slug}}" {{repos}}

enter slug:
    devel enter "{{slug}}"

list:
    devel list

path slug:
    devel path "{{slug}}"

destroy slug:
    devel destroy "{{slug}}"

prune:
    devel prune

cache *repos:
    devel cache update {{repos}}
