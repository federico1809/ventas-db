-- 12. Definir una clave foránea faltante.
-- Que audit_logs.user_info referencie a customers.email.

-- NOTA: la ia realiza aclaraciones de importancia en este punto, a saber:
-- A) PRE-REQUISITO: Para que la FK funcione, la columna customers.email
-- debe ser UNIQUE (ya lo es en el script inicial) y la columna audit_logs.user_info
-- debe tener el mismo tipo de dato.

ALTER TABLE audit_logs
ADD CONSTRAINT fk_user_info_customer_email
FOREIGN KEY (user_info)
REFERENCES customers (email);

-- B) Los datos iniciales de audit_logs (ej. 'admin') violarán esta restricción
-- si no son emails válidos en la tabla customers.
-- La clave foránea se añade sobre el supuesto de que los futuros registros de 'user_info'
-- serán emails válidos. Para la ejecución de este script, se asume que los datos
-- iniciales no se están referenciando o que solo referencian a usuarios existentes.
-- En la base de datos de ejemplo, si los 'user_info' existentes no son emails de customers,
-- este ALTER fallará. Por simplicidad, asumimos que todos los 'user_info' válidos
-- son emails. Sin embargo, para que funcione, debemos tener emails en lugar de nombres de usuario:


-- Si la inserción inicial falló: SI FALLÓ
UPDATE audit_logs
SET user_info = 'carlos.perez@email.com'
WHERE user_info = 'carlos.perez';
-- Ejecuto este script con éxito.