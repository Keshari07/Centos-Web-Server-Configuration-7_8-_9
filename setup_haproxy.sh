#!/bin/bash

# Function to display help message
function display_help() {
    echo "Usage: $0 [option]"
    echo "Options:"
    echo "  -b, --backend <backend_servers>     Specify backend server list (comma-separated)"
    echo "  -f, --frontend <frontend_port>      Specify frontend port for HAProxy"
    echo "  -h, --help                           Display this help message"
    exit 1
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -b|--backend)
            BACKEND="$2"
            shift
            shift
            ;;
        -f|--frontend)
            FRONTEND_PORT="$2"
            shift
            shift
            ;;
        -h|--help)
            display_help
            ;;
        *)
            echo "Error: Invalid option."
            display_help
            ;;
    esac
done

# Check if backend servers and frontend port are provided
if [ -z "$BACKEND" ] || [ -z "$FRONTEND_PORT" ]; then
    echo "Error: Backend servers or frontend port not provided."
    display_help
fi

# Function to configure HAProxy
function configure_haproxy() {
    # Install HAProxy if not installed
    sudo yum install -y haproxy

    # Configure HAProxy
    sudo tee /etc/haproxy/haproxy.cfg > /dev/null <<EOF
global
    log /dev/log    local0
    log /dev/log    local1 notice
    chroot /var/lib/haproxy
    stats socket /run/haproxy/admin.sock mode 660 level admin expose-fd listeners
    stats timeout 30s
    user haproxy
    group haproxy
    daemon

defaults
    log     global
    mode    http
    option  httplog
    option  dontlognull
    timeout connect 5000
    timeout client  50000
    timeout server  50000

frontend http_front
    bind *:$FRONTEND_PORT
    stats uri /haproxy?stats
    default_backend http_back

backend http_back
    balance roundrobin
    server server1 $BACKEND
EOF

    # Restart HAProxy
    sudo systemctl restart haproxy
}

# Configure HAProxy
configure_haproxy
