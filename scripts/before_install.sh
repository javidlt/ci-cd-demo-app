#!/bin/bash

# before_install.sh - Prepare the environment before installing the application

echo "Starting before_install.sh script..."

# Update system packages
echo "Updating system packages..."
yum update -y

# Install Python 3 and pip if not already installed
echo "Installing Python 3 and pip..."
yum install -y python3 python3-pip

# Install system dependencies
echo "Installing system dependencies..."
yum install -y git curl wget

# Create application directory if it doesn't exist
echo "Creating application directory..."
if [ ! -d "/opt/ci-cd-demo-app" ]; then
    mkdir -p /opt/ci-cd-demo-app
fi

# Change ownership to ec2-user
echo "Setting directory ownership..."
chown -R ec2-user:ec2-user /opt/ci-cd-demo-app

# Stop any existing application processes
echo "Stopping any existing application processes..."
pkill -f "python.*app.py" || true
pkill -f "gunicorn.*app:app" || true

# Remove any existing systemd service file
echo "Cleaning up existing service files..."
if [ -f "/etc/systemd/system/ci-cd-demo.service" ]; then
    systemctl stop ci-cd-demo || true
    systemctl disable ci-cd-demo || true
    rm -f /etc/systemd/system/ci-cd-demo.service
    systemctl daemon-reload
fi

echo "before_install.sh script completed successfully!"
