#!/bin/bash
set +x

read -p "Which host would you like to update? [pve1/pve2/pve3] " choice

if [[ $choice == "pve1" ]]; then
    ssh root@pve1.local 'bash <(wget -qO- https://github.com/pr0gsn0b/PVE-Updates/raw/refs/heads/main/pve1-updates.sh)'
elif [[ $choice == "pve2" ]]; then
    ssh root@pve2.local 'bash <(wget -qO- https://github.com/pr0gsn0b/PVE-Updates/raw/refs/heads/main/pve2-updates.sh)'
elif [[ $choice == "pve3" ]]; then
    ssh root@pve3.local 'bash <(wget -qO- https://github.com/pr0gsn0b/PVE-Updates/raw/refs/heads/main/pve3-updates.sh)'
else 
    echo "Invalid Input."
fi

