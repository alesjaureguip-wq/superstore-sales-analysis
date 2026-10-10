-- PREGUNTA 01:
-- ¿Qué categorías de productos generan mayores ventas y ganancias?

SELECT
    categoria,
    ROUND(SUM(ventas), 2) AS ventas_totales,
    ROUND(SUM(ganancia), 2) AS ganancias_totales,
    ROUND(SUM(ganancia) / NULLIF(SUM(ventas), 0) * 100, 2)
        AS margen_ganancia_pct
FROM retail_sales.retail_analysis.vw_super_store_orders
GROUP BY categoria
ORDER BY ganancias_totales DESC;


-- PREGUNTA 02:
-- ¿Qué subcategorías de productos son las más y menos rentables?

SELECT
    subcategoria,
    ROUND(SUM(ventas), 2) AS ventas_totales,
    ROUND(SUM(ganancia), 2) AS ganancias_totales,
    ROUND(SUM(ganancia) / NULLIF(SUM(ventas), 0) * 100, 2)
        AS margen_ganancia_pct
FROM retail_sales.retail_analysis.vw_super_store_orders
GROUP BY subcategoria
ORDER BY ganancias_totales DESC;


-- PREGUNTA 03:
-- ¿Qué regiones generan mayores ventas y ganancias?

SELECT
    region,
    ROUND(SUM(ventas), 2) AS ventas_totales,
    ROUND(SUM(ganancia), 2) AS ganancias_totales,
    COUNT(DISTINCT id_pedido) AS pedidos_unicos
FROM retail_sales.retail_analysis.vw_super_store_orders
GROUP BY region
ORDER BY ganancias_totales DESC;


-- PREGUNTA 04:
-- ¿Cómo evolucionan las ventas y las ganancias a lo largo de los años?

SELECT
    anio,
    ROUND(SUM(ventas), 2) AS ventas_totales,
    ROUND(SUM(ganancia), 2) AS ganancias_totales,
    COUNT(DISTINCT id_pedido) AS pedidos_unicos
FROM retail_sales.retail_analysis.vw_super_store_orders
GROUP BY anio
ORDER BY anio;


-- PREGUNTA 05:
-- ¿Qué segmentos de clientes generan mayores ventas y ganancias?

SELECT
    segmento_cliente,
    COUNT(DISTINCT id_pedido) AS pedidos_unicos,
    ROUND(SUM(ventas), 2) AS ventas_totales,
    ROUND(SUM(ganancia), 2) AS ganancias_totales,
    ROUND(SUM(ganancia) / NULLIF(SUM(ventas), 0) * 100, 2)
        AS margen_ganancia_pct
FROM retail_sales.retail_analysis.vw_super_store_orders
GROUP BY segmento_cliente
ORDER BY ganancias_totales DESC;


-- PREGUNTA 06:
-- ¿Qué relación existe entre los descuentos aplicados y las ganancias?

SELECT
    CASE
        WHEN descuento = 0 THEN 'Sin descuento'
        WHEN descuento <= 0.10 THEN 'Hasta 10%'
        WHEN descuento <= 0.20 THEN 'Entre 10% y 20%'
        WHEN descuento <= 0.30 THEN 'Entre 20% y 30%'
        ELSE 'Mas de 30%'
    END AS rango_descuento,
    COUNT(*) AS registros,
    ROUND(AVG(descuento) * 100, 2) AS descuento_promedio_pct,
    ROUND(SUM(ventas), 2) AS ventas_totales,
    ROUND(SUM(ganancia), 2) AS ganancias_totales,
    ROUND(AVG(ganancia), 2) AS ganancia_promedio_registro
FROM retail_sales.retail_analysis.vw_super_store_orders
GROUP BY
    CASE
        WHEN descuento = 0 THEN 'Sin descuento'
        WHEN descuento <= 0.10 THEN 'Hasta 10%'
        WHEN descuento <= 0.20 THEN 'Entre 10% y 20%'
        WHEN descuento <= 0.30 THEN 'Entre 20% y 30%'
        ELSE 'Mas de 30%'
    END
