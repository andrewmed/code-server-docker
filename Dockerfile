FROM debian:testing-backports

RUN set -ex; \
    # Get dependencies
    apt-get update && apt-get install -y --no-install-recommends \
    bash \
    bsdmainutils \
    build-essential \
    ca-certificates \
    curl \
    dnsutils \
    git \
    gnupg \
    htop \
    iputils-ping \
    vim \
    jq \
    less \
    libsecret-1-dev \
    libx11-dev \
    libxkbfile-dev \
    net-tools \
    nodejs \
    openssh-client \
    pkg-config \
    procps \
    sudo \
    tzdata \
    unzip \
    util-linux \
    wget \
    yarn


RUN set -ex; \
    # Get runtime dependencies
    apt-get update && apt-get install -y --no-install-recommends \
    golang \
    python3-pip \
    global

RUN set -ex; \
    # Get code-server
    CODE_VERSION="$(curl -sL https://api.github.com/repos/cdr/code-server/releases/latest | jq -r .tag_name)"; \
    CODE_VERSION_NUMBER="$(echo "$CODE_VERSION" | sed 's|v||g')"; \
    curl -sL https://github.com/cdr/code-server/releases/download/"$CODE_VERSION"/code-server-"$CODE_VERSION_NUMBER"-linux-amd64.tar.gz -o /tmp/code-server-"$CODE_VERSION"-linux-amd64.tar.gz; \
    tar -xzf /tmp/code-server-"$CODE_VERSION"-linux-amd64.tar.gz -C /tmp; \
    mv /tmp/code-server-"$CODE_VERSION_NUMBER"-linux-amd64 /usr/local/lib/code-server; \
    \
    # Symlink code-server
    ln -s /usr/local/lib/code-server/bin/code-server /usr/local/bin/code-server;


ARG UID
ARG USERNAME
RUN useradd -ms /bin/bash -U -u ${UID} ${USERNAME}

USER ${USERNAME}
RUN wget https://github.com/microsoft/vscode-cpptools/releases/download/1.5.1/cpptools-linux.vsix -P $HOME/
RUN mkdir $HOME/code

RUN set -ex; \
    code-server --install-extension=golang.go --force; \
    code-server --install-extension=ms-python.python --force; \
    code-server --install-extension=$HOME/cpptools-linux.vsix --force;

CMD code-server --auth none --disable-telemetry --disable-update-check --bind-addr 0.0.0.0:8080


