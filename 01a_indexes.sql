CREATE INDEX idx_orders_customer_id
ON orders(customer_id);

SELECT *
FROM orders
WHERE orders.customer_id = 'C001';

EXPLAIN
SELECT *
FROM orders
WHERE orders.customer_id = 'C001';

