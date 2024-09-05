#!/bin/bash

# Author: 7uu13
# +rep yyrike for the idea

ANSIBLE_HOSTS_FILE="/home/admin-johan/projects/ica0002/hosts"
URL="http://193.40.156.67/students/7uu13.html"  

# Fetch the new port from the website
NEW_PORT=(curl -s $URL | grep -oP 'port\s*\K\d+')

# Check if the port was retrieved successfully
if [[ -z "$NEW_PORT" ]]; then
  echo "Failed to fetch the new port from the website."
  exit 1
fi

echo "Fetched new port: $NEW_PORT"

# Update the ansible_port in the Ansible hosts file
sed -i "s/ansible_port=[0-9]\+/ansible_port=$NEW_PORT/g" "$ANSIBLE_HOSTS_FILE"

echo "Ansible port updated successfully in $ANSIBLE_HOSTS_FILE."
