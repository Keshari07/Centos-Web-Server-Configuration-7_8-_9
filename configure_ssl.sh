#!/bin/bash

# Update package list
sudo yum update -y

# Install Apache
sudo yum install -y httpd

# CentOS 7: Enable EPEL repository for certbot installation
if [ "$(rpm -E %centos)" = "7" ]; then
    sudo yum install -y epel-release
fi

# Install certbot for Let's Encrypt certificate (optional)
sudo yum install -y certbot python2-certbot-apache

# Generate SSL certificate and key using certbot (optional)
if [ -x "$(command -v certbot)" ]; then
    sudo certbot --apache -d example.com
fi

# Enable SSL module
sudo systemctl enable httpd
sudo systemctl start httpd

echo "SSL/TLS configuration completed successfully."
