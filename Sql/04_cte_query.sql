-- ============================================================
-- Sunrise Supermarket - CTE Query
-- Student: KALISA INEZA Jovith
-- Student ID: 26259
-- DBMS: Oracle Database 21c
-- Schema: SYSTEM
-- ============================================================


-- ============================================================
-- CTE QUERY
-- Calculate each customer's total spending
-- and return customers whose spending is above
-- the average customer spending
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
    total_spend
FROM customer_totals
WHERE total_spend > (
    SELECT AVG(total_spend)
    FROM customer_totals
)
ORDER BY total_spend DESC;