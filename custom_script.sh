#!/usr/bin/env bash

# echo -e "${G}########## Mounting drives ##########"
# sudo sh -c 'echo "
# UUID=6E9781F365706FF3	/mnt/Entertainment	ntfs	defaults	0	0
# UUID=7796BF99038EDBCE	/mnt/Program		ntfs	defaults	0	0
# " >>/etc/fstab'

# echo -e "${G}############### Updating DNS ############"
# sudo apt install -y systemd-resolved
# sudo sh -c 'echo "
# DNS=45.90.28.0#******.dns.nextdns.io
# DNS=2a07:a8c0::#******.dns.nextdns.io
# DNS=45.90.30.0#******.dns.nextdns.io
# DNS=2a07:a8c1::#******.dns.nextdns.io
# DNSOverTLS=yes
# " >>/etc/systemd/resolved.conf'
# sudo systemctl enable systemd-resolved.service
# sudo service NetworkManager restart