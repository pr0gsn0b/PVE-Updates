#!/bin/bash

pve2hosts=( "homepage" "whoogle" "firefox" "pihole" "ddns" "nextcloud" "kuma" "guac" "tunnel-2" "nginx" "vault" "tdarr-1" "beeguard" )



: <<'CMNT'
for host in ${pve2hosts[@]}; do
    ssh-copy-id root@$host.local
done
CMNT



for host in ${pve2hosts[@]}; do
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
        done
    fi
    docker image prune -f
    exit
CMD
done

ssh root@pve2.local 'apt update && apt dist-upgrade -y'
