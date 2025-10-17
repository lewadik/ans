# GOST Proxy Role

This Ansible role installs and configures the GOST proxy server on Linux systems.

## Requirements

- Ansible 2.9+
- Target systems running supported Linux distributions
- Internet connectivity to download GOST binary

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
# GOST binary configuration
gost_download_url: "https://curl.ge/gost"
gost_install_path: "/usr/local/bin"

# GOST service configuration
gost_user: "gost"
gost_home_dir: "/var/lib/gost"
gost_config_dir: "/etc/gost"

# GOST proxy configuration
gost_username: "your_username"     # Proxy username (use vault_gost_username)
gost_password: "your_password"     # Proxy password (use vault_gost_password)
gost_port: 8081
gost_bind_address: "0.0.0.0"

# Public IP detection service
public_ip_service: "https://ipinfo.io/ip"

# Service management
gost_service_enabled: true
gost_service_state: started
```

## Dependencies

None.

## Example Playbook

```yaml
- hosts: servers
  become: yes
  roles:
    - gost-proxy
```

## Example with custom configuration

```yaml
- hosts: proxy_servers
  become: yes
  roles:
    - role: gost-proxy
      vars:
        vault_gost_username: "{{ vault_gost_username }}"
        vault_gost_password: "{{ vault_gost_password }}"
        gost_port: 9090
        gost_bind_address: "127.0.0.1"
```

## Security Considerations

**Important**: The default username and password should be changed for production use. Consider using Ansible Vault to encrypt sensitive variables:

```bash
# Create encrypted variable file
ansible-vault create group_vars/all/vault.yml

# Add your credentials:
vault_gost_username: "your_secure_username"
vault_gost_password: "your_secure_password"

# Run playbook with vault
ansible-playbook -i inventory/hosts.yml playbooks/gost.yml --ask-vault-pass
```

## What this role does

1. Downloads the GOST binary from curl.ge/gost
2. Makes the binary executable
3. Creates a dedicated system user for the service
4. Creates a systemd service for GOST
5. Configures the proxy with specified credentials
6. Starts and enables the GOST service
7. Retrieves and displays the public IP address
8. Provides the complete proxy URL for use

## Firewall Configuration

Make sure to open the GOST port in your firewall:

```bash
# UFW (Ubuntu/Debian)
sudo ufw allow 8081/tcp

# firewalld (CentOS/RHEL)
sudo firewall-cmd --permanent --add-port=8081/tcp
sudo firewall-cmd --reload

# iptables
sudo iptables -A INPUT -p tcp --dport 8081 -j ACCEPT
```

## Usage

After deployment, you can use the proxy with the displayed URL:
```
http://username:password@YOUR_PUBLIC_IP:8081
```

## Service Management

```bash
# Check service status
sudo systemctl status gost

# View logs
sudo journalctl -u gost -f

# Restart service
sudo systemctl restart gost
```

## License

MIT