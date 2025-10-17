#!/bin/bash

# SSH Port Forwarding One-liners

# Local port forwarding (access remote service locally)
# Forward local port 8080 to remote server's port 80 via jump server
ssh -L 8080:target-server:80 user@jump-server -N

# Remote port forwarding (expose local service remotely)  
# Make local port 3000 accessible on remote server's port 8080
ssh -R 8080:localhost:3000 user@remote-server -N

# Dynamic port forwarding (SOCKS proxy)
# Create SOCKS proxy on local port 1080 via remote server
ssh -D 1080 user@remote-server -N

# Multiple port forwards in one command
ssh -L 8080:target1:80 -L 3306:target2:3306 -L 5432:target3:5432 user@jump-server -N

# Background tunnel with auto-reconnect
ssh -f -N -L 8080:target-server:80 user@jump-server && echo "Tunnel established in background"

# One-liner with connection options for unreliable networks
ssh -o ServerAliveInterval=60 -o ServerAliveCountMax=3 -o ExitOnForwardFailure=yes -L 8080:target:80 user@server -N