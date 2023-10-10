# Instructions

## Usage
Run the script with the following command-line options:

- -q <Number_of_quickstart_VMs>: Number of Quickstart VMs to set up.
- -v <Number_of_invitro_VMs>: Number of Invitro VMs to set up.
- -u <Cloudlab_User>: Your Cloudlab user.

Example usage:

``` ./cloudlab-vm-setup.sh -q 5 -v 3 -u myuser ```

## Important Note
Please make sure to create a file `ip_list.txt` with your actual IP addresses of Cloudlab nodes.
Make sure a folder named `cloud-init-files` exists with required configuration for VMs.

## Individual Script Usage
### Setup Individual Cloudlab Nodes 

Usage: ``` ./setup-node.sh <ip> <cloudlab-user> ```

- Create guest user account to SSH 
    - ``` ssh guest@123.123.123.123 ```
    - ```password : guest```
- Install multipass

### Add VMs to a Specific Cloudlab Node
Usage: ``` ./add-vms.sh -q <Number_of_quickstart_VMs> -v <Number_of_invitro_VMs> -u <Cloudlab_User> -i <VM_IP> ```

Default SSH Credentials for VMs
- Invitro VMs
    -  ``` username : invitro ```
    - ``` password : invitro-sosp```
- Quickstart VMs
   -  ``` username : vhive ```
    - ``` password : vhive-sosp```

