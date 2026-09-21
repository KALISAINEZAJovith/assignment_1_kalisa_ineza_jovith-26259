# Assignment 1 — Sunrise Supermarket

**Name:** Kalisa Ineza Jovith
**Student ID:** 26259
**DBMS used:** PostgreSQL 16 (works unchanged on PostgreSQL; see the note at the
bottom of this file for the one-line change needed to run it on Oracle instead,
since the original brief was written in Oracle-style DDL)

> Repository name: `assignment_1_kalisa_ineza_jovith-26259`

---

## 1. Business scenario

Sunrise Supermarket sells products to customers who place orders containing one
or more line items. Management wants three things out of the data:

1. **Who their customers are** — basic profile and location.
2. **What they buy** — which products, in which categories, at what price and
   quantity.
3. **How sales are trending over time** — order frequency, spend per customer,
   and revenue growth across the order history.

The database models this with four tables:

| Table          | Purpose                                                        |
|----------------|------------------------------------------------------------------|
| `customers`    | One row per customer (name, email, city)                        |
| `products`     | One row per product (name, category, price)                     |
| `orders`       | One row per order (which customer, on what date)                 |
| `order_items`  | One row per line item on an order (which product, what quantity) |

`order_items.quantity * products.price` gives the revenue of a single line
item; summing that up gives order totals, customer totals, and overall revenue.

## 2. How to run it

1. Install PostgreSQL (16 or later works; any recent version is fine) and make
   sure a server is running locally.
2. Create a database, e.g.:
   ```bash
   createdb sunrise_supermarket
   ```
3. From the repository root, run the three scripts in order:
   ```bash
   psql -d sunrise_supermarket -f 01_schema.sql
   psql -d sunrise_supermarket -f 02_seed_data.sql
   psql -d sunrise_supermarket -f 03_queries.sql
   ```
   `01_schema.sql` creates the four tables, `02_seed_data.sql` populates them
   with the sample data described below, and `03_queries.sql` contains every
   JOIN / CTE / window-function query, ready to run individually or as one
   script.
4. Alternatively, paste the contents of each file into `psql`, DBeaver,
   pgAdmin, or any SQL client connected to the `sunrise_supermarket` database.

### Sample data summary

- **6 customers** (one — Frank Habimana — is deliberately left with **zero
  orders**, so the LEFT JOIN query has something real to demonstrate).
- **9 products** across **6 categories**: Grocery, Bakery, Dairy, Produce,
  Meat, Household.
- **15 orders**, dated between 2026-01-05 and 2026-04-02.
- **27 order items** spread across those 15 orders.

This meets and exceeds the assignment's minimums (5 customers / 8 products /
3 categories / 15 orders / 25 order items).

## 3. Queries, explanations, and results

All results below were captured by actually running `03_queries.sql` against
the seeded PostgreSQL database (see "How to run it" above to reproduce them).

### JOIN queries

**1. Every order with customer name, city, and order date (INNER JOIN)**

```sql
SELECT o.order_id, c.customer_name, c.city, o.order_date
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
ORDER BY o.order_date;
```

*Explanation:* an `INNER JOIN` on `customer_id` attaches each order to the
customer who placed it. Only orders that have a matching customer are
returned — which is every order here, since `customer_id` is a foreign key.

*Result (15 rows, abridged):*

```
 order_id |  customer_name  |  city   | order_date
----------+-----------------+---------+------------
        1 | Alice Uwimana   | Kigali  | 2026-01-05
        2 | Brian Mugisha   | Kigali  | 2026-01-08
        3 | Alice Uwimana   | Kigali  | 2026-01-15
        4 | Clara Ingabire  | Musanze | 2026-01-20
        5 | David Niyonzima | Huye    | 2026-01-25
       ...
       15 | David Niyonzima | Huye    | 2026-04-02
```

*Business interpretation:* this is the base "order log" management would use
to see, at a glance, who ordered what and when — the starting point for any
customer-service lookup or fulfilment report.

---

**2. Every order item with product name, category, price, and quantity**

```sql
SELECT oi.order_item_id, oi.order_id, p.product_name, p.category, p.price,
       oi.quantity, (p.price * oi.quantity) AS line_total
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
ORDER BY oi.order_id, oi.order_item_id;
```

*Explanation:* joining `order_items` to `products` turns the numeric
`product_id` into a readable product name, category, and price, and lets us
compute a `line_total` for each item on the fly.

*Result (27 rows, abridged):*

