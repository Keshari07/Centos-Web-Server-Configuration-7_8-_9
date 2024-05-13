#!/bin/bash

# Function to display help message
function display_help() {
    echo "Usage: $0 [option]"
    echo "Options:"
    echo "  -v, --version <version>   Specify Jenkins version (optional, default is latest)"
    echo "  -h, --help                Display this help message"
    exit 1
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -v|--version)
            VERSION="$2"
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

# Install Java (OpenJDK)
sudo yum install -y java-1.8.0-openjdk-devel

# Import the Jenkins repository key
sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key

# Add the Jenkins repository to the system
sudo tee /etc/yum.repos.d/jenkins.repo > /dev/null <<EOF
[jenkins]
name=Jenkins
baseurl=https://pkg.jenkins.io/redhat
gpgcheck=1
EOF

# Install Jenkins
if [ -n "$VERSION" ]; then
    sudo yum install -y jenkins-"$VERSION"
else
    sudo yum install -y jenkins
fi

# Start Jenkins service
sudo systemctl start jenkins

# Enable Jenkins service to start on boot
sudo systemctl enable jenkins

echo "Jenkins installation completed successfully."
