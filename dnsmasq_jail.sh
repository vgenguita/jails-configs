#!/bin/sh

# DNSMasq Jail Setup Script for FreeBSD/TrueNAS
# Original script by vgenguita

if [ "$#" -ne 1 ]; then
    echo "Use: $0 jailName"
    exit 0
else
    ##PRE
    ##pkg install diffutils wget
    JAIL="$1"
    JAILMOUNTPOINT="/usr/local/jails/containers/$1"
    CONFIGS="config"
    
    service jail restart "$JAIL"
    pkg -j "$JAIL" install dnsmasq
    
    # Enable service in rc.conf
    echo 'dnsmasq_enable="YES"' >> "$JAILMOUNTPOINT/$JAIL/etc/rc.conf"
    
    # create required directories
    # mkdir /usr/local/etc/{dnsmasq.conf,hosts}.d
    # create a new file for hosts & addresses
    #cp $CONFIGS/10-custom.conf $JAILMOUNTPOINT/$JAIL/usr/local/etc/dnsmasq.conf.d/
    
    ##Check with diff before copy
    ##diff $CONFIGS/dnsmasq_rcd $JAILMOUNTPOINT/$JAIL/usr/local/etc/rc.d/dnsmasq
    ##diff $CONFIGS/dnsmasq_conf $JAILMOUNTPOINT/$JAIL/usr/local/etc/dnsmasq.conf
    cp "$CONFIGS/dnsmasq_rcd" "$JAILMOUNTPOINT/$JAIL/usr/local/etc/rc.d/dnsmasq"
    cp "$CONFIGS/dnsmasq_conf" "$JAILMOUNTPOINT/$JAIL/usr/local/etc/dnsmasq.conf"
    
    # grab some configs
    wget --no-check-certificate https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/dnsmasq/fake.txt -O "$JAILMOUNTPOINT/$JAIL/usr/local/etc/dnsmasq.conf.d/00-blockListFakeUrl.conf"
    wget --no-check-certificate https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/dnsmasq/popupads.txt -O "$JAILMOUNTPOINT/$JAIL/usr/local/etc/dnsmasq.conf.d/01-blockListPopUpUrl.conf"
    wget --no-check-certificate https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/dnsmasq/anti.piracy.txt -O "$JAILMOUNTPOINT/$JAIL/usr/local/etc/dnsmasq.conf.d/03-blockListAntiPiracy.conf"
    wget --no-check-certificate https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/dnsmasq/gambling.txt -O "$JAILMOUNTPOINT/$JAIL/usr/local/etc/dnsmasq.conf.d/04-blockListGambling.conf"
    wget --no-check-certificate https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/dnsmasq/native.amazon.txt -O "$JAILMOUNTPOINT/$JAIL/usr/local/etc/dnsmasq.conf.d/05-blockListTrackingApple.conf"
    wget --no-check-certificate https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/dnsmasq/native.winoffice.txt -O "$JAILMOUNTPOINT/$JAIL/usr/local/etc/dnsmasq.conf.d/06-blockListTrackingMicrosoft.conf"
    wget --no-check-certificate https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/dnsmasq/native.tiktok.txt -O "$JAILMOUNTPOINT/$JAIL/usr/local/etc/dnsmasq.conf.d/07-blockListTrackingTikTok.conf"
    wget --no-check-certificate https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/dnsmasq/native.lgwebos.txt -O "$JAILMOUNTPOINT/$JAIL/usr/local/etc/dnsmasq.conf.d/08-blockListTrackingLgWebOS.conf"
    wget --no-check-certificate https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/dnsmasq/native.oppo-realme.txt -O "$JAILMOUNTPOINT/$JAIL/usr/local/etc/dnsmasq.conf.d/09-blockListTrackingOppoRealme.conf"
    wget --no-check-certificate https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/dnsmasq/native.xiaomi.txt -O "$JAILMOUNTPOINT/$JAIL/usr/local/etc/dnsmasq.conf.d/10-blockListTrackingXiaomi.conf"
    wget --no-check-certificate https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/dnsmasq/native.amazon.txt -O "$JAILMOUNTPOINT/$JAIL/usr/local/etc/dnsmasq.conf.d/11-blockListTrackingAmazon.conf"

    # grab some hosts
    #wget --no-check-certificate https://raw.githubusercontent.com/r-a-y/mobile-hosts/master/AdguardDNS.txt -O $JAILMOUNTPOINT/$JAIL/usr/local/etc/hosts.d/adguard
    #wget --no-check-certificate https://raw.githubusercontent.com/r-a-y/mobile-hosts/master/AdguardMobileAds.txt -O $JAILMOUNTPOINT/$JAIL/usr/local/etc/hosts.d/adguard-mobile
    
    ##POST
    ##Pass port from jail to host with pf or prefered firewall
    ##Test config
    ##  dnsmasq --test #ON JAIL
    ##Check config
    ##  dnsmasq -d -q #ON JAIL
    ##  drill freebsd.org @ipjail #ON HOST
    ##Start service
    ##  service dnsmasq start
    echo 'dnsmasq_enable="YES"' >> "$JAILMOUNTPOINT/$JAIL/etc/rc.conf"
    echo 'dnsmasq_conf="/usr/local/etc/dnsmasq.conf"' >> "$JAILMOUNTPOINT/$JAIL/etc/rc.conf"
fi