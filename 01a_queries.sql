SELECT flourmills_sales.product_name, flourmills_sales.total_amount FROM flourmills_sales WHERE flourmills_sales.total_amount > (SELECT AVG(flourmills_sales.total_amount) FROM flourmills_sales);

