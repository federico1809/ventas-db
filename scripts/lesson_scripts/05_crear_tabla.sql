
-- Caso 4: Mantenimiento del esquema, performance, triggers y transacciones
-- Tablas: orders, order_items, products, customers, audit_logs

-- 1) Índices recomendados para acelerar filtros y joins
CREATE INDEX IF NOT EXISTS idx_orders_order_date       ON orders(order_date);
CREATE INDEX IF NOT EXISTS idx_orders_customer_id      ON orders(customer_id);
CREATE INDEX IF NOT EXISTS idx_order_items_order_id    ON order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_order_items_product_id  ON order_items(product_id);
CREATE INDEX IF NOT EXISTS idx_products_category       ON products(category);
CREATE INDEX IF NOT EXISTS idx_customers_email_norm    ON customers (LOWER(TRIM(email)));

-- 2) Trigger de auditoría al insertar una orden
-- Requiere que exista audit_logs(log_id serial/bigserial, event_type text, event_timestamp timestamptz, user_info text)
CREATE OR REPLACE FUNCTION fn_log_insert_order()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO audit_logs(event_type, event_timestamp, user_info)
  VALUES ('INSERT_ORDER', NOW(), current_user);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_log_insert_order ON orders;
CREATE TRIGGER trg_log_insert_order
AFTER INSERT ON orders
FOR EACH ROW
EXECUTE FUNCTION fn_log_insert_order();

-- 3) Transacción: alta de orden con múltiples ítems y rollback ante error
DO $$
DECLARE
  v_order_id INT;
BEGIN
  BEGIN
    INSERT INTO orders(customer_id, order_date)
    VALUES (1, CURRENT_DATE)
    RETURNING order_id INTO v_order_id;

    -- Ajusta product_id a valores existentes en tu catálogo
    INSERT INTO order_items(order_id, product_id, quantity)
    VALUES
      (v_order_id, 1, 2),
      (v_order_id, 999, 1); -- Fuerza error de FK si no existe el producto 999
  EXCEPTION WHEN foreign_key_violation THEN
    RAISE NOTICE 'Rollback por FK inválida en order_items.';
    -- El bloque DO deshace las operaciones fallidas automáticamente
  END;
END $$;

-- 4) Vistas útiles
CREATE OR REPLACE VIEW vw_ingresos_por_mes AS
SELECT DATE_TRUNC('month', o.order_date)::date AS mes,
       SUM(oi.quantity * p.price)::numeric(12,2) AS ingresos
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
JOIN products p     ON p.product_id = oi.product_id
GROUP BY 1;

CREATE OR REPLACE VIEW vw_ranking_clientes AS
SELECT o.customer_id,
       c.full_name,
       SUM(oi.quantity) AS unidades
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
JOIN customers c    ON c.customer_id = o.customer_id
GROUP BY o.customer_id, c.full_name
ORDER BY unidades DESC;