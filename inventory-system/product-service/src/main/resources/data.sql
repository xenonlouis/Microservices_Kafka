-- Clear existing data
TRUNCATE TABLE products CASCADE;

-- Insert test products
INSERT INTO products (name, description, price, stock) VALUES
('Laptop XPS 15', 'High-performance laptop with 4K display', 1299.99, 10),
('Wireless Mouse', 'Ergonomic wireless mouse', 29.99, 50),
('Mechanical Keyboard', 'RGB mechanical gaming keyboard', 89.99, 25),
('27" Monitor', '4K HDR IPS Monitor', 399.99, 15),
('USB-C Hub', '7-in-1 USB-C hub with HDMI', 45.99, 30); 