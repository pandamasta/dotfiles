Title: Useful commands
Date: 2017-01-27
Modified: 2024-05-17
Category: Howto
Tags: linux,cli
Summary: List of standard and most usefull CLI tools and tips

I have tried to gather all the command line that are useful for my daily task. This will be written in English to help a maximum of person. Some of jedi tricks are coming from other website so I'll try to mention the source whenever it's possible.

Bash
-----
    Move

    Ctrl + a : go to the begening of the line
    Ctrl + e : go to the end of the line
    Alt + b : move word by word backward 
    Alt + f : move word by word forward 
    ctrl + xx : Begenning or end of a word

    Copy/Paste

	Ctrl + k : cut string until the end of the line 
	Ctrl + u : cut string until the begening of the line
	Ctrl + w : cut the word before the cursor
	Ctrl + y : paste cutede string

    Replacement

	Ctrl + t : switch two caracters before  the cursor
	Alt + t : switch the position of the two word before the cursor
	Alt + c : change the carater to upercase 
	Alt + l : change the word in lowercase 
	Alt + u : change the word to uppercase
	Alt + . : get the parametter of the previous command line

    Various

    Esc + .  : put the last arguement under the cursor
	Ctrl + l : clear the screen
	Ctrl + _ : undo the last modification
	Ctrl + r : look in the history, reverse research
	Ctrl + c : kill the command in progress
	Ctrl + d : quit the current sheel
	ctrl + x + ctrl + e : open the default EDITOR


Process
--------
```
# Get a father of a child process
pgrep -P $your_process1_pid

# When a process started (http://www.tux-planet.fr/)
ps -e -o pid,comm,lstart | grep name_of_process

# Process that consume CPUs
ps -eo pcpu,pid,user,args | sort -k 1 -r | head -13 

# Number of process for the same bin
ps aux | awk '{print $11}' | sort | uniq -c | sort -nk1 | tail -n5

# Process run by user on the system
ps aux | awk '{print $1}' | sort | uniq -c | sort -nk1 | tail -n5
```
Swap
----
```
# Swap usage
ps -eo pid,ppid,rss,vsize,pcpu,pmem,cmd,user -ww --sort=vsize

swapon -s
swapon /dev/sdax
mkswap -U `uuidgen` /dev/sdax
ls -l /dev/disk/by-uuid/*

# Swap usage of process
#echo "COMM PID SWAP"; for file in /proc/*/status ; do awk '/^Pid|VmSwap|Name/{printf $2 " " $3}END{ print ""}' $file; done | grep kB | grep -wv "0 kB" | sort -k 3 -n -r) | column -t
```

ssh
---
```
# Tunnel SSH, local forwarding
ssh -L 6666:localhost:8888 user@server -p443

# Dynamic forwarding; port translation SOCKS proxy
ssh -D <local_port>@<host> -p<port>
```
Rsync
----
```
# Use a different ssh port
rsync -e 'ssh -p 2222' -avz --progress /path/with/data boby@hello.net:/destination/path
```
SSL
---
```
# Generate RSA private key encoded in Triple DES
openssl genrsa -des3 -out server.key 4096

# Generate x509 certificate without priv' key passphrase
openssl req -x509 -newkey rsa:4096 -out server.key -nodes

# Generate CSR
openssl req -new -key server.key -out server.csr

# Remove the passphrase of RSA key if needed
openssl rsa -in server.key -out server.key.new

# Generating a Self-signed Certificate
openssl x509 -req -days 365 -in server.csr -signkey server.key.new -out server.crt

# Generating a Self-Signed Certificate in one line
openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -days 365 -nodes

# Extract pem to private key
openssl rsa -outform der -in key.pem -out private.key

#SSL/TLS client which can establish a transparent connection to a remote server speaking SSL/TLS
openssl s_client -starttls smtp -connect ip:587

#Check the validity of certificate
openssl x509 -noout -dates -in /usr/local/etc/letsencrypt/live/foo.me/cert.pem
echo | openssl s_client -servername www.shellhacks.com -connect www.shellhacks.com:443 2>/dev/null | openssl x509 -noout -dates

#Check certificate 
echo | openssl s_client -servername pandaa.me -connect pandaa.me:443

# Read x509 crt
openssl x509 -in <CERTIFICATE>.crt -noout -text

# Read PFX crt
openssl pkcs12 -info -in <CERTIFICATE>.pfx

# Read CSR
openssl req -noout -text -in <CERTIFICATE>.csr

# Get remote cert
openssl s_client -connect xxxx:443

# Get remote cert and dump its expiration
openssl s_client -connect xxxx:443 2>/dev/null | openssl x509 -noout -dates
openssl s_client -proxy <HOST:PORT> -connect <HOST:PORT> -servername=<HOST>  2>&1 | openssl x509 -noout -dates

#  Create p12
openssl pkcs12 -export -in wildcard.foo.cer -inkey wildcard.foo.key -certfile GLOBALSIGN.crt -out certif.p12
```

