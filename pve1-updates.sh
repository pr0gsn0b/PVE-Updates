#!/bin/bash

pve1hosts=( "tunnel1" "avery-kuma" "cockpit" "sabnzbd" "qbit" "tdarr" "overseerr" "plex" "servarr" "minecraft" )
pve2hosts=( "homepage" "whoogle" "firefox" "pihole2" "ddns" "nextcloud" "kuma" "guac" "tunnel-2" "nginx" "vault" "tdarr-1" "beeguard" )
pve3hosts=( "tunnel-3" "tdarr-2" )


read -p "Which host would you like to update? [pve1/pve2/pve3]" choice

if [[ $choice != "pve1" && $choice != "pve2" && $choice != "pve3" ]]; then
    echo "Invalid input."
    exit
else
    choice=$choice"hosts"
    exit
fi


for host in ${chosts[@]}; do
    ssh -tt root@$host.local <<'CMD'
    if grep -iq debian /etc/os-release > /dev/null 2>&1; then
        apt update && apt upgrade -y
    elif grep -iq alpine /etc/os-release > /dev/null 2>&1; then
        apk update && apk upgrade
    fi

    if command -v docker > /dev/null 2>&1; then
        for ct in /home/*/; do
            cd "$ct"
            docker compose pull
            docker compose up -d
            docker image prune -f
        done
    fi
    exit
CMD
done


ssh root@pve1.local 'apt update && apt dist-upgrade -y'
