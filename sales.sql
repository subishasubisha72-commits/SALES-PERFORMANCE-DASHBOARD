
/* ============================================================
   RETAIL SALES & CUSTOMER ANALYTICS DATABASE USING SQL
   Database: MySQL 8.0
   ============================================================ */

-- ============================================================
-- 1. CREATE DATABASE
-- ============================================================

DROP DATABASE IF EXISTS retail_sales_analytics;

CREATE DATABASE retail_sales_analytics;

USE retail_sales_analytics;


-- ============================================================
-- 2. CREATE CUSTOMERS TABLE
-- ============================================================

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(20),
    gender ENUM('Male','Female','Other'),
    date_of_birth DATE,
    city VARCHAR(50),
    state VARCHAR(50),
    country VARCHAR(50) DEFAULT 'India',
    registration_date DATE NOT NULL,
    customer_status ENUM('Active','Inactive') DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- 3. CREATE CATEGORIES TABLE
-- ============================================================

CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(255)
);


-- ============================================================
-- 4. CREATE PRODUCTS TABLE
-- ============================================================

CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
    category_id INT NOT NULL,
    brand VARCHAR(100),
    unit_price DECIMAL(10,2) NOT NULL,
    cost_price DECIMAL(10,2) NOT NULL,
    stock_quantity INT DEFAULT 0,
    reorder_level INT DEFAULT 10,
    product_status ENUM('Active','Inactive') DEFAULT 'Active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT fk_product_category
        FOREIGN KEY (category_id)
        REFERENCES categories(category_id),

    CONSTRAINT chk_product_price
        CHECK (unit_price >= 0 AND cost_price >= 0),

    CONSTRAINT chk_stock
        CHECK (stock_quantity >= 0)
);


-- ============================================================
-- 5. CREATE STORES TABLE
-- ============================================================

CREATE TABLE stores (
    store_id INT AUTO_INCREMENT PRIMARY KEY,
    store_name VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50),
    country VARCHAR(50) DEFAULT 'India',
    opening_date DATE,
    manager_name VARCHAR(100)
);


-- ============================================================
-- 6. CREATE EMPLOYEES TABLE
-- ============================================================

CREATE TABLE employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(20),
    job_title VARCHAR(50),
    store_id INT,

    CONSTRAINT fk_employee_store
        FOREIGN KEY (store_id)
        REFERENCES stores(store_id)
);


-- ============================================================
-- 7. CREATE ORDERS TABLE
-- ============================================================

CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    store_id INT NOT NULL,
    employee_id INT,
    order_date DATETIME NOT NULL,

    payment_method ENUM(
        'Cash',
        'Credit Card',
        'Debit Card',
        'UPI',
        'Net Banking'
    ) NOT NULL,

    order_status ENUM(
        'Completed',
        'Pending',
        'Cancelled',
        'Returned'
    ) DEFAULT 'Completed',

    total_amount DECIMAL(12,2) DEFAULT 0,

    CONSTRAINT fk_order_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id),

    CONSTRAINT fk_order_store
        FOREIGN KEY (store_id)
        REFERENCES stores(store_id),

    CONSTRAINT fk_order_employee
        FOREIGN KEY (employee_id)
        REFERENCES employees(employee_id)
);


-- ============================================================
-- 8. CREATE ORDER ITEMS TABLE
-- ============================================================

CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    discount_percent DECIMAL(5,2) DEFAULT 0,

    subtotal DECIMAL(12,2)
        GENERATED ALWAYS AS
        (
            quantity * unit_price *
            (1 - discount_percent / 100)
        ) STORED,

    CONSTRAINT fk_item_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
        ON DELETE CASCADE,

    CONSTRAINT fk_item_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id),

    CONSTRAINT chk_quantity
        CHECK (quantity > 0),

    CONSTRAINT chk_discount
        CHECK (discount_percent BETWEEN 0 AND 100)
);


-- ============================================================
-- 9. CREATE PAYMENTS TABLE
-- ============================================================

CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    payment_date DATETIME NOT NULL,
    amount DECIMAL(12,2) NOT NULL,

    payment_method ENUM(
        'Cash',
        'Credit Card',
        'Debit Card',
        'UPI',
        'Net Banking'
    ) NOT NULL,

    payment_status ENUM(
        'Successful',
        'Pending',
        'Failed',
        'Refunded'
    ) DEFAULT 'Successful',

    CONSTRAINT fk_payment_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id),

    CONSTRAINT chk_payment_amount
        CHECK (amount >= 0)
);

