# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-kasmvnc:debianbookworm

# abc doesn't need sudo access
RUN deluser abc sudo

ARG WINE_VERSION=10.0.0.0~bookworm-1
ARG WINE_MONO_VERSION=9.4.0

COPY --chmod=0755 /root/scripts/install_wine.sh /scripts/install_wine.sh
RUN /scripts/install_wine.sh

RUN apt-get update && apt-get install -y --no-install-recommends \
  xvfb \
  xdotool \
  winbind \
  unzip \
  && rm -rf /var/lib/apt/lists/*

COPY --chmod=0755 /root/scripts/install_quark.sh /scripts/install_quark.sh
ARG QUARK_URL="https://pdds.quark.cn/download/stfile/xx6479879xy4xz8zx/QuarkCloudDrive_v3.19.0_release_(Build2135311-20250327222033).exe"
ENV WINEDEBUG=fixme-all

# Wine prefix needs to be owned by abc
RUN chown abc:abc /config
USER abc
RUN xvfb-run /scripts/install_quark.sh

# entrypoint expects root
USER root

COPY /root/defaults /defaults
