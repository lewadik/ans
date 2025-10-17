# TCP/UDP Tunnel Setup Guide

This guide provides multiple methods to create persistent tunnels between your NAT local server and VPS.

## Quick Start Options

### 1. SSH Reverse Tunnel (Recommended)

**On your local NAT server:**
```bash
# Basic reverse tunnel - exposes local port 3000 on VPS port 8080
ssh -R 8080:localhost:3000 user@your-vps-ip -N

# With connection stability options
ssh -o ServerAliveInterval=60 -o ServerAliveCountMax=3 -o ExitOnForwardFailure=yes -R 8080:localhost:3000 user@your-vps-ip -N
```

**On Windows (PowerShell):**
```powershell
# Install OpenSSH if not available
Add-WindowsCapability -Online -Name OpenSSH.Client~~~~0.0.1.0

# Create tunnel
ssh -o ServerAliveInterval=60 -o ServerAliveCountMax=3 -o ExitOnForwardFailure=yes -R 8080:localhost:3000 user@your-vps-ip -N
```

### 2. Using AutoSSH (Linux/WSL)

```bash
# Install autossh
sudo apt install autossh  # Ubuntu/Debian
sudo yum install autossh  # CentOS/RHEL

# Create persistent tunnel
autossh -M 0 -o ServerAliveInterval=60 -o ServerAliveCountMax=3 -R 8080:localhost:3000 user@your-vps-ip -N
```

### 3. Docker Solution

```bash
# Run the tunnel in Docker
docker-compose -f docker-compose.tunnel.yml up -d ssh-tunnel
```

### 4. Socat for UDP/TCP

**TCP Tunnel:**
```bash
# On local server
socat TCP-LISTEN:8080,fork,reuseaddr TCP:your-vps-ip:8080

# On VPS
socat TCP-LISTEN:8080,fork,reuseaddr TCP:localhost:3000
```

**UDP Tunnel:**
```bash
# On local server  
socat UDP-LISTEN:8081,fork,reuseaddr UDP:your-vps-ip:8081

# On VPS
socat UDP-LISTEN:8081,fork,reuseaddr UDP:localhost:3000
```

## Setup Instructions

### Prerequisites

1. **SSH Key Authentication** (recommended):
   ```bash
   # Generate key pair
   ssh-keygen -t rsa -b 4096 -C "tunnel@local"
   
   # Copy to VPS
   ssh-copy-id user@your-vps-ip
   ```

2. **VPS Configuration**:
   Edit `/etc/ssh/sshd_config` on your VPS:
   ```
   GatewayPorts yes
   ClientAliveInterval 60
   ClientAliveCountMax 3
   ```
   Then restart SSH: `sudo systemctl restart sshd`

### Windows-Specific Setup

1. **Using WSL2** (Recommended):
   ```powershell
   # Install WSL2
   wsl --install
   
   # In WSL, run the Linux commands above
   ```

2. **Using PowerShell**:
   ```powershell
   # Create persistent tunnel with background job
   Start-Job -ScriptBlock {
       ssh -o ServerAliveInterval=60 -o ServerAliveCountMax=3 -R 8080:localhost:3000 user@your-vps-ip -N
   }
   ```

3. **Using Windows Task Scheduler**:
   - Create a new task
   - Set trigger: At startup
   - Set action: Start program `ssh.exe` with arguments `-o ServerAliveInterval=60 -o ServerAliveCountMax=3 -R 8080:localhost:3000 user@your-vps-ip -N`

### Linux Systemd Service

1. Copy the service file:
   ```bash
   sudo cp systemd-tunnel.service /etc/systemd/system/
   ```

2. Edit the service file with your details:
   ```bash
   sudo nano /etc/systemd/system/systemd-tunnel.service
   ```

3. Enable and start:
   ```bash
   sudo systemctl enable systemd-tunnel.service
   sudo systemctl start systemd-tunnel.service
   ```

### Monitoring and Auto-Restart

Run the monitoring script:
```bash
./tunnel-monitor.sh
```

Or as a systemd service for automatic monitoring.

## Configuration Examples

### Multiple Port Forwards
```bash
ssh -R 8080:localhost:3000 -R 8081:localhost:3001 -R 8082:localhost:3002 user@your-vps-ip -N
```

### Bidirectional Tunnel
```bash
# Forward both ways
ssh -L 9000:localhost:9000 -R 8080:localhost:3000 user@your-vps-ip -N
```

### SOCKS Proxy
```bash
# Create SOCKS proxy through VPS
ssh -D 1080 user@your-vps-ip -N
```

## Troubleshooting

1. **Connection drops**: Increase `ServerAliveInterval` and `ServerAliveCountMax`
2. **Permission denied**: Check SSH key authentication and VPS user permissions
3. **Port already in use**: Change the port numbers or kill existing processes
4. **Firewall issues**: Ensure ports are open on both servers

## Security Considerations

- Use SSH key authentication instead of passwords
- Restrict SSH access by IP if possible
- Consider using WireGuard for better performance and security
- Monitor tunnel usage and logs regularly

## Performance Tips

- Use compression for slow connections: `ssh -C`
- For high-throughput applications, consider WireGuard or direct VPN solutions
- Monitor bandwidth usage and connection stability