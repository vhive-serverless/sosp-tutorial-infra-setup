#!/bin/bash

# Define the output file name
output_file="vm_ports_mapping.txt"

names=()
ips=()
random_ports=()

# Check if the output file already exists
if [ -f "$output_file" ]; then

  # Read each line from the output file
  while IFS=: read -r name ip random_port; do
    # Add the extracted values to their respective lists
    names+=("$name")
    ips+=("$ip")
    random_ports+=("$random_port")

  done < "$output_file"

  # Display the existing VMs,IPs and their mapped ports
  echo "Names: ${names[*]}"
  echo "IPs: ${ips[*]}"
  echo "Random Ports: ${random_ports[*]}"
else
  echo "Output file does not exist."
fi

# Function to generate a unique port
generate_port_with_offset() {
  local vm_name="$1"
  local vm_offset="$2"
  
  # Extract the last number from the VM name
  last_number=$(echo "$vm_name" | grep -oE '[0-9]+$')
  
  # Calculate the port based on the offset and last number
  port=$((last_number + vm_offset))

  echo "$port"
}

# SSH into the VM and get its IP
sudo multipass list --format csv | tail -n +2 | while IFS=, read -r name state ipv4 dummy1 dummy2 dummy3; do
  if [ "$state" == "Running" ]; then
  
  case "$name" in
      quickstart-vm*)
        port_offset=10000
        ;;
      invitro-vm*)
        port_offset=20000
        ;;
      *)
        continue
        ;;
    esac

    if [[ ! " ${names[*]} " =~ " $name " ]]; then
      echo "Getting a port with offset $port_offset for $name..."
      random_port=$(generate_port_with_offset "$name" "$port_offset")
      echo "Adding $name:$ipv4:$random_port to $output_file"
      echo "$name:$ipv4:$random_port" >> "$output_file"
    else
      echo "$name is in the list."
    fi

  else
    echo "VM $name is not running."
  fi
done

# Display the contents of the output file
cat "$output_file"