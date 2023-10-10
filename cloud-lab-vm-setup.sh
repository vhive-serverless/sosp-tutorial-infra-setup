#!/bin/bash

# Remove ssh key passphrase to avoid halts due to interactive input
# ssh-keygen -p -f ~/.ssh/your-key

while getopts "q:v:u:" opt; do
  case $opt in
    q)
      NUM_QUICKSTART_VMS="$OPTARG"
      ;;
    v)
      NUM_INVITRO_VMS="$OPTARG"
      ;;
    u)
      SSH_USER="$OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

# Check if the required options are provided
if [ -z "$NUM_QUICKSTART_VMS" ] || [ -z "$NUM_INVITRO_VMS" ] || [ -z "$SSH_USER" ]; then
  echo "Usage: $0 -q <Number_of_quickstart_VMs> -v <Number_of_invitro_VMs> -u <Cloudlab_User>"
  exit 1
fi

# Set permissions
chmod +x setup-node.sh
chmod +x add-vms.sh

# Compress Cloud-init files
zip -r cloud-init-files.zip cloud-init-files

# Specify the file containing the list of IP addresses (one per line)
IP_FILE="ip_list.txt"  # Replace with your file name

# Check if the IP file exists
if [ ! -f "$IP_FILE" ]; then
    echo "IP file '$IP_FILE' not found. Please create the file with one IP address per line."
    exit 1
fi

# Loop through each IP address in the file and create a tmux session
while IFS= read -r ip; do
    # Create a unique tmux session name based on the IP address
    session_name="vm_${ip//./_}"

    # Create a new tmux session with a window running the script
    tmux new-session -d -s "$session_name" "./setup-node.sh $ip $SSH_USER && ./add-vms.sh -i $ip -v $NUM_QUICKSTART_VMS -q $NUM_QUICKSTART_VMS -u $SSH_USER"

done < "$IP_FILE"