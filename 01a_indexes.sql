CREATE INDEX idx_orders_customer_id
ON orders(customer_id);

SELECT *
FROM orders
WHERE orders.customer_id = 'C001';

EXPLAIN
SELECT *
FROM orders
WHERE orders.customer_id = 'C001';

CREATE INDEX idx_orders_order_date
ON orders(order_date);

SELECT DATE_TRUNC('month', orders.order_date) AS month,
       SUM(orders.sales)
FROM orders
GROUP BY DATE_TRUNC('month', orders.order_date)
ORDER BY month ASC;

CREATE INDEX idx_orders_region_category
ON orders(customer_id, order_date);

SELECT customers.customer_name,
       customers.region,
       orders.order_id,
       orders.order_date,
       orders.sales,
       orders.profit
FROM orders
JOIN customers ON orders.customer_id = customers.customer_id
WHERE customers.region = 'West'
  AND orders.order_date >= '2024-01-01'
ORDER BY orders.order_date ASC;