ORDER BY MIN(descuento); :param_1 :param_2


-- PREGUNTA 07:
-- ¿Qué productos generan las mayores ganancias y cuáles registran
-- las mayores pérdidas?

SELECT
    id_producto,
    nombre_producto,
    categoria,
    subcategoria,
    ROUND(SUM(ventas), 2) AS ventas_totales,
    ROUND(SUM(ganancia), 2) AS ganancias_totales
FROM retail_sales.retail_analysis.vw_super_store_orders
GROUP BY
    id_producto,
    nombre_producto,
    categoria,
    subcategoria
ORDER BY ganancias_totales DESC
LIMIT 10;


-- PREGUNTA 07 - CONSULTA ADICIONAL:
-- ¿Qué 10 productos registran las mayores pérdidas?

SELECT
    id_producto,
    nombre_producto,
    categoria,
    subcategoria,
    ROUND(SUM(ventas), 2) AS ventas_totales,
    ROUND(SUM(ganancia), 2) AS ganancias_totales
FROM retail_sales.retail_analysis.vw_super_store_orders
GROUP BY
    id_producto,
    nombre_producto,
    categoria,
    subcategoria
HAVING SUM(ganancia) < 0
ORDER BY ganancias_totales ASC
LIMIT 10;

-- PREGUNTA 08:
-- ¿Cuánto tiempo tardan en enviarse los pedidos según el modo de envío?

SELECT
    modalidad_envio,
    COUNT(DISTINCT id_pedido) AS pedidos_unicos,
    ROUND(AVG(DATEDIFF(fecha_envio, fecha_pedido)), 2)
        AS dias_promedio_envio,
    MIN(DATEDIFF(fecha_envio, fecha_pedido)) AS minimo_dias,
    MAX(DATEDIFF(fecha_envio, fecha_pedido)) AS maximo_dias
FROM retail_sales.retail_analysis.vw_super_store_orders
WHERE fecha_envio IS NOT NULL
  AND fecha_pedido IS NOT NULL
GROUP BY modalidad_envio
ORDER BY dias_promedio_envio;


-- PREGUNTA 09:
-- ¿Qué países y mercados presentan los mejores resultados de ventas
-- y rentabilidad?

SELECT
    mercado,
    pais,
    ROUND(SUM(ventas), 2) AS ventas_totales,
    ROUND(SUM(ganancia), 2) AS ganancias_totales,
    ROUND(SUM(ganancia) / NULLIF(SUM(ventas), 0) * 100, 2)
        AS margen_ganancia_pct,
    COUNT(DISTINCT id_pedido) AS pedidos_unicos
FROM retail_sales.retail_analysis.vw_super_store_orders
GROUP BY mercado, pais
ORDER BY ganancias_totales DESC
LIMIT 20;


-- PREGUNTA 10:
-- ¿Qué combinaciones de categoría y región ofrecen la mayor rentabilidad?

WITH rentabilidad_categoria_region AS (
    SELECT
        categoria,
        region,
        ROUND(SUM(ventas), 2) AS ventas_totales,
        ROUND(SUM(ganancia), 2) AS ganancias_totales,
        ROUND(
            SUM(ganancia) / NULLIF(SUM(ventas), 0) * 100,
            2
        ) AS margen_ganancia_pct
    FROM retail_sales.retail_analysis.vw_super_store_orders
    GROUP BY categoria, region
),
ranking AS (
    SELECT
        *,
        RANK() OVER (
            ORDER BY ganancias_totales DESC
        ) AS ranking_ganancias,
        RANK() OVER (
            ORDER BY margen_ganancia_pct DESC
        ) AS ranking_margen
    FROM rentabilidad_categoria_region
)
SELECT *
FROM ranking
ORDER BY ranking_ganancias, ranking_margen;