Packages
---------
```
# List the content of a .deb
dpkg -c package.deb
ar tv package.deb

# Extract .deb package
dpkg -x package.deb /tmp/
ar vx package.deb
ar p package.deb data.tar.gz | tar zx
ar p package.deb data.tar.xz | unxz | tar x

#List file installed by a package
dpkg-query -L bash

#Search the package that install a file
dpkg -S /bin/cat

#List hold package
dpkg --get-selections | grep hold

dpkg --info

apt-cache showpkg coreutils
```
dpkg
-----
```
# Put a package on hold:
echo "<package-name> hold" | sudo dpkg --set-selections

# Remove the hold:
echo "<package-name> install" | sudo dpkg --set-selections

# Display the status of all your packages:
dpkg --get-selections

# Display the status of a single package:
dpkg --get-selections <package-name>

# Show all packages on hold:
dpkg --get-selections | grep "\<hold$"

# Check database sanity and consistency on package
dpkg -C <package>
```
apt
---
```
# Hold a package
sudo apt-mark hold <package-name>

# Remove the hold
apt-mark unhold <package-name>

# Show all packages on hold:
apt-mark showhold

# Simulate install
apt -s install ./<package>.deb
```
Audio
------
```
# List firewire device
grep . /sys/bus/firewire/devices/fw*/*
```
Memory
---------
```
# Memory state, corruptible or uncoruptible,EDAC (Error Detection and Correction) drivers in the kernel
cat /sys/devices/system/edac/mc/log_ue
grep "[0-9]" /sys/devices/system/edac/mc/mc*/csrow*/ch*_ce_count
grep "[0-9]" /sys/devices/system/edac/mc/mc*/csrow*/ue_count
```
Disk
----
```
# List scsi device
lsscsi --g

# Remove a disk from the scsi layer
echo "scsi remove-single-device 0 0 0 0" > /proc/scsi/scsi   #the 0 0 0 0 are the ID of the disk


# List major and minor number of a block device
grep ^ /sys/class/block/*/dev
cat /proc/self/mountinfo

# Get block device attribude
udevadm info -q env -p /block/sda

# Find a mapping from SCSI host to the ata* ID:
grep '[0-9]' /sys/class/scsi_host/host{0..9}/unique_id

# Find a mapping from the SCSI host to the sd* ID
ls -l /sys/block/sd*
```
SMART
-----
```
# Check ata disk
smartctl -a -d ata /dev/sda

# Check if disk support SMART :
smartctl -i /dev/sda

# Enable SMART on SATA drive :
smartctl -s on -d ata /dev/sda

# Error log of SMART
smartctl -l error /dev/sda

# Offline test
smartctl -t offline /dev/sda

# Long test
smartctl -d ata -t long /dev/sda

# Get most relevent field of SMART output
grep -w 'Raw_Read_Error_Rate\|Reallocated_Sector_Ct\|Seek_Error_Rate\|Hardware_ECC_Recovered\|Reallocated_Event_Count\|Current_Pending_Sector\|Offline_Uncorrectable\|UDMA_CRC_Error_Count'

# SMART 3ware
smartctl -a -d 3ware,6 /dev/twa0


# SMART adaptec
smartctl -a -d sat /dev/sg28


# SMART PERC controller 
smartctl -a -d sat+megaraid,8 /dev/sda
smartctl -a -dsat+megaraid,22  /dev/sg0

smartctl -adcciss,0 /dev/sg2

for i in `lsscsi --g | awk '{ print $NF }'`;do echo ">>>> $i" ; smartctl -a -d sat $i | grep "UDMA_CRC_Error_Count";done

smartctl --scan-open
```
RAID
----

