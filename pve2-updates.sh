#!/bin/bash
set +x

pve2hosts=( "homepage" "whoogle" "firefox" "pihole2" "ddns" "nextcloud" "kuma" "guac" "tunnel-2" "nginx" "vault" "tdarr-1" "beeguard" )


for host in ${pve2hosts[@]}; do
    ssh -tt root@$host.local <<'CMD'
    if grep -iq debian /etc/os-release > /dev/null 2>&1 || grep -iq ubuntu /etc/os-release > /dev/null 2>&1; then
        echo -e "\e[1;92mUpdating system for $(hostname)\e[0m"
        apt update && apt upgrade -y
        apt autoremove -y
    elif grep -iq alpine /etc/os-release > /dev/null 2>&1; then
        echo -e "\e[1;92mUpdating system for $(hostname)\e[0m"
        apk update && apk upgrade
    fi
    

    if command -v docker > /dev/null 2>&1; then
        echo -e "\e[1;94mUpdating docker images for $(hostname)\e[0m"
        for ct in /home/*/; do
            cd "$ct"
            docker compose pull
            docker compose up -d
        done
        docker image prune -f
    fi


    if [[ $(hostname) == "guacamole" ]]; then
        service docker restart
    elif [[ $(hostname) == "pihole" ]]; then
        pihole -up
    fi
    exit
CMD
done

echo -e "\e[1;93mUpdating system for $(hostname)\e[0m"
apt-get update && apt-get dist-upgrade -y