SHOW TABLES;

-- ============================================================
-- 10. INSERT CATEGORIES
-- ============================================================

INSERT INTO categories
(category_name, description)
VALUES
('Electronics', 'Electronic devices and accessories'),
('Clothing', 'Men and women clothing'),
('Home Appliances', 'Appliances for home use'),
('Grocery', 'Food and grocery products'),
('Beauty', 'Beauty and personal care products'),
('Sports', 'Sports and fitness products');


-- ============================================================
-- 11. INSERT CUSTOMERS
-- ============================================================

INSERT INTO customers
(first_name, last_name, email, phone, gender, date_of_birth,
 city, state, country, registration_date, customer_status)
VALUES
('Arun','Kumar','arun@gmail.com','9876543210','Male',
 '1998-05-12','Chennai','Tamil Nadu','India',
 '2024-01-15','Active'),

('Priya','Sharma','priya@gmail.com','9876543211','Female',
 '1997-08-20','Bangalore','Karnataka','India',
 '2024-02-10','Active'),

('Rahul','Verma','rahul@gmail.com','9876543212','Male',
 '1995-03-18','Mumbai','Maharashtra','India',
 '2024-03-05','Active'),

('Sneha','Reddy','sneha@gmail.com','9876543213','Female',
 '1999-11-25','Hyderabad','Telangana','India',
 '2024-03-20','Active'),

('Vikram','Singh','vikram@gmail.com','9876543214','Male',
 '1996-07-14','Delhi','Delhi','India',
 '2024-04-01','Active'),

('Anjali','Patel','anjali@gmail.com','9876543215','Female',
 '2000-01-30','Ahmedabad','Gujarat','India',
 '2024-04-15','Active'),

('Karthik','Raj','karthik@gmail.com','9876543216','Male',
 '1994-12-10','Coimbatore','Tamil Nadu','India',
 '2024-05-01','Active'),

('Meena','Iyer','meena@gmail.com','9876543217','Female',
 '1998-06-08','Chennai','Tamil Nadu','India',
 '2024-05-10','Active'),

('Suresh','Nair','suresh@gmail.com','9876543218','Male',
 '1993-09-22','Kochi','Kerala','India',
 '2024-06-01','Active'),

('Divya','Menon','divya@gmail.com','9876543219','Female',
 '2001-02-16','Kochi','Kerala','India',
 '2024-06-15','Inactive');


-- ============================================================
-- 12. INSERT STORES
-- ============================================================

INSERT INTO stores
(store_name, city, state, country, opening_date, manager_name)
VALUES
('Chennai Central Store','Chennai','Tamil Nadu','India',
 '2023-01-10','Ramesh Kumar'),

('Bangalore City Store','Bangalore','Karnataka','India',
 '2023-03-15','Sanjay Rao'),

('Mumbai Mall Store','Mumbai','Maharashtra','India',
 '2023-05-20','Amit Shah'),

('Hyderabad Store','Hyderabad','Telangana','India',
 '2023-07-01','Ravi Teja');


-- ============================================================
-- 13. INSERT EMPLOYEES
-- ============================================================

INSERT INTO employees
(first_name,last_name,email,phone,job_title,store_id)
VALUES
('Ramesh','Kumar','ramesh@retail.com','9000000001',
 'Manager',1),

('Sanjay','Rao','sanjay@retail.com','9000000002',
 'Manager',2),

('Amit','Shah','amit@retail.com','9000000003',
 'Manager',3),

('Ravi','Teja','ravi@retail.com','9000000004',
 'Manager',4),

('John','Peter','john@retail.com','9000000005',
 'Sales Executive',1),

('Kavya','Krishnan','kavya@retail.com','9000000006',
 'Sales Executive',2);


-- ============================================================
-- 14. INSERT PRODUCTS
-- ============================================================

INSERT INTO products
(product_name,category_id,brand,unit_price,cost_price,
 stock_quantity,reorder_level)
VALUES
('iPhone 15',1,'Apple',69999,60000,25,5),

('Samsung Galaxy S24',1,'Samsung',64999,55000,30,5),

('Dell Inspiron Laptop',1,'Dell',55999,48000,15,5),

('Sony Headphones',1,'Sony',7999,5500,50,10),

('Men T-Shirt',2,'Levis',1499,800,100,20),

