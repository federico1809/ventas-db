-- Tarea 15: Crear una vista dinámica que muestre las ventas acumuladas por trimestre y categoría,
-- incluyendo ingresos totales y clientes distintos.

-- La vista facilitará el reporting y el análisis de tendencias.
CREATE OR REPLACE VIEW v_ventas_trimestrales AS
SELECT
    -- 1. Determinar el Año y el Trimestre
    EXTRACT(YEAR FROM o.order_date) AS anio,
    EXTRACT(QUARTER FROM o.order_date) AS trimestre,
    p.category,
    
    -- 2. Métricas de Venta
    SUM(oi.quantity * p.price) AS ingresos_totales,
    SUM(oi.quantity) AS unidades_vendidas,
    
    -- 3. Métrica de Clientes
    COUNT(DISTINCT o.customer_id) AS clientes_distintos
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY 1, 2, p.category
ORDER BY anio, trimestre, category;

-- -----------------------------------------------------------
-- Prueba de la Vista (DQL)
-- -----------------------------------------------------------
SELECT * FROM v_ventas_trimestrales;