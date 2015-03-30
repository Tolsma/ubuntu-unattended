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

#clear

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


# update repos
#apt-get -y update > /dev/null 2>&1
#apt-get -y upgrade > /dev/null 2>&1
#apt-get -y dist-upgrade > /dev/null 2>&1
#apt-get -y autoremove > /dev/null 2>&1
#apt-get -y purge > /dev/null 2>&1

# remove myself to prevent any unintended changes at a later stage
#rm $0

# finish
echo " DONE... "