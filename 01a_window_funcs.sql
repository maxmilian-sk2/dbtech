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

WITH customer_type_revenue AS (
    SELECT flourmills_sales.customer_type,
           SUM(flourmills_sales.total_amount) AS revenue
    FROM flourmills_sales
    GROUP BY flourmills_sales.customer_type
),
revenue_share AS (
    SELECT customer_type_revenue.customer_type,
           customer_type_revenue.revenue,
           SUM(customer_type_revenue.revenue) OVER () AS total_revenue,
           ROUND(customer_type_revenue.revenue / SUM(customer_type_revenue.revenue) OVER () * 100, 2) AS revenue_percentage
    FROM customer_type_revenue
)
SELECT revenue_share.customer_type,
       revenue_share.revenue,
       revenue_share.total_revenue,
       revenue_share.revenue_percentage
FROM revenue_share
ORDER BY revenue_share.revenue DESC;

WITH ranked_purchases AS (
    SELECT flourmills_sales.customer_id,
           flourmills_sales.product_name,
           flourmills_sales.sale_date,
           flourmills_sales.total_amount,
           ROW_NUMBER() OVER (
               PARTITION BY flourmills_sales.customer_id
               ORDER BY flourmills_sales.sale_date DESC
           ) AS purchase_rank
    FROM flourmills_sales
)
SELECT ranked_purchases.customer_id,
       ranked_purchases.product_name,
       ranked_purchases.sale_date,
       ranked_purchases.total_amount
FROM ranked_purchases
WHERE ranked_purchases.purchase_rank = 1
ORDER BY ranked_purchases.customer_id ASC;
