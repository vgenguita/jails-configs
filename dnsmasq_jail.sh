#!/bin/bash

# Configuration
jailName="dnsmasq"
jailMountPoint="/mnt/$(iocage get -p)/iocage/jails/${jailName}/root"
dnsmasqConfDir="usr/local/etc/dnsmasq.d"

# Blocklist URLs
blockListFakeUrl='https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/dnsmasq/fake.txt'
blockListPopUpUrl='https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/dnsmasq/popupads.txt'
blockListAntiPiracy='https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/dnsmasq/anti.piracy.txt'
blockListGambling='https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/dnsmasq/gambling.txt'
blockListTrackingApple='https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/dnsmasq/native.amazon.txt'
blockListTrackingMicrosoft='https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/dnsmasq/native.winoffice.txt'
blockListTrackingTikTok='https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/dnsmasq/native.tiktok.txt'
blockListTrackingLgWebOS='https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/dnsmasq/native.lgwebos.txt'
blockListTrackingOppoRealme='https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/dnsmasq/native.oppo-realme.txt'
blockListTrackingXiaomi='https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/dnsmasq/native.xiaomi.txt'
blockListTrackingAmazon='https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/dnsmasq/native.amazon.txt'

# Create the jail if it doesn't exist
if ! iocage list | grep -q "${jailName}"; then
    echo "Creating jail ${jailName}..."
    iocage create -n "${jailName}" -r 13.2-RELEASE dhcp=on bpf=yes vnet=on
fi

# Start the jail
iocage start "${jailName}"

# Install dnsmasq inside the jail
iocage exec "${jailName}" pkg install -y dnsmasq

# Create dnsmasq.d directory
iocage exec "${jailName}" mkdir -p "/${dnsmasqConfDir}"

# Download blocklists to individual files
echo "Downloading blocklists..."
curl -L "${blockListFakeUrl}" -o "${jailMountPoint}/${dnsmasqConfDir}/00-blockListFakeUrl.conf"
curl -L "${blockListPopUpUrl}" -o "${jailMountPoint}/${dnsmasqConfDir}/01-blockListPopUpUrl.conf"
curl -L "${blockListAntiPiracy}" -o "${jailMountPoint}/${dnsmasqConfDir}/03-blockListAntiPiracy.conf"
curl -L "${blockListGambling}" -o "${jailMountPoint}/${dnsmasqConfDir}/04-blockListGambling.conf"
curl -L "${blockListTrackingApple}" -o "${jailMountPoint}/${dnsmasqConfDir}/05-blockListTrackingApple.conf"
curl -L "${blockListTrackingMicrosoft}" -o "${jailMountPoint}/${dnsmasqConfDir}/06-blockListTrackingMicrosoft.conf"
curl -L "${blockListTrackingTikTok}" -o "${jailMountPoint}/${dnsmasqConfDir}/07-blockListTrackingTikTok.conf"
curl -L "${blockListTrackingLgWebOS}" -o "${jailMountPoint}/${dnsmasqConfDir}/08-blockListTrackingLgWebOS.conf"
curl -L "${blockListTrackingOppoRealme}" -o "${jailMountPoint}/${dnsmasqConfDir}/09-blockListTrackingOppoRealme.conf"
curl -L "${blockListTrackingXiaomi}" -o "${jailMountPoint}/${dnsmasqConfDir}/10-blockListTrackingXiaomi.conf"
curl -L "${blockListTrackingAmazon}" -o "${jailMountPoint}/${dnsmasqConfDir}/11-blockListTrackingAmazon.conf"

# Configure dnsmasq to use the .d directory
iocage exec "${jailName}" bash -c "cat <<EOF > /usr/local/etc/dnsmasq.conf
conf-dir=/${dnsmasqConfDir}/,.conf
port=53
domain-needed
bogus-priv
no-resolv
server=1.1.1.1
server=1.0.0.1
EOF"

# Enable and start dnsmasq
iocage exec "${jailName}" sysrc dnsmasq_enable="YES"
iocage exec "${jailName}" service dnsmasq restart

echo "dnsmasq jail is set up and blocklists are updated."