-- 14. Simular una transacción completa e invertirla con ROLLBACK.

-- 1. INICIO DE LA TRANSACCIÓN (Punto de no retorno, salvo ROLLBACK)
BEGIN;

-- 2. OPERACIONES DENTRO DE LA TRANSACCIÓN

-- 2.1. Insertar un cliente nuevo
INSERT INTO customers (full_name, email, created_at)
VALUES ('Cliente Transaccional', 'transaccion.test@email.com', CURRENT_DATE);

-- Obtener el ID del cliente recién insertado
SELECT currval('customers_customer_id_seq') INTO v_new_customer_id; -- PostgreSQL

-- 2.2. Registrar una orden para ese cliente
INSERT INTO orders (customer_id, order_date)
VALUES (v_new_customer_id, CURRENT_DATE);

-- Obtener el ID de la orden
SELECT currval('orders_order_id_seq') INTO v_new_order_id; -- PostgreSQL

-- 2.3. Insertar ítems de la orden
INSERT INTO order_items (order_id, product_id, quantity)
VALUES
    (v_new_order_id, 1, 1),
    (v_new_order_id, 3, 2);

-- 3. INVERSIÓN: Deshacer todos los cambios (ROLLBACK)

ROLLBACK;

-- 4. VERIFICACIÓN (Nada debe haberse insertado)
-- La cuenta debería ser la misma que antes de la transacción.
SELECT * FROM customers WHERE full_name = 'Cliente Transaccional';
SELECT * FROM orders ORDER BY order_id DESC LIMIT 1;
SELECT * FROM order_items ORDER BY order_item_id DESC LIMIT 2;

-- NOTA: Si hubiéramos usado COMMIT; en lugar de ROLLBACK;, los datos se habrían guardado permanentemente.