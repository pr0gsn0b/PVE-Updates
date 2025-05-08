#!/bin/bash

pve1hosts=( "tunnel1" "avery-kuma" "cockpit" "sabnzbd" "qbit" "tdarr" "overseerr" "plex" "servarr" "minecraft" )
pve2hosts=( "homepage" "whoogle" "firefox" "pihole2" "ddns" "nextcloud" "kuma" "guac" "tunnel-2" "nginx" "vault" "tdarr-1" "beeguard" )
pve3hosts=( "tunnel-3" "tdarr-2" )


read -p "Which host would you like to update? [pve1/pve2/pve3]" choice

if [[ $choice == "pve1" ]]; then
    ssh root@pve1.local 'bash <(wget -qO- https://github.com/pr0gsn0b/PVE-Updates/raw/refs/heads/main/pve1-updates.sh)'
elif [[ $choice == "pve2" ]]; then
    ssh root@pve2.local 'bash <(wget -qO- )'
elif [[ $choice == "pve3" ]]; then
    ssh root@pve3.local 'bash <(wget -qO- )'
else 
    echo "Invalid Input."
fi

