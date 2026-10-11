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
