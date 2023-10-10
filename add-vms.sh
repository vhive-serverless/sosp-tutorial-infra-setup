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

# SSH into the VM
echo "SSH into the VM at $VM_IP..."
ssh -o StrictHostKeyChecking=no "$SSH_USER@$VM_IP" <<EOF
    # Check if the specified cloud-init files exist in /root/cloud-init-files/
    if sudo [ -f "/root/cloud-init-files/cloud-init-quickstart.yaml" ]; then
        QUICKSTART_CLOUD_INIT="/root/cloud-init-files/cloud-init-quickstart.yaml"
        echo "Cloud-init file for quickstart exists."
    else
        echo "Cloud-init file for quickstart does not exist."
        exit 1
    fi

    if sudo [ -f "/root/cloud-init-files/cloud-init-invitro.yaml" ]; then
        INVITRO_CLOUD_INIT="/root/cloud-init-files/cloud-init-invitro.yaml"
        echo "Cloud-init file for invitro exists."
    else
        echo "Cloud-init file for invitro does not exist."
        exit 1
    fi

    # Create 'quickstart' VMs using multipass
    if [ "$NUM_QUICKSTART_VMS" -gt 0 ]; then
        echo "Creating $NUM_QUICKSTART_VMS 'quickstart' VMs with cloud-init..."
        for ((i=1; i<=$NUM_QUICKSTART_VMS; i++)); do
            sudo multipass launch --name "quickstart-vm\${i}" --cloud-init "\${QUICKSTART_CLOUD_INIT}" -c 4 -m 8G -d 20G 20.04
        done
        echo "$NUM_QUICKSTART_VMS 'quickstart' VMs created successfully."
    fi

    # Create 'invitro' VMs using multipass
    if [ "$NUM_INVITRO_VMS" -gt 0 ]; then
        echo "Creating $NUM_INVITRO_VMS 'invitro' VMs with cloud-init..."
        for ((i=1; i<=$NUM_INVITRO_VMS; i++)); do
            sudo multipass launch --name "invitro-vm\${i}" --cloud-init "\${INVITRO_CLOUD_INIT}" -c 4 -m 8G -d 20G 20.04
        done
        echo "$NUM_INVITRO_VMS 'invitro' VMs created successfully."
    fi
EOF
