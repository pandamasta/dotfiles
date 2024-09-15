#!/bin/bash
# author: Aurelien Martin
# This script has been tested on debian 12 LXC in proxmox 8.2

# Variables
WG_CONF_PATH="/etc/wireguard/wg0.conf"
SERVER_KEY_PATH="/etc/wireguard/server/server.key"
SERVER_PUB_KEY_PATH="/etc/wireguard/server/server.key.pub"

# Functions
install_packages_and_setup() {
    # Update and install necessary packages
    apt update && apt upgrade -y && apt autoremove -y
    apt-get install -y curl iptables wireguard qrencode

    # Create directories
    mkdir -p /etc/wireguard/server
    mkdir -p /etc/wireguard/clients

    # Generate server keys if they don't exist
    if [ ! -f "$SERVER_KEY_PATH" ]; then
        wg genkey | tee "$SERVER_KEY_PATH" | wg pubkey | tee "$SERVER_PUB_KEY_PATH"
        echo "Server keys generated."
    else
        echo "Server keys already exist."
    fi

    # Write WireGuard server configuration
    if [ ! -f "$WG_CONF_PATH" ]; then
        echo "[Interface]" >> "$WG_CONF_PATH"
        echo "Address = 172.16.1.0/32" >> "$WG_CONF_PATH"
        echo "ListenPort = 51820" >> "$WG_CONF_PATH"
        echo "PrivateKey = $(cat $SERVER_KEY_PATH)" >> "$WG_CONF_PATH"
        echo "SaveConfig = true" >> "$WG_CONF_PATH"
        echo "PostUp = iptables -t nat -I POSTROUTING -o eth0 -j MASQUERADE" >> "$WG_CONF_PATH"
        echo "PreDown = iptables -t nat -D POSTROUTING -o eth0 -j MASQUERADE" >> "$WG_CONF_PATH"
        echo "WireGuard server configuration created."
    else
        echo "WireGuard server configuration already exists."
    fi

    # Start WireGuard
    wg-quick up wg0
    systemctl enable wg-quick@wg0

    # Enable IP forwarding
    sed -i '/net.ipv4.ip_forward=1/s/^#//g' /etc/sysctl.conf
    sysctl -p
}

create_vpn_client() {
    VPN_CLIENT="$1"
    VPN_CLIENT_CONF="/etc/wireguard/clients/${VPN_CLIENT}.conf"

    # Create VPN client keys if they don't exist
    if [ ! -f "/etc/wireguard/clients/${VPN_CLIENT}.key" ]; then
        wg genkey | tee "/etc/wireguard/clients/${VPN_CLIENT}.key" | wg pubkey | tee "/etc/wireguard/clients/${VPN_CLIENT}.key.pub"
        echo "VPN client keys generated for ${VPN_CLIENT}."
    else
        echo "VPN client keys for ${VPN_CLIENT} already exist."
    fi

    # Create VPN client configuration if it doesn't exist
    if [ ! -f "$VPN_CLIENT_CONF" ]; then
        echo "[Interface]" >> "$VPN_CLIENT_CONF"
        echo "PrivateKey = $(cat /etc/wireguard/clients/${VPN_CLIENT}.key)" >> "$VPN_CLIENT_CONF"
        echo "Address = 172.16.1.1/32" >> "$VPN_CLIENT_CONF"
        echo "DNS = 192.168.1.16" >> "$VPN_CLIENT_CONF"
        echo "" >> "$VPN_CLIENT_CONF"
        echo "[Peer]" >> "$VPN_CLIENT_CONF"
        echo "PublicKey = $(cat $SERVER_PUB_KEY_PATH)" >> "$VPN_CLIENT_CONF"
        echo "Endpoint = $(curl -s ip.me):51820" >> "$VPN_CLIENT_CONF"
        echo "AllowedIPs = 0.0.0.0/0" >> "$VPN_CLIENT_CONF"
        echo "VPN client configuration created for ${VPN_CLIENT}."
    else
        echo "VPN client configuration for ${VPN_CLIENT} already exists."
    fi

    # Add VPN client to the WireGuard server
    wg set wg0 peer $(cat /etc/wireguard/clients/${VPN_CLIENT}.key.pub) allowed-ips 172.16.1.1

    # Generate QR code for VPN client configuration
    qrencode -t ansiutf8 -r "$VPN_CLIENT_CONF"
}

# Main logic
if [ "$1" == "--install" ]; then
    install_packages_and_setup
elif [ "$1" == "--user" ] && [ -n "$2" ]; then
    create_vpn_client "$2"
else
    echo "Usage:"
    echo "$0 --install                # Install and set up WireGuard"
    echo "$0 --user <VPN_CLIENT>       # Create VPN client configuration"
    exit 1
fi

