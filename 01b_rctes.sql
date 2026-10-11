WITH RECURSIVE date_range AS (
    SELECT MIN(flourmills_sales.sale_date) AS start_date,
           MAX(flourmills_sales.sale_date) AS end_date
    FROM flourmills_sales
),
calendar AS (
    SELECT date_range.start_date AS calendar_date
    FROM date_range

    UNION ALL

    SELECT calendar.calendar_date + 1
    FROM calendar
    CROSS JOIN date_range
    WHERE calendar.calendar_date < date_range.end_date
)
SELECT calendar.calendar_date
FROM calendar
ORDER BY calendar.calendar_date ASC;

WITH RECURSIVE monthly_revenue AS (
    SELECT DATE_TRUNC('month', flourmills_sales.sale_date) AS month,
           SUM(flourmills_sales.total_amount) AS revenue
    FROM flourmills_sales
    GROUP BY DATE_TRUNC('month', flourmills_sales.sale_date)
),
ordered_months AS (
    SELECT ROW_NUMBER() OVER (ORDER BY monthly_revenue.month) AS rn,
           monthly_revenue.month,
           monthly_revenue.revenue
    FROM monthly_revenue
),
cumulative_target AS (
    SELECT ordered_months.rn,
           ordered_months.month,
           ordered_months.revenue,
           ordered_months.revenue AS cumulative_revenue
    FROM ordered_months
    WHERE ordered_months.rn = 1

    UNION ALL

    SELECT ordered_months.rn,
           ordered_months.month,
           ordered_months.revenue,
           cumulative_target.cumulative_revenue + ordered_months.revenue
    FROM cumulative_target
    JOIN ordered_months ON ordered_months.rn = cumulative_target.rn + 1
    WHERE cumulative_target.cumulative_revenue < 500000000
)
SELECT cumulative_target.rn,
       cumulative_target.month,
       cumulative_target.revenue,
       cumulative_target.cumulative_revenue
FROM cumulative_target
ORDER BY cumulative_target.rn ASC;
