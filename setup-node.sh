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

# Path to the local cloud-init.yaml file on your client machine
LOCAL_CLOUD_INIT_FILE="cloud-init-files.zip"

# Path to the local post-setup files file on your client machine
LOCAL_POST_SETUP_FILE="post-setup-node.zip"

echo "Copying cloud-init files zip to VM at IP: $VM_IP"

# Use scp to copy the generated cloud-init-files to the remote VM
scp -o StrictHostKeyChecking=no "$LOCAL_CLOUD_INIT_FILE" "$SSH_USER@$VM_IP:/tmp/cloud-init-files.zip"

echo "Copying post setup scripts zip to VM at IP: $VM_IP"

# Use scp to copy the post-setup-scripts to the remote VM
scp -o StrictHostKeyChecking=no "$LOCAL_POST_SETUP_FILE" "$SSH_USER@$VM_IP:/tmp/post-setup-node.zip"

echo "Configuring VM at IP: $VM_IP"

# SSH into the VM without host key checking and perform the remaining setup
ssh -o StrictHostKeyChecking=no "$SSH_USER@$VM_IP" <<EOF

  # Update package repository and install snapd
  sudo apt update
  sudo apt install -y snapd tmux

  # Install Multipass
  sudo snap install multipass

  # Unzip cloudinit files to ~
  sudo unzip -o /tmp/cloud-init-files.zip 

  # Unzip post node setup files to ~
  sudo unzip -o /tmp/post-setup-node.zip 

  # Executable permissions
  find post-setup-node/ -name "*.sh" -type f -exec sudo chmod +x {} \;

  # Unzip cloudinit files to /root/
  sudo unzip -o /tmp/cloud-init-files.zip -d /root/

  # Verify that the files are in /root
  sudo ls -l /root/cloud-init-files/
  
  if !sudo multipass info &>/dev/null; then
      echo "Multipass is not running. Starting Multipass..."
      sudo multipass start
  else
      echo "Multipass is already running."
  fi

  sleep 15
  
EOF

echo "Configuration completed for VM at IP: $VM_IP"