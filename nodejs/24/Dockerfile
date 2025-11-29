FROM --platform=$TARGETOS/$TARGETARCH node:24-bookworm-slim

LABEL author="ndika" maintainer="ndika@pterodactyl.io"

# Add container user and set stop signal
RUN useradd -m -d /home/container container
STOPSIGNAL SIGINT

# Install dependencies
RUN apt update \
    && apt -y install \
        ffmpeg \
        iproute2 \
        git \
        sqlite3 \
        libsqlite3-dev \
        python3 \
        python3-dev \
        ca-certificates \
        dnsutils \
        tzdata \
        zip \
        tar \
        curl \
        build-essential \
        libtool \
        iputils-ping \
        libnss3 \
        tini \
    && rm -rf /var/lib/apt/lists/* \
    && apt clean

# Update npm & install TypeScript
RUN npm install --global npm@latest typescript ts-node @types/node

# Install pnpm
RUN npm install -g corepack
RUN corepack enable
RUN corepack prepare pnpm@latest --activate

# Install pm2
RUN npm install -g pm2

# Set working user and directory
USER container
ENV USER=container HOME=/home/container
WORKDIR /home/container

# Copy entrypoint.sh yang sudah dimodifikasi
COPY --chown=container:container ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Gunakan tini sebagai init + entrypoint
ENTRYPOINT ["/usr/bin/tini", "-g", "--"]
CMD ["/entrypoint.sh"]