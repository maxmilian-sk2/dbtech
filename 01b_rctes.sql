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

