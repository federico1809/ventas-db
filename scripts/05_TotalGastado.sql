-- 5. Calcular el valor monetario total gastado por cliente (SUM(quantity*price)).
-- uso de joins múltiples, sum y group by

SELECT
    c.customer_id,
    c.full_name,
      SUM(oi.quantity * p.price) AS total_gastado
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
GROUP BY c.customer_id, c.full_name
ORDER BY total_gastado DESC;