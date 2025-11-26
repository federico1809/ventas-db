
-- Caso 2: Informe de ventas por producto y ranking de clientes
-- Tablas: order_items, products, orders, customers

-- 1) Ventas por producto: cantidades, órdenes y promedio por orden
SELECT p.product_id,
       p.product_name,
       p.category,
       SUM(oi.quantity)                           AS unidades_totales,
       COUNT(DISTINCT oi.order_id)                AS ordenes_distintas,
       AVG(oi.quantity)::numeric(10,2)            AS unidades_prom_por_orden,
       SUM(oi.quantity * p.price)::numeric(12,2)  AS ingresos_totales
FROM order_items oi
JOIN products p ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name, p.category
ORDER BY ingresos_totales DESC;

-- 2) Filtrar con HAVING: productos con >3 ventas o ingresos > 200
SELECT p.product_id, p.product_name,
       SUM(oi.quantity) AS unidades_totales,
       SUM(oi.quantity * p.price) AS ingresos
FROM order_items oi
JOIN products p ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
HAVING SUM(oi.quantity) > 3
    OR SUM(oi.quantity * p.price) > 200
ORDER BY ingresos DESC;

-- 3) Clientes más activos por cantidad de órdenes
SELECT o.customer_id,
       c.full_name,
       COUNT(*) AS cant_ordenes
FROM orders o
JOIN customers c ON c.customer_id = o.customer_id
GROUP BY o.customer_id, c.full_name
ORDER BY cant_ordenes DESC, o.customer_id
LIMIT 10;

-- 4) Clientes con mayor cantidad total de productos comprados
SELECT o.customer_id,
       c.full_name,
       SUM(oi.quantity) AS unidades_total
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
JOIN customers c    ON c.customer_id = o.customer_id
GROUP BY o.customer_id, c.full_name
ORDER BY unidades_total DESC
LIMIT 10;
