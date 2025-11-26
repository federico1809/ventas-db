-- 1. Calcular la fecha de la última orden de cada cliente.
-- uso de MAX y GROUP BY

SELECT
    c.customer_id,
    c.full_name,
    MAX(o.order_date) AS ultima_fecha_orden
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name
ORDER BY ultima_fecha_orden DESC;