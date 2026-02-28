#!/bin/bash

# Reset complet des tables standards
for t in filter nat mangle raw; do
    sudo iptables -t $t -F
    sudo iptables -t $t -X
done

# Politiques restrictives
sudo iptables -P INPUT DROP
sudo iptables -P FORWARD DROP
sudo iptables -P OUTPUT ACCEPT

# 1. Autoriser Loopback et Connexions établies
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

# 2. Autoriser SSH (Port 2222) et Web (80/443)
sudo iptables -A INPUT -p tcp --dport 2222 -j ACCEPT
sudo iptables -A INPUT -p tcp -m multiport --dports 80,443 -j ACCEPT
sudo iptables -A INPUT -p icmp -j ACCEPT

# 3. Autoriser tout le trafic interne Docker vers l'Hôte
# (Pour que les conteneurs puissent parler à l'IP du serveur si besoin)
sudo iptables -A INPUT -s 172.16.0.0/12 -j ACCEPT

# 4. Chaîne DOCKER-USER (Le pont entre réseaux Docker)
if ! sudo iptables -L DOCKER-USER &>/dev/null; then sudo iptables -N DOCKER-USER; fi
sudo iptables -F DOCKER-USER
sudo iptables -A DOCKER-USER -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
# Autoriser le forward interne entre bridges
sudo iptables -A DOCKER-USER -s 172.16.0.0/12 -d 172.16.0.0/12 -j ACCEPT
# Autoriser NPM à recevoir le trafic du Web
sudo iptables -A DOCKER-USER -p tcp -m multiport --dports 80,443 -j ACCEPT
# Laisser Docker finir le boulot
sudo iptables -A DOCKER-USER -j RETURN

# Sauvegarde
sudo apt-get install -y iptables-persistent
sudo netfilter-persistent save

echo "Firewall Boilerplate appliqué."
