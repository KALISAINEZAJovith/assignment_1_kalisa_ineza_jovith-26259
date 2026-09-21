-- =====================================================================
-- Sunrise Supermarket - Assignment 1
-- 03_queries.sql
-- DBMS: PostgreSQL 16
-- All JOIN / CTE / window-function queries required by the assignment.
-- Run 01_schema.sql and 02_seed_data.sql first.
-- =====================================================================


-- ---------------------------------------------------------------------
-- JOIN QUERY 1
-- Every order with the customer's name, city, and order date.
-- (INNER JOIN: orders + customers)
-- ---------------------------------------------------------------------
SELECT o.order_id,
       c.customer_name,
       c.city,
       o.order_date
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
ORDER BY o.order_date;


-- ---------------------------------------------------------------------
-- JOIN QUERY 2
-- Every order item with product name, category, price, and quantity.
-- (JOIN: order_items + products)
-- ---------------------------------------------------------------------
SELECT oi.order_item_id,
       oi.order_id,
       p.product_name,
       p.category,
       p.price,
       oi.quantity,
       (p.price * oi.quantity) AS line_total
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
ORDER BY oi.order_id, oi.order_item_id;


-- ---------------------------------------------------------------------
-- JOIN QUERY 3
-- All customers and their orders where they exist, including customers
-- with no orders.
-- (LEFT JOIN: customers + orders)
-- ---------------------------------------------------------------------
SELECT c.customer_id,
       c.customer_name,
       o.order_id,
       o.order_date
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
ORDER BY c.customer_id, o.order_date;


-- ---------------------------------------------------------------------
-- CTE QUERY 1
-- Each customer's total spend (quantity x price); return customers
-- above average spend. A CTE computes customer totals first.
-- ---------------------------------------------------------------------
WITH customer_totals AS (
    SELECT c.customer_id,
           c.customer_name,
           SUM(oi.quantity * p.price) AS total_spend
    FROM customers c
    JOIN orders o       ON o.customer_id = c.customer_id
    JOIN order_items oi ON oi.order_id = o.order_id
    JOIN products p     ON p.product_id = oi.product_id
    GROUP BY c.customer_id, c.customer_name
)
SELECT customer_id,
       customer_name,
       total_spend,
       (SELECT ROUND(AVG(total_spend), 2) FROM customer_totals) AS avg_spend
FROM customer_totals
WHERE total_spend > (SELECT AVG(total_spend) FROM customer_totals)
ORDER BY total_spend DESC;


-- ---------------------------------------------------------------------
-- WINDOW-FUNCTION QUERY 1
-- Rank customers by total amount spent, highest first.
-- ---------------------------------------------------------------------
WITH customer_totals AS (
    SELECT c.customer_id,
           c.customer_name,
           SUM(oi.quantity * p.price) AS total_spend
    FROM customers c
    JOIN orders o       ON o.customer_id = c.customer_id
    JOIN order_items oi ON oi.order_id = o.order_id
    JOIN products p     ON p.product_id = oi.product_id
    GROUP BY c.customer_id, c.customer_name
)
SELECT customer_name,
       total_spend,
       RANK() OVER (ORDER BY total_spend DESC) AS spend_rank
FROM customer_totals
ORDER BY spend_rank;


-- ---------------------------------------------------------------------
-- WINDOW-FUNCTION QUERY 2
-- Number each customer's orders in the order they were placed.
-- ---------------------------------------------------------------------
SELECT c.customer_name,
       o.order_id,
       o.order_date,
       ROW_NUMBER() OVER (PARTITION BY c.customer_id ORDER BY o.order_date) AS order_seq
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
ORDER BY c.customer_name, order_seq;


-- ---------------------------------------------------------------------
-- WINDOW-FUNCTION QUERY 3
-- Running total of revenue over time, ordered by order date.
-- ---------------------------------------------------------------------
WITH order_revenue AS (
    SELECT o.order_id,
           o.order_date,
           SUM(oi.quantity * p.price) AS order_revenue
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    JOIN products p     ON p.product_id = oi.product_id
    GROUP BY o.order_id, o.order_date
)
SELECT order_id,
       order_date,
       order_revenue,
       SUM(order_revenue) OVER (ORDER BY order_date, order_id
                                 ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
FROM order_revenue
ORDER BY order_date, order_id;


-- ---------------------------------------------------------------------
-- WINDOW-FUNCTION QUERY 4
-- For each customer with more than one order, show days between the
-- current and previous order.
-- ---------------------------------------------------------------------
WITH order_gaps AS (
    SELECT c.customer_name,
           o.order_id,
           o.order_date,
           LAG(o.order_date) OVER (PARTITION BY c.customer_id ORDER BY o.order_date) AS prev_order_date,
           COUNT(*) OVER (PARTITION BY c.customer_id) AS order_count
    FROM orders o
    JOIN customers c ON c.customer_id = o.customer_id
)
SELECT customer_name,
       order_id,
       order_date,
       prev_order_date,
       (order_date - prev_order_date) AS days_since_previous
FROM order_gaps
WHERE order_count > 1
ORDER BY customer_name, order_date;
