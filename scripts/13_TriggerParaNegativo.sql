-- 13. Crear un trigger que detecte si se inserta una orden con quantity <= 0
-- y registre el intento en audit_logs como event_type = 'ERROR_ORDER'.

-- a: CREAR FUNCIÓN DE TRIGGER
CREATE OR REPLACE FUNCTION log_invalid_order_item()
RETURNS TRIGGER AS $$
BEGIN
    -- Verificar si la cantidad es menor o igual a cero
    IF NEW.quantity <= 0 THEN
        -- Si la cantidad es inválida, registrar el error en audit_logs
        INSERT INTO audit_logs (event_type, event_timestamp, user_info)
        VALUES (
            'ERROR_ORDER',
            NOW(),
            'Attempted insertion of invalid quantity: ' || NEW.quantity || ' for product_id: ' || NEW.product_id
        );
        -- Opcional: Lanzar una excepción para evitar que la inserción continúe
        -- RAISE EXCEPTION 'La cantidad del ítem de la orden debe ser positiva.';
    END IF;

    -- Devolver NEW para permitir la inserción si todo es correcto (o si se quiere registrar el error pero permitir el dato)
    -- Si se lanza la excepción (RAISE), no se llega a este punto.
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- b: CREAR EL TRIGGER
CREATE TRIGGER trg_check_order_quantity
BEFORE INSERT OR UPDATE ON order_items
FOR EACH ROW
EXECUTE FUNCTION log_invalid_order_item();

-- c: PRUEBA DEL TRIGGER (EJECUTAR DESPUÉS DEL CÓDIGO ANTERIOR)
-- Este INSERT generará un registro en audit_logs con event_type = 'ERROR_ORDER'
INSERT INTO order_items (order_id, product_id, quantity)
VALUES (1, 1, 0);

-- d: Verificación:
SELECT * FROM audit_logs ORDER BY log_id DESC;