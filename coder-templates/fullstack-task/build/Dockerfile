FROM mcr.microsoft.com/playwright:v1.53.2-noble

ARG USER=coder

RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    ca-certificates curl git git-lfs gh jq sudo unzip zip ripgrep fd-find fzf \
    build-essential pkg-config openssh-client docker.io docker-compose-v2 \
    golang-go \
  && curl -fsSL https://deb.nodesource.com/setup_24.x | bash - \
  && apt-get install -y --no-install-recommends nodejs \
  && npm install -g bun pnpm yarn \
  && useradd --groups sudo,docker --create-home --shell /bin/bash "$USER" \
  && echo "$USER ALL=(ALL) NOPASSWD:ALL" >/etc/sudoers.d/$USER \
  && chmod 0440 /etc/sudoers.d/$USER \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /home/$USER
