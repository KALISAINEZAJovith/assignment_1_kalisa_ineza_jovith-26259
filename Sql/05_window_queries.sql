-- ============================================================
-- Sunrise Supermarket - Window Function Queries
-- Student: KALISA INEZA Jovith
-- Student ID: 26259
-- DBMS: Oracle Database 21c
-- Schema: SYSTEM
-- ============================================================


-- ============================================================
-- WINDOW QUERY 1
-- Rank customers by total amount spent
-- Highest spender gets rank 1
-- ============================================================

WITH customer_totals AS (
    SELECT
        c.customer_id,
        c.customer_name,
        SUM(oi.quantity * p.price) AS total_spend
    FROM customers c
    INNER JOIN orders o
        ON c.customer_id = o.customer_id
    INNER JOIN order_items oi
        ON o.order_id = oi.order_id
    INNER JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY
        c.customer_id,
        c.customer_name
)
SELECT
    customer_id,
    customer_name,
    total_spend,
    RANK() OVER (
        ORDER BY total_spend DESC
    ) AS spending_rank
FROM customer_totals
ORDER BY spending_rank;


-- ============================================================
-- WINDOW QUERY 2
-- Number each customer's orders in the order they were placed
-- ============================================================

SELECT
    order_id,
    customer_id,
    order_date,
    ROW_NUMBER() OVER (
        PARTITION BY customer_id
        ORDER BY order_date
    ) AS customer_order_number
FROM orders
ORDER BY customer_id, order_date;


-- ============================================================
-- WINDOW QUERY 3
-- Calculate running total of revenue over time
-- ============================================================

WITH daily_revenue AS (
    SELECT
        o.order_date,
        SUM(oi.quantity * p.price) AS daily_revenue
    FROM orders o
    INNER JOIN order_items oi
        ON o.order_id = oi.order_id
    INNER JOIN products p
        ON oi.product_id = p.product_id
    GROUP BY o.order_date
)
SELECT
    order_date,
    daily_revenue,
    SUM(daily_revenue) OVER (
        ORDER BY order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total_revenue
FROM daily_revenue
ORDER BY order_date;


-- ============================================================
-- WINDOW QUERY 4
-- Calculate days between current and previous order
-- for customers with more than one order
-- ============================================================

WITH order_history AS (
    SELECT
        order_id,
        customer_id,
        order_date,
        LAG(order_date) OVER (
            PARTITION BY customer_id
            ORDER BY order_date
        ) AS previous_order_date,
        COUNT(*) OVER (
            PARTITION BY customer_id
        ) AS customer_order_count
    FROM orders
)
SELECT
    order_id,
    customer_id,
    order_date,
    previous_order_date,
    order_date - previous_order_date AS days_between_orders
FROM order_history
WHERE customer_order_count > 1
ORDER BY customer_id, order_date;