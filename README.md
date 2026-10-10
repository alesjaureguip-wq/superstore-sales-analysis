# Superstore Sales Analysis

Análisis de ventas, rentabilidad y desempeño comercial mediante SQL y Databricks.

## Descripción del proyecto

Este proyecto tiene como objetivo analizar datos de ventas de una tienda minorista para identificar patrones comerciales, evaluar la rentabilidad de sus productos y obtener información útil para la toma de decisiones.

Mediante consultas SQL se examinan las ventas, ganancias, categorías, clientes, descuentos, mercados y tiempos de envío. Los resultados permiten identificar oportunidades de mejora y posibles problemas de rentabilidad.

## Objetivos

- Analizar las ventas y ganancias por categoría y subcategoría.
- Identificar las regiones y los mercados con mejores resultados.
- Evaluar la evolución de las ventas a lo largo del tiempo.
- Comparar el desempeño de los segmentos de clientes.
- Examinar la relación entre los descuentos y las pérdidas.
- Identificar productos con ganancias y pérdidas acumuladas.
- Analizar los tiempos de envío por modalidad.
- Evaluar la rentabilidad por categoría y región.

## Herramientas utilizadas

- **SQL:** consultas, agregaciones, subconsultas y funciones de ventana.
- **Databricks:** ejecución de consultas y análisis de datos.
- **Git y GitHub:** control de versiones y publicación del proyecto.

## Fuente de datos

