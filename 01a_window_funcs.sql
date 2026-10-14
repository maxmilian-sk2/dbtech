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

WITH price_history AS (
    SELECT retail_sales.stock_code,
           retail_sales.invoice_no,
           retail_sales.invoice_date,
           LAG(retail_sales.unit_price) OVER (
               PARTITION BY retail_sales.stock_code
               ORDER BY retail_sales.invoice_date
           ) AS previous_price,
           retail_sales.unit_price AS current_price
    FROM retail_sales
)
SELECT price_history.stock_code,
       price_history.invoice_no,
       price_history.invoice_date,
       price_history.previous_price,
       price_history.current_price,
       price_history.current_price - price_history.previous_price AS price_difference
FROM price_history
WHERE price_history.previous_price IS NOT NULL
  AND price_history.current_price <> price_history.previous_price
ORDER BY price_history.invoice_date ASC;

WITH customer_sales AS (
    SELECT retail_sales.customer_id,
           SUM(retail_sales.quantity * retail_sales.unit_price) AS total_amount
    FROM retail_sales
    WHERE retail_sales.customer_id IS NOT NULL
    GROUP BY retail_sales.customer_id
)
SELECT customer_sales.customer_id,
       customer_sales.total_amount,
       NTILE(4) OVER (
           ORDER BY customer_sales.total_amount DESC
       ) AS sales_quartile
FROM customer_sales
ORDER BY customer_sales.total_amount DESC;
