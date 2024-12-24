package com.inventory.notification.model;

import jakarta.persistence.*;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@Entity
public class Notification {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String message;
    private String recipientEmail;
    private String status;
    private LocalDateTime createdAt;
    private LocalDateTime sentAt;
} 