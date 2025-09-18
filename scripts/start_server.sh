#!/bin/bash

# start_server.sh - Start the Flask application

echo "Starting start_server.sh script..."

# Navigate to application directory
cd /opt/ci-cd-demo-app

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    echo "Error: Virtual environment not found!"
    exit 1
fi

# Activate virtual environment
echo "Activating virtual environment..."
source venv/bin/activate

# Check if required files exist
if [ ! -f "app.py" ]; then
    echo "Error: app.py not found!"
    exit 1
fi

if [ ! -f "requirements.txt" ]; then
    echo "Error: requirements.txt not found!"
    exit 1
fi

# Start the systemd service
echo "Starting ci-cd-demo service..."
systemctl start ci-cd-demo

# Wait a moment for the service to start
sleep 5

# Check if service is running
if systemctl is-active --quiet ci-cd-demo; then
    echo "CI/CD Demo application started successfully!"
    echo "Service status:"
    systemctl status ci-cd-demo --no-pager
else
    echo "Error: Failed to start ci-cd-demo service!"
    echo "Service status:"
    systemctl status ci-cd-demo --no-pager
    echo "Service logs:"
    journalctl -u ci-cd-demo --no-pager -n 20
    exit 1
fi

echo "start_server.sh script completed successfully!"
