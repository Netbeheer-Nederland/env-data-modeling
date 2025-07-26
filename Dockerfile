FROM ghcr.io/astral-sh/uv:python3.12-bookworm

ARG USER_ID=1000
ARG USER_NAME=devuser
ARG GROUP_ID=1000

# Avoid interactive prompts during install
ENV DEBIAN_FRONTEND=noninteractive

ENV RUNNING_IN_DOCKER=true

RUN groupadd --gid $GROUP_ID $USER_NAME \
    && useradd -m -u $USER_ID -g $GROUP_ID $USER_NAME -s /bin/bash

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    gnupg ca-certificates \
    curl \
    git \
    bc \
    vim

# Install Python project dependencies
COPY pyproject.toml uv.lock ./
RUN uv export --format requirements.txt > requirements.txt \
    && uv pip install --system -r requirements.txt

# Install just
RUN curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to /usr/local/bin --tag 1.38.0

COPY justfile ./

# Install shell completions for just
RUN just --completions bash >> /usr/share/bash-completion/completions/just \
    && echo 'source /usr/share/bash-completion/completions/just' >> /etc/bash.bashrc

# GitHub client
RUN (type -p wget >/dev/null || (apt update && apt-get install wget -y)) \
    && mkdir -p -m 755 /etc/apt/keyrings \
    && out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
    && cat $out | tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
    && chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
    && apt update \
    && apt install gh -y

LABEL org.opencontainers.image.source=https://github.com/netbeheer-nederland/env-data-modeling
LABEL org.opencontainers.image.description="Netbeheer Nederland environment for data modeling and generating documentation and schemas."
LABEL org.opencontainers.image.licenses=Apache-2.0
