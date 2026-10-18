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

WITH sales_by_month AS (
    SELECT DATE_TRUNC('month', orders.order_date)::date AS month,
           SUM(orders.sales) AS monthly_sales
    FROM orders
    GROUP BY DATE_TRUNC('month', orders.order_date)::date
)
SELECT sales_by_month.month,
       sales_by_month.monthly_sales,
       LAG(sales_by_month.monthly_sales, 1) OVER (ORDER BY sales_by_month.month) AS prev_month_sales,
       LEAD(sales_by_month.monthly_sales, 1) OVER (ORDER BY sales_by_month.month) AS next_month_sales
FROM sales_by_month
ORDER BY sales_by_month.month ASC;

WITH product_totals AS (
    SELECT products.category,
           products.product_name,
           SUM(orders.sales) AS product_sales
    FROM orders
    JOIN products ON orders.product_id = products.product_id
    GROUP BY products.category, products.product_name
)
SELECT product_totals.category,
       product_totals.product_name,
       product_totals.product_sales,
       SUM(product_totals.product_sales) OVER (PARTITION BY product_totals.category) AS category_total,
       ROUND(
           product_totals.product_sales * 100.0 /
           SUM(product_totals.product_sales) OVER (PARTITION BY product_totals.category),
           2
       ) AS pct_of_category
FROM product_totals
ORDER BY product_totals.category ASC, product_totals.product_sales DESC;

WITH customer_dates AS (
    SELECT customers.customer_id,
           customers.customer_name,
           MAX(orders.order_date) OVER (PARTITION BY customers.customer_id) AS last_order_date,
           MAX(orders.order_date) OVER () AS latest_order_date
    FROM customers
    JOIN orders ON customers.customer_id = orders.customer_id
)
SELECT DISTINCT customer_dates.customer_id,
       customer_dates.customer_name,
       customer_dates.last_order_date
FROM customer_dates
WHERE customer_dates.last_order_date < customer_dates.latest_order_date - INTERVAL '90 days'
ORDER BY customer_dates.last_order_date ASC;

WITH sales_by_month AS (
    SELECT DATE_TRUNC('month', orders.order_date)::date AS month,
           SUM(orders.sales) AS monthly_sales
    FROM orders
    GROUP BY DATE_TRUNC('month', orders.order_date)::date
),
sales_with_previous AS (
    SELECT sales_by_month.month,
           sales_by_month.monthly_sales,
           LAG(sales_by_month.monthly_sales) OVER (ORDER BY sales_by_month.month) AS prev_month_sales
    FROM sales_by_month
)
SELECT sales_with_previous.month,
       sales_with_previous.monthly_sales,
       sales_with_previous.prev_month_sales,
       sales_with_previous.monthly_sales - sales_with_previous.prev_month_sales AS sales_change,
       ROUND((sales_with_previous.monthly_sales - sales_with_previous.prev_month_sales) / sales_with_previous.prev_month_sales * 100, 2) AS growth_percentage
FROM sales_with_previous
ORDER BY sales_with_previous.month ASC;