```
 order_item_id | order_id |     product_name     | category  | price | quantity | line_total
---------------+----------+----------------------+-----------+-------+----------+------------
             1 |        1 | Rice 5kg             | Grocery   | 12.50 |        2 |      25.00
             2 |        1 | Milk 1L               | Dairy     |  1.20 |        3 |       3.60
             3 |        2 | Bread Loaf            | Bakery    |  1.50 |        4 |       6.00
            ...
            27 |       15 | Cheddar Cheese 250g   | Dairy     |  4.75 |        3 |      14.25
```

*Business interpretation:* this is the detail layer behind every sale — it
shows exactly what mix of products drives revenue, and it's the table
`GROUP BY category` reports (best-selling category, category revenue share,
etc.) would be built on top of.

---

**3. All customers and their orders, including customers with none (LEFT JOIN)**

```sql
SELECT c.customer_id, c.customer_name, o.order_id, o.order_date
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
ORDER BY c.customer_id, o.order_date;
```

*Explanation:* a `LEFT JOIN` keeps every row from `customers` regardless of
whether it has a matching row in `orders`. Customers with no orders get
`NULL` in the order columns instead of being dropped.

*Result (16 rows):*

```
 customer_id |  customer_name  | order_id | order_date
-------------+-----------------+----------+------------
           1 | Alice Uwimana   |        1 | 2026-01-05
           1 | Alice Uwimana   |        3 | 2026-01-15
           1 | Alice Uwimana   |        8 | 2026-02-10
           1 | Alice Uwimana   |       13 | 2026-03-15
           2 | Brian Mugisha   |        2 | 2026-01-08
           2 | Brian Mugisha   |        6 | 2026-02-02
           2 | Brian Mugisha   |       11 | 2026-03-01
           3 | Clara Ingabire  |        4 | 2026-01-20
           3 | Clara Ingabire  |        9 | 2026-02-18
           3 | Clara Ingabire  |       14 | 2026-03-22
           4 | David Niyonzima |        5 | 2026-01-25
           4 | David Niyonzima |       10 | 2026-02-25
           4 | David Niyonzima |       15 | 2026-04-02
           5 | Eva Mukamana    |        7 | 2026-02-05
           5 | Eva Mukamana    |       12 | 2026-03-10
           6 | Frank Habimana  |     NULL | NULL
```

*Business interpretation:* Frank Habimana appears with `NULL` order columns —
he's a registered customer who has never actually bought anything. This is
exactly the kind of row an `INNER JOIN` would hide, and exactly the kind of
customer a marketing team would want to target with a "come back" campaign.

### CTE query

**1. Customers above average spend**

```sql
WITH customer_totals AS (
    SELECT c.customer_id, c.customer_name,
           SUM(oi.quantity * p.price) AS total_spend
    FROM customers c
    JOIN orders o       ON o.customer_id = c.customer_id
    JOIN order_items oi ON oi.order_id = o.order_id
    JOIN products p     ON p.product_id = oi.product_id
    GROUP BY c.customer_id, c.customer_name
)
SELECT customer_id, customer_name, total_spend,
       (SELECT ROUND(AVG(total_spend), 2) FROM customer_totals) AS avg_spend
FROM customer_totals
WHERE total_spend > (SELECT AVG(total_spend) FROM customer_totals)
ORDER BY total_spend DESC;
```

*Explanation:* the CTE `customer_totals` first collapses every order line
down to one total-spend figure per customer (joining all four tables and
`GROUP BY`-ing on customer). The outer query then compares each customer's
total against the average of that same CTE, so the average is only computed
once, in one readable place, rather than being recalculated inline.

*Full customer totals (for reference), then the filtered result:*

```
 customer_id |  customer_name  | total_spend
-------------+-----------------+------------
           1 | Alice Uwimana   |       90.35
           3 | Clara Ingabire  |       51.75
           2 | Brian Mugisha   |       49.40
           4 | David Niyonzima |       44.50
           5 | Eva Mukamana    |       26.60

Average spend across the 5 purchasing customers: 52.52

-- Query result:
 customer_id | customer_name |  total_spend | avg_spend
-------------+---------------+--------------+-----------
           1 | Alice Uwimana |        90.35 |     52.52
```

*Business interpretation:* only Alice Uwimana spends above the customer
average (₣90.35 vs. an average of ₣52.52) — she's the clearest candidate for
a loyalty/VIP program. Everyone else clusters much closer together, which
also flags that the "average" here is being pulled up by one high spender —
worth remembering if this were used to set a loyalty-tier threshold.

### Window-function queries

**1. Rank customers by total spend, highest first**

```sql
WITH customer_totals AS (
    SELECT c.customer_id, c.customer_name,
           SUM(oi.quantity * p.price) AS total_spend
    FROM customers c
    JOIN orders o       ON o.customer_id = c.customer_id
    JOIN order_items oi ON oi.order_id = o.order_id
    JOIN products p     ON p.product_id = oi.product_id
    GROUP BY c.customer_id, c.customer_name
)
SELECT customer_name, total_spend,
       RANK() OVER (ORDER BY total_spend DESC) AS spend_rank
FROM customer_totals
ORDER BY spend_rank;
```

