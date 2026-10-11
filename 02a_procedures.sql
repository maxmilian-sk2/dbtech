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

