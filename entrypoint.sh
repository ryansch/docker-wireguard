#!/bin/bash
set -e

add_module() {
  cd /wireguard/src
  echo "Adding the wireguard kernel module..."


  DKMSDIR=/usr/src/wireguard-${WIREGUARD_MODULE_VERSION} make dkms-install
  dkms add wireguard/${WIREGUARD_MODULE_VERSION}
}

install_module () {
  cd /wireguard/src
  echo "Installing the wireguard kernel module..."


  DKMSDIR=/usr/src/wireguard-${WIREGUARD_MODULE_VERSION} make dkms-install
  dkms install wireguard/${WIREGUARD_MODULE_VERSION}
  modprobe wireguard

  echo "Successfully built and installed the wireguard kernel module!"
}

if [[ "$1" == "dkms-add" ]]; then
  add_module
  exit $?
elif [[ "$1" == "install" ]]; then
  install_module
  exit $?
elif [[ "$1" == "version" ]]; then
  echo -n ${WIREGUARD_MODULE_VERSION}
  exit 0
fi

# shellcheck disable=SC2068
exec $@
