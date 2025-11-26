-- Tarea 16: Diseñar una función definida por el usuario que clasifique a cada cliente en segmentos:
-- "Frecuente": más de 5 órdenes.
-- "Ocasional": entre 2 y 5 órdenes.
-- "Nuevo": solo 1 orden.

-- -----------------------------------------------------------
-- PARTE 1: CREAR FUNCIÓN QUE RECIBE EL ID DEL CLIENTE
-- -----------------------------------------------------------
CREATE OR REPLACE FUNCTION clasificar_cliente_por_frecuencia(
    p_customer_id INT
)
RETURNS VARCHAR(50) AS $$
DECLARE
    v_ordenes_count INT;
    v_segmento VARCHAR(50);
BEGIN
    -- Contar cuántas órdenes ha realizado el cliente
    SELECT COUNT(order_id)
    INTO v_ordenes_count
    FROM orders
    WHERE customer_id = p_customer_id;

    -- Lógica de segmentación
    IF v_ordenes_count > 5 THEN
        v_segmento := 'Frecuente';
    ELSIF v_ordenes_count BETWEEN 2 AND 5 THEN
        v_segmento := 'Ocasional';
    ELSE
        -- Incluye clientes con 1 orden o 0 órdenes (si hubiera LEFT JOIN en el conteo)
        v_segmento := 'Nuevo';
    END IF;

    RETURN v_segmento;
END;
$$ LANGUAGE plpgsql; -- Lenguaje de procedimientos de PostgreSQL

-- -----------------------------------------------------------
-- PARTE 2: PROBAR LA FUNCIÓN APLICADA A TODOS LOS CLIENTES
-- -----------------------------------------------------------
SELECT
    c.customer_id,
    c.full_name,
    (SELECT COUNT(order_id) FROM orders WHERE customer_id = c.customer_id) AS total_ordenes,
    -- Aplicar la función a cada cliente
    clasificar_cliente_por_frecuencia(c.customer_id) AS segmento_rfm
FROM customers c
ORDER BY total_ordenes DESC;