*Explanation:* `RANK()` orders every customer by `total_spend` descending and
assigns 1, 2, 3... (with ties sharing a rank and leaving a gap afterwards —
not an issue here since no two customers tie exactly).

*Result:*

```
  customer_name  | total_spend | spend_rank
-----------------+-------------+------------
 Alice Uwimana   |       90.35 |          1
 Clara Ingabire  |       51.75 |          2
 Brian Mugisha   |       49.40 |          3
 David Niyonzima |       44.50 |          4
 Eva Mukamana    |       26.60 |          5
```

*Business interpretation:* a ready-made leaderboard for a "top customers"
dashboard — Alice is comfortably #1, with the next three customers fairly
close together and Eva Mukamana trailing.

---

**2. Number each customer's orders in the order placed**

```sql
SELECT c.customer_name, o.order_id, o.order_date,
       ROW_NUMBER() OVER (PARTITION BY c.customer_id ORDER BY o.order_date) AS order_seq
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
ORDER BY c.customer_name, order_seq;
```

*Explanation:* `PARTITION BY customer_id` restarts the numbering for each
customer, and `ORDER BY order_date` within that partition means order #1 is
always that customer's first-ever order, #2 their second, and so on.

*Result (15 rows, abridged):*

```
  customer_name  | order_id | order_date | order_seq
-----------------+----------+------------+-----------
 Alice Uwimana   |        1 | 2026-01-05 |         1
 Alice Uwimana   |        3 | 2026-01-15 |         2
 Alice Uwimana   |        8 | 2026-02-10 |         3
 Alice Uwimana   |       13 | 2026-03-15 |         4
 Brian Mugisha   |        2 | 2026-01-08 |         1
 Brian Mugisha   |        6 | 2026-02-02 |         2
 Brian Mugisha   |       11 | 2026-03-01 |         3
       ...
 Eva Mukamana    |       12 | 2026-03-10 |         2
```

*Business interpretation:* this makes it trivial to identify each customer's
"first order" (order_seq = 1, useful for new-customer acquisition analysis)
versus repeat orders, without a separate query per customer.

---

**3. Running total of revenue over time, ordered by order date**

```sql
WITH order_revenue AS (
    SELECT o.order_id, o.order_date,
           SUM(oi.quantity * p.price) AS order_revenue
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    JOIN products p     ON p.product_id = oi.product_id
    GROUP BY o.order_id, o.order_date
)
SELECT order_id, order_date, order_revenue,
       SUM(order_revenue) OVER (ORDER BY order_date, order_id
                                 ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
FROM order_revenue
ORDER BY order_date, order_id;
```

*Explanation:* the CTE first collapses each order down to its own revenue
total, then a window `SUM()` with an explicit frame
(`UNBOUNDED PRECEDING` to `CURRENT ROW`, ordered by date) accumulates that
into a running total — the classic "cumulative revenue" pattern.

*Result (15 rows):*

```
 order_id | order_date | order_revenue | running_total
----------+------------+---------------+---------------
        1 | 2026-01-05 |         28.60 |         28.60
        2 | 2026-01-08 |         12.50 |         41.10
        3 | 2026-01-15 |         11.60 |         52.70
        4 | 2026-01-20 |         28.50 |         81.20
        5 | 2026-01-25 |         17.75 |         98.95
        6 | 2026-02-02 |          5.40 |        104.35
        7 | 2026-02-05 |         21.80 |        126.15
        8 | 2026-02-10 |         40.25 |        166.40
        9 | 2026-02-18 |         10.75 |        177.15
       10 | 2026-02-25 |         12.50 |        189.65
       11 | 2026-03-01 |         31.50 |        221.15
       12 | 2026-03-10 |          4.80 |        225.95
       13 | 2026-03-15 |          9.90 |        235.85
       14 | 2026-03-22 |         12.50 |        248.35
       15 | 2026-04-02 |         14.25 |        262.60
```

*Business interpretation:* total lifetime revenue across the sample data is
₣262.60. Order #8 (Alice, 2026-02-10) was the single biggest order at
₣40.25, visible as the steepest jump in the running total — useful for
spotting standout sales days on a cumulative-revenue chart.

---

**4. Days between current and previous order (customers with 2+ orders)**