MDADM
```
cat /proc/mdstat 
mdadm /dev/md7  --add /dev/sdb9
mdadm --assemble --update=resync /dev/md7 /dev/sdb9 /dev/sda9
mdadm --examine /dev/sd[a-z] | egrep 'Event|/dev/sd'
mdadm --examine /dev/sd[efghi]1 | egrep 'dev|Update|Role|State|Chunk Size'
mdadm --create --assume-clean --level=6 --raid-devices=6 /dev/md125 /dev/sdc /dev/sdd /dev/sde missing /dev/sdg /dev/sdh
mdadm --examine /dev/sd[efghi]1 | egrep 'dev|Update|Role|State|Chunk Size'
```

3WARE controler
```
tw_cli info c0
tw_cli /c0 show alarms
tw_cli /c0/bbu show all
tw_cli alarms 
tw_cli maint rescan c0
tw_cli maint deleteunit c0 u11        #delete unit
tw_cli maint createunit c0 rspare p3
tw_cli maint remove c0 p9
tw_cli alarms|grep -v INFO
grep 3w- /var/log/messages
grep lemon-tw /var/log/messages
grep -i 'I/O\|ata[0-9]' /var/log/messages*
tw_cli /c0 add type=spare disk=3
```
Adaptec controler
```
arcconf getconfig 1
arcconf getstatus 1
arcconf getlogs 1 device tabular
arcconf getlogs 1 dead tabular
arcconf getlogs 1 dead tabular|grep -B9 -A3 MJ0251YMG0U5RA 
arcconf setstate 1 device 0 8 rdy
arcconf getconfig 1 | grep -i 'Reported Location\|State\|Device #\|Reported Channel'
arcconf getconfig 1 | grep -i 'Logical device number\|Segment 0\|Segment 1\|Reported Channel\|Serial'
arcconf getconfig 1 | grep -i 'Reported Location\|State\|Device #\|Reported Channel\|Serial' | grep -B4 --color WCAVY2334627
arcconf getconfig 1 | grep -C5 -e "0,14"
arcconf getconfig 1 | grep -A5 Battery
arcconf getconfig 1 ad | egrep "Firmware|Driver"
arcconf setstate 1 device 0 63 rdy
arcconf setpriority 1 <task_id> high

# Create a JBOD
arcconf create 1 jbod 0 17

# Delete JBOD
arcconf delete 1 jbod 0 63
arcconf setstate 1 device 0 63 ddd
```

MEGACLI PERC controller
```
# Check log of controller
megacli -PDList -aAll | grep "ID\|Slot\|Inquiry\|Media Error Count\|Other Error Count\|Predictive Failure Count"
megacli -PD List -aAll

# All serial number
megacli -pdlist -a0 | grep "Inquiry Data:"

# megaraidsas_lv_optional alarm
megacli -LDSetProp WT -Lall a0
megacli -LDSetProp RA -Lall a0

# View virtual disk
megacli -LdPdInfo -a0 | grep -A 40 "Virtual Drive: 35" | grep -e "^Virtual Drive\|^Size\|^State\|^Device Id"

# View physical disk
megacli -PDList -aALL | grep 'Device Id\|Slot'
megacli -LDpdinfo  -aAll
megacli -pdinfo -physdrv '[45:0]' -aall
smartctl -dsat+megaraid,21  -i /dev/sg0

# Logical disk on controler 0 and adapter 0
megacli -LDInfo -L0 -a0

# Show the adapter config
megacli -AdpAllInfo -aALL

# Physical drive and logical drive mapping
megacli -LDPDInfo -aAll

# Watch the rebuild
megacli -AdpGetProp RebuildRate -a0
megacli -PDRbld -ShowProg -PhysDrv [32:1] -aALL
megacli -LdPdInfo -a0 | grep "Virtual Drive: 16 (" -A 33 | egrep "Virtual Drive:|State|Enclosure Device|Slot Number:|Device Id:|Firmware|Inquiry Data:"

# BBU info
megacli -AdpBbuCmd -GetBbuStatus -a0

```

