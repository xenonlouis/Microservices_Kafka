-- Clear existing data
TRUNCATE TABLE orders CASCADE;
TRUNCATE TABLE order_items CASCADE;

-- Insert test orders
INSERT INTO orders (customer_name, customer_email, total_amount, status, created_at) VALUES
('John Doe', 'john@example.com', 1329.98, 'COMPLETED', CURRENT_TIMESTAMP - INTERVAL '2 days'),
('Jane Smith', 'jane@example.com', 489.98, 'PENDING', CURRENT_TIMESTAMP - INTERVAL '1 day'),
('Bob Wilson', 'bob@example.com', 75.98, 'PROCESSING', CURRENT_TIMESTAMP);

-- Insert order items (linking to product IDs from product service)
INSERT INTO order_items (order_id, product_id, quantity, price) VALUES
(1, 1, 1, 1299.99),  -- Laptop XPS 15
(1, 2, 1, 29.99),    -- Wireless Mouse
(2, 4, 1, 399.99),   -- 27" Monitor
(2, 3, 1, 89.99),    -- Mechanical Keyboard
(3, 2, 1, 29.99),    -- Wireless Mouse
(3, 5, 1, 45.99);    -- USB-C Hub 