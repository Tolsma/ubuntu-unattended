#!/bin/bash
set -e

# set defaults
default_hostname="hosting"
default_domain="tolsma.net"

#eth0
default_eth0_ipv4="82.94.249.68"
default_eth0_ipv4netmask="255.255.255.248"
default_ipv4gateway="82.94.249.65"
default_eth0_ipv6="2001:888:2000:47::4000:1"
default_eth0_2ndipv6="2001:888:2000:47::4000:2"
default_eth0_ipv6netmask="64"
default_ipv6gateway="2001:888:2000:47::1"

#eth1
default_eth1_ipv4="10.128.0.150"
default_eth1_ipv4netmask="255.255.255.0"

# DNS resolvers
default_nameservers="194.109.6.66 194.109.9.99"

# temp location
tmp="/home/sander/"

clear

# check for root privilege
if [ "$(id -u)" != "0" ]; then
   echo " this script must be run as root" 1>&2
   echo
   exit 1
fi

# define download function
# courtesy of http://fitnr.com/showing-file-download-progress-using-wget.html
download()
{
    local url=$1
    echo -n "    "
    wget --progress=dot $url 2>&1 | grep --line-buffered "%" | \
        sed -u -e "s,\.,,g" | awk '{printf("\b\b\b\b%4s", $2)}'
    echo -ne "\b\b\b\b"
    echo " DONE"
}

# determine ubuntu version
ubuntu_version=$(lsb_release -cs)

# check for interactive shell
if ! grep -q "noninteractive" /proc/cmdline ; then
    stty sane

    # ask questions
    read -ep " please enter your preferred hostname: " -i "$default_hostname" hostname
    read -ep " please enter your preferred domain: " -i "$default_domain" domain

    # eth0
    read -ep " please enter the IPv4 address of eth0: " -i "$default_eth0_ipv4" eth0_ipv4
    read -ep " please enter the IPv4 Netmask of eth0: " -i "$default_eth0_ipv4netmask" eth0_ipv4netmask
    read -ep " please enter Default IPv4 Gateway (82.94.249.65/82.94.249.73): " -i "$default_ipv4gateway" ipv4gateway
    read -ep " please enter the IPv6 address of eth0 (replace 4000): " -i "$default_eth0_ipv6" eth0_ipv6
    read -ep " please enter the 2nd IPv6 address of eth0 (replace 4000): " -i "$default_eth0_2ndipv6" eth0_2ndipv6
    read -ep " please enter the IPv6 Netmask of eth0: " -i "$default_eth0_ipv6netmask" eth0_ipv6netmask
    read -ep " please enter Default IPv6 Gateway: " -i "$default_ipv6gateway" ipv6gateway

    # eth1
    read -ep " please enter the IP address of eth1: " -i "$default_eth0_ipv4" eth1_ipv4
    read -ep " please enter the Netmask of eth1: " -i "$default_eth0_ipv4netmask" eth1_ipv4netmask

    # DNS resolvers
    read -ep " please enter Nameservers: " -i "$default_nameservers" nameservers

fi

# print status message
echo " preparing your server; this may take a few minutes ..."

# configure network
file="/etc/network/interfaces"
cat << EOF > $file
# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).
# The loopback network interface
auto lo eth0 eth1
iface lo inet loopback

# Configure eth0 ipv4
iface eth0 inet static
address $eth0_ipv4
netmask $eth0_ipv4netmask
#broadcast 82.94.249.71
#network 82.94.249.64
gateway $ipv4gateway

# dns-* options are implemented by the resolvconf package, if installed
dns-search $domain
dns-nameservers $nameservers

# Configure etho ipv6
iface eth0 inet6 static
pre-up /sbin/modprobe -q ipv6 ; /bin/true
address $eth0_ipv6
netmask $eth0_ipv6netmask
up ifconfig eth0 inet6 add $eth0_2ndipv6/$eth0_ipv6netmask
gateway $ipv6gateway

# The second network interface
auto eth1
iface eth1 inet static
address $eth1_ip
netmask $eth1_netmask

EOF
#don't use any space before of after 'EOF' in the previous line

# set fqdn
fqdn="$hostname.$domain"

# update hostname
echo "$hostname" > /etc/hostname
sed -i "s@ubuntu.ubuntu@$fqdn@g" /etc/hosts
sed -i "s@ubuntu@$hostname@g" /etc/hosts
hostname "$hostname"

# reset network interfaces to new config
ifdown lo
ifup lo
ifdown eth0
ifup eth0
ifdown eth1
ifup eth1

# update repos
apt-get -y update > /dev/null 2>&1
apt-get -y upgrade > /dev/null 2>&1
apt-get -y dist-upgrade > /dev/null 2>&1
apt-get -y autoremove > /dev/null 2>&1
apt-get -y purge > /dev/null 2>&1

# install vmware tools package
apt-get -y install open-vm-tools > /dev/null 2>&1

# install all other standard packages

# remove myself to prevent any unintended changes at a later stage
rm $0

# finish
echo " DONE; rebooting ... "

# reboot
reboot