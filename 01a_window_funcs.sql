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

WITH customer_orders AS (
    SELECT DISTINCT retail_sales.customer_id,
           retail_sales.invoice_no,
           retail_sales.invoice_date::date AS invoice_date
    FROM retail_sales
    WHERE retail_sales.customer_id IS NOT NULL
),
next_orders AS (
    SELECT customer_orders.customer_id,
           customer_orders.invoice_no,
           customer_orders.invoice_date,
           LEAD(customer_orders.invoice_date) OVER (
               PARTITION BY customer_orders.customer_id
               ORDER BY customer_orders.invoice_date
           ) AS next_invoice_date
    FROM customer_orders
)
SELECT next_orders.customer_id,
       next_orders.invoice_no,
       next_orders.invoice_date,
       next_orders.next_invoice_date,
       next_orders.next_invoice_date - next_orders.invoice_date AS days_to_next_invoice
FROM next_orders
WHERE next_orders.next_invoice_date IS NOT NULL
ORDER BY days_to_next_invoice DESC;