('Women Dress',2,'Zara',2999,1800,70,15),

('Running Shoes',6,'Nike',5999,3500,40,10),

('Mixer Grinder',3,'Philips',4499,3000,35,8),

('Refrigerator',3,'LG',42999,36000,12,3),

('Rice 5kg',4,'India Gate',499,400,200,30),

('Face Cream',5,'Nivea',399,250,150,20),

('Protein Powder',6,'MuscleBlaze',2499,1700,60,10);


-- ============================================================
-- 15. INSERT ORDERS
-- ============================================================

INSERT INTO orders
(customer_id,store_id,employee_id,order_date,
 payment_method,order_status,total_amount)
VALUES
(1,1,5,'2025-01-05 10:30:00','UPI','Completed',69999),

(2,2,6,'2025-01-10 12:15:00','Credit Card','Completed',2999),

(3,3,3,'2025-01-15 15:20:00','Debit Card','Completed',55999),

(4,4,4,'2025-01-20 18:30:00','UPI','Completed',5999),

(5,1,5,'2025-02-02 11:00:00','Cash','Completed',1499),

(6,2,6,'2025-02-10 16:45:00','UPI','Completed',42999),

(7,1,5,'2025-02-18 13:10:00','Credit Card','Completed',7999),

(8,1,5,'2025-03-01 17:00:00','UPI','Completed',2499),

(9,4,4,'2025-03-10 14:25:00','Cash','Completed',499),

(10,3,3,'2025-03-15 19:30:00','Credit Card','Completed',4499),

(1,1,5,'2025-04-01 10:00:00','UPI','Completed',8358),

(2,2,6,'2025-04-12 15:00:00','Debit Card','Completed',5999),

(3,3,3,'2025-05-05 16:00:00','UPI','Completed',64999),

(4,4,4,'2025-05-18 12:30:00','Cash','Completed',2499),

(5,1,5,'2025-06-01 17:45:00','Credit Card','Completed',4499);


-- ============================================================
-- 16. INSERT ORDER ITEMS
-- ============================================================

INSERT INTO order_items
(order_id,product_id,quantity,unit_price,discount_percent)
VALUES
(1,1,1,69999,0),

(2,6,1,2999,0),

(3,3,1,55999,0),

(4,7,1,5999,0),

(5,5,1,1499,0),

(6,9,1,42999,0),

(7,4,1,7999,0),

(8,12,1,2499,0),

(9,10,1,499,0),

(10,8,1,4499,0),

(11,4,1,7999,0),
(11,11,1,399,10),

(12,7,1,5999,0),

(13,2,1,64999,0),

(14,12,1,2499,0),

(15,8,1,4499,0);


-- ============================================================
-- 17. INSERT PAYMENTS
-- ============================================================

INSERT INTO payments
(order_id,payment_date,amount,payment_method,payment_status)
SELECT
    order_id,
    order_date,
    total_amount,
    payment_method,
    'Successful'
FROM orders
WHERE order_status = 'Completed';


-- ============================================================
-- 18. CREATE INDEXES
-- ============================================================

CREATE INDEX idx_customer_email
ON customers(email);

CREATE INDEX idx_order_customer
ON orders(customer_id);

CREATE INDEX idx_order_date
ON orders(order_date);

CREATE INDEX idx_order_store
ON orders(store_id);

CREATE INDEX idx_order_status
ON orders(order_status);

CREATE INDEX idx_product_category
ON products(category_id);

CREATE INDEX idx_orderitem_product
ON order_items(product_id);
SELECT * FROM categories;

SELECT * FROM stores;

SELECT * FROM customers;

SELECT * FROM products;

-- ============================================================
-- 19. CREATE SALES SUMMARY VIEW
-- ============================================================
CREATE VIEW sales_summary AS
SELECT
    o.order_id,
    o.order_date,

    CONCAT(
        c.first_name,' ',c.last_name
    ) AS customer_name,

    s.store_name,
    o.payment_method,
    o.order_status,
    o.total_amount

FROM orders o

JOIN customers c
    ON o.customer_id = c.customer_id

JOIN stores s
    ON o.store_id = s.store_id;

-- ============================================================
-- 20. CREATE CUSTOMER SALES VIEW
-- ============================================================

