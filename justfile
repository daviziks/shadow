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

# Create a task from explicit repo specs: owner/repo[@base][=work]
task-new slug *repos:
    scripts/shadow-task new "{{slug}}" {{repos}}

# Pick repos interactively from a GitHub owner/user with fzf.
task-pick slug owner="":
    scripts/shadow-task pick "{{slug}}" "{{owner}}"

# List known task directories.
task-list:
    scripts/shadow-task list

# Print a task path.
task-path slug:
    scripts/shadow-task path "{{slug}}"

# Enter a task shell with task-local podman/docker wrappers.
task-shell slug:
    scripts/shadow-task shell "{{slug}}"

# Print shell exports for a task.
task-env slug:
    scripts/shadow-task env "{{slug}}"

# Run isolated podman for a task.
task-podman slug *args:
    scripts/shadow-task podman "{{slug}}" {{args}}

# Run isolated docker-compatible podman for a task.
task-docker slug *args:
    scripts/shadow-task docker "{{slug}}" {{args}}

# Ensure the task's private podman network exists.
task-network slug:
    scripts/shadow-task network "{{slug}}"

# Refresh shared bare git caches.
task-cache-update *repos:
    scripts/shadow-task cache-update {{repos}}

# Delete a task directory and its task-local container state.
task-destroy slug:
    scripts/shadow-task destroy "{{slug}}"
