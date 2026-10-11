WITH product_sales AS (
    SELECT flourmills_sales.product_category,
           flourmills_sales.product_name,
           SUM(flourmills_sales.total_amount) AS total_product_sales
    FROM flourmills_sales
    GROUP BY flourmills_sales.product_category, flourmills_sales.product_name
),
ranked_products AS (
    SELECT product_sales.product_category,
           product_sales.product_name,
           product_sales.total_product_sales,
           RANK() OVER (
               PARTITION BY product_sales.product_category
               ORDER BY product_sales.total_product_sales DESC
           ) AS category_rank
    FROM product_sales
)
SELECT ranked_products.product_category,
       ranked_products.product_name,
       ranked_products.total_product_sales,
       ranked_products.category_rank
FROM ranked_products
WHERE ranked_products.category_rank <= 3
ORDER BY ranked_products.product_category ASC, ranked_products.category_rank ASC;

