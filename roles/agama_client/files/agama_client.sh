#!/bin/bash

LOG_FILE="/var/log/agama-client.log"

logger() {
    local message="$1"
    local timestamp

    timestamp=$(date +"%Y-%m-%d %H:%M:%S")

    echo "$timestamp - $message" >> "$LOG_FILE"
}

for t in database_url database_name subnet; do
    if ! grep -q "^${t}=" /etc/agama-client/agama-client.conf; then
        logger "$0 Failed to get $t from config"
        exit 1
    fi
done

which fping > /dev/null || { logger "$0 fping not found"; exit 1; }

db_url=$(grep "^database_url=" /etc/agama-client/agama-client.conf | sed 's/^.*=//')
db_name=$(grep "^database_name=" /etc/agama-client/agama-client.conf | sed 's/^.*=//')
subnet=$(grep "^subnet=" /etc/agama-client/agama-client.conf | sed 's/^.*=//')

curl -i -XPOST "$db_url/query" --data-urlencode "q=CREATE DATABASE $db_name" 1>/dev/null 2>/dev/null || { logger "$0 Failed to create database"; exit 1; }
while true; do
    for vm_ip in $(fping -g $subnet -a 2>/dev/null); do
        # Getting content of agama page
        content=$(curl --connect-timeout 1 -w "%{http_code}" -s $vm_ip)
        if test ${content: -3} -ne 200; then
            # nothing to do, going to next student
            continue
        fi
        # Getting where it's hosted
        vm_name=$(echo "$content" | grep "running on" | awk '{print $5}')
        echo $vm_name
        # Number of items in agama
        table_rows=$(echo "$content" | grep -c "</tr>")
        # Write stats to inflixdb
        curl -i -XPOST "${db_url}/write?db=$db_name" --data-binary "agama-stats,name=$vm_name items=$table_rows" 1>/dev/null 2>/dev/null
        # If hostname exists in agama - delete it
        if $(echo "$content" | grep -q $(hostname)); then
            for delete_url in $(echo "$content" | grep $(hostname) | grep -o '/items/.*/swap-state' | sed 's/swap-state/delete/'); do
                curl -s $vm_ip$delete_url -o /dev/null
            done
        fi
        # Add new item to agama
        curl -s -XPOST $vm_ip/items/add -F new_item="Checked from $(hostname) at $(date)" -o /dev/null
    done
    sleep 300
done
