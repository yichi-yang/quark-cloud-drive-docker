#!/bin/bash

set -e

# Enable 32 bit architecture
dpkg --add-architecture i386

# Add the repository key
mkdir -pm755 /etc/apt/keyrings
curl -o - https://dl.winehq.org/wine-builds/winehq.key | gpg --dearmor -o /etc/apt/keyrings/winehq-archive.key -

# Add the repository
curl --output-dir /etc/apt/sources.list.d/ -O https://dl.winehq.org/wine-builds/debian/dists/bookworm/winehq-bookworm.sources

apt update

# Install Wine
apt install -y --no-install-recommends winehq-stable=$WINE_VERSION fonts-noto-cjk

# Install Wine Mono
apt install -y --no-install-recommends xz-utils
mkdir -p /usr/share/wine/mono
curl -o - https://dl.winehq.org/wine/wine-mono/${WINE_MONO_VERSION}/wine-mono-${WINE_MONO_VERSION}-x86.tar.xz | tar -xJ -C /usr/share/wine/mono

# Clean up
rm -rf /var/lib/apt/lists/*
