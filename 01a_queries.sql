SELECT flourmills_sales.product_name, flourmills_sales.total_amount FROM flourmills_sales WHERE flourmills_sales.total_amount > (SELECT AVG(flourmills_sales.total_amount) FROM flourmills_sales);

SELECT * FROM flourmills_sales WHERE flourmills_sales.product_category = (SELECT flourmills_sales.product_category FROM flourmills_sales GROUP BY flourmills_sales.product_category ORDER BY SUM(flourmills_sales.total_amount) DESC LIMIT 1) ORDER BY flourmills_sales.sales_id ASC;

SELECT flourmills_sales.product_name, flourmills_sales.total_amount, (SELECT AVG(flourmills_sales.total_amount) FROM flourmills_sales) AS avg_amount FROM flourmills_sales;

SELECT flourmills_sales.product_name, flourmills_sales.total_amount, flourmills_sales.total_amount / (SELECT SUM(flourmills_sales.total_amount) FROM flourmills_sales) AS amount_share FROM flourmills_sales;

SELECT month, monthly_sales FROM (SELECT EXTRACT(MONTH FROM flourmills_sales.sale_date) AS month, SUM(total_amount) AS monthly_sales FROM flourmills_sales GROUP BY EXTRACT(MONTH FROM flourmills_sales.sale_date)) AS month_sale ORDER BY monthly_sales DESC;

SELECT product_category, total_sales FROM (SELECT flourmills_sales.product_category, SUM(flourmills_sales.total_amount) AS total_sales FROM flourmills_sales GROUP BY flourmills_sales.product_category) AS cats WHERE total_sales > 50000000 ORDER BY total_sales DESC;

SELECT flourmills_sales.product_name, flourmills_sales.product_category, flourmills_sales.total_amount FROM flourmills_sales WHERE flourmills_sales.total_amount > (SELECT AVG(fs.total_amount) FROM flourmills_sales AS fs WHERE fs.product_category = flourmills_sales.product_category);

SELECT flourmills_sales.product_name, flourmills_sales.region, flourmills_sales.total_amount, (SELECT MIN(fs.total_amount) FROM flourmills_sales AS fs WHERE fs.region = flourmills_sales.region) AS region_min_amount FROM flourmills_sales ORDER BY flourmills_sales.sales_id ASC;

SELECT flourmills_sales.product_name, flourmills_sales.sale_date, flourmills_sales.total_amount FROM flourmills_sales WHERE EXISTS (SELECT 1 FROM flourmills_sales AS fs WHERE fs.product_name = flourmills_sales.product_name GROUP BY fs.product_name HAVING COUNT(DISTINCT EXTRACT(MONTH FROM fs.sale_date)) > 1) ORDER BY flourmills_sales.sales_id ASC;

SELECT flourmills_sales.product_category, flourmills_sales.product_name, flourmills_sales.total_amount FROM flourmills_sales WHERE EXISTS (SELECT 1 FROM flourmills_sales AS fs WHERE fs.product_category = flourmills_sales.product_category AND fs.total_amount > 200000) ORDER BY flourmills_sales.sales_id ASC;

SELECT cats.product_category FROM (SELECT DISTINCT flourmills_sales.product_category FROM flourmills_sales) AS cats WHERE EXISTS (SELECT 1 FROM flourmills_sales AS fs WHERE fs.product_category = cats.product_category GROUP BY fs.product_category HAVING COUNT(DISTINCT fs.region) > 3) ORDER BY cats.product_category ASC;

SELECT flourmills_sales.region, flourmills_sales.sale_date, flourmills_sales.product_name, flourmills_sales.total_amount FROM flourmills_sales WHERE EXISTS (SELECT 1 FROM flourmills_sales AS fs WHERE fs.region = flourmills_sales.region AND EXTRACT(YEAR FROM fs.sale_date) = 2024) ORDER BY flourmills_sales.sales_id ASC;

