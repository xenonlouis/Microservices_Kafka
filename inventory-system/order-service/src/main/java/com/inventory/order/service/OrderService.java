package com.inventory.order.service;

import com.inventory.order.client.ProductClient;
import com.inventory.order.dto.ProductDTO;
import com.inventory.order.model.Order;
import com.inventory.order.model.OrderItem;
import com.inventory.order.repository.OrderRepository;
import org.springframework.kafka.core.KafkaTemplate;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class OrderService {
    private final OrderRepository orderRepository;
    private final ProductClient productClient;
    private final KafkaTemplate<String, String> kafkaTemplate;

    public OrderService(OrderRepository orderRepository, 
                       ProductClient productClient,
                       KafkaTemplate<String, String> kafkaTemplate) {
        this.orderRepository = orderRepository;
        this.productClient = productClient;
        this.kafkaTemplate = kafkaTemplate;
    }

    @Transactional
    public Order createOrder(String customerEmail, List<OrderItem> items) {
        // Validate products and stock
        for (OrderItem item : items) {
            ProductDTO product = productClient.getProduct(item.getProductId());
            if (product.getStock() < item.getQuantity()) {
                throw new RuntimeException("Insufficient stock for product: " + product.getName());
            }
            item.setPrice(product.getPrice());
        }

        // Create order
        Order newOrder = new Order();
        newOrder.setCustomerEmail(customerEmail);
        newOrder.setOrderDate(LocalDateTime.now());
        newOrder.setStatus("PENDING");
        newOrder.setItems(items);
        
        // Set order reference in items
        items.forEach(item -> item.setOrder(newOrder));

        // Save order
        Order savedOrder = orderRepository.save(newOrder);

        // Send notification
        kafkaTemplate.send("order-notifications", 
            String.format("New order created: %d for customer: %s", savedOrder.getId(), customerEmail));

        return savedOrder;
    }

    public Order getOrder(Long id) {
        return orderRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Order not found"));
    }

    public List<Order> getAllOrders() {
        return orderRepository.findAll();
    }
} 