```sql
WITH order_gaps AS (
    SELECT c.customer_name, o.order_id, o.order_date,
           LAG(o.order_date) OVER (PARTITION BY c.customer_id ORDER BY o.order_date) AS prev_order_date,
           COUNT(*) OVER (PARTITION BY c.customer_id) AS order_count
    FROM orders o
    JOIN customers c ON c.customer_id = o.customer_id
)
SELECT customer_name, order_id, order_date, prev_order_date,
       (order_date - prev_order_date) AS days_since_previous
FROM order_gaps
WHERE order_count > 1
ORDER BY customer_name, order_date;
```

*Explanation:* `LAG()` looks back one row within each customer's partition
(ordered by date) to fetch their previous order date; subtracting dates gives
the gap in days. `COUNT(*) OVER (PARTITION BY customer_id)` is used in the
`WHERE` clause to keep only customers who placed more than one order (every
customer here except Frank, who has none).

*Result (15 rows; each customer's first order has no previous date, so that
row's gap is blank):*

```
  customer_name  | order_id | order_date | prev_order_date | days_since_previous
-----------------+----------+------------+------------------+---------------------
 Alice Uwimana   |        1 | 2026-01-05 |                  |
 Alice Uwimana   |        3 | 2026-01-15 | 2026-01-05       |                  10
 Alice Uwimana   |        8 | 2026-02-10 | 2026-01-15       |                  26
 Alice Uwimana   |       13 | 2026-03-15 | 2026-02-10       |                  33
 Brian Mugisha   |        2 | 2026-01-08 |                  |
 Brian Mugisha   |        6 | 2026-02-02 | 2026-01-08       |                  25
 Brian Mugisha   |       11 | 2026-03-01 | 2026-02-02       |                  27
 Clara Ingabire  |        4 | 2026-01-20 |                  |
 Clara Ingabire  |        9 | 2026-02-18 | 2026-01-20       |                  29
 Clara Ingabire  |       14 | 2026-03-22 | 2026-02-18       |                  32
 David Niyonzima |        5 | 2026-01-25 |                  |
 David Niyonzima |       10 | 2026-02-25 | 2026-01-25       |                  31
 David Niyonzima |       15 | 2026-04-02 | 2026-02-25       |                  36
 Eva Mukamana    |        7 | 2026-02-05 |                  |
 Eva Mukamana    |       12 | 2026-03-10 | 2026-02-05       |                  33
```

*Business interpretation:* most customers in this sample re-order roughly
every 25–36 days, i.e. a broadly monthly shopping cadence, with Alice's gaps
widening slightly over time (10 → 26 → 33 days). That kind of trend is exactly
what a "predict the next order date" or "customer churn risk" model would use
as an input feature.

## 4. Challenges and resolutions

- **Original DDL was Oracle-specific (`NUMBER`, `VARCHAR2`).** The brief
  allows any SQL/DBMS tool, so the types were mapped to PostgreSQL
  equivalents (`INTEGER`, `NUMERIC`, `VARCHAR`) while keeping the table and
  column names identical. See the note below for the two-line change needed
  to run the same logic on Oracle.
- **Demonstrating the LEFT JOIN meaningfully.** A LEFT JOIN only tells a
  useful story if at least one customer genuinely has zero orders — otherwise
  the query looks identical to an INNER JOIN. Customer #6 (Frank Habimana)
  was deliberately left without any orders in `02_seed_data.sql` so the
  `NULL` row is real and visible in the results.
- **Getting the CTE's "average" to make sense as a threshold.** Early data
  had spend values clustered too closely together, so no customer stood out
  above the average. The order/order-item data was adjusted (heavier orders
  for Alice Uwimana) so the CTE result actually surfaces a single clear
  above-average customer rather than three or four near-identical ones.
- **Running-total ties on the same date.** Because a couple of orders share
  or nearly share dates, the running-total window function orders by
  `(order_date, order_id)` rather than `order_date` alone, so the result is
  deterministic and reproducible on every run.
- **Verifying correctness.** Every query in this README was actually executed
  against the seeded PostgreSQL database (not hand-calculated), so the
  numbers shown are real output, and the total revenue figure (₣262.60) was
  cross-checked by hand-summing all 27 `order_items` line totals.

## 5. Running the same schema on Oracle

If Oracle is required instead of PostgreSQL, only `01_schema.sql` needs
changing:

```sql
CREATE TABLE customers (
  customer_id   NUMBER PRIMARY KEY,
  customer_name VARCHAR2(100),
  email         VARCHAR2(100),
  city          VARCHAR2(50)
);
-- ...and so on, exactly as given in the assignment brief.
```

`02_seed_data.sql` and `03_queries.sql` are standard ANSI SQL (CTEs, `JOIN`,
`RANK()`, `ROW_NUMBER()`, `LAG()`, window frames) and run unchanged on Oracle,
PostgreSQL, or SQL Server.
