#!/bin/bash

# Function to display help message
function display_help() {
    echo "Usage: $0 [option]"
    echo "Options:"
    echo "  -a, --add-service <service>      Add a service to the firewall"
    echo "  -r, --remove-service <service>   Remove a service from the firewall"
    echo "  -l, --list-services              List all services allowed by the firewall"
    echo "  -h, --help                       Display this help message"
    exit 1
}

# Function to add a service to the firewall
function add_service() {
    sudo firewall-cmd --permanent --add-service="$1"
    sudo firewall-cmd --reload
}

# Function to remove a service from the firewall
function remove_service() {
    sudo firewall-cmd --permanent --remove-service="$1"
    sudo firewall-cmd --reload
}

# Function to list all services allowed by the firewall
function list_services() {
    sudo firewall-cmd --list-services
}

# Parse command line arguments
case "$1" in
    -a|--add-service)
        if [ -z "$2" ]; then
            echo "Error: Service name not provided."
            exit 1
        fi
        add_service "$2"
        ;;
    -r|--remove-service)
        if [ -z "$2" ]; then
            echo "Error: Service name not provided."
            exit 1
        fi
        remove_service "$2"
        ;;
    -l|--list-services)
        list_services
        ;;
    -h|--help)
        display_help
        ;;
    *)
        echo "Error: Invalid option."
        display_help
        ;;
esac

exit 0
