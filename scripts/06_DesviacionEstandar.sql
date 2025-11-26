-- 6. Encontrar productos con alta dispersión en ventas usando STDDEV.

SELECT
    p.product_id,
    p.product_name,
    -- Calcula la desviación estándar de la cantidad vendida.
    STDDEV_POP(oi.quantity) AS desviacion_estandar_cantidad
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id, p.product_name
HAVING COUNT(oi.order_id) > 1 -- Aseguramos que solo incluya productos con más de una venta para calcular la dispersión.
ORDER BY desviacion_estandar_cantidad DESC;