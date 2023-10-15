# Instructions

## Prerequisites

Before you begin, ensure the following prerequisites are met:

1. Create a file named `ip_list.txt` containing the actual IP addresses of your Cloudlab nodes. (Always end with a newline \n)

2. Ensure you have access to Cloudlab without requiring an SSH passphrase.

-  _Remove ssh key passphrase to avoid halts due to interactive input_
- _ssh-keygen -p -f ~/.ssh/your-key_ 


3. Verify that `tmux` is installed and working on your local machine.

## Usage

### Clone the repository

```shell
git clone https://github.com/vhive-serverless/sosp-tutorial-infra-setup/
cd sosp-tutorial-infra-setup
```

### Give executable permissions

```shell
find . -name "*.sh" -type f -exec chmod +x {} ;
```


### Run the top script

Run the script with the following command-line options:

- -q <Number_of_quickstart_VMs>: Number of Quickstart VMs to set up.
- -v <Number_of_invitro_VMs>: Number of Invitro VMs to set up.
- -u <Cloudlab_User>: Your Cloudlab user.

Example usage:

```shell
./cloud-lab-vm-setup.sh -q 5 -v 3 -u myuser
```

This would create separate tmux sessions that run in parallel for each Cloudlab node.

You can view the progress by running these commands:

```shell
tmux list-sessions
tmux attach -t {session_name}
```

This might take around ~5 minutes to be completed.
Once the tmux sessions have been terminated, you can access your VMs on each node as follows:

### Accessing Quickstart VMs

For quickstart VMs, ports would be assigned from 10001 onwards.

Example:

Quickstart VM 01:

```shell
ssh vhive@{CLOUD_LAB_IP} -p 10001
Password: vhive-sosp
```

Quickstart VM 02:
```shell
ssh vhive@{CLOUD_LAB_IP} -p 10002
Password: vhive-sosp
```

### Accessing Invitro VMs

For invitro VMs, ports would be assigned from 20001 onwards.

Example:

Invitro VM 01:

```shell
ssh invitro@{CLOUD_LAB_IP} -p 20001
Password: invitro-sosp
```

Invitro VM 02:
```shell
ssh invitro@{CLOUD_LAB_IP} -p 20002
Password: invitro-sosp
```


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