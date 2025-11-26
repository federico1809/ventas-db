-- 10. Clientes que compraron una categoría pero no la otra.
-- Clientes que compraron 'Periféricos' pero NO 'Pantallas'.
-- uso de EXCEPT

-- Conjunto 1: Clientes que compraron 'Periféricos'
SELECT DISTINCT o.customer_id
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE p.category = 'Periféricos'

EXCEPT -- resta los IDs del segundo conjunto

-- Conjunto 2: Clientes que compraron 'Pantallas'
SELECT DISTINCT o.customer_id
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE p.category = 'Pantallas';