Dataset: [Superstore Sales Dataset — Kaggle](https://www.kaggle.com/datasets/laibaanwer/superstore-sales-dataset).

## Estructura del proyecto

```text
superstore-sales-analysis/
├── data/
│   └── SuperStoreOrders.csv
├── Git/
│   └── .gitattributes
├── picture/
│   ├── Pregunta 1.png
│   ├── Pregunta 2.png
│   ├── Pregunta 3.png
│   ├── Pregunta 4.png
│   ├── Pregunta 5.png
│   ├── Pregunta 6.png
│   ├── Pregunta 7.png
│   ├── Pregunta 7.2.png
│   ├── Pregunta 8.png
│   ├── Pregunta 9.png
│   └── Pregunta 10.png
├── script/
│   ├── ddl.sql
│   └── dml.sql
└── README.md
```

## Consultas SQL y resultados

### Pregunta 1. ¿Qué categorías generan mayores ventas y ganancias?

**Consulta SQL**

```sql
SELECT
    categoria,
    ROUND(SUM(ventas), 2) AS ventas_totales,
    ROUND(SUM(ganancia), 2) AS ganancias_totales
    ROUND(SUM(ganancia) / NULLIF(SUM(ventas), 0) * 100, 2)
    AS margen_ganancia_pct
FROM retail_sales.retail_analysis.vw_super_store_orders
GROUP BY categoria
ORDER BY ventas_totales DESC;
```

**Resultados**

![Resultados de la pregunta 1](./picture/Pregunta%201.png)

---

### Pregunta 2. ¿Qué subcategorías son las más y menos rentables?

**Consulta SQL**

```sql
SELECT
    subcategoria,
    ROUND(SUM(ventas), 2) AS ventas_totales,
    ROUND(SUM(ganancia), 2) AS ganancias_totales
FROM retail_sales.retail_analysis.vw_super_store_orders
GROUP BY subcategoria
ORDER BY ganancias_totales DESC;
```

**Resultados**

![Resultados de la pregunta 2](./picture/Pregunta%202.png)

---

### Pregunta 3. ¿Qué regiones generan mayores ventas y ganancias?

**Consulta SQL**

```sql
SELECT
    region,
    ROUND(SUM(ventas), 2) AS ventas_totales,
    ROUND(SUM(ganancia), 2) AS ganancias_totales
FROM retail_sales.retail_analysis.vw_super_store_orders
GROUP BY region
ORDER BY ventas_totales DESC;
```

**Resultados**

![Resultados de la pregunta 3](./picture/Pregunta%203.png)

---

### Pregunta 4. ¿Cómo evolucionan las ventas y ganancias a lo largo del tiempo?

**Consulta SQL**

```sql
SELECT
    anio,
    ROUND(SUM(ventas), 2) AS ventas_totales,
    ROUND(SUM(ganancia), 2) AS ganancias_totales
FROM retail_sales.retail_analysis.vw_super_store_orders
GROUP BY anio
ORDER BY anio;
```

**Resultados**

![Resultados de la pregunta 4](./picture/Pregunta%204.png)

---

### Pregunta 5. ¿Qué segmentos de clientes generan mayores ventas y ganancias?

**Consulta SQL**

```sql
SELECT
    segmento_cliente,
    ROUND(SUM(ventas), 2) AS ventas_totales,
    ROUND(SUM(ganancia), 2) AS ganancias_totales,
    COUNT(DISTINCT id_pedido) AS total_pedidos
FROM retail_sales.retail_analysis.vw_super_store_orders
GROUP BY segmento_cliente
ORDER BY ventas_totales DESC;
```

**Resultados**

![Resultados de la pregunta 5](./picture/Pregunta%205.png)

---

### Pregunta 6. ¿Qué relación existe entre los descuentos y las ganancias?

**Consulta SQL**

```sql
SELECT
    CASE
        WHEN descuento = 0 THEN 'Sin descuento'
        WHEN descuento <= 0.10 THEN 'Hasta 10%'
        WHEN descuento <= 0.20 THEN '10% a 20%'
        WHEN descuento <= 0.30 THEN '20% a 30%'
        ELSE 'Más de 30%'
    END AS rango_descuento,
    COUNT(*) AS total_registros,
    ROUND(SUM(ventas), 2) AS ventas_totales,
    ROUND(SUM(ganancia), 2) AS ganancias_totales,
    ROUND(
        100.0 * SUM(
            CASE WHEN ganancia < 0 THEN 1 ELSE 0 END
        ) / COUNT(*),
        2
    ) AS porcentaje_registros_con_perdida
FROM retail_sales.retail_analysis.vw_super_store_orders
GROUP BY
    CASE
        WHEN descuento = 0 THEN 'Sin descuento'
        WHEN descuento <= 0.10 THEN 'Hasta 10%'
        WHEN descuento <= 0.20 THEN '10% a 20%'
        WHEN descuento <= 0.30 THEN '20% a 30%'
        ELSE 'Más de 30%'
    END
ORDER BY MIN(descuento);
```

**Resultados**

![Resultados de la pregunta 6](./picture/Pregunta%206.png)

---

### Pregunta 7. ¿Qué productos generan las mayores ganancias?

**Consulta SQL**

```sql
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
HAVING SUM(ganancia) > 0
ORDER BY ganancias_totales DESC
LIMIT 10;
```

**Resultados: productos con mayores ganancias**

![Resultados de la pregunta 7](./picture/Pregunta%207.png)

**Consulta complementaria: productos con mayores pérdidas**

```sql
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
```

**Resultados: productos con mayores pérdidas**

![Resultados de la pregunta 7.2](./picture/Pregunta%207.2.png)

---

### Pregunta 8. ¿Cuánto tiempo tardan los envíos según su modalidad?

**Consulta SQL**

```sql
SELECT
    modalidad_envio,
    COUNT(*) AS total_registros,
    ROUND(
        AVG(DATEDIFF(fecha_envio, fecha_pedido)),
        2
    ) AS promedio_dias_envio,
    MIN(DATEDIFF(fecha_envio, fecha_pedido))
        AS minimo_dias_envio,
    MAX(DATEDIFF(fecha_envio, fecha_pedido))
        AS maximo_dias_envio
FROM retail_sales.retail_analysis.vw_super_store_orders
GROUP BY modalidad_envio
ORDER BY promedio_dias_envio;
```

**Resultados**

![Resultados de la pregunta 8](./picture/Pregunta%208.png)

---

### Pregunta 9. ¿Qué países y mercados presentan mejores resultados?

**Consulta SQL**

```sql
SELECT
    mercado,
    pais,
    ROUND(SUM(ventas), 2) AS ventas_totales,
    ROUND(SUM(ganancia), 2) AS ganancias_totales,
    ROUND(
        100.0 * SUM(ganancia)
        / NULLIF(SUM(ventas), 0),
        2
    ) AS margen_ganancia_pct
FROM retail_sales.retail_analysis.vw_super_store_orders
GROUP BY mercado, pais
ORDER BY ganancias_totales DESC;
```

**Resultados**

![Resultados de la pregunta 9](./picture/Pregunta%209.png)

---

### Pregunta 10. ¿Qué combinaciones de categoría y región presentan mayor rentabilidad?

**Consulta SQL**

```sql
WITH rentabilidad AS (
    SELECT
        categoria,
        region,
        ROUND(SUM(ventas), 2) AS ventas_totales,
        ROUND(SUM(ganancia), 2) AS ganancias_totales,
        ROUND(
            100.0 * SUM(ganancia)
            / NULLIF(SUM(ventas), 0),
            2
        ) AS margen_ganancia_pct
    FROM retail_sales.retail_analysis.vw_super_store_orders
    GROUP BY categoria, region
)
SELECT
    categoria,
    region,
    ventas_totales,
    ganancias_totales,
    margen_ganancia_pct,
    RANK() OVER (
        ORDER BY ganancias_totales DESC
    ) AS ranking_ganancias,
    RANK() OVER (
        ORDER BY margen_ganancia_pct DESC
    ) AS ranking_margen
FROM rentabilidad
ORDER BY ranking_ganancias;
```

**Resultados**

![Resultados de la pregunta 10](./picture/Pregunta%2010.png)

---

## Hallazgos del análisis

Los resultados obtenidos permiten estudiar las diferencias de rentabilidad entre categorías, subcategorías, regiones y mercados.

También se observa que los registros con descuentos más elevados presentan una mayor frecuencia de pérdidas en este conjunto de datos. Esta relación es una asociación observada y no demuestra, por sí sola, causalidad.

El análisis de productos permite distinguir entre aquellos que acumulan ganancias y aquellos que acumulan pérdidas, mientras que el análisis de envíos ayuda a comparar los tiempos registrados según la modalidad de entrega.

## Conclusión

Este proyecto demuestra la aplicación de SQL para transformar datos de ventas en información útil para el análisis comercial. Las consultas permiten resumir indicadores, comparar segmentos y explorar posibles oportunidades de mejora en la rentabilidad.

## Autor

Proyecto personal desarrollado con fines de aprendizaje y portafolio profesional.
