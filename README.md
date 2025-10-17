# My Ansible Project

This project is an Ansible setup designed to automate the configuration and management of servers. Below are the details of the project structure and how to use it.

## Project Structure

```
my-ansible-project
├── ansible.cfg          # Configuration settings for Ansible
├── inventory            # Inventory of hosts
│   └── hosts.yml       # Hosts and connection details
├── playbooks            # Playbooks to execute tasks
│   └── site.yml        # Main playbook
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
│   └── docker           # Docker installation role
│       ├── tasks
│       │   └── main.yml # Docker installation tasks
│       ├── handlers
│       │   └── main.yml # Docker service handlers
│       ├── defaults
│       │   └── main.yml # Default variables
│       ├── vars
│       │   └── main.yml # Role variables
│       ├── meta
│       │   └── main.yml # Role metadata
│       └── README.md    # Docker role documentation
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

3. **Run the playbook**:
   Execute the main playbook with the following command:
   ```
   ansible-playbook playbooks/site.yml
   ```

## Configuration

The `ansible.cfg` file contains the configuration settings for Ansible. You can modify it to change inventory paths, roles path, and other settings.

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

## License

This project is licensed under the MIT License. See the LICENSE file for more details.