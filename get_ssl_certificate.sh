#!/bin/bash

# Function to display help message
function display_help() {
    echo "Usage: $0 [option]"
    echo "Options:"
    echo "  -d, --domain <domain_name>     Specify the domain name for which to obtain the SSL certificate"
    echo "  -h, --help                      Display this help message"
    exit 1
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -d|--domain)
            DOMAIN="$2"
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

# Check if domain is provided
if [ -z "$DOMAIN" ]; then
    echo "Error: Domain name not provided."
    display_help
fi

# Function to obtain SSL certificate using certbot
function obtain_ssl_certificate() {
    if [ -x "$(command -v certbot)" ]; then
        sudo certbot certonly --webroot -w /var/www/html -d "$DOMAIN"
    else
        echo "Error: Certbot not found. Please install certbot."
        exit 1
    fi
}

# Obtain SSL certificate
obtain_ssl_certificate
