#!/bin/csh
if ($#argv != 1) then
	echo "Use: $0 jailName"
	exit 0
else
    ##PRE
    ##pkg install diffutils wget
    set JAIL = "$1"
    set JAILMOUNTPOINT = "/mnt/jails"
    set CONFIGS = "config"
    service jail restart $JAIL
    pkg -j $JAIL install dnsmasq
    echo dnsmasq_enable="YES" >> $JAILMOUNTPOINT/$JAIL/etc/rc.conf
    # create required directories
    # mkdir /usr/local/etc/{dnsmasq.conf,hosts}.d
    # create a new file for hosts & addresses
    cp $CONFIGS/10-custom.conf $JAILMOUNTPOINT/$JAIL/usr/local/etc/dnsmasq.conf.d/
    ##Check with diff before copy
    ##diff $CONFIGS/dnsmasq_rcd $JAILMOUNTPOINT/$JAIL/usr/local/etc/rc.d/dnsmasq
    ##diff $CONFIGS/dnsmasq_conf $JAILMOUNTPOINT/$JAIL/usr/local/etc/dnsmasq.conf
    cp $CONFIGS/dnsmasq_rcd $JAILMOUNTPOINT/$JAIL/usr/local/etc/rc.d/dnsmasq
    cp $CONFIGS/dnsmasq_conf $JAILMOUNTPOINT/$JAIL/usr/local/etc/dnsmasq.conf
    # grab some configs
    wget --no-check-certificate https://raw.githubusercontent.com/acidwars/AdBlock-Lists/master/adblock.conf -O /usr/local/etc/dnsmasq.conf.d/20-adblock.conf
    wget --no-check-certificate https://raw.githubusercontent.com/acidwars/AdBlock-Lists/master/ads01.conf -O /usr/local/etc/dnsmasq.conf.d/21-ads01.conf
    wget --no-check-certificate https://raw.githubusercontent.com/notracking/hosts-blocklists/master/domains.txt -O /usr/local/etc/dnsmasq.conf.d/22-blocklists.conf
    # grab some hosts
    wget --no-check-certificate https://raw.githubusercontent.com/r-a-y/mobile-hosts/master/AdguardDNS.txt -O /usr/local/etc/hosts.d/adguard
    wget --no-check-certificate https://raw.githubusercontent.com/r-a-y/mobile-hosts/master/AdguardMobileAds.txt -O /usr/local/etc/hosts.d/adguard-mobile
    ##POST
    ##Pass port from jail to host with pf or prefered firewall
    ##Test config
    ##  dnsmasq --test #ON JAIL
    ##Check config
    ##  dnsmasq -d -q #ON JAIL
    ##  drill freebsd.org @ipjail #ON HOST
    ##Start service
    ##  service dnsmasq start
endif
