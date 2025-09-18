#!/bin/bash

# validate_service.sh - Validate that the Flask application is running correctly

echo "Starting validate_service.sh script..."

# Wait for the service to be fully ready
echo "Waiting for service to be ready..."
sleep 10

# Check if the service is active
echo "Checking if ci-cd-demo service is active..."
if ! systemctl is-active --quiet ci-cd-demo; then
    echo "Error: ci-cd-demo service is not active!"
    systemctl status ci-cd-demo --no-pager
    exit 1
fi

echo "Service is active. Proceeding with validation..."

# Test the application endpoint
echo "Testing application endpoint..."
MAX_RETRIES=5
RETRY_COUNT=0
SUCCESS=false

while [ $RETRY_COUNT -lt $MAX_RETRIES ]; do
    echo "Attempt $((RETRY_COUNT + 1)) of $MAX_RETRIES..."
    
    # Test the root endpoint
    RESPONSE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8080/ || echo "000")
    
    if [ "$RESPONSE" = "200" ]; then
        echo "SUCCESS: Application is responding correctly (HTTP 200)"
        SUCCESS=true
        break
    else
        echo "WARNING: Application returned HTTP $RESPONSE"
        RETRY_COUNT=$((RETRY_COUNT + 1))
        if [ $RETRY_COUNT -lt $MAX_RETRIES ]; then
            echo "Retrying in 5 seconds..."
            sleep 5
        fi
    fi
done

if [ "$SUCCESS" = false ]; then
    echo "ERROR: Application validation failed after $MAX_RETRIES attempts"
    echo "Service status:"
    systemctl status ci-cd-demo --no-pager
    echo "Recent service logs:"
    journalctl -u ci-cd-demo --no-pager -n 20
    exit 1
fi

# Test the actual response content
echo "Testing response content..."
CONTENT=$(curl -s http://localhost:8080/ | grep -o "Hello CI/CD!" || echo "")

if [ "$CONTENT" = "Hello CI/CD!" ]; then
    echo "SUCCESS: Application is returning expected content"
else
    echo "WARNING: Application is not returning expected content"
    echo "Actual response:"
    curl -s http://localhost:8080/
    echo ""
fi

# Check if the process is listening on the correct port
echo "Checking if application is listening on port 8080..."
if netstat -tuln | grep -q ":8080 "; then
    echo "SUCCESS: Application is listening on port 8080"
else
    echo "ERROR: Application is not listening on port 8080"
    echo "Active listening ports:"
    netstat -tuln | grep LISTEN
    exit 1
fi

# Final validation message
echo "========================================="
echo "SERVICE VALIDATION COMPLETED SUCCESSFULLY"
echo "========================================="
echo "Application URL: http://localhost:8080/"
echo "Service Status: $(systemctl is-active ci-cd-demo)"
echo "Validation Time: $(date)"

echo "validate_service.sh script completed successfully!"
