-- Clear existing data
TRUNCATE TABLE notifications CASCADE;

-- Insert test notifications
INSERT INTO notifications (order_id, customer_email, message, status, created_at) VALUES
(1, 'john@example.com', 'Your order #1 has been completed successfully!', 'SENT', CURRENT_TIMESTAMP - INTERVAL '2 days'),
(2, 'jane@example.com', 'Your order #2 is pending confirmation.', 'SENT', CURRENT_TIMESTAMP - INTERVAL '1 day'),
(3, 'bob@example.com', 'Your order #3 is being processed.', 'PENDING', CURRENT_TIMESTAMP); 