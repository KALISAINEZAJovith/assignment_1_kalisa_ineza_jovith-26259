# PLS/SQL Assignment One - Sunrise Supermarket

## Student Information

- **Student Name:** KALISA INEZA Jovith
- **Student ID:** 26259
- **Course:** PLS/SQL
- **Assignment:** Assignment One - Sunrise Supermarket
- **DBMS:** Oracle Database 21c
- **Schema:** SYSTEM

---

## 1. Project Overview

This project is a database solution for **Sunrise Supermarket**.

The purpose of the project is to manage supermarket customers, products, orders, and order items using a relational database.

The project demonstrates the use of:

- SQL table creation
- Primary keys
- Foreign keys
- Data insertion
- INNER JOIN
- LEFT JOIN
- Common Table Expressions (CTEs)
- Window functions
- Customer spending analysis
- Revenue analysis
- Order history analysis

The project was developed using **Oracle Database 21c**.

---

## 2. Business Scenario

Sunrise Supermarket sells different types of products to customers in different cities.

The supermarket needs a database to keep track of:

- Customers
- Products
- Product categories
- Customer orders
- Products included in each order
- Quantity purchased
- Product prices
- Customer spending
- Revenue over time

The database allows Sunrise Supermarket to analyze customer purchasing behavior and order activity.

For example, management can use the database to:

- See which customers placed orders
- See what products customers purchased
- Identify customers who spend more than average
- Rank customers according to their total spending
- Number each customer's orders
- Calculate cumulative revenue
- Analyze the number of days between customer orders

---

## 3. Database Structure

The project contains four main tables:

### Customers

Stores information about supermarket customers.

| Column | Description |
|---|---|
| customer_id | Unique customer ID |
| customer_name | Customer's name |
| email | Customer email |
| city | Customer's city |

### Products

Stores information about products sold by the supermarket.

| Column | Description |
|---|---|
| product_id | Unique product ID |
| product_name | Product name |
| category | Product category |
| price | Product selling price |

### Orders

Stores customer orders.

| Column | Description |
|---|---|
| order_id | Unique order ID |
| customer_id | Customer who placed the order |
| order_date | Date the order was placed |

### Order Items

Stores the products contained in each order.

| Column | Description |
|---|---|
| order_item_id | Unique order item ID |
| order_id | Related order |
| product_id | Related product |
| quantity | Quantity purchased |

---

## 4. Database Relationships

The tables are related as follows:

```text
CUSTOMERS
    |
    | 1
    |
    | Many
ORDERS
    |
    | 1
    |
    | Many
ORDER_ITEMS
    |
    | Many
    |
    | 1
PRODUCTS