-- Create database
CREATE DATABASE ecommerce_sales;
USE ecommerce_sales;

-- Customers table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    city VARCHAR(50),
    country VARCHAR(50),
    signup_date DATE
);
INSERT INTO customers VALUES
(1, 'Alice Johnson', 'alice@email.com', 'New York', 'USA', '2023-01-15'),
(2, 'Rahul Sharma', 'rahul@email.com', 'Delhi', 'India', '2023-02-20'),
(3, 'Aliza Oakley', 'Aliza@email.com', 'Madrid', 'Spain', '2023-03-10'),
(4, 'Jhon stewart', 'Jhon@email.com', 'Madrid', 'New York', '2022-06-16'),
(5, 'Annie Jane',  'Annie@email.com', 'Madrid', 'Italy', '2025-07-25'),
(6, 'Clint Eastwood', 'Clint@email.com', 'Madrid', 'Veitnam', '2020-03-24'),
(7, 'Emma Watson', 'Emma@email.com', 'Madrid', 'Japan', '2021-09-20'),
(8, 'Ayushi Tomar', 'Ayushi@email.com', 'Agra', 'India', '2025-08-17'),
(9, 'Rithik Kasawa', 'Rithik@email.com', 'Mumbai', 'India', '2024-03-10'),
(10, 'Aryan Jain', 'Aryan@email.com', 'Noida', 'India', '2025-04-19');



-- Products table
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);
INSERT INTO products VALUES
(101, 'Laptop', 'Electronics', 800000.00),
(102, 'Headphones', 'Electronics', 500.00),
(103, 'Office Chair', 'Furniture', 12000.00),
(104, 'Coffee Maker', 'Appliances', 700.00),
(105, 'Sofa', 'Furniture', 500000.00),
(106, 'Refridgerator', 'Appliances', 20000.00),
(107, 'Almira', 'Furniture', 12000.00),
(108, 'Mixer-Grinder ', 'Appliances', 12000.00),
(109, 'Showcase', 'Furniture', 12000.00),
(110, 'Air-Conditioner', 'Electronics', 45000.00);


-- Orders table
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_id INT,
    order_date DATE,
    quantity INT,
    shipping_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);
INSERT INTO orders VALUES
(1001, 1, 101, '2025-05-10', 1, '2025-05-12'),
(1002, 2, 102, '2025-05-11', 4, '2025-05-13'),
(1003, 1, 103, '2025-06-01', 5, '2025-06-05'),
(1004, 4, 104, '2025-06-15', 5, '2025-06-20'),
(1005, 5, 105, '2025-07-05', 2, '2025-07-08'),
(1006, 7, 106, '2025-06-15', 2, '2025-06-20'),
(1007, 4, 107, '2025-07-15', 1, '2025-07-20'),
(1008, 5, 104, '2025-08-17', 4, '2025-08-20'),
(1009, 6, 103, '2025-09-25', 4, '2025-09-28'),
(1010, 8, 105, '2025-04-16', 1, '2025-06-20');
-- update Entry--
update orders 
set shipping_date = "2025-04-20"
where order_id = 1010;

------------------------------------------------
-- Analysis Queries.
-------------------------------------------------
-- Q1: Top Customers by Revenue.

SELECT c.customer_name, SUM(p.price * o.quantity) AS total_spent
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN products p ON o.product_id = p.product_id
GROUP BY c.customer_name
ORDER BY total_spent DESC
LIMIT 5;

-- Q2: Monthly Sales.

SELECT DATE_FORMAT(order_date, '%Y-%m') AS month,
       SUM(p.price * o.quantity) AS monthly_sales
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY month
ORDER BY month;

-- Q3: Best Selling Products.

SELECT p.product_name, SUM(o.quantity) AS total_sold
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sold DESC;

-- Q4 Repeate Buyers.

SELECT c.customer_name,
       COUNT(DISTINCT o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name
HAVING total_orders > 1;

-- Q5 Shipping Performance.

SELECT order_id,
       DATEDIFF(shipping_date, order_date) AS shipping_days
FROM orders
ORDER BY shipping_days DESC;

-- Q6 Category-wise Sales Contribution

SELECT p.category,
       ROUND(SUM(p.price * o.quantity) * 100 / 
       (SELECT SUM(p2.price * o2.quantity) 
        FROM orders o2 
        JOIN products p2 ON o2.product_id = p2.product_id), 2) AS contribution_percentage
FROM orders o
JOIN products p ON o.product_id = p.product_id
GROUP BY p.category;

-- Q6 Rank Customers by Spendings.

SELECT c.customer_name,
       SUM(p.price * o.quantity) AS total_spent,
       RANK() OVER (ORDER BY SUM(p.price * o.quantity) DESC) AS rank_by_spending
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN products p ON o.product_id = p.product_id
GROUP BY c.customer_name;





















