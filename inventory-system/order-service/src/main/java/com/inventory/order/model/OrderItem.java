package com.inventory.order.model;

import jakarta.persistence.*;
import lombok.Data;

@Data
@Entity
public class OrderItem {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private Long productId;
    private Integer quantity;
    private Double price;
    
    @ManyToOne
    @JoinColumn(name = "order_id")
    private Order order;
} 