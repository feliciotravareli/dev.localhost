#!/bin/bash

# Usage:
#
#   curl -sL https://gist.githubusercontent.com/archan937/d35deef3b1f2b5522dd4b8f397038d27/raw/setup-dnsmasq.sh | sudo bash
#

DOMAIN=".docker.localhost"

ensure_ping() {
  if ! [ "$(command -v ping)" ]; then
    sudo apt-get install -y iputils-ping
  fi
}

check_network_manager_conf() {
  local conf="/etc/NetworkManager/NetworkManager.conf"

  if [[ "$(cat $conf 2>&1)" != *"dns=dnsmasq"* ]]; then
    echo "Adding dnsmasq to $conf ..."
    sudo sed -i 's/keyfile/keyfile\ndns=dnsmasq/g' $conf
  fi
}

check_dnsmasq_conf() {
  local dir="/etc/NetworkManager"
  local conf="$dir/dnsmasq.d/conf$DOMAIN"

  if [[ "$(cat $dir/* $dir/*/* $dir/*/*/* 2>&1)" != *"/$DOMAIN/127.0.0.1"* ]]; then
    echo "Configuring $DOMAIN in $conf ..."
    sudo mkdir -p "$(dirname $conf)"
    echo "address=/$DOMAIN/127.0.0.1" | sudo tee $conf > /dev/null
  fi
}

check_resolv_conf_symlink() {
  local network_manager_resolv_conf="/var/run/NetworkManager/resolv.conf"
  local resolv_conf="/etc/resolv.conf"

  echo "Symlinking $resolv_conf to $network_manager_resolv_conf ..."
  sudo rm $resolv_conf
  sudo ln -s $network_manager_resolv_conf $resolv_conf
}

restart_network_manager() {
  echo "Restarting NetworkManager ..."
  sudo service NetworkManager restart
  sleep 1.5
}

ping_domain() {
  local domain="foo$DOMAIN"
  echo "Pinging $domain ..."
  timeout 1 ping -c 1 $domain || echo "Unable to ping '$domain' domain."
}

ensure_ping;
check_network_manager_conf;
check_dnsmasq_conf;
check_resolv_conf_symlink;
restart_network_manager;
ping_domain;
