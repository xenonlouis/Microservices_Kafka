#!/bin/bash

echo "Building all services..."
Set-Location config-server; mvn clean package -DskipTests
Set-Location ../product-service; mvn clean package -DskipTests
Set-Location ../order-service; mvn clean package -DskipTests
Set-Location ../notification-service; mvn clean package -DskipTests
Set-Location ../api-gateway; mvn clean package -DskipTests
Set-Location ..

echo "Starting all containers..."
docker-compose up -d

echo "Waiting for services to start..."
Start-Sleep -Seconds 30

# API Gateway base URL
$GATEWAY_URL="http://localhost:8080"

echo "Testing Product Service through API Gateway..."
echo "1. Getting all products..."
Invoke-RestMethod -Uri "${GATEWAY_URL}/api/products" -Method Get

echo "`n2. Getting product with ID 1..."
Invoke-RestMethod -Uri "${GATEWAY_URL}/api/products/1" -Method Get

echo "`n3. Creating a new product..."
$productBody = @{
    name = "Test Product"
    description = "Test Description"
    price = 99.99
    quantity = 10
} | ConvertTo-Json
Invoke-RestMethod -Uri "${GATEWAY_URL}/api/products" -Method Post -Body $productBody -ContentType "application/json"

echo "`nTesting Order Service through API Gateway..."
echo "1. Getting all orders..."
Invoke-RestMethod -Uri "${GATEWAY_URL}/api/orders" -Method Get

echo "`n2. Creating a new order..."
$orderBody = @(
    @{
        productId = 1
        quantity = 2
    }
) | ConvertTo-Json
Invoke-RestMethod -Uri "${GATEWAY_URL}/api/orders?customerEmail=test@example.com&customerName=Test%20User" -Method Post -Body $orderBody -ContentType "application/json"

echo "`n3. Getting order details..."
Invoke-RestMethod -Uri "${GATEWAY_URL}/api/orders/1" -Method Get

echo "`nTesting Notification Service through API Gateway..."
echo "1. Getting all notifications..."
Invoke-RestMethod -Uri "${GATEWAY_URL}/api/notifications" -Method Get

echo "`n2. Getting notifications for order ID 1..."
Invoke-RestMethod -Uri "${GATEWAY_URL}/api/notifications/order/1" -Method Get

echo "`nChecking service health..."
echo "1. API Gateway health:"
Invoke-RestMethod -Uri "${GATEWAY_URL}/actuator/health" -Method Get

echo "`n2. Checking service logs..."
echo "API Gateway logs:"
docker-compose logs --tail=20 api-gateway
echo "`nProduct Service logs:"
docker-compose logs --tail=20 product-service
echo "`nOrder Service logs:"
docker-compose logs --tail=20 order-service
echo "`nNotification Service logs:"
docker-compose logs --tail=20 notification-service

echo "`nAll tests completed!" 