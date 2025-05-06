#!/bin/bash

pve1hosts=( "tunnel1" "avery-kuma" "cockpit" "sabnzbd" "qbit" "tdarr" "overseerr" "plex" "servarr" "minecraft" )
pve2hosts=( "homepage" "whoogle" "firefox" "pihole" "ddns" "nextcloud" "kuma" "guac" "tunnel-2" "nginx" "vault" "tdarr-1" "beeguard" )
pve3hosts=( "tunnel-3" "tdarr-2" )

copy () {
  for host in "${1[@]}"; do
    ssh-copy-id root@$host
  done
}

copy $pve1hosts
copy $pve2hosts
copy $pve3hosts
