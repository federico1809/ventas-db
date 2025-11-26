
-- Caso 3: Visualizar pedidos por cliente con JOINs y segmentación con conjuntos
-- Tablas: customers, orders, order_items, products

-- 1) Detalle de pedidos por cliente con productos y cantidades
SELECT c.customer_id,
       c.full_name,
       o.order_id,
       o.order_date,
       p.product_id,
       p.product_name,
       p.category,
       p.price,
       oi.quantity,
       (oi.quantity * p.price)::numeric(12,2) AS subtotal
FROM customers c
JOIN orders o       ON o.customer_id = c.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
JOIN products p     ON p.product_id = oi.product_id
ORDER BY c.customer_id, o.order_date, o.order_id;

-- 2) Ítems promedio comprados por cliente por orden
WITH per_order AS (
  SELECT o.order_id,
         o.customer_id,
         SUM(oi.quantity) AS items_en_orden
  FROM orders o
  JOIN order_items oi ON oi.order_id = o.order_id
  GROUP BY o.order_id, o.customer_id
)
SELECT c.customer_id,
       c.full_name,
       AVG(items_en_orden)::numeric(10,2) AS items_promedio_por_orden
FROM per_order po
JOIN customers c ON c.customer_id = po.customer_id
GROUP BY c.customer_id, c.full_name
ORDER BY items_promedio_por_orden DESC;

-- 3) Operaciones de conjuntos: clientes que compraron Periféricos y/o Pantallas
WITH clientes_perifericos AS (
  SELECT DISTINCT o.customer_id
  FROM orders o
  JOIN order_items oi ON oi.order_id = o.order_id
  JOIN products p     ON p.product_id = oi.product_id
  WHERE p.category = 'Periféricos'
),
clientes_pantallas AS (
  SELECT DISTINCT o.customer_id
  FROM orders o
  JOIN order_items oi ON oi.order_id = o.order_id
  JOIN products p     ON p.product_id = oi.product_id
  WHERE p.category = 'Pantallas'
)
-- INTERSECT: clientes que compraron ambos tipos
SELECT cp.customer_id
FROM clientes_perifericos cp
INTERSECT
SELECT cpa.customer_id
FROM clientes_pantallas cpa;

-- UNION: lista combinada sin duplicados
WITH clientes_perifericos AS (
  SELECT DISTINCT o.customer_id
  FROM orders o
  JOIN order_items oi ON oi.order_id = o.order_id
  JOIN products p     ON p.product_id = oi.product_id
  WHERE p.category = 'Periféricos'
),
clientes_pantallas AS (
  SELECT DISTINCT o.customer_id
  FROM orders o
  JOIN order_items oi ON oi.order_id = o.order_id
  JOIN products p     ON p.product_id = oi.product_id
  WHERE p.category = 'Pantallas'
)
SELECT customer_id FROM clientes_perifericos
UNION
SELECT customer_id FROM clientes_pantallas
ORDER BY customer_id;
