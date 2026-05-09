#!/bin/sh

# DNSMasq Jail Setup Script for FreeBSD/TrueNAS
# Modified to include multiple Hagezi blocklists

# Configuration
jailName="dnsmasq"
dnsmasqConfDir="/usr/local/etc/dnsmasq.d"
blockListFile="$dnsmasqConfDir/blocklist.conf"

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

echo "Installing dnsmasq..."
pkg install -y dnsmasq

echo "Creating configuration directory..."
mkdir -p $dnsmasqConfDir

echo "Downloading and updating blocklists..."
# Create/Empty the blocklist file
: > "$blockListFile"

# Download each list and append to the main blocklist file
for url in "$blockListFakeUrl" "$blockListPopUpUrl" "$blockListAntiPiracy" "$blockListGambling" \
           "$blockListTrackingApple" "$blockListTrackingMicrosoft" "$blockListTrackingTikTok" \
           "$blockListTrackingLgWebOS" "$blockListTrackingOppoRealme" "$blockListTrackingXiaomi" \
           "$blockListTrackingAmazon"; do
    echo "Fetching $url..."
    fetch -o - "$url" >> "$blockListFile"
done

# Basic dnsmasq configuration
cat <<EOF > /usr/local/etc/dnsmasq.conf
# Main configuration
conf-dir=$dnsmasqConfDir/,.conf
port=53
domain-needed
bogus-priv
no-resolv
server=1.1.1.1
server=1.0.0.1
interface=epair0b
bind-interfaces
EOF

echo "Enabling and starting dnsmasq..."
sysrc dnsmasq_enable="YES"
service dnsmasq restart

echo "Setup complete. DNSMasq is running with the updated blocklists."