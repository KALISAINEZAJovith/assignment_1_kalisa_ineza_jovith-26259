-- ============================================================
-- Sunrise Supermarket - Assignment 1
-- Data Population
-- Student ID: 26259
-- ============================================================

-- ============================================================
-- CUSTOMERS
-- ============================================================

INSERT INTO customers VALUES
(1, 'Alice Uwase', 'alice@gmail.com', 'Kigali');

INSERT INTO customers VALUES
(2, 'Brian Mugisha', 'brian@gmail.com', 'Huye');

INSERT INTO customers VALUES
(3, 'Claudine Mukamana', 'claudine@gmail.com', 'Musanze');

INSERT INTO customers VALUES
(4, 'David Niyonzima', 'david@gmail.com', 'Kigali');

INSERT INTO customers VALUES
(5, 'Eric Habimana', 'eric@gmail.com', 'Rubavu');

INSERT INTO customers VALUES
(6, 'Fiona Ingabire', 'fiona@gmail.com', 'Kigali');

INSERT INTO customers VALUES
(7, 'Grace Uwamahoro', 'grace@gmail.com', 'Huye');

INSERT INTO customers VALUES
(8, 'Henry Tuyisenge', 'henry@gmail.com', 'Musanze');

-- ============================================================
-- PRODUCTS
-- ============================================================

INSERT INTO products VALUES
(1, 'Rice 5kg', 'Groceries', 8500);

INSERT INTO products VALUES
(2, 'Sugar 2kg', 'Groceries', 3000);

INSERT INTO products VALUES
(3, 'Cooking Oil 1L', 'Groceries', 4500);

INSERT INTO products VALUES
(4, 'Milk 1L', 'Dairy', 1500);

INSERT INTO products VALUES
(5, 'Yogurt 500ml', 'Dairy', 2000);

INSERT INTO products VALUES
(6, 'Cheese 250g', 'Dairy', 3500);

INSERT INTO products VALUES
(7, 'Bread', 'Bakery', 1200);

INSERT INTO products VALUES
(8, 'Croissant', 'Bakery', 1800);

INSERT INTO products VALUES
(9, 'Chocolate Bar', 'Snacks', 1000);

INSERT INTO products VALUES
(10, 'Potato Chips', 'Snacks', 1500);

INSERT INTO products VALUES
(11, 'Biscuits', 'Snacks', 2000);

INSERT INTO products VALUES
(12, 'Cake', 'Bakery', 7000);


-- ============================================================
-- 5. INSERT ORDERS
-- ============================================================

INSERT INTO orders VALUES
(1, 1, DATE '2026-08-01');

INSERT INTO orders VALUES
(2, 2, DATE '2026-08-02');

INSERT INTO orders VALUES
(3, 3, DATE '2026-08-04');

INSERT INTO orders VALUES
(4, 1, DATE '2026-08-07');

INSERT INTO orders VALUES
(5, 4, DATE '2026-08-09');

INSERT INTO orders VALUES
(6, 5, DATE '2026-08-12');

INSERT INTO orders VALUES
(7, 2, DATE '2026-08-15');

INSERT INTO orders VALUES
(8, 6, DATE '2026-08-18');

INSERT INTO orders VALUES
(9, 3, DATE '2026-08-20');

INSERT INTO orders VALUES
(10, 1, DATE '2026-08-22');

INSERT INTO orders VALUES
(11, 7, DATE '2026-08-25');

INSERT INTO orders VALUES
(12, 4, DATE '2026-08-27');

INSERT INTO orders VALUES
(13, 5, DATE '2026-08-29');

INSERT INTO orders VALUES
(14, 6, DATE '2026-08-30');

INSERT INTO orders VALUES
(15, 8, DATE '2026-09-01');


-- ============================================================
-- 6. INSERT ORDER ITEMS
-- ============================================================

INSERT INTO order_items VALUES (1, 1, 1, 2);
INSERT INTO order_items VALUES (2, 1, 7, 3);

INSERT INTO order_items VALUES (3, 2, 2, 2);
INSERT INTO order_items VALUES (4, 2, 4, 2);

INSERT INTO order_items VALUES (5, 3, 3, 2);
INSERT INTO order_items VALUES (6, 3, 9, 4);

INSERT INTO order_items VALUES (7, 4, 1, 1);
INSERT INTO order_items VALUES (8, 4, 12, 1);

INSERT INTO order_items VALUES (9, 5, 5, 3);
INSERT INTO order_items VALUES (10, 5, 7, 2);

INSERT INTO order_items VALUES (11, 6, 6, 2);
INSERT INTO order_items VALUES (12, 6, 10, 3);

INSERT INTO order_items VALUES (13, 7, 2, 3);
INSERT INTO order_items VALUES (14, 7, 11, 2);

INSERT INTO order_items VALUES (15, 8, 4, 4);
INSERT INTO order_items VALUES (16, 8, 8, 2);

INSERT INTO order_items VALUES (17, 9, 3, 1);
INSERT INTO order_items VALUES (18, 9, 12, 1);

INSERT INTO order_items VALUES (19, 10, 1, 2);
INSERT INTO order_items VALUES (20, 10, 6, 1);
INSERT INTO order_items VALUES (21, 10, 9, 3);

INSERT INTO order_items VALUES (22, 11, 7, 4);
INSERT INTO order_items VALUES (23, 11, 10, 2);

INSERT INTO order_items VALUES (24, 12, 5, 2);
INSERT INTO order_items VALUES (25, 12, 12, 1);

INSERT INTO order_items VALUES (26, 13, 3, 2);
INSERT INTO order_items VALUES (27, 13, 11, 3);

INSERT INTO order_items VALUES (28, 14, 4, 3);
INSERT INTO order_items VALUES (29, 14, 8, 2);

INSERT INTO order_items VALUES (30, 15, 1, 1);


-- ============================================================
-- 7. SAVE DATA
-- ============================================================

COMMIT;