CREATE VIEW customer_sales_summary AS
SELECT
    c.customer_id,

    CONCAT(
        c.first_name,' ',c.last_name
    ) AS customer_name,

    c.city,

    COUNT(o.order_id) AS total_orders,

    COALESCE(
        SUM(o.total_amount),0
    ) AS total_spent,

    COALESCE(
        AVG(o.total_amount),0
    ) AS average_order_value

FROM customers c

LEFT JOIN orders o
    ON c.customer_id = o.customer_id
    AND o.order_status = 'Completed'

GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name,
    c.city;
-- ============================================================
-- 21. CREATE PRODUCT PERFORMANCE VIEW
-- ============================================================

CREATE VIEW product_performance AS
SELECT
    p.product_id,
    p.product_name,
    c.category_name,
    p.brand,
    p.unit_price,
    p.cost_price,

    COALESCE(
        SUM(oi.quantity),0
    ) AS units_sold,

    COALESCE(
        SUM(oi.subtotal),0
    ) AS revenue,

    COALESCE(
        SUM(
            oi.quantity *
            (p.unit_price-p.cost_price)
        ),0
    ) AS estimated_profit

FROM products p

JOIN categories c
    ON p.category_id = c.category_id

LEFT JOIN order_items oi
    ON p.product_id = oi.product_id

GROUP BY
    p.product_id,
    p.product_name,
    c.category_name,
    p.brand,
    p.unit_price,
    p.cost_price;


-- ============================================================
-- 22. STORED PROCEDURE - CUSTOMER SALES
-- ============================================================

DELIMITER $$

CREATE PROCEDURE GetCustomerSales(
    IN p_customer_id INT
)
BEGIN

    SELECT
        c.customer_id,

        CONCAT(
            c.first_name,' ',c.last_name
        ) AS customer_name,

        COUNT(o.order_id) AS total_orders,

        COALESCE(
            SUM(o.total_amount),0
        ) AS total_spent,

        COALESCE(
            AVG(o.total_amount),0
        ) AS average_order_value

    FROM customers c

    LEFT JOIN orders o
        ON c.customer_id = o.customer_id
        AND o.order_status = 'Completed'

    WHERE c.customer_id = p_customer_id

    GROUP BY
        c.customer_id,
        c.first_name,
        c.last_name;

END $$

DELIMITER ;


-- ============================================================
-- 23. STORED PROCEDURE - SALES BETWEEN DATES
-- ============================================================

DELIMITER $$

CREATE PROCEDURE GetSalesByDate(
    IN p_start_date DATE,
    IN p_end_date DATE
)
BEGIN

    SELECT
        DATE(order_date) AS sale_date,
        COUNT(order_id) AS number_of_orders,
        SUM(total_amount) AS total_sales

    FROM orders

    WHERE order_status = 'Completed'

    AND DATE(order_date)
        BETWEEN p_start_date AND p_end_date

    GROUP BY DATE(order_date)

    ORDER BY sale_date;

END $$

DELIMITER ;


-- ============================================================
-- 24. FUNCTION - CUSTOMER LIFETIME VALUE
-- ============================================================

DELIMITER $$

CREATE FUNCTION CalculateCustomerLifetimeValue(
    p_customer_id INT
)
RETURNS DECIMAL(12,2)
DETERMINISTIC
READS SQL DATA

BEGIN

    DECLARE total_value DECIMAL(12,2);

    SELECT
        COALESCE(SUM(total_amount),0)

    INTO total_value

    FROM orders

    WHERE customer_id = p_customer_id

    AND order_status = 'Completed';

    RETURN total_value;

END $$

DELIMITER ;


-- ============================================================
-- 25. CUSTOMER ANALYTICS
-- ============================================================

SELECT
    c.customer_id,

    CONCAT(
        c.first_name,' ',c.last_name
    ) AS customer_name,

    COUNT(o.order_id) AS total_orders,

    COALESCE(
        SUM(o.total_amount),0
    ) AS total_spent

FROM customers c

LEFT JOIN orders o
    ON c.customer_id = o.customer_id
    AND o.order_status = 'Completed'

GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name

ORDER BY total_spent DESC;


-- ============================================================
-- 26. PRODUCT ANALYTICS
-- ============================================================

SELECT
    p.product_name,

    SUM(oi.quantity) AS units_sold,

    SUM(oi.subtotal) AS revenue

FROM products p

JOIN order_items oi
    ON p.product_id = oi.product_id

JOIN orders o
    ON oi.order_id = o.order_id

WHERE o.order_status = 'Completed'

