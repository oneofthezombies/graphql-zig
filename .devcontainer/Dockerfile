FROM mcr.microsoft.com/devcontainers/base:debian-12

ENV DEBIAN_FRONTEND=noninteractive

SHELL ["/bin/bash", "-c"]

RUN apt update && \
    apt install -y \
    curl \
    git \
    # To open in a browser on the host
    xdg-utils \
    && apt clean && \
    rm -rf /var/lib/apt/lists/*

ENV ZIG_VERSION="0.13.0"
RUN ARCH="$(uname -m)" && \
    ZIG_FILENAME="zig-linux-$ARCH-$ZIG_VERSION.tar.xz" && \
    curl -fsSLO "https://ziglang.org/download/$ZIG_VERSION/$ZIG_FILENAME" && \
    tar -C /opt -xf "$ZIG_FILENAME" && \
    rm "$ZIG_FILENAME" && \
    ln -s "/opt/zig-linux-$ARCH-$ZIG_VERSION/zig" "/usr/local/bin/zig" && \
    ZLS_FILENAME="zls-$ARCH-linux.tar.xz" && \
    curl -fsSLO "https://github.com/zigtools/zls/releases/download/$ZIG_VERSION/$ZLS_FILENAME" && \
    mkdir -p "/opt/zls-$ARCH-linux" && \
    tar -C "/opt/zls-$ARCH-linux" -xf "$ZLS_FILENAME" && \
    rm "$ZLS_FILENAME" && \
    ln -s "/opt/zls-$ARCH-linux/zls" "/usr/local/bin/zls"

USER vscode
ENV HOME="/home/vscode"
RUN echo '' >> ~/.bashrc && \
    echo '################################################################################' >> ~/.bashrc && \
    echo '# Environment variables' >> ~/.bashrc && \
    echo '################################################################################' >> ~/.bashrc && \
    echo '' >> ~/.bashrc

ENV PATH="$HOME/.volta/bin:$PATH"
RUN echo '# JavaScript' >> ~/.bashrc && \
    curl https://get.volta.sh | bash && \
    volta install \
    node@22.13.0 \
    npm@11.0.0 \
    deno@v2.1.6 \
    gitmoji-cli@9.5.0 \
    && echo '' >> ~/.bashrc

RUN echo '# Aliases' >> ~/.bashrc && \
    echo 'alias ll="ls -a -p -lh"' >> ~/.bashrc && \
    echo '' >> ~/.bashrc

WORKDIR /work
