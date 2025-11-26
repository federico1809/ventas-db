-- 4. Construir un indicador de frecuencia: cuántas órdenes realizó cada cliente.
-- Uso de COUNT y GROUP BY

SELECT
    c.customer_id,
    c.full_name,
    COUNT(o.order_id) AS numero_ordenes
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.full_name
ORDER BY numero_ordenes DESC;