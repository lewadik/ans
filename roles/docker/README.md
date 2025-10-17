# Docker Role

This Ansible role installs Docker CE on Linux systems (Ubuntu, Debian, CentOS, RHEL).

## Requirements

- Ansible 2.9+
- Target systems running supported Linux distributions

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
# Whether to add the current user to the docker group
docker_add_user_to_group: true

# Docker service configuration
docker_service_state: started
docker_service_enabled: true

# Package state (present, latest)
docker_package_state: present
```

## Dependencies

None.

## Example Playbook

```yaml
- hosts: servers
  become: yes
  roles:
    - docker
```

## Example with custom variables

```yaml
- hosts: servers
  become: yes
  roles:
    - role: docker
      vars:
        docker_add_user_to_group: false
        docker_package_state: latest
```

## Supported Platforms

- Ubuntu 20.04+ (Focal, Jammy)
- Debian 11+ (Bullseye, Bookworm)
- CentOS/RHEL 7, 8, 9

## License

MIT