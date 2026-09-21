-- =====================================================================
-- Sunrise Supermarket - Assignment 1
-- 02_seed_data.sql
-- Populates: 6 customers, 9 products (6 categories), 15 orders,
--            27 order_items spread across Jan-Apr 2026.
-- Note: Frank Habimana (customer_id 6) is deliberately given NO orders
--       so the LEFT JOIN query has something to demonstrate.
-- =====================================================================

INSERT INTO customers (customer_id, customer_name, email, city) VALUES
(1, 'Alice Uwimana',   'alice.uwimana@example.com',   'Kigali'),
(2, 'Brian Mugisha',   'brian.mugisha@example.com',   'Kigali'),
(3, 'Clara Ingabire',  'clara.ingabire@example.com',  'Musanze'),
(4, 'David Niyonzima', 'david.niyonzima@example.com', 'Huye'),
(5, 'Eva Mukamana',    'eva.mukamana@example.com',    'Rubavu'),
(6, 'Frank Habimana',  'frank.habimana@example.com',  'Kigali');

INSERT INTO products (product_id, product_name, category, price) VALUES
(1, 'Rice 5kg',            'Grocery',   12.50),
(2, 'Bread Loaf',          'Bakery',     1.50),
(3, 'Milk 1L',              'Dairy',      1.20),
(4, 'Cheddar Cheese 250g', 'Dairy',      4.75),
(5, 'Bananas 1kg',         'Produce',    1.00),
(6, 'Apples 1kg',          'Produce',    2.20),
(7, 'Chicken Breast 1kg',  'Meat',       6.50),
(8, 'Laundry Detergent 2L','Household',  8.00),
(9, 'Toothpaste 100ml',    'Household',  2.75);

INSERT INTO orders (order_id, customer_id, order_date) VALUES
(1,  1, DATE '2026-01-05'),
(2,  2, DATE '2026-01-08'),
(3,  1, DATE '2026-01-15'),
(4,  3, DATE '2026-01-20'),
(5,  4, DATE '2026-01-25'),
(6,  2, DATE '2026-02-02'),
(7,  5, DATE '2026-02-05'),
(8,  1, DATE '2026-02-10'),
(9,  3, DATE '2026-02-18'),
(10, 4, DATE '2026-02-25'),
(11, 2, DATE '2026-03-01'),
(12, 5, DATE '2026-03-10'),
(13, 1, DATE '2026-03-15'),
(14, 3, DATE '2026-03-22'),
(15, 4, DATE '2026-04-02');

INSERT INTO order_items (order_item_id, order_id, product_id, quantity) VALUES
(1,  1, 1, 2),
(2,  1, 3, 3),
(3,  2, 2, 4),
(4,  2, 7, 1),
(5,  3, 5, 5),
(6,  3, 6, 3),
(7,  4, 1, 1),
(8,  4, 8, 2),
(9,  5, 4, 2),
(10, 5, 9, 3),
(11, 6, 3, 2),
(12, 6, 2, 2),
(13, 7, 7, 2),
(14, 7, 6, 4),
(15, 8, 1, 3),
(16, 8, 9, 1),
(17, 9, 5, 6),
(18, 9, 4, 1),
(19, 10, 2, 3),
(20, 10, 8, 1),
(21, 11, 1, 2),
(22, 11, 7, 1),
(23, 12, 3, 4),
(24, 13, 6, 2),
(25, 13, 9, 2),
(26, 14, 1, 1),
(27, 15, 4, 3);
