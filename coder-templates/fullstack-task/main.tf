terraform {
  required_providers {
    coder = {
      source = "coder/coder"
    }
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

variable "docker_socket" {
  default     = "unix:///run/podman/podman.sock"
  description = "Docker-compatible socket. Shadow uses Podman."
  type        = string
}

provider "docker" {
  host = var.docker_socket
}

data "coder_provisioner" "me" {}
data "coder_workspace" "me" {}
data "coder_workspace_owner" "me" {}

data "coder_parameter" "repo_specs" {
  name         = "repo_specs"
  display_name = "Repository specs"
  description  = "Whitespace-separated repo specs like owner/repo@base=work. Leave blank for an empty workspace."
  type         = "string"
  default      = ""
  mutable      = true
}

data "coder_parameter" "service_profile" {
  name         = "service_profile"
  display_name = "Service profile"
  description  = "Initial service profile label for devel metadata."
  type         = "string"
  default      = "none"
  mutable      = true
  option {
    name  = "None"
    value = "none"
  }
  option {
    name  = "Node API + Web"
    value = "node-web"
  }
  option {
    name  = "SQL Server + MinIO + Centrifugo"
    value = "sqlserver-minio-centrifugo"
  }
}

locals {
  workspace_name = lower(replace(data.coder_workspace.me.name, "/[^a-zA-Z0-9_.-]/", "-"))
  container_name = "coder-${data.coder_workspace_owner.me.name}-${local.workspace_name}"
}

resource "coder_agent" "main" {
  arch           = data.coder_provisioner.me.arch
  os             = "linux"
  startup_script = file("${path.module}/startup.sh")

  env = {
    CODER_WORKSPACE_NAME   = data.coder_workspace.me.name
    SHADOW_REPO_SPECS      = data.coder_parameter.repo_specs.value
    SHADOW_SERVICE_PROFILE = data.coder_parameter.service_profile.value
    GIT_AUTHOR_NAME        = coalesce(data.coder_workspace_owner.me.full_name, data.coder_workspace_owner.me.name)
    GIT_AUTHOR_EMAIL       = data.coder_workspace_owner.me.email
    GIT_COMMITTER_NAME     = coalesce(data.coder_workspace_owner.me.full_name, data.coder_workspace_owner.me.name)
    GIT_COMMITTER_EMAIL    = data.coder_workspace_owner.me.email
  }

  metadata {
    display_name = "CPU"
    key          = "cpu"
    script       = "coder stat cpu"
    interval     = 10
    timeout      = 1
  }

  metadata {
    display_name = "Memory"
    key          = "mem"
    script       = "coder stat mem"
    interval     = 10
    timeout      = 1
  }

  metadata {
    display_name = "Disk"
    key          = "disk"
    script       = "coder stat disk --path /home/coder"
    interval     = 60
    timeout      = 1
  }
}

resource "coder_app" "frontend_3000" {
  agent_id     = coder_agent.main.id
  slug         = "3000"
  display_name = "3000"
  url          = "http://localhost:3000"
  icon         = "/icon/code.svg"
  subdomain    = false
  share        = "owner"
}

resource "coder_app" "frontend_4000" {
  agent_id     = coder_agent.main.id
  slug         = "4000"
  display_name = "4000"
  url          = "http://localhost:4000"
  icon         = "/icon/code.svg"
  subdomain    = false
  share        = "owner"
}

resource "coder_app" "frontend_4200" {
  agent_id     = coder_agent.main.id
  slug         = "4200"
  display_name = "4200"
  url          = "http://localhost:4200"
  icon         = "/icon/code.svg"
  subdomain    = false
  share        = "owner"
}

resource "docker_image" "fullstack" {
  name = "shadow/fullstack-task:${data.coder_workspace.me.id}"
  build {
    context = "./build"
  }
  triggers = {
    dockerfile_sha1 = filesha1("./build/Dockerfile")
  }
}

resource "docker_volume" "home" {
  name = "coder-${data.coder_workspace_owner.me.name}-${local.workspace_name}-home"
}

resource "docker_container" "workspace" {
  count    = data.coder_workspace.me.start_count
  image    = docker_image.fullstack.name
  name     = local.container_name
  hostname = local.workspace_name

  host {
    host = "shadow"
    ip   = "10.88.0.1"
  }

  command = ["sh", "-c", coder_agent.main.init_script]
  env = [
    "CODER_AGENT_TOKEN=${coder_agent.main.token}",
    "DOCKER_HOST=unix:///var/run/docker.sock",
    "BUN_INSTALL_CACHE_DIR=/home/coder/.cache/bun",
    "npm_config_cache=/home/coder/.cache/npm",
    "COREPACK_HOME=/home/coder/.cache/corepack",
  ]

  volumes {
    volume_name    = docker_volume.home.name
    container_path = "/home/coder"
  }

  volumes {
    host_path      = "/run/podman/podman.sock"
    container_path = "/var/run/docker.sock"
  }

  working_dir = "/home/coder/workspace"
}
