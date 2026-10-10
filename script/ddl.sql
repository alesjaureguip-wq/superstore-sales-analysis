CREATE OR REPLACE VIEW retail_sales.retail_analysis.vw_super_store_orders AS
SELECT
    order_id AS id_pedido,
    COALESCE(
        TRY_TO_DATE(order_date, 'd/M/yyyy'),
        TRY_TO_DATE(order_date, 'd-M-yyyy')
    ) AS fecha_pedido,
    COALESCE(
        TRY_TO_DATE(ship_date, 'd/M/yyyy'),
        TRY_TO_DATE(ship_date, 'd-M-yyyy')
    ) AS fecha_envio,
    ship_mode AS modalidad_envio,
    customer_name AS nombre_cliente,
    segment AS segmento_cliente,
    state AS estado,
    country AS pais,
    market AS mercado,
    region AS region,
    product_id AS id_producto,
    category AS categoria,
    sub_category AS subcategoria,
    product_name AS nombre_producto,
    TRY_CAST(
        REPLACE(TRIM(sales), ',', '')
        AS DECIMAL(18,2)
    ) AS ventas,
    quantity AS cantidad,
    discount AS descuento,
    profit AS ganancia,
    shipping_cost AS costo_envio,
    order_priority AS prioridad_pedido,
    year AS anio
FROM retail_sales.retail_analysis.super_store_orders;




SELECT
    id_pedido,
    fecha_pedido,
    fecha_envio,
    categoria,
    subcategoria,
    ventas,
    cantidad,
    descuento,
    region,
    ganancia
FROM retail_sales.retail_analysis.vw_super_store_orders
LIMIT 10;