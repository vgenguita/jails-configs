#!/bin/sh

# DNSMasq Jail Setup Script for FreeBSD/TrueNAS
# Original script by vgenguita

if [ "$#" -ne 1 ]; then
    echo "Use: $0 jailName"
    exit 0
else
    ##PRE
    ##pkg install diffutils
    JAIL="$1"
    JAILMOUNTPOINT="/usr/local/jails/containers/"
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
    mkdir -p "$JAILMOUNTPOINT/$JAIL/usr/local/etc/dnsmasq.conf.d"
    # grab some configs
    fetch https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/dnsmasq/fake.txt -o "$JAILMOUNTPOINT/$JAIL/usr/local/etc/dnsmasq.conf.d/00-blockListFakeUrl.conf"
    fetch https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/dnsmasq/popupads.txt -o "$JAILMOUNTPOINT/$JAIL/usr/local/etc/dnsmasq.conf.d/01-blockListPopUpUrl.conf"
    fetch https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/dnsmasq/anti.piracy.txt -o "$JAILMOUNTPOINT/$JAIL/usr/local/etc/dnsmasq.conf.d/03-blockListAntiPiracy.conf"
    fetch https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/dnsmasq/gambling.txt -o "$JAILMOUNTPOINT/$JAIL/usr/local/etc/dnsmasq.conf.d/04-blockListGambling.conf"
    fetch https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/dnsmasq/native.amazon.txt -o "$JAILMOUNTPOINT/$JAIL/usr/local/etc/dnsmasq.conf.d/05-blockListTrackingApple.conf"
    fetch https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/dnsmasq/native.winoffice.txt -o "$JAILMOUNTPOINT/$JAIL/usr/local/etc/dnsmasq.conf.d/06-blockListTrackingMicrosoft.conf"
    fetch https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/dnsmasq/native.tiktok.txt -o "$JAILMOUNTPOINT/$JAIL/usr/local/etc/dnsmasq.conf.d/07-blockListTrackingTikTok.conf"
    fetch https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/dnsmasq/native.lgwebos.txt -o "$JAILMOUNTPOINT/$JAIL/usr/local/etc/dnsmasq.conf.d/08-blockListTrackingLgWebOS.conf"
    fetch https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/dnsmasq/native.oppo-realme.txt -o "$JAILMOUNTPOINT/$JAIL/usr/local/etc/dnsmasq.conf.d/09-blockListTrackingOppoRealme.conf"
    fetch https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/dnsmasq/native.xiaomi.txt -o "$JAILMOUNTPOINT/$JAIL/usr/local/etc/dnsmasq.conf.d/10-blockListTrackingXiaomi.conf"
    fetch https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/dnsmasq/native.amazon.txt -o "$JAILMOUNTPOINT/$JAIL/usr/local/etc/dnsmasq.conf.d/11-blockListTrackingAmazon.conf"

    # grab some hosts
    #fetch https://raw.githubusercontent.com/r-a-y/mobile-hosts/master/AdguardDNS.txt -o $JAILMOUNTPOINT/$JAIL/usr/local/etc/hosts.d/adguard
    #fetch https://raw.githubusercontent.com/r-a-y/mobile-hosts/master/AdguardMobileAds.txt -o $JAILMOUNTPOINT/$JAIL/usr/local/etc/hosts.d/adguard-mobile
    
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