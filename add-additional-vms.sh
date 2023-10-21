#!/bin/bash

while getopts "q:v:u:i:" opt; do
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
    i)
      VM_IP="$OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

# Check if the required options are provided
if [ -z "$NUM_QUICKSTART_VMS" ] || [ -z "$NUM_INVITRO_VMS" ] || [ -z "$SSH_USER" ] || [ -z "$VM_IP" ]; then
  echo "Usage: $0 -q <Number_of_quickstart_VMs> -v <Number_of_invitro_VMs> -u <Cloudlab_User> -i <VM_IP>"
  exit 1
fi

# ADD VMS and Setup SSH Tunnel

./add-vms.sh -i $VM_IP -v $NUM_INVITRO_VMS -q $NUM_QUICKSTART_VMS -u $SSH_USER && ./setup-ssh-tunnel.sh $VM_IP $SSH_USER