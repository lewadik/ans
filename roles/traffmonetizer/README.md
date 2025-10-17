# TrafficMonetizer Role

This Ansible role deploys the TrafficMonetizer CLI container using Docker.

## Requirements

- Docker must be installed (use the `docker` role)
- Ansible 2.9+
- Target systems running supported Linux distributions

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
# TrafficMonetizer token - REQUIRED
traffmonetizer_token: "your_token_here"

# Container configuration
traffmonetizer_container_name: tm
traffmonetizer_image: traffmonetizer/cli_v2
traffmonetizer_restart_policy: unless-stopped

# Whether to pull the latest image before running
traffmonetizer_pull_image: true
```

## Dependencies

- `docker` role (automatically included via meta/main.yml)

## Example Playbook

```yaml
- hosts: servers
  become: yes
  roles:
    - role: traffmonetizer
      vars:
        traffmonetizer_token: "DFgXTN5Epi56fp7DN7rtBxXZWSS8J9XQsd4U62I43gQ="
```

## Example with custom container name

```yaml
- hosts: servers
  become: yes
  roles:
    - role: traffmonetizer
      vars:
        traffmonetizer_token: "your_token_here"
        traffmonetizer_container_name: "my-tm-container"
```

## Security Note

**Important**: The TrafficMonetizer token should be stored securely using Ansible Vault or environment variables, not in plain text in your playbooks.

### Using Ansible Vault:
```bash
# Create encrypted variable file
ansible-vault create group_vars/all/vault.yml

# Add your token:
traffmonetizer_token: "your_secret_token"

# Run playbook with vault
ansible-playbook -i inventory/hosts.yml playbooks/site.yml --ask-vault-pass
```

### Using environment variables:
```bash
export TRAFFMONETIZER_TOKEN="your_token_here"
ansible-playbook -i inventory/hosts.yml playbooks/site.yml -e "traffmonetizer_token=$TRAFFMONETIZER_TOKEN"
```

## What this role does

1. Verifies Docker is installed
2. Pulls the TrafficMonetizer CLI image
3. Stops any existing TrafficMonetizer container
4. Runs a new container with the specified token
5. Verifies the container is running

## License

MIT