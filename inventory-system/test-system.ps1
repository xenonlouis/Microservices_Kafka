docker-compose down

echo "Building all services..."
cd config-server; mvn clean package -DskipTests
cd ../product-service; mvn clean package -DskipTests
cd ../order-service; mvn clean package -DskipTests
cd ../notification-service; mvn clean package -DskipTests
cd ../api-gateway; mvn clean package -DskipTests
cd ..

echo "Starting all containers..."
docker-compose up -d

echo "Waiting for services to start..."
Start-Sleep -Seconds 30

# Common headers for GraphQL requests
$headers = @{
    "Content-Type" = "application/json"
}

# API Gateway base URL
$GATEWAY_URL = "http://localhost:8070"

echo "`n=== Testing Product Service (GraphQL) ==="
echo "1. Getting all products..."
$query = @{
    query = "{ products { id name description price stock } }"
} | ConvertTo-Json
$response = Invoke-RestMethod -Uri "$GATEWAY_URL/graphql/products" -Method Post -Headers $headers -Body $query
Write-Host "Products:" -ForegroundColor Green
$response.data.products | Format-Table -AutoSize

echo "`n2. Creating a new product..."
$query = @{
    query = "mutation { createProduct(name: `"Test Laptop`", description: `"High-end laptop`", price: 1299.99, stock: 10) { id name description price stock } }"
} | ConvertTo-Json
$response = Invoke-RestMethod -Uri "$GATEWAY_URL/graphql/products" -Method Post -Headers $headers -Body $query
Write-Host "Created Product:" -ForegroundColor Green
$response.data.createProduct | Format-Table -AutoSize
$productId = $response.data.createProduct.id

echo "`n=== Testing Order Service (GraphQL) ==="
echo "1. Creating a new order..."
$query = @{
    query = "mutation { createOrder(input: { customerEmail: `"test@example.com`", items: [{ productId: `"$productId`", quantity: 1 }] }) { id customerEmail totalAmount status items { productId quantity price } } }"
} | ConvertTo-Json
$response = Invoke-RestMethod -Uri "$GATEWAY_URL/graphql/orders" -Method Post -Headers $headers -Body $query
Write-Host "Created Order:" -ForegroundColor Green
$response.data.createOrder | Format-Table -AutoSize
$orderId = $response.data.createOrder.id

echo "`n2. Getting order details..."
$query = @{
    query = "{ order(id: `"$orderId`") { id customerEmail totalAmount status items { productId quantity price } } }"
} | ConvertTo-Json
$response = Invoke-RestMethod -Uri "$GATEWAY_URL/graphql/orders" -Method Post -Headers $headers -Body $query
Write-Host "Order Details:" -ForegroundColor Green
$response.data.order | Format-Table -AutoSize

echo "`n=== Testing Notification Service (GraphQL) ==="
echo "1. Getting notifications for the order..."
$query = @{
    query = "{ notificationsByOrder(orderId: `"$orderId`") { id orderId customerEmail message status createdAt } }"
} | ConvertTo-Json
$response = Invoke-RestMethod -Uri "$GATEWAY_URL/graphql/notifications" -Method Post -Headers $headers -Body $query
Write-Host "Order Notifications:" -ForegroundColor Green
$response.data.notificationsByOrder | Format-Table -AutoSize

echo "`nChecking service health..."
echo "1. API Gateway health:"
Invoke-RestMethod -Uri "$GATEWAY_URL/actuator/health" -Method Get

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