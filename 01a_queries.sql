SELECT * FROM customers;

SELECT * FROM products;

SELECT * FROM orders;

SELECT orders.order_id, customers.customer_name, orders.sales FROM orders JOIN customers ON orders.customer_id = customers.customer_id WHERE orders.sales > 500;

SELECT orders.order_id, customers.customer_name, products.category, orders.sales FROM orders JOIN customers ON orders.customer_id = customers.customer_id JOIN products ON orders.product_id = products.product_id;

SELECT customers.region, SUM(orders.sales) FROM orders RIGHT JOIN customers on orders.customer_id = customers.customer_id GROUP BY customers.region;

SELECT products.product_name, SUM(orders.sales) FROM products LEFT JOIN orders ON products.product_id = orders.product_id GROUP BY products.product_id;