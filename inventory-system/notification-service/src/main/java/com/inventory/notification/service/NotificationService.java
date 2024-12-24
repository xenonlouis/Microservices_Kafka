package com.inventory.notification.service;

import com.inventory.notification.model.Notification;
import com.inventory.notification.repository.NotificationRepository;
import org.springframework.kafka.annotation.KafkaListener;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;

@Service
public class NotificationService {
    private final NotificationRepository notificationRepository;
    private final EmailService emailService;

    public NotificationService(NotificationRepository notificationRepository, 
                             EmailService emailService) {
        this.notificationRepository = notificationRepository;
        this.emailService = emailService;
    }

    @KafkaListener(topics = "order-notifications", groupId = "notification-group")
    public void handleOrderNotification(String message) {
        Notification notification = new Notification();
        notification.setMessage(message);
        notification.setStatus("RECEIVED");
        notification.setCreatedAt(LocalDateTime.now());
        
        // Save notification
        notification = notificationRepository.save(notification);
        
        try {
            // Send email
            emailService.sendEmail(notification);
            
            // Update notification status
            notification.setStatus("SENT");
            notification.setSentAt(LocalDateTime.now());
            notificationRepository.save(notification);
        } catch (Exception e) {
            notification.setStatus("FAILED");
            notificationRepository.save(notification);
        }
    }
} 