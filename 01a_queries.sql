SELECT * FROM customers;

SELECT * FROM products;

SELECT * FROM orders;

SELECT orders.order_id, customers.customer_name, orders.sales FROM orders JOIN customers ON orders.customer_id = customers.customer_id WHERE orders.sales > 500;

SELECT orders.order_id, customers.customer_name, products.category, orders.sales FROM orders JOIN customers ON orders.customer_id = customers.customer_id JOIN products ON orders.product_id = products.product_id;

SELECT customers.region, SUM(orders.sales) FROM orders RIGHT JOIN customers on orders.customer_id = customers.customer_id GROUP BY customers.region;

SELECT products.product_name, SUM(orders.sales) FROM products LEFT JOIN orders ON products.product_id = orders.product_id GROUP BY products.product_id;

SELECT customers.customer_name, orders.order_id, orders.sales FROM customers FULL OUTER JOIN orders ON customers.customer_id = orders.customer_id;

SELECT customers.region, SUM(orders.sales) FROM orders JOIN customers ON orders.customer_id = customers.customer_id GROUP BY customers.region;

SELECT customers.customer_name, COUNT(orders.order_id) FROM customers LEFT JOIN orders ON customers.customer_id = orders.customer_id GROUP BY customers.customer_id;

SELECT products.sub_category, AVG(orders.discount) FROM products LEFT JOIN orders ON products.product_id = orders.product_id GROUP BY products.sub_category;

SELECT customers.customer_name, SUM(orders.sales) FROM customers JOIN orders ON customers.customer_id = orders.customer_id GROUP BY customers.customer_id HAVING SUM(orders.sales) > 2000.00;

SELECT customers.region, SUM(orders.sales), AVG(orders.discount), COUNT(orders.order_id) FROM customers LEFT JOIN orders ON customers.customer_id = orders.customer_id GROUP BY customers.region;

SELECT customers.region, SUM(CASE WHEN orders.sales > 1000 THEN 1 ELSE 0 END) AS high_value, SUM(CASE WHEN orders.sales <= 1000 THEN 1 ELSE 0 END) AS low_value FROM customers JOIN orders ON customers.customer_id = orders.customer_id GROUP BY customers.region;

SELECT customers.customer_name, SUM(orders.sales), AVG(orders.discount), COUNT(orders.order_id), CASE WHEN SUM(orders.sales) > 2500 THEN 'VIP' ELSE 'REGULAR' END FROM customers LEFT JOIN orders ON customers.customer_id = orders.customer_id GROUP BY customers.customer_id ORDER BY SUM(orders.sales) DESC NULLS LAST;

