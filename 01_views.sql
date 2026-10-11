-- Active: 1790513191773@@127.0.0.1@5432@superstore
CREATE VIEW high_value_customers AS
SELECT customers.customer_id,
       customers.customer_name,
       SUM(orders.sales) AS total_sales
FROM customers
JOIN orders ON customers.customer_id = orders.customer_id
GROUP BY customers.customer_id, customers.customer_name
HAVING SUM(orders.sales) > 2000;

SELECT * FROM high_value_customers;

CREATE VIEW regional_monthly_sales AS
SELECT customers.region,
       DATE_TRUNC('month', orders.order_date) AS month,
       SUM(orders.sales) AS monthly_sales
FROM customers
JOIN orders ON customers.customer_id = orders.customer_id
GROUP BY customers.region, DATE_TRUNC('month', orders.order_date);

SELECT * FROM regional_monthly_sales WHERE regional_monthly_sales.region = 'West' ORDER BY regional_monthly_sales.month ASC;

