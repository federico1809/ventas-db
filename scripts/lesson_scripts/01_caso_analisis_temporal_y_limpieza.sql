
-- Caso 1: Análisis temporal, comportamiento de clientes y limpieza de datos
-- Requisitos: PostgreSQL 13+ y esquema VentasDB cargado previamente.
-- Tablas esperadas: customers, orders, order_items, products

-- 1) Limpieza de emails y split de nombres
-- Vista previa de limpieza de emails
SELECT customer_id,
       email AS email_original,
       TRIM(LOWER(email)) AS email_limpio
FROM customers;

-- Aplicar limpieza de emails
UPDATE customers
SET email = TRIM(LOWER(email))
WHERE email IS NOT NULL;

-- Agregar columnas para nombre y apellido si no existen (ajusta tipos/longitudes según tu esquema)
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name='customers' AND column_name='first_name'
  ) THEN
    ALTER TABLE customers ADD COLUMN first_name VARCHAR(60);
  END IF;
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns 
    WHERE table_name='customers' AND column_name='last_name'
  ) THEN
    ALTER TABLE customers ADD COLUMN last_name VARCHAR(60);
  END IF;
END $$;

-- Rellenar first_name y last_name desde full_name
UPDATE customers
SET first_name = NULLIF(SPLIT_PART(full_name, ' ', 1), ''),
    last_name  = NULLIF(SPLIT_PART(full_name, ' ', 2), '')
WHERE full_name IS NOT NULL;

-- Chequeos de calidad de nombres
-- Nombres con un solo token (posible incompleto)
SELECT customer_id, full_name
FROM customers
WHERE POSITION(' ' IN full_name) = 0;

-- Emails potencialmente inválidos (heurístico simple)
SELECT customer_id, email
FROM customers
WHERE email NOT LIKE '%@%.%';

-- 2) Listado de clientes nuevos del último trimestre (ajusta el rango)
WITH params AS (
  SELECT DATE '2024-04-01' AS desde, DATE '2024-06-30' AS hasta
)
SELECT c.customer_id,
       c.full_name,
       c.email,
       c.created_at
FROM customers c
JOIN params p ON c.created_at BETWEEN p.desde AND p.hasta
ORDER BY c.created_at;

-- 3) Resumen mensual de órdenes, unidades e ingresos y detección de picos
-- Resumen por año/mes
SELECT EXTRACT(YEAR  FROM o.order_date)::int AS anio,
       EXTRACT(MONTH FROM o.order_date)::int AS mes,
       COUNT(DISTINCT o.order_id)            AS ordenes,
       SUM(oi.quantity)                      AS unidades,
       SUM(oi.quantity * p.price)::numeric   AS ingresos
FROM orders o
LEFT JOIN order_items oi ON oi.order_id = o.order_id
LEFT JOIN products p     ON p.product_id = oi.product_id
GROUP BY anio, mes
ORDER BY anio, mes;

-- Detección de picos usando media + 1 desvío estándar poblacional
WITH m AS (
  SELECT DATE_TRUNC('month', o.order_date) AS periodo,
         SUM(oi.quantity * p.price) AS ingresos
  FROM orders o
  JOIN order_items oi ON oi.order_id = o.order_id
  JOIN products p     ON p.product_id = oi.product_id
  GROUP BY 1
),
stats AS (
  SELECT AVG(ingresos) AS avg_ing,
         STDDEV_POP(ingresos) AS sd_ing
  FROM m
)
SELECT m.periodo::date AS mes,
       m.ingresos,
       CASE WHEN m.ingresos > s.avg_ing + s.sd_ing THEN 'pico' ELSE 'normal' END AS clasificacion
FROM m CROSS JOIN stats s
ORDER BY mes;
