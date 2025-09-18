#!/bin/bash

# after_install.sh - Configure the application after installation

echo "Starting after_install.sh script..."

# Navigate to application directory
cd /opt/ci-cd-demo-app

# Create virtual environment
echo "Creating Python virtual environment..."
python3 -m venv venv

# Activate virtual environment
echo "Activating virtual environment..."
source venv/bin/activate

# Upgrade pip
echo "Upgrading pip..."
pip install --upgrade pip

# Install application dependencies
echo "Installing Python dependencies..."
pip install -r requirements.txt

# Create systemd service file
echo "Creating systemd service file..."
cat > /etc/systemd/system/ci-cd-demo.service << EOF
[Unit]
Description=CI/CD Demo Flask Application
After=network.target

[Service]
Type=simple
User=ec2-user
Group=ec2-user
WorkingDirectory=/opt/ci-cd-demo-app
Environment=PATH=/opt/ci-cd-demo-app/venv/bin
ExecStart=/opt/ci-cd-demo-app/venv/bin/gunicorn --bind 0.0.0.0:8080 --workers 2 app:create_app()
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# Set correct permissions
echo "Setting file permissions..."
chown -R ec2-user:ec2-user /opt/ci-cd-demo-app
chmod +x /opt/ci-cd-demo-app/scripts/*.sh

# Reload systemd daemon
echo "Reloading systemd daemon..."
systemctl daemon-reload

# Enable the service
echo "Enabling ci-cd-demo service..."
systemctl enable ci-cd-demo

echo "after_install.sh script completed successfully!"
