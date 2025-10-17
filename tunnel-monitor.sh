#!/bin/bash

# Tunnel monitoring and auto-restart script
# Usage: ./tunnel-monitor.sh

VPS_IP="your-vps-ip"
VPS_USER="root"
LOCAL_PORT="3000"
REMOTE_PORT="8080"
CHECK_INTERVAL=30

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

check_tunnel() {
    # Check if SSH tunnel process is running
    if pgrep -f "ssh.*$VPS_IP.*-R $REMOTE_PORT" > /dev/null; then
        return 0
    else
        return 1
    fi
}

test_connectivity() {
    # Test if we can reach the VPS
    if timeout 5 nc -z $VPS_IP 22 2>/dev/null; then
        return 0
    else
        return 1
    fi
}

start_tunnel() {
    log "Starting SSH tunnel..."
    ssh -f -o ServerAliveInterval=60 \
        -o ServerAliveCountMax=3 \
        -o ExitOnForwardFailure=yes \
        -R $REMOTE_PORT:localhost:$LOCAL_PORT \
        $VPS_USER@$VPS_IP -N
    
    if [ $? -eq 0 ]; then
        log "Tunnel started successfully"
        return 0
    else
        log "Failed to start tunnel"
        return 1
    fi
}

stop_tunnel() {
    log "Stopping existing tunnel..."
    pkill -f "ssh.*$VPS_IP.*-R $REMOTE_PORT"
}

main() {
    log "Starting tunnel monitor..."
    
    while true; do
        if ! test_connectivity; then
            log "Cannot reach VPS, waiting..."
            sleep $CHECK_INTERVAL
            continue
        fi
        
        if ! check_tunnel; then
            log "Tunnel is down, restarting..."
            stop_tunnel
            sleep 5
            start_tunnel
        else
            log "Tunnel is running"
        fi
        
        sleep $CHECK_INTERVAL
    done
}

# Handle signals
trap 'log "Stopping monitor..."; stop_tunnel; exit 0' SIGTERM SIGINT

main