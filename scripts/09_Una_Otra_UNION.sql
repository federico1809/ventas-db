-- 9. Lista combinada de clientes que compraron una u otra categoría.
-- Clientes que compraron 'Periféricos' O 'Pantallas'.
-- uso de UNION

-- Conjunto 1: Clientes que compraron 'Periféricos'
SELECT DISTINCT o.customer_id
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE p.category = 'Periféricos'

UNION -- eliminando duplicados

-- Conjunto 2: Clientes que compraron 'Pantallas'
SELECT DISTINCT o.customer_id
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE p.category = 'Pantallas';