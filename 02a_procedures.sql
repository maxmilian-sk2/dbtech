-- Active: 1790513191773@@127.0.0.1@5432@superstore
CREATE PROCEDURE get_customer_sales(
    p_customer_id VARCHAR(20)
)
LANGUAGE plpgsql
AS $procedure$
DECLARE
    v_total_sales NUMERIC(10,2);
BEGIN
    SELECT SUM(orders.sales)
    INTO v_total_sales
    FROM orders
    WHERE orders.customer_id = p_customer_id;

    RAISE NOTICE 'Customer %: total sales %', p_customer_id, v_total_sales;
END;
$procedure$;

CALL get_customer_sales('CUST001');

CREATE PROCEDURE apply_regional_discount(
    region_name VARCHAR(50),
    discount_rate NUMERIC(5,2)
)
LANGUAGE plpgsql
AS $procedure$
BEGIN
    UPDATE orders
    SET sales = orders.sales * (1 - discount_rate)
    FROM customers
    WHERE orders.customer_id = customers.customer_id
      AND customers.region = region_name;

    RAISE NOTICE 'Discount % applied to region %', discount_rate, region_name;
END;
$procedure$;

CALL apply_regional_discount('West', 0.10);

CREATE PROCEDURE get_sales_between(
    start_date DATE,
    end_date DATE
)
LANGUAGE plpgsql
AS $procedure$
DECLARE
    v_total_sales NUMERIC(10,2);
BEGIN
    SELECT SUM(orders.sales)
    INTO v_total_sales
    FROM orders
    WHERE orders.order_date BETWEEN start_date AND end_date;

    RAISE NOTICE 'Sales from % to %: %', start_date, end_date, v_total_sales;
END;
$procedure$;

CALL get_sales_between('2024-01-01', '2024-03-31');
