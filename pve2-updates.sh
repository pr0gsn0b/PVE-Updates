#!/bin/bash

pve2hosts=( "homepage" "whoogle" "firefox" "pihole2" "ddns" "nextcloud" "kuma" "guac" "tunnel-2" "nginx" "vault" "tdarr-1" "beeguard" )


for host in ${pve2hosts[@]}; do
    ssh -tt root@$host.local <<'CMD'
    if grep -iq debian /etc/os-release > /dev/null 2>&1 || grep -iq ubuntu /etc/os-release > /dev/null 2>&1; then
        apt update && apt upgrade -y
        apt autoremove -y
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


apt update && apt dist-upgrade -y
