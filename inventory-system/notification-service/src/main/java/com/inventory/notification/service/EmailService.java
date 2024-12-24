package com.inventory.notification.service;

import com.inventory.notification.model.Notification;
import org.springframework.stereotype.Service;

@Service
public class EmailService {
    
    public void sendEmail(Notification notification) {
        // Implement actual email sending logic here
        // This is just a placeholder
        System.out.println("Sending email notification: " + notification.getMessage());
    }
} 