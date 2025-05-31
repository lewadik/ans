# Simple Ansible Project

This is a basic Ansible project structure for managing servers.

## Project Structure

```
ansible-project/
├── ansible.cfg          # Ansible configuration
├── inventory            # Inventory file with host definitions
├── site.yml            # Main playbook
├── group_vars/         # Group variable files
│   ├── all.yml         # Variables for all hosts
│   └── webservers.yml  # Variables for webservers group
├── host_vars/          # Host-specific variables (empty)
└── roles/              # Custom roles directory (empty)
```

## Usage

1. **Edit the inventory file** to add your actual server IPs and connection details:
   ```bash
   # Uncomment and modify the hosts in the inventory file
   # Add your server IPs and SSH details
   ```

2. **Test connectivity** to your hosts:
   ```bash
   ansible all -m ping
   ```

3. **Run the playbook**:
   ```bash
   ansible-playbook site.yml
   ```

4. **Run specific tags**:
   ```bash
   ansible-playbook site.yml --tags nginx
   ```

5. **Check what would be changed** (dry run):
   ```bash
   ansible-playbook site.yml --check
   ```

## Customization

- Modify `group_vars/` files to change default variables
- Add host-specific variables in `host_vars/`
- Create custom roles in the `roles/` directory
- Add more playbooks for different purposes

## Prerequisites

- Ansible installed on your control machine
- SSH access to target hosts
- Sudo privileges on target hosts (for tasks marked with `become: yes`)