GROUP BY
    p.product_id,
    p.product_name

ORDER BY revenue DESC;


-- ============================================================
-- 27. CATEGORY SALES
-- ============================================================
SELECT
    c.category_name,
    SUM(oi.subtotal) AS total_revenue
FROM categories c
JOIN products p
    ON c.category_id = p.category_id
JOIN order_items oi
    ON p.product_id = oi.product_id
JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_status = 'Completed'
GROUP BY
    c.category_id,
    c.category_name
ORDER BY total_revenue DESC;


-- ============================================================
-- 28. STORE SALES
-- ======================================================
SELECT
    s.store_name,
    s.city,
COUNT(o.order_id) AS total_orders,
SUM(o.total_amount) AS total_sales
FROM stores s
LEFT JOIN orders o
    ON s.store_id = o.store_id
    AND o.order_status = 'Completed'
GROUP BY
    s.store_id,
    s.store_name,
    s.city
ORDER BY total_sales DESC;


-- ============================================================
-- 29. MONTHLY SALES
-- ============================================================

SELECT
    YEAR(order_date) AS sales_year,

    MONTH(order_date) AS sales_month,

    SUM(total_amount) AS monthly_sales

FROM orders

WHERE order_status = 'Completed'

GROUP BY
    YEAR(order_date),
    MONTH(order_date)

ORDER BY
    sales_year,
    sales_month;


-- ============================================================
-- 30. PAYMENT METHOD ANALYSIS
-- ============================================================

SELECT
    payment_method,

    COUNT(*) AS transactions,

    SUM(total_amount) AS total_sales

FROM orders

WHERE order_status = 'Completed'

GROUP BY payment_method

ORDER BY total_sales DESC;


-- ============================================================
-- 31. TOP 5 CUSTOMERS
-- ============================================================

SELECT
    c.customer_id,

    CONCAT(
        c.first_name,' ',c.last_name
    ) AS customer_name,

    SUM(o.total_amount) AS total_spent

FROM customers c

JOIN orders o
    ON c.customer_id = o.customer_id

WHERE o.order_status = 'Completed'

GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name

ORDER BY total_spent DESC

LIMIT 5;


-- ============================================================
-- 32. TOP 5 PRODUCTS
-- ============================================================

SELECT
    p.product_name,

    SUM(oi.quantity) AS units_sold

FROM products p

JOIN order_items oi
    ON p.product_id = oi.product_id

JOIN orders o
    ON oi.order_id = o.order_id

WHERE o.order_status = 'Completed'

GROUP BY
    p.product_id,
    p.product_name

ORDER BY units_sold DESC

LIMIT 5;


-- ============================================================
-- 33. LOW STOCK PRODUCTS
-- ============================================================

SELECT
    product_id,
    product_name,
    stock_quantity,
    reorder_level

FROM products

WHERE stock_quantity <= reorder_level;


-- ============================================================
-- 34. PRODUCT PROFIT ANALYSIS
-- ============================================================

SELECT
    product_name,
    brand,
    unit_price,
    cost_price,

    unit_price - cost_price AS profit_per_unit

FROM products

ORDER BY profit_per_unit DESC;


-- ============================================================
-- 35. CUSTOMER SEGMENTATION
-- ============================================================

SELECT
    c.customer_id,

    CONCAT(
        c.first_name,' ',c.last_name
    ) AS customer_name,

    COALESCE(
        SUM(o.total_amount),0
    ) AS total_spent,

    CASE

        WHEN COALESCE(SUM(o.total_amount),0) >= 100000
            THEN 'VIP Customer'

        WHEN COALESCE(SUM(o.total_amount),0) >= 50000
            THEN 'Premium Customer'

        WHEN COALESCE(SUM(o.total_amount),0) >= 10000
            THEN 'Regular Customer'

        ELSE 'Low Value Customer'

    END AS customer_segment

FROM customers c

LEFT JOIN orders o
    ON c.customer_id = o.customer_id
    AND o.order_status = 'Completed'

GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name

ORDER BY total_spent DESC;


-- ============================================================
-- 36. REPEAT CUSTOMERS
-- ============================================================

SELECT
    c.customer_id,

    CONCAT(
        c.first_name,' ',c.last_name
    ) AS customer_name,

    COUNT(o.order_id) AS number_of_orders

FROM customers c

JOIN orders o
    ON c.customer_id = o.customer_id

WHERE o.order_status = 'Completed'

