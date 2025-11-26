-- 8. Clientes que compraron en dos categorías.
-- Clientes que compraron 'Periféricos' Y 'Pantallas'.
-- uso de INTERSECT

-- Conjunto 1: Clientes que compraron 'Periféricos'
SELECT DISTINCT o.customer_id
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE p.category = 'Periféricos'

INTERSECT -- Operador de Conjunto: solo IDs presentes en ambos conjuntos

-- Conjunto 2: Clientes que compraron 'Pantallas'
SELECT DISTINCT o.customer_id
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE p.category = 'Pantallas';