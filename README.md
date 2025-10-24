# Ultra Light Ansible Project

Minimal Ansible setup with single-file roles for maximum simplicity and speed.

## Project Structure

```
my-ansible-project/
├── ansible.cfg          # Ansible configuration
├── inventory/
│   └── hosts.yml       # Target hosts
├── playbooks/          # Ultra light playbooks
│   └── gost-proxy.yml  # GOST proxy deployment
├── roles/              # Single-file roles (10-40 lines each)
│   ├── common.yml      # System setup
│   ├── gost-proxy.yml  # Proxy server
│   └── traffmonetizer.yml # Container deploy
├── install-docker.yml  # Standalone Docker installer
├── vault-light.yml.example # Credentials template
├── docker-compose.tunnel.yml # Docker tunnel setup
├── tunnel-setup.sh     # Tunnel automation script
├── tunnel-monitor.sh   # Tunnel monitoring
├── systemd-tunnel.service # Systemd service for tunnels
├── wireguard-tunnel.conf # WireGuard configuration
├── TUNNEL-README.md    # Tunnel setup guide
└── README.md           # This file
```

## Quick Start

1. **Setup credentials**:
   ```bash
   cp vault-light.yml.example vault.yml
   nano vault.yml  # Add your tokens/passwords
   ansible-vault encrypt vault.yml
   ```

2. **Install Docker** (standalone):
   ```bash
   # Install Docker on any Linux system
   ansible-playbook install-docker.yml
   ```

3. **Deploy services**:
   ```bash
   # GOST Proxy
   ansible-playbook playbooks/gost-proxy.yml --ask-vault-pass
   
   # TrafficMonetizer (using role directly)
   ansible-playbook -e @vault.yml roles/traffmonetizer.yml --ask-vault-pass
   
   # Common system setup
   ansible-playbook roles/common.yml
   ```

## Available Playbooks & Roles

### `install-docker.yml` (Standalone Playbook)
- Multi-platform Docker installation (Ubuntu/Debian, CentOS/RHEL/Rocky/AlmaLinux, Fedora)
- Installs Docker CE with Docker Compose plugin
- Adds user to docker group and starts service
- Comprehensive OS detection and package management

### `playbooks/gost-proxy.yml` (Full Playbook)
- Deploys GOST proxy with authentication
- Shows connection information and test commands
- Uses vault credentials for security

### Ultra Light Roles

#### `roles/common.yml` (10 lines)
- Installs: git, curl, vim, wget, htop
- Creates /opt/common directory

#### `roles/traffmonetizer.yml` (20 lines)
- Validates Docker installation
- Deploys TrafficMonetizer container with token
- Uses restart policy: unless-stopped

#### `roles/gost-proxy.yml` (40 lines)
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
# Install Docker on target systems
ansible-playbook install-docker.yml

# Quick system setup
ansible-playbook roles/common.yml

# Deploy GOST proxy with full setup
ansible-playbook playbooks/gost-proxy.yml --ask-vault-pass

# Deploy TrafficMonetizer directly
ansible-playbook roles/traffmonetizer.yml -e @vault.yml --ask-vault-pass

# Run multiple roles in sequence
ansible-playbook roles/common.yml roles/traffmonetizer.yml -e @vault.yml --ask-vault-pass
```

## Tunnel & Networking Features

This project includes comprehensive tunneling solutions:

- **SSH Reverse Tunnels**: Persistent tunnels through NAT
- **Docker Tunnel Setup**: Containerized tunnel management
- **WireGuard Configuration**: High-performance VPN tunnels
- **Monitoring Scripts**: Automatic tunnel health checks
- **Systemd Services**: System-level tunnel management

See `TUNNEL-README.md` for detailed tunnel setup instructions.

## Benefits

✅ **Ultra Minimal**: Compact roles and playbooks for maximum efficiency  
✅ **Multi-Platform**: Docker installer supports all major Linux distributions  
✅ **No Dependencies**: Each role is completely self-contained  
✅ **Fast Execution**: Minimal overhead, maximum speed  
✅ **Easy to Understand**: Simple, readable code  
✅ **Portable**: Copy any single file to use elsewhere  
✅ **Secure**: Vault-based credential management  
✅ **Networking Ready**: Built-in tunnel and proxy solutions

## License

MIT