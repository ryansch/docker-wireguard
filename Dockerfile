FROM debian:latest
LABEL maintainer="Ryan Schlesinger <ryan@ryanschlesinger.com>"

RUN apt-get update && apt-get install -y --no-install-recommends \
      libmnl-dev \
      libelf-dev \
      build-essential \
      pkg-config \
      git \
      ca-certificates \
      dkms \
      tini \
      iptables \
  && rm -rf /var/lib/apt/lists/*

# https://git.zx2c4.com/wireguard-linux-compat/refs/
ENV WIREGUARD_MODULE_VERSION v0.0.20200205
# https://git.zx2c4.com/wireguard-tools/refs/
ENV WIREGUARD_TOOLS_VERSION v1.0.20200206

RUN set -x \
	&& git clone --depth 1 --branch "${WIREGUARD_MODULE_VERSION}" https://git.zx2c4.com/wireguard-linux-compat.git /wireguard \
	&& git clone --depth 1 --branch "${WIREGUARD_TOOLS_VERSION}" https://git.zx2c4.com/wireguard-tools.git /wireguard-tools \
	&& ( \
		cd /wireguard-tools/src \
		&& make install \
		&& make clean \
	)

COPY entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["/usr/bin/tini", "-g", "--", "/docker-entrypoint.sh"]
CMD [ "wg", "--help" ]
