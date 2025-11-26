Proyecto de Análisis de Comportamiento de Clientes (VentasDB)

Este repositorio contiene los scripts SQL desarrollados para la base de datos VentasDB con el objetivo de explorar, transformar y preparar datos de clientes y órdenes. El análisis está enfocado en generar features que permitan optimizar decisiones de negocio en áreas como marketing, gestión de productos y retención de clientes.

Entorno y Tecnología

Motor de Base de Datos: PostgreSQL

Cliente SQL: DBeaver

Base de Datos Inicial: VentasDB (Cargada con VentasDB_inicial.sql)

Secciones de la Tarea

La tarea se dividió en cuatro áreas clave del manejo de datos con SQL:

1. Manipulación de Datos Temporales y Textuales

Archivo

Objetivo

Funciones Clave

01_ultima_orden.sql

Calcular la fecha de la última orden para cada cliente.

MAX(), GROUP BY

02_separar_nombre_apellido.sql

Dividir full_name en first_name y last_name.

SPLIT_PART() (PostgreSQL)

03_detectar_outliers.sql

Detectar y cuantificar correos con formato anómalo (sin '@' o con espacios).

LIKE, NOT LIKE, COUNT()

2. Agregación y Agrupamiento (Creación de Features Analíticos)

Archivo

Objetivo

Funciones Clave

04_frecuencia_ordenes.sql

Construir un indicador de frecuencia (órdenes por cliente).

COUNT(), LEFT JOIN

05_valor_monetario_total.sql

Calcular el valor monetario total (gasto) por cada cliente.

SUM(quantity * price), JOINs

06_dispersion_ventas.sql

Encontrar productos con alta dispersión en cantidades vendidas.

STDDEV_POP()

3. Consultas Compuestas y Relaciones (Set Operators)

Archivo

Objetivo

Operador Clave

07_listar_compras_join.sql

Reporte simple de todas las compras con detalles de cliente y producto.

JOIN

08_clientes_intersect.sql

Clientes que compraron productos de la Categoría A Y de la Categoría B.

INTERSECT

09_clientes_union.sql

Clientes que compraron productos de la Categoría A O de la Categoría B.

UNION

10_clientes_except.sql

Clientes que compraron de la Categoría A PERO NO de la Categoría B.

EXCEPT

4. Gestión Avanzada de Bases de Datos (DDL, Transacciones y Funciones)

Archivo

Objetivo

Concepto Clave

11_crear_indice.sql

Optimizar el rendimiento de búsquedas por cliente.

CREATE INDEX

12_definir_fk_logs.sql

Definir una clave foránea en audit_logs para asegurar la referencia de user_info a customers.email.

ALTER TABLE ADD CONSTRAINT FOREIGN KEY

13_crear_trigger_error.sql

Crear un mecanismo automático para auditar intentos de inserción con quantity <= 0.

TRIGGER (BEFORE INSERT) y FUNCTION

14_transaccion_rollback.sql

Demostración de control de consistencia de datos.

BEGIN; ... ROLLBACK;

Secciones Extra Mile

Archivo

Objetivo

Técnica Avanzada

15_vista_ventas_trimestre.sql

Simplificar reportes creando una vista dinámica de ventas por trimestre.

CREATE VIEW (EXTRACT(QUARTER))

16_funcion_segmentacion.sql

Clasificar clientes en segmentos ("Frecuente", "Ocasional", "Nuevo") usando lógica de negocio.

UDF (CREATE FUNCTION con plpgsql)

17_insert_data_ia.sql

Simulación de la inserción de nuevos registros generados de forma limpia para evitar outliers.

Inserción de prueba y Documentación de Ajustes.