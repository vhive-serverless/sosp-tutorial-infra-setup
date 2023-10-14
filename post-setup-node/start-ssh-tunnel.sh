#!/bin/bash

# Read the text file line by line
while IFS=: read -r name ip port; do
  # Create a unique session name based on IP
  session_name="${ip//./_}"

  # Check if the session already exists
  if ! tmux has-session -t "$session_name" 2>/dev/null; then
    echo $session_name
    # Start a tmux session with the ssh command running in the background
    tmux new-session -d -s "$session_name" "sudo ssh -N -L 0.0.0.0:$port:$ip:22 ubuntu@$ip -i /var/snap/multipass/common/data/multipassd/ssh-keys/id_rsa -o StrictHostKeyChecking=no"
  else
    echo "Session $session_name already exists."
  fi
done < vm_ports_mapping.txt