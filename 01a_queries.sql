SELECT flourmills_sales.product_name, flourmills_sales.total_amount FROM flourmills_sales WHERE flourmills_sales.total_amount > (SELECT AVG(flourmills_sales.total_amount) FROM flourmills_sales);

SELECT * FROM flourmills_sales WHERE flourmills_sales.product_category = (SELECT flourmills_sales.product_category FROM flourmills_sales GROUP BY flourmills_sales.product_category ORDER BY SUM(flourmills_sales.total_amount) DESC LIMIT 1) ORDER BY flourmills_sales.sales_id ASC;

SELECT flourmills_sales.product_name, flourmills_sales.total_amount, (SELECT AVG(flourmills_sales.total_amount) FROM flourmills_sales) AS avg_amount FROM flourmills_sales;

SELECT flourmills_sales.product_name, flourmills_sales.total_amount, flourmills_sales.total_amount / (SELECT SUM(flourmills_sales.total_amount) FROM flourmills_sales) AS amount_share FROM flourmills_sales;

SELECT month, monthly_sales FROM (SELECT EXTRACT(MONTH FROM flourmills_sales.sale_date) AS month, SUM(total_amount) AS monthly_sales FROM flourmills_sales GROUP BY EXTRACT(MONTH FROM flourmills_sales.sale_date)) AS month_sale ORDER BY monthly_sales DESC;

SELECT product_category, total_sales FROM (SELECT flourmills_sales.product_category, SUM(flourmills_sales.total_amount) AS total_sales FROM flourmills_sales GROUP BY flourmills_sales.product_category) AS cats WHERE total_sales > 50000000 ORDER BY total_sales DESC;

