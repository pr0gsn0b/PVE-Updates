#!/bin/bash

pve1hosts=( "tunnel1" "avery-kuma" "cockpit" "sabnzbd" "qbit" "tdarr" "overseerr" "plex" "servarr" "minecraft" )
pve2hosts=( "homepage" "whoogle" "firefox" "pihole2" "ddns" "nextcloud" "kuma" "guac" "tunnel-2" "nginx" "vault" "tdarr-1" "beeguard" )
pve3hosts=( "tunnel-3" "tdarr-2" )


for host in ${pve1hosts[@]}; do
  ssh-copy-id root@$host.local
done

for host in ${pve2hosts[@]}; do
  ssh-copy-id root@$host.local
done

for host in ${pve3hosts[@]}; do
  ssh-copy-id root@$host.local
done
