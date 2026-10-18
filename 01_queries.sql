-- Active: 1790513191773@@127.0.0.1@5432@superstore
WITH numbered_orders AS (
    SELECT customers.customer_name,
           orders.order_id,
           orders.order_date,
           ROW_NUMBER() OVER (
               PARTITION BY customers.customer_id
               ORDER BY orders.order_date DESC
           ) AS order_rank
    FROM customers
    JOIN orders ON customers.customer_id = orders.customer_id
)
SELECT numbered_orders.customer_name,
       numbered_orders.order_id,
       numbered_orders.order_date
FROM numbered_orders
WHERE numbered_orders.order_rank <= 2
ORDER BY numbered_orders.customer_name ASC, numbered_orders.order_rank ASC;