GROUP BY
    c.customer_id,
    c.first_name,
    c.last_name

HAVING COUNT(o.order_id) > 1;


-- ============================================================
-- 37. CUSTOMER LIFETIME VALUE
-- ============================================================

SELECT
    customer_id,

    CONCAT(
        first_name,' ',last_name
    ) AS customer_name,

    CalculateCustomerLifetimeValue(customer_id)
        AS lifetime_value

FROM customers

ORDER BY lifetime_value DESC;


-- ============================================================
-- 38. RUNNING SALES TOTAL
-- ============================================================

SELECT
    order_id,
    order_date,
    total_amount,

    SUM(total_amount) OVER (
        ORDER BY order_date, order_id
    ) AS running_total

FROM orders

WHERE order_status = 'Completed'

ORDER BY order_date, order_id;


-- ============================================================
-- 39. STORE SALES RANKING
-- ============================================================

SELECT
    s.store_name,

    SUM(o.total_amount) AS total_sales,

    RANK() OVER (
        ORDER BY SUM(o.total_amount) DESC
    ) AS sales_rank

FROM stores s

JOIN orders o
    ON s.store_id = o.store_id

WHERE o.order_status = 'Completed'

GROUP BY
    s.store_id,
    s.store_name;


-- ============================================================
-- 40. EMPLOYEE PERFORMANCE
-- ============================================================

SELECT
    e.employee_id,

    CONCAT(
        e.first_name,' ',e.last_name
    ) AS employee_name,

    e.job_title,

    COUNT(o.order_id) AS orders_handled,

    COALESCE(
        SUM(o.total_amount),0
    ) AS sales_generated

FROM employees e

LEFT JOIN orders o
    ON e.employee_id = o.employee_id
    AND o.order_status = 'Completed'

GROUP BY
    e.employee_id,
    e.first_name,
    e.last_name,
    e.job_title

ORDER BY sales_generated DESC;


-- ============================================================
-- 41. TOTAL REVENUE
-- ============================================================

SELECT
    SUM(total_amount) AS total_revenue

FROM orders

WHERE order_status = 'Completed';


-- ============================================================
-- 42. AVERAGE ORDER VALUE
-- ============================================================

SELECT
    AVG(total_amount) AS average_order_value

FROM orders

WHERE order_status = 'Completed';


-- ============================================================
-- 43. TOTAL ORDERS
-- ============================================================

SELECT
    COUNT(*) AS total_orders

FROM orders

WHERE order_status = 'Completed';


-- ============================================================
-- 44. TOTAL UNITS SOLD
-- ============================================================

SELECT
    SUM(oi.quantity) AS total_units_sold

FROM order_items oi

JOIN orders o
    ON oi.order_id = o.order_id

WHERE o.order_status = 'Completed';


-- ============================================================
-- 45. ESTIMATED PROFIT
-- ============================================================

SELECT
    SUM(
        oi.quantity *
        (p.unit_price - p.cost_price)
    ) AS estimated_profit

FROM order_items oi

JOIN products p
    ON oi.product_id = p.product_id

JOIN orders o
    ON oi.order_id = o.order_id

WHERE o.order_status = 'Completed';


-- ============================================================
-- 46. FINAL DASHBOARD SUMMARY
-- ============================================================

SELECT

    (SELECT COUNT(*)
     FROM customers) AS total_customers,

    (SELECT COUNT(*)
     FROM products) AS total_products,

    (SELECT COUNT(*)
     FROM orders
     WHERE order_status = 'Completed') AS total_orders,

    (SELECT SUM(total_amount)
     FROM orders
     WHERE order_status = 'Completed') AS total_revenue,

    (SELECT AVG(total_amount)
     FROM orders
     WHERE order_status = 'Completed') AS average_order_value,

    (SELECT SUM(oi.quantity)
     FROM order_items oi
     JOIN orders o
        ON oi.order_id = o.order_id
     WHERE o.order_status = 'Completed') AS total_units_sold,

    (SELECT SUM(
        oi.quantity *
        (p.unit_price - p.cost_price)
    )
     FROM order_items oi
     JOIN products p
        ON oi.product_id = p.product_id
     JOIN orders o
        ON oi.order_id = o.order_id
     WHERE o.order_status = 'Completed') AS estimated_profit;


/* ============================================================
   END OF RETAIL SALES & CUSTOMER ANALYTICS PROJECT
   ============================================================ */