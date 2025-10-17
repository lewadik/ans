# My Ansible Project

This project is an Ansible setup designed to automate the configuration and management of servers. Below are the details of the project structure and how to use it.

## Project Structure

```
my-ansible-project
├── ansible.cfg          # Configuration settings for Ansible
├── inventory            # Inventory of hosts
│   └── hosts.yml       # Hosts and connection details
├── group_vars           # Group variables
│   └── all              # Variables for all hosts
│       ├── vault.yml.example # Example vault file (copy and encrypt)
│       └── .gitignore   # Ignore actual vault files
├── playbooks            # Playbooks to execute tasks
│   ├── site.yml        # Main playbook
│   ├── traffmonetizer.yml # TrafficMonetizer deployment playbook
│   └── gost-proxy.yml  # GOST proxy deployment playbook
├── roles                # Roles for organizing tasks
│   ├── common           # Common role for shared tasks
│   │   ├── tasks
│   │   │   └── main.yml # Main tasks for the common role
│   │   ├── handlers
│   │   │   └── main.yml # Handlers for the common role
│   │   ├── templates    # Jinja2 templates
│   │   ├── files        # Static files
│   │   └── vars
│   │       └── main.yml # Variables for the common role
│   ├── docker           # Docker installation role
│   │   ├── tasks
│   │   │   └── main.yml # Docker installation tasks
│   │   ├── handlers
│   │   │   └── main.yml # Docker service handlers
│   │   ├── defaults
│   │   │   └── main.yml # Default variables
│   │   ├── vars
│   │   │   └── main.yml # Role variables
│   │   ├── meta
│   │   │   └── main.yml # Role metadata
│   │   └── README.md    # Docker role documentation
│   ├── traffmonetizer   # TrafficMonetizer deployment role
│   │   ├── tasks
│   │   │   └── main.yml # TrafficMonetizer deployment tasks
│   │   ├── handlers
│   │   │   └── main.yml # Container management handlers
│   │   ├── defaults
│   │   │   └── main.yml # Default variables
│   │   ├── vars
│   │   │   └── main.yml # Role variables
│   │   ├── meta
│   │   │   └── main.yml # Role metadata and dependencies
│   │   └── README.md    # TrafficMonetizer role documentation
│   └── gost-proxy       # GOST proxy server role
│       ├── tasks
│       │   └── main.yml # GOST installation and configuration tasks
│       ├── handlers
│       │   └── main.yml # Service management handlers
│       ├── templates
│       │   └── gost.service.j2 # Systemd service template
│       ├── defaults
│       │   └── main.yml # Default variables
│       ├── vars
│       │   └── main.yml # Role variables
│       ├── meta
│       │   └── main.yml # Role metadata
│       └── README.md    # GOST proxy role documentation
└── README.md            # Project documentation
```

## Getting Started

1. **Clone the repository**:
   ```
   git clone <repository-url>
   cd my-ansible-project
   ```

2. **Configure the inventory**:
   Edit the `inventory/hosts.yml` file to specify the hosts you want to manage.

3. **Set up credentials** (for roles that require them):
   ```bash
   # Copy the example vault file
   cp group_vars/all/vault.yml.example group_vars/all/vault.yml
   
   # Edit with your actual credentials
   nano group_vars/all/vault.yml
   
   # Encrypt the vault file
   ansible-vault encrypt group_vars/all/vault.yml
   ```

4. **Run the playbook**:
   Execute the main playbook with the following command:
   ```
   ansible-playbook playbooks/site.yml
   ```
   
   For playbooks requiring vault credentials:
   ```
   ansible-playbook playbooks/traffmonetizer.yml --ask-vault-pass
   ansible-playbook playbooks/gost-proxy.yml --ask-vault-pass
   ```

## Configuration

The `ansible.cfg` file contains the configuration settings for Ansible. You can modify it to change inventory paths, roles path, and other settings.

## Security and Credential Management

This project uses Ansible Vault to securely store sensitive information like tokens and passwords. All credentials have been removed from default configurations and must be provided via encrypted vault files.

### Setting Up Vault

1. **Copy the example vault file**:
   ```bash
   cp group_vars/all/vault.yml.example group_vars/all/vault.yml
   ```

2. **Edit with your credentials**:
   ```bash
   nano group_vars/all/vault.yml
   ```

3. **Encrypt the vault file**:
   ```bash
   ansible-vault encrypt group_vars/all/vault.yml
   ```

### Required Vault Variables

```yaml
# TrafficMonetizer token
vault_traffmonetizer_token: "your_actual_token"

# GOST Proxy credentials  
vault_gost_username: "your_username"
vault_gost_password: "your_password"
```

### Vault Management Commands

