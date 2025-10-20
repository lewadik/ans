# Ultra Light Ansible Project

Minimal Ansible setup with single-file roles for maximum simplicity and speed.

## Project Structure

```
my-ansible-project/
├── ansible.cfg          # Ansible configuration
├── inventory/
│   └── hosts.yml       # Target hosts
├── playbooks/          # Ultra light playbooks (6-18 lines each)
│   ├── light-site.yml  # Basic setup
│   ├── light-traffmonetizer.yml # TrafficMonetizer
│   ├── light-gost.yml  # GOST proxy
│   └── light-all.yml   # All-in-one
├── roles/              # Single-file roles (10-40 lines each)
│   ├── common.yml      # System setup
│   ├── docker.yml      # Docker install
│   ├── traffmonetizer.yml # Container deploy
│   └── gost-proxy.yml  # Proxy server
├── vault-light.yml.example # Credentials template
└── README.md           # This file
```

## Quick Start

1. **Setup credentials**:
   ```bash
   cp vault-light.yml.example vault.yml
   nano vault.yml  # Add your tokens/passwords
   ansible-vault encrypt vault.yml
   ```

2. **Deploy services**:
   ```bash
   # Basic system + Docker
   ansible-playbook playbooks/light-site.yml
   
   # TrafficMonetizer
   ansible-playbook playbooks/light-traffmonetizer.yml --ask-vault-pass
   
   # GOST Proxy
   ansible-playbook playbooks/light-gost.yml --ask-vault-pass
   
   # All services at once
   ansible-playbook playbooks/light-all.yml --ask-vault-pass \
     -e "deploy_traffmonetizer=true deploy_gost=true"
   ```

## Ultra Light Roles

### `roles/common.yml` (10 lines)
- Installs: git, curl, vim, wget, htop
- Creates /opt/common directory

### `roles/docker.yml` (35 lines)  
- Multi-platform Docker installation (Ubuntu/Debian + CentOS/RHEL)
- Adds user to docker group
- Starts and enables service

### `roles/traffmonetizer.yml` (20 lines)
- Validates Docker installation
- Deploys TrafficMonetizer container with token
- Uses restart policy: unless-stopped

### `roles/gost-proxy.yml` (40 lines)
- Downloads GOST binary from curl.ge/gost
- Creates systemd service with credentials
- Shows public IP and proxy URL

## Vault Configuration

Simple 3-line vault file:
```yaml
vault_traffmonetizer_token: "your_token"
vault_gost_username: "your_username"  
vault_gost_password: "your_password"
```

## Usage Examples

```bash
# Quick system setup
ansible-playbook playbooks/light-site.yml

# Deploy specific services
ansible-playbook playbooks/light-traffmonetizer.yml --ask-vault-pass
ansible-playbook playbooks/light-gost.yml --ask-vault-pass

# Use tags for selective deployment
ansible-playbook playbooks/light-all.yml --tags "docker" 
ansible-playbook playbooks/light-all.yml --tags "gost" --ask-vault-pass

# Deploy everything
ansible-playbook playbooks/light-all.yml --ask-vault-pass \
  -e "deploy_traffmonetizer=true deploy_gost=true"
```

## Benefits

✅ **Ultra Minimal**: Total of 105 lines across all roles  
✅ **No Dependencies**: Each role is completely self-contained  
✅ **Fast Execution**: Minimal overhead, maximum speed  
✅ **Easy to Understand**: Simple, readable code  
✅ **Portable**: Copy any single file to use elsewhere  
✅ **Secure**: Vault-based credential management

## License

MIT