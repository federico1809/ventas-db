-- 3. Detectar outliers textuales en correos (email que no contengan “@” o con espacios anómalos)
-- y cuantificar cuántos clientes están mal registrados.

-- Detectar y listar clientes con emails que no contienen '@' o tienen espacios
SELECT
    customer_id,
    full_name,
    email
FROM customers
WHERE
    -- Condición 1: No contiene el símbolo '@'
    email NOT LIKE '%@%'
    OR
    -- Condición 2: Contiene algún espacio en blanco
    email LIKE '% %';

-- Cuantificar cuántos clientes están mal registrados
SELECT
    COUNT(customer_id) AS clientes_mal_registrados
FROM customers
WHERE
    email NOT LIKE '%@%'
    OR
    email LIKE '% %';