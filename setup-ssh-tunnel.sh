#!/bin/bash

# Check if the VM_IP parameter is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <VM_IP>"
  exit 1
fi

# Assign the first command-line argument (VM_IP) to the VM_IP variable
VM_IP="$1"

# Define the SSH username for Cloudlab Account
SSH_USER="$2"

# SSH into the Cloudlab Node without host key checking and perform the SSH tunneling for VMs
ssh -o StrictHostKeyChecking=no "$SSH_USER@$VM_IP" <<EOF

  # Generate port mapping and create vm_ports_mapping.txt file

  ./post-setup-node/generate-port-mapping.sh 

  # Execute port forwarding

  ./post-setup-node/start-ssh-tunnel.sh

EOF
