#!/bin/bash

pve1hosts=( "tunnel1" "avery-kuma" "cockpit" "sabnzbd" "qbit" "tdarr" "overseerr" "plex" "servarr" "minecraft" )


for host in ${pve1hosts[@]}; do
    ssh -tt root@$host.local <<'CMD'
    if grep -iq debian /etc/os-release > /dev/null 2>&1 || grep -iq ubuntu /etc/os-release > /dev/null 2>&1; then
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


apt-get update && apt-get dist-upgrade -y
zfs list && zpool status