Storecli
```
storcli /c0 show all
```
LSI
```
mpt-status -i 0 -n
mpt-status -s
```
sas2ircu
```
sas2ircu 0 display
sas2ircu 0 display | grep -B6 `smartctl -a /dev/sdf | grep  "Serial Number" | awk {'print $NF'}`
```
LVM
---
```
# Load LVM module (if not load you get: failure to communicate with kernel device-mapper driver.)
modprobe dm-mod

# Probe the LVM volumes
lvmdiskscan 

#Get pv vg and lv information
pvdisplay ; vgdisplay ; lvdisplay
pvs ; vgs ; lvs

#Scan volume group by probing physical volume
vgscan

#Active volume group (eg: vg1)
vgchange -ay vg1

# Extend logical volume
lvextend -L +50G /dev/os_local_vg/pgbackup
resize2fs /dev/os_local_vg/pgbackup
```
File System
-----------
```
# Check integrity of fileystem
 fsck -yfv -C fd /dev/sda
fsck -a (all)

# Check file system full
for i in `ls / | grep -v "afs\|boot\|tmp\|var"`; do du -ah $i | awk '$1 ~ /G$/ { print $0 }'; done
du -ahx /var | awk '$1 ~ /G$/ { print $0 }'
du -a /var/log/ | sort -n -r | head -n 20

# Bigest file
du -hs /srv/castor/* | sort -nr | head -8
du -sh * | sort -n

# Dump the mbr
sfdisk -d /dev/sda > sda-mbr 
hexdump -C sda-mbr
```
Grub
-----
```
grub> find /grub/stage1
find /grub/stage1
 (hd0,0)
 (hd1,0)
 (hd2,0)

root (hd0,0) /dev/sda
 Filesystem type is ext2fs, partition type 0xfd

grub> setup (hd0)
setup (hd0)
 Checking if "/boot/grub/stage1" exists... no
 Checking if "/grub/stage1" exists... yes
 Checking if "/grub/stage2" exists... yes
 Checking if "/grub/e2fs_stage1_5" exists... yes
 Running "embed /grub/e2fs_stage1_5 (hd0)"...  15 sectors are embedded.
succeeded
 Running "install /grub/stage1 (hd0) (hd0)1+15 p (hd0,0)/grub/stage2 /grub/grub.conf"... succeeded
Done.
```
Log
----
```
grep 'Jan 17 06:*' /var/log/messages 
logrotate -f /etc/logrotate.d/syslog
grep -i  -e 'i/o' -e 'edac' -e 'BIOS' /var/log/messages
```
Network
--------
```
# Force speed of interface
ethtool -s eth0 autoneg off speed 1000 duplex full

# Set autoneg on interface
ethtool -s eth0 autoneg on

# List internet network file
lsof -i

# Add route
route add default gw r9994-4-rhp82-1 dev eth0
ip route add 192.168.55.0/24 via 192.168.1.254 dev eth1
route add -net 192.168.55.0 netmask 255.255.255.0 gw 192.168.1.254 dev eth1
```


IPMI
----
```
lsmod | grep ipmi
ipmitool sdr 
ipmitool mc info | grep "Firmware Revision\|IPMI Version"

ipmitool lan set 1 ipsrc dhcp
ipmitool lan set 1 access on
ipmitool lan print 1
ipmitool lan set 1 ipaddr 10.0.0.1
ipmitool lan set 1 netmask 255.255.0.0
ipmitool lan set 1 defgw ipaddr 192.168.0.1

ipmitool user list
ipmitool user set name 2 moi
ipmitool user set password 2 mon_super_mot_de_passe

ipmitool -H 192.168.0.100 -U moi -P mon_super_mot_de_passe power status
ipmitool -I lanplus -H host -U admin chassis status
```
Other
-----
```
# Get email from webpage
wget -q -O - http://www.telecharger.com | grep -oe '\w*.\w*@\w*.\w*.\w\+' | sort -u

# -c to continue download
wget -c http://cdimage.debian.org/debian-cd/9.2.1/amd64/iso-cd/debian-9.2.1-amd64-xfce-CD-1.iso

#ftp to remoe dir
wget -r -nH --cut-dirs=5 -nc ftp://user:pass@server//absolute/path/to/directory


# Is file exist
[ -f /etc/iss.nologin ] && echo "File exists" || echo "File does not exists"

# Convert the current Time to stamp
date +%s

# Get the timestamp of a date
date -d "2017-05-07 17:00:00" +%s 

# Timestamp to date
date -d @1494169200

# Find and show file > 1GB
find /var/* -size +1G -exec ls -lh {} \; | sort -k5 -n | awk '{ print $5 "\t" $9 }' 

# Sort IP
sort -t . -k4,4n xx.list

# Get udev device info
udevadm info --query=all --name /dev/md114 

# Prevent module to be load during the boot
echo blacklist pcspkr >> /etc/modprobe.d/blacklist.conf

# polkit
pkaction --verbose --action-id org.freedesktop.udisks2.filesystem-mount-system
```

