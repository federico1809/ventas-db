-- Tarea 17: Insertar datos faltantes con IA (simulación) y explicar qué ajustes se hicieron.

-- -----------------------------------------------------------
-- EXPLICACIÓN Y AJUSTES REALIZADOS
-- -----------------------------------------------------------
/*
1. Objetivo: Aumentar la densidad de datos para las categorías 'Periféricos' y 'Pantallas'
   y añadir un cliente que se usará para probar las transacciones futuras.

2. Datos Generados por IA (Simulación):
   - Producto: 'Webcam 4K', Categoría: 'Periféricos', Precio: 99.99
   - Cliente: 'Andrés López', Email: 'andres.lopez@email.com', Fecha: '2024-04-15'

3. Ajustes al script:
   - Se utilizaron las secuencias de PostgreSQL (`SERIAL` o `DEFAULT`) para asegurar que
     los IDs (`customer_id` y `product_id`) se autogeneren correctamente.
   - La estructura de la tabla ya era compatible, por lo que solo se requirió la sintaxis
     básica de `INSERT INTO`.
*/

-- -----------------------------------------------------------
-- INSERCIÓN DE NUEVOS DATOS
-- -----------------------------------------------------------

-- Insertar Nuevo Producto (Generado por IA)
INSERT INTO products (product_name, category, price) VALUES
('Webcam 4K', 'Periféricos', 99.99);

-- Insertar Nuevo Cliente (Generado por IA)
INSERT INTO customers (full_name, email, created_at) VALUES
('Andrés López', 'andres.lopez@email.com', '2024-04-15');


-- -----------------------------------------------------------
-- VERIFICACIÓN
-- -----------------------------------------------------------
SELECT * FROM products ORDER BY product_id DESC LIMIT 1;
SELECT * FROM customers ORDER BY customer_id DESC LIMIT 1;