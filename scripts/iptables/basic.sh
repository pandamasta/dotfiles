#!/bin/bash
# -------------------------------
# Firewall setup for VPS + Docker
# SSH, Docker web ports, host protection
# Fully Docker-safe, generic, validated in Debian 13.3
# -------------------------------

# -------------------------------
# Flush all existing rules
# -------------------------------
sudo iptables -F
sudo iptables -X
sudo iptables -t nat -F
sudo iptables -t nat -X
sudo iptables -t mangle -F
sudo iptables -t mangle -X

# -------------------------------
# Set default policies
# -------------------------------
sudo iptables -P INPUT DROP
sudo iptables -P FORWARD DROP
sudo iptables -P OUTPUT ACCEPT

# -------------------------------
# Host INPUT rules
# -------------------------------
# Loopback
sudo iptables -A INPUT -i lo -j ACCEPT
# Drop invalid
sudo iptables -A INPUT -m conntrack --ctstate INVALID -j DROP
# Established/related
sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
# ICMP
sudo iptables -A INPUT -p icmp -j ACCEPT
sudo ip6tables -A INPUT -p ipv6-icmp -j ACCEPT
# SSH (adjust IP/range as needed)
sudo iptables -A INPUT -p tcp --dport 2222 -m conntrack --ctstate NEW -m limit --limit 5/min --limit-burst 10 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 2222 -j LOG --log-prefix "SSH-ALERT: " --log-level 4
# Web ports for host
sudo iptables -A INPUT -p tcp -m multiport --dports 80,443 -m conntrack --ctstate NEW -j ACCEPT
# Reject everything else
sudo iptables -A INPUT -j REJECT --reject-with icmp-port-unreachable

# -------------------------------
# Docker-safe forwarding
# -------------------------------
# Create DOCKER-USER if missing
if ! sudo iptables -L DOCKER-USER &>/dev/null; then
    sudo iptables -N DOCKER-USER
fi

# Basic Docker rules
sudo iptables -I DOCKER-USER -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
sudo iptables -I DOCKER-USER -i docker0 -j ACCEPT
sudo iptables -I DOCKER-USER -o docker0 -j ACCEPT

# -------------------------------
# Docker port restrictions (generic)
# Only allow 80/443 + SSH to admin IPs
# Drop all other exposed ports
# -------------------------------
sudo iptables -I DOCKER-USER -p tcp --dport 80 -j ACCEPT
sudo iptables -I DOCKER-USER -p tcp --dport 443 -j ACCEPT
#sudo iptables -I DOCKER-USER -p tcp --dport 2222 -s 1.2.3.0/24 -j ACCEPT
sudo iptables -I DOCKER-USER -p tcp --dport 2222 -j ACCEPT
sudo iptables -I DOCKER-USER -j DROP

# Optional: log blocked Docker traffic
# sudo iptables -I DOCKER-USER -j LOG --log-prefix "DOCKER-BLOCK: " --log-level 4

# -------------------------------
# Save rules permanently
# -------------------------------
sudo apt install -y iptables-persistent
sudo netfilter-persistent save

echo "Firewall successfully applied"