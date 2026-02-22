sudo nft flush ruleset

sudo nft add table inet filter

sudo nft 'add chain inet filter input { type filter hook input priority 0; policy drop; }'
sudo nft 'add chain inet filter forward { type filter hook forward priority 0; policy drop; }'
sudo nft 'add chain inet filter output { type filter hook output priority 0; policy accept; }'

sudo nft add rule inet filter input ct state invalid drop
sudo nft add rule inet filter input ct state established,related accept
sudo nft add rule inet filter input iif lo accept

sudo nft add rule inet filter input ip protocol icmp accept
sudo nft add rule inet filter input ip6 nexthdr icmpv6 accept

sudo nft add rule inet filter input tcp dport 2222 ct state new limit rate 5/minute burst 10 packets accept

sudo nft add rule inet filter input reject with icmpx type admin-prohibited

sudo nft list ruleset | sudo tee /etc/nftables.conf
sudo systemctl enable nftables

sudo nft list ruleset