System
-------
```
iotop
vmstat 1
iostat 1
lsof
dkms status

#get the runlevel
who -r
```

Systemd
--------
```
# Enable a service at boot
systemctl enable sshd.service

# Disable
systemctl disable sshd.service

# Status
systemctl is-active sshd.service

# All service running
systemctl list-units --type=service 

# Get runlevel
systemctl get-default
multi-user.target = 3
graphical.target = 5

# Change runlevel
systemctl isolate graphical.target

# Change runlevel by default
systemctl set-default graphical.target

systemctl --system daemon-reload


systemctl start xx.service 
systemctl stop xx.service 
systemctl restart xx.service
systemctl reload xx.service
```
Debug
------
```
strace -e trace=open <application>
strace -e trace=open -p <pid>
```
man
---
```
#List all manpage available on the system
man -k ' '

#Convert manpage to html
zcat /usr/share/man/man1/man.1.gz  | groff -mandoc -Thtml > file.html
```
sound
------
```
# List sound device of the system
$ cat /proc/asound/cards

# Device reconize by alsa
$ arecord -l

# Record the default sound device. Mic test
$ arecord -d 10 /tmp/test-mic.wav
```
FreeBSD
-------
```
# Recompile kernel with vimage support
cp /usr/src/sys/amd64/conf/GENERIC /usr/src/sys/amd64/conf/GENERIC-FreeBSD-vimage
do you modif'
cd /usr/src
make buildkernel kernconf=/usr/src/sys/amd64/conf/GENERIC-FreeBSD-vimage
make installkernel kernconf=/usr/src/sys/amd64/conf/GENERIC-FreeBSD-vimage

# See kernel option
kldstat -v

#pkg
pkg which /usr/local/bin/yasm

```
KVM
----
```
virsh snapshot-create-as --domain hostname  --name "20220204" --description "Snapshot"
```

vmware
-------
```
# extend vmware new vmdk size
echo 1 > /sys/block/sda/device/rescan
parted /dev/sda
Disk /dev/sda: 752GB
(parted) resizepart 1
End?  [666GB]? 752GB
pvresize /dev/sda1
lvextend -L +50G /dev/os_local_vg/pgbackup
resize2fs /dev/os_local_vg/pgbackup
```
find
-----
```
# Find file > 4GB
find /var/log/ -xdev -size +4096 -exec ls -l {} \;| awk '{print $5/1024/1024, $1, $2, $3, $4, $6, $7, $8, $9}'| sort -nr| head -25

# Find dm mapping
find /dev/ -name "dm-*" -exec readlink -n {} \; -exec echo " -->" {} \;

# Find occurence in all .htaccess file
find /www/apache2/ -type f -name '.htaccess' | xargs fgrep 'occurence'

# Find pattern in file changed 1 day ago
find /var/log/apache2/ -mtime -1 -name "*.log" -print0 | xargs -0 grep -R pattern 
```
SSH
----
```
# Check if the key is a key
ssh-keygen -l -f id_rsa.pub 
# Show key size and algorithm.
ssh-keygen -l -f <file> 
# generate pubkey for verification
ssh-keygen -y -f id_rsa 

# Remove a key from known_hosts
ssh-keygen -f "/root/.ssh/known_hosts" -R "foo.com"
ssh-keygen -H -F foo.com

# pssh with sshpass
/usr/bin/sshpass -f ~/xxx parallel-ssh -h /tmp/hostfile.txt -t 10 -A -l username -i -O StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null uptime 2> /dev/null
```
PERL
----
```
cpan -l
perldoc perllocal | grep Module
```
tmux
-----
```
Ctrl+b " - split pane horizontally.
Ctrl+b % - split pane vertically.
Ctrl+b arrow key — switch pane.
Hold Ctrl+b, don’t release it and hold one of the arrow keys — resize pane.
Ctrl+b c - (c)reate a new window.
Ctrl+b n - move to the (n)ext window.
Ctrl+b p - move to the (p)revious window.
Ctrl+b } { - Rotate pane
Ctrl+b space - Horizontal to vertical
Ctrl+b alt+o - swap pane

# Create a new session with name
Ctrl-b :new -s <name>
tmux new -s <name>

# Swith interactively session
Ctrl-b s

#Killing pane
Ctrl-b x 

#Killing window
Ctrl-b &

tmux new -s session_name
tmux attach -t session_name
tmux switch -t session_name
tmux list-sessions
tmux detach (prefix + d)
```

chrome
------
```
chrome://net-internals/#hsts
```
GPG
---
```
# Encrypt .file to .file.gpg with symmetric password
gpg  --output .file.gpg  --symmetric .file
```

Git
----
```
# Remove merged branch interactivelly with vim. Be carefull to not remove master
git branch --merged >/tmp/merged-branches && \
  vi /tmp/merged-branches && xargs git branch -d < /tmp/merged-branches

# Remove all branche exept master.
git branch --merged master | grep -v '^[ *]*master$' | xargs git branch -d

# Undo last commit
git reset --soft HEAD~1

git diff --name-only
git diff --color-words

git clone -c http.sslverify=false
git config --global http.proxy http://hostname:port

GIT_SSH_COMMAND='ssh -i private_key_file -o IdentitiesOnly=yes' git clone user@host:repo.git

git tag <tag_name> <commit_hash>
git push --tags

# Delete tag remote 
git push --delete origin v0.1

git tag -d v0.1
git branch --contains xx

git update-index --assume-unchanged vim/.vim/.netrwhist
git update-index --no-assume-unchanged #Revert back
```

lsof
----
```
# List listen socket TCP
lsof -i TCP:443
lsof -nP -iTCP -sTCP:LISTEN
```
ss
---
```
# TCP port open
ss -tunlp
```
Windows
-------
```
#Nat
Add-NetNatStaticMapping  -NatName NATNetwork  -Protocol TCP  -ExternalIPAddress 0.0.0.0/24  -ExternalPort 80  -InternalIPAddress 10.0.0.3  -InternalPort 80
```

Curl
-----
```
 curl -w "@curl-format.txt" -o /dev/null -s "http://wordpress.com/"

     time_namelookup:  %{time_namelookup}s\n
        time_connect:  %{time_connect}s\n
     time_appconnect:  %{time_appconnect}s\n
    time_pretransfer:  %{time_pretransfer}s\n
       time_redirect:  %{time_redirect}s\n
  time_starttransfer:  %{time_starttransfer}s\n
                     ----------\n
          time_total:  %{time_total}s\n
```
Vim
----
```
# vimdiff disable color
TERM=vt100 vimdiff or set t_Co=0

:%!jq . # One line to good format
:%!column -t # Nice collumn
```
journalctl
----------
```
journalctl --since "1 hour ago"
journalctl  --since "2023-03-10 00:00"
journalctl -u metricbeat -n 100 --no-pager
journalctl -b -1
journalctl --since "2015-06-26 23:15:00" --until "2015-06-26 23:20:00"
```
Regex
-----
```
#^((?!SUN).)*$
```
ZFS
----
```
# Delete ZFS snapshots
#zfs destroy -R lxd_pool/containers/${TARGET}_diskint@os 

# List snapshot
zfs list -t snapshot | grep <hostname>

# Restore LXC with ZFS snapshot
lxc restore $TARGET os ; for i in `zfs list -t snapshot | grep $TARGET | awk '{print $1}'`; do echo zfs rollback $i; done 

# Set quota to pool
zfs set quota=10G lxd_pool/containers/xxxx_diskint/home
```
LXC
---
```
# Take snapshot of a container
lxc snapshot xxxxx backup_name

# Delete LXC container
lxc delete ${TARGET}

#Delete LXC snapshot

lxc delete $HOST/<snapshot> 

# Stop container
lxc-stop -n containerNameHere --kill

# Set cpu limit
lxc config set <hostname> limits.cpu 8
```
apache
------
```
apachectl -v
```
grep
----
```
# grep IP
grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}'
```
Solaris
--------
```
# agregat
dladm show-aggr -L
dladm show-dev:w
```
Tcpdump
--------
```
tcpdump -i eth0 dst x.x.x.x and src x.x.x.x and src port 80 -w xx.pcap
```
