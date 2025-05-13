#!/bin/bash
set +x

pve1hosts=( "tunnel1" "avery-kuma" "cockpit" "sabnzbd" "qbit" "tdarr" "overseerr" "plex" "servarr" "minecraft" )
pve2hosts=( "homepage" "whoogle" "firefox" "pihole2" "ddns" "nextcloud" "kuma" "guac" "tunnel-2" "nginx" "vault" "tdarr-1" "beeguard" )
pve3hosts=( "tunnel-3" "tdarr-2" )

func () {
    echo -e "\e[1;93m#######################\e[0m"
    echo -e "\e[1;93m# Updating $1 group #\e[0m"
    echo -e "\e[1;93m#######################\e[0m"

    shift
    for host in "$@"; do
        echo -e "\e[1;94m>>> Connecting to $host <<<\e[0m"
        ssh -tt root@"$host".local <<'EOT'
            if grep -iq debian /etc/os-release || grep -iq ubuntu /etc/os-release; then
                echo -e "\e[1;92m>>> Updating system for $(hostname) <<<\e[0m"
                apt update && apt upgrade -y
                apt autoremove -y
            elif grep -iq alpine /etc/os-release; then
                echo -e "\e[1;92m>>> Updating system for $(hostname) <<<\e[0m"
                apk update && apk upgrade
            fi

            if command -v docker > /dev/null 2>&1; then
                echo -e "\e[1;94m>>> Updating docker images for $(hostname) <<<\e[0m"
                for ct in /home/*/; do
                    cd "$ct"
                    docker compose pull
                    docker compose up -d
                done
                docker image prune -f
            fi

            case $(hostname) in
                guacamole)
                    service docker restart
                    ;;
                pihole)
                    echo -e "\e[1;91m>>> Updating pihole <<<\e[0m"
                    pihole -up
                    ;;
            esac
            exit
EOT
    done
}

update_pve_node () {
    local node=$1
    echo -e "\e[1;96m>>> Updating Proxmox node: $node <<<\e[0m"
    ssh -tt root@"$node".local <<EOT
        echo -e "\e[1;93m>>> Updating system for $node <<<\e[0m"
        apt update && apt-get dist-upgrade -y
        case "$node" in
            pve1)
                zfs list && zpool status
                ;;
        esac
        exit
EOT
}

read -ep "\e[1;96mWhich host would you like to update? [pve1/pve2/pve3/all] \e[0m" choice

case $choice in
    "pve1")
        func "pve1" "${pve1hosts[@]}"
        update_pve_node "pve1"
        ;;
    "pve2")
        func "pve2" "${pve2hosts[@]}"
        update_pve_node "pve2"
        ;;
    "pve3")
        func "pve3" "${pve3hosts[@]}"
        update_pve_node "pve3"
        ;;
    "all")
        func "pve1" "${pve1hosts[@]}"
        func "pve2" "${pve2hosts[@]}"
        func "pve3" "${pve3hosts[@]}"
        update_pve_node "pve3"
        update_pve_node "pve2"
        update_pve_node "pve1"
        ;;
    *)
        echo "Invalid input."
        exit 1
        ;;
esac