```bash
# Create new vault file
ansible-vault create group_vars/all/vault.yml

# Edit existing vault file
ansible-vault edit group_vars/all/vault.yml

# View vault contents
ansible-vault view group_vars/all/vault.yml

# Change vault password
ansible-vault rekey group_vars/all/vault.yml
```

## Roles

### Common Role
The `roles/common` directory contains tasks, handlers, templates, files, and variables for the common role with shared system configurations.

### Docker Role
The `roles/docker` directory contains tasks for installing Docker CE on Linux systems. This role supports:

- **Supported Platforms**: Ubuntu, Debian, CentOS, RHEL
- **Features**: 
  - Automatic repository setup
  - Docker CE installation with containerd
  - User group management (adds users to docker group)
  - Service management (starts and enables Docker)
  - Installation verification

#### Docker Role Variables

You can customize the Docker installation by setting these variables:

```yaml
# Whether to add the current user to the docker group (default: true)
docker_add_user_to_group: true

# Docker service state (default: started)
docker_service_state: started

# Enable Docker service on boot (default: true)
docker_service_enabled: true

# Package installation state (default: present)
docker_package_state: present
```

#### Using Docker Role

**Install Docker on all hosts** (default behavior):
```bash
ansible-playbook playbooks/site.yml
```

**Install Docker on specific host groups**:
```bash
ansible-playbook playbooks/site.yml --limit docker_hosts
```

**Custom Docker installation**:
Create a custom playbook with specific variables:
```yaml
- hosts: servers
  become: true
  roles:
    - role: docker
      vars:
        docker_add_user_to_group: false
        docker_package_state: latest
```

### TrafficMonetizer Role
The `roles/traffmonetizer` directory contains tasks for deploying the TrafficMonetizer CLI container. This role:

- **Dependencies**: Requires Docker (automatically installs docker role)
- **Features**:
  - Pulls TrafficMonetizer CLI Docker image
  - Manages container lifecycle (stop/start/restart)
  - Configurable token and container settings
  - Container health verification

#### TrafficMonetizer Role Variables

```yaml
# TrafficMonetizer token - REQUIRED (stored in vault)
vault_traffmonetizer_token: "your_token_here"

# Container configuration
traffmonetizer_container_name: tm
traffmonetizer_image: traffmonetizer/cli_v2
traffmonetizer_restart_policy: unless-stopped

# Whether to pull the latest image before running
traffmonetizer_pull_image: true
```

#### Using TrafficMonetizer Role

**Deploy TrafficMonetizer with default token**:
```bash
ansible-playbook playbooks/traffmonetizer.yml
```

**Deploy with Ansible Vault** (required - credentials are secured):
```bash
# Ensure vault.yml is set up with your token
ansible-playbook playbooks/traffmonetizer.yml --ask-vault-pass
```

**Deploy with custom token** (temporary override):
```bash
ansible-playbook playbooks/traffmonetizer.yml --ask-vault-pass -e "vault_traffmonetizer_token=YOUR_TOKEN_HERE"
```

**Deploy to specific hosts**:
```bash
ansible-playbook playbooks/traffmonetizer.yml --limit production_servers
```

### GOST Proxy Role
The `roles/gost-proxy` directory contains tasks for installing and configuring the GOST proxy server. This role:

- **Features**:
  - Downloads GOST binary from curl.ge/gost
  - Creates systemd service for automatic startup
  - Configurable proxy credentials and port
  - Public IP detection and display
  - Service management and monitoring

#### GOST Proxy Role Variables

```yaml
# GOST proxy configuration (credentials stored in vault)
vault_gost_username: "your_username"    # Proxy username (stored in vault)
vault_gost_password: "your_password"    # Proxy password (stored in vault)
gost_port: 8081                         # Proxy port
gost_bind_address: "0.0.0.0"            # Bind address (0.0.0.0 for all interfaces)

# Installation configuration
gost_download_url: "https://curl.ge/gost"
gost_install_path: "/usr/local/bin"
gost_user: "gost"              # Service user

# Service configuration
gost_service_enabled: true
gost_service_state: started
```

#### Using GOST Proxy Role

**Deploy with Ansible Vault** (required - credentials are secured):
```bash
# Ensure vault.yml is set up with your credentials
ansible-playbook playbooks/gost-proxy.yml --ask-vault-pass
```

**Deploy with custom credentials** (temporary override):
```bash
ansible-playbook playbooks/gost-proxy.yml --ask-vault-pass -e "vault_gost_username=myuser" -e "vault_gost_password=mypassword"
```

**Test your proxy after deployment**:
```bash
curl --proxy http://username:password@YOUR_PUBLIC_IP:8081 https://ipinfo.io/ip
```

#### Security Notes

- Change default credentials for production use
- Consider firewall rules for the proxy port
- Use Ansible Vault for sensitive variables
- Monitor proxy usage and access logs

## License

This project is licensed under the MIT License. See the LICENSE file for more details.