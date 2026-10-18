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

WITH customer_profit AS (
    SELECT customers.region,
           customers.customer_name,
           SUM(orders.profit) AS total_profit
    FROM customers
    JOIN orders ON customers.customer_id = orders.customer_id
    GROUP BY customers.region, customers.customer_id, customers.customer_name
)
SELECT customer_profit.region,
       customer_profit.customer_name,
       customer_profit.total_profit,
       RANK() OVER (
           PARTITION BY customer_profit.region
           ORDER BY customer_profit.total_profit DESC
       ) AS profit_rank,
       DENSE_RANK() OVER (
           PARTITION BY customer_profit.region
           ORDER BY customer_profit.total_profit DESC
       ) AS profit_dense_rank
FROM customer_profit
ORDER BY customer_profit.region ASC, profit_rank ASC;

WITH customer_sales AS (
    SELECT customers.customer_name,
           SUM(orders.sales) AS total_sales
    FROM customers
    JOIN orders ON customers.customer_id = orders.customer_id
    GROUP BY customers.customer_id, customers.customer_name
)
SELECT customer_sales.customer_name,
       customer_sales.total_sales,
       NTILE(4) OVER (
           ORDER BY customer_sales.total_sales DESC
       ) AS quartile
FROM customer_sales
ORDER BY customer_sales.total_sales DESC;

