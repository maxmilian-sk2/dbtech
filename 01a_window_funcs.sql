SELECT retail_sales.customer_id,
       retail_sales.invoice_no,
       retail_sales.invoice_date,
       retail_sales.quantity,
       retail_sales.unit_price,
       retail_sales.quantity * retail_sales.unit_price AS revenue,
       SUM(retail_sales.quantity * retail_sales.unit_price) OVER (
           PARTITION BY retail_sales.customer_id
           ORDER BY retail_sales.invoice_date
           RANGE BETWEEN INTERVAL '14 days' PRECEDING AND CURRENT ROW
       ) AS revenue_last_14_days
FROM retail_sales
WHERE retail_sales.customer_id IS NOT NULL
ORDER BY retail_sales.customer_id ASC, retail_sales.invoice_date ASC;

SELECT retail_sales.stock_code,
       retail_sales.country,
       retail_sales.invoice_date,
       retail_sales.quantity,
       ROUND(AVG(retail_sales.quantity) OVER (
           PARTITION BY retail_sales.stock_code, retail_sales.country
           ORDER BY retail_sales.invoice_date
           RANGE BETWEEN INTERVAL '7 days' PRECEDING AND CURRENT ROW
       ), 2) AS avg_quantity_7_days
FROM retail_sales
WHERE retail_sales.quantity > 1
ORDER BY retail_sales.stock_code ASC, retail_sales.country ASC, retail_sales.invoice_date ASC;
