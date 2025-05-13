#!/bin/bash
set +x

pve1hosts=( "tunnel1" "avery-kuma" "cockpit" "sabnzbd" "qbit" "tdarr" "overseerr" "plex" "servarr" "minecraft" )
pve2hosts=( "homepage" "whoogle" "firefox" "pihole2" "ddns" "nextcloud" "kuma" "guac" "tunnel-2" "nginx" "vault" "tdarr-1" "beeguard" )
pve3hosts=( "tunnel-3" "tdarr-2" )

func () {
    echo -e "\e[1;93m#################\e[0m"
    echo -e "\e[1;93m# Updating $choice #\e[0m"
    echo -e "\e[1;93m#################\e[0m"

    for host in "$@"; do
        ssh -tt root@$host.local <<EOT
            if grep -iq debian /etc/os-release > /dev/null 2>&1 || grep -iq ubuntu /etc/os-release > /dev/null 2>&1; then
                echo -e "\e[1;92m>>> Updating system for \$(hostname) <<<\e[0m"
                apt update && apt upgrade -y
                apt autoremove -y
            elif grep -iq alpine /etc/os-release > /dev/null 2>&1; then
                echo -e "\e[1;92m>>> Updating system for \$(hostname) <<<\e[0m"
                apk update && apk upgrade
            fi

            if command -v docker > /dev/null 2>&1; then
                echo -e "\e[1;94m>>> Updating docker images for \$(hostname) <<<\e[0m"
                for ct in /home/*/; do
                    cd "\$ct"
                    docker compose pull
                    docker compose up -d
                done
                docker image prune -f
            fi

            case \$(hostname) in
                "guacamole")
                    service docker restart
                    ;;
                "pihole")
                    echo -e "\e[1;91m>>> Updating pihole <<<\e[0m"
                    pihole -up
                    ;;
            esac
            exit
EOT
    done

    case $choice in
        !"all")
            ssh -tt root@$choice.local <<EOT
                echo -e "\e[1;93m>>> Updating system for $choice <<<\e[0m"
                apt update && apt-get dist-upgrade -y
                case $choice in
                    "pve1")
                        zfs list && zpool status
                        ;;
                esac
                exit
EOT
                ;;
        "all")
            ssh -tt root@pve3.local 'apt update && apt-get dist-upgrade -y'
            ssh -tt root@pve2.local 'apt update && apt-get dist-upgrade -y'
            ssh -tt root@pve1.local 'apt update && apt-get dist-upgrade -y && zfs list && zpool status'
}


read -p "Which host would you like to update? [pve1/pve2/pve3/all] " choice

case $choice in
    "pve1")
        func "${pve1hosts[@]}"
        ;;
    "pve2")
        func "${pve2hosts[@]}"
        ;;
    "pve3")
        func "${pve3hosts[@]}"
        ;;
    "all")
        func "${pve1hosts[@]}"
        func "${pve2hosts[@]}"
        func "${pve3hosts[@]}"
        ;;
    *)
        echo "Invalid input."
        exit
esac
