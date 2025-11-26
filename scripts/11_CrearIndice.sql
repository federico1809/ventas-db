-- 11. Crear un índice sobre customer_id en orders para acelerar reportes por cliente.
-- Se crea un índice no único (ya que un cliente puede tener muchas órdenes)
-- sobre la columna customer_id de la tabla orders.
CREATE INDEX idx_orders_customer_id ON orders (customer_id);

-- Para verificar el índice:
SELECT * FROM pg_indexes WHERE tablename = 'orders';