#!/bin/bash

pve3hosts=( "tunnel-3" "tdarr-2" )


for host in ${pve3hosts[@]}; do
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


ssh root@pve3.local 'apt update && apt dist-upgrade -y'
