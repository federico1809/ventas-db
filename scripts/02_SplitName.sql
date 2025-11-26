-- 2. Crear un campo first_name y last_name desde full_name.
-- uso de SPLIT_PART para dividir la cadena

SELECT
    customer_id,
    full_name,
    -- primer componente del split
    SPLIT_PART(full_name, ' ', 1) AS first_name,
    -- segundo componente (y resto, si hay más de dos palabras)
    SPLIT_PART(full_name, ' ', 2) AS last_name
    -- Nota: Si hubiera nombres compuestos (ej: 'Juan De La Cruz'), esta división
    -- podría no ser perfecta, lo cual es común en la preparación de datos.
FROM customers;