-- Active: 1790513191773@@127.0.0.1@5432@datacraftinglab_db
WITH daily_sales AS (
    SELECT flourmills_sales.sale_date,
           SUM(flourmills_sales.total_amount) AS total_daily_sales
    FROM flourmills_sales
    GROUP BY flourmills_sales.sale_date
)
SELECT daily_sales.sale_date,
       daily_sales.total_daily_sales
FROM daily_sales
WHERE daily_sales.total_daily_sales > 3000000
ORDER BY daily_sales.total_daily_sales DESC;

