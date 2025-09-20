#!/bin/sh -e
ubuntu_version="$(
    command -v lsb_release >/dev/null 2>&1 \
    && lsb_release -r | awk '{print $2 * 100}' \
    || echo unknown
)"

add-apt-repository -y ppa:git-core/ppa
apt-get update
apt-get upgrade -y
apt-get install -y \
    git \
    gpg \
    jq \
    libsqlite3-dev \
    libssl-dev \
    python3 \
    python3-pip \
    shellcheck \
    sqlite3 \
    unzip \
    wget \
    zip \
    zsh

## sheldon
mkdir -p $HOME/.local/bin
if [ ! -f $HOME/.local/bin/sheldon ]; then
  curl --proto '=https' -fLsS https://rossmacarthur.github.io/install/crate.sh \
      | bash -s -- --repo rossmacarthur/sheldon --to ~/.local/bin
fi

## mise
apt-get update -y && apt-get install -y gpg sudo wget curl
install -dm 755 /etc/apt/keyrings
wget -qO - https://mise.jdx.dev/gpg-key.pub | gpg --dearmor | tee /etc/apt/keyrings/mise-archive-keyring.gpg 1> /dev/null
echo "deb [signed-by=/etc/apt/keyrings/mise-archive-keyring.gpg arch=$(dpkg --print-architecture)] https://mise.jdx.dev/deb stable main" | tee /etc/apt/sources.list.d/mise.list
apt-get update
apt-get install -y mise
# TODO: install completion

## Docker
# Add Docker's official GPG key:
apt-get update
apt-get install -y ca-certificates curl
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update

# Install Docker Engine, containerd, and Docker Compose
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
