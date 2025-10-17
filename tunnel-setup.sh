#!/bin/bash

# TCP/UDP Tunnel Setup Script
# Usage: ./tunnel-setup.sh [method] [local_port] [remote_port] [vps_ip]

set -e

METHOD=${1:-ssh}
LOCAL_PORT=${2:-8080}
REMOTE_PORT=${3:-8080}
VPS_IP=${4:-"your-vps-ip"}
VPS_USER=${5:-"root"}

echo "Setting up $METHOD tunnel: Local:$LOCAL_PORT <-> VPS:$REMOTE_PORT"

case $METHOD in
    "ssh")
        echo "Creating SSH tunnel..."
        # Reverse tunnel - expose local service on VPS
        ssh -o ServerAliveInterval=60 \
            -o ServerAliveCountMax=3 \
            -o ExitOnForwardFailure=yes \
            -R $REMOTE_PORT:localhost:$LOCAL_PORT \
            $VPS_USER@$VPS_IP -N
        ;;
    
    "autossh")
        echo "Creating persistent SSH tunnel with autossh..."
        autossh -M 0 \
            -o ServerAliveInterval=60 \
            -o ServerAliveCountMax=3 \
            -o ExitOnForwardFailure=yes \
            -R $REMOTE_PORT:localhost:$LOCAL_PORT \
            $VPS_USER@$VPS_IP -N
        ;;
    
    "socat-tcp")
        echo "Creating TCP tunnel with socat..."
        # Run on VPS: socat TCP-LISTEN:$REMOTE_PORT,fork TCP:localhost:$LOCAL_PORT
        socat TCP-LISTEN:$LOCAL_PORT,fork TCP:$VPS_IP:$REMOTE_PORT
        ;;
    
    "socat-udp")
        echo "Creating UDP tunnel with socat..."
        # Run on VPS: socat UDP-LISTEN:$REMOTE_PORT,fork UDP:localhost:$LOCAL_PORT
        socat UDP-LISTEN:$LOCAL_PORT,fork UDP:$VPS_IP:$REMOTE_PORT
        ;;
    
    *)
        echo "Usage: $0 [ssh|autossh|socat-tcp|socat-udp] [local_port] [remote_port] [vps_ip] [vps_user]"
        exit 1
        ;;
esac