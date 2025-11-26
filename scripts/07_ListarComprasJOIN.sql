-- 7. Listar compras con un JOIN, mostrando detalles clave.

SELECT
    o.order_id,
    o.order_date,
    c.full_name AS nombre_cliente,
    p.product_name AS producto_comprado,
    oi.quantity,
    p.price,
    (oi.quantity * p.price) AS subtotal
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
ORDER BY o.order_date, o.order_id;