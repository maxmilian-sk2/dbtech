SELECT flourmills_sales.product_name, flourmills_sales.total_amount FROM flourmills_sales WHERE flourmills_sales.total_amount > (SELECT AVG(flourmills_sales.total_amount) FROM flourmills_sales);

SELECT * FROM flourmills_sales WHERE flourmills_sales.product_category = (SELECT flourmills_sales.product_category FROM flourmills_sales GROUP BY flourmills_sales.product_category ORDER BY SUM(flourmills_sales.total_amount) DESC LIMIT 1) ORDER BY flourmills_sales.sales_id ASC;

