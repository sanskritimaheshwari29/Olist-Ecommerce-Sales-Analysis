DROP VIEW IF EXISTS monthly_revenue;

CREATE VIEW monthly_revenue AS
SELECT
YEAR(STR_TO_DATE(order_purchase_timestamp,'%d-%m-%Y %H:%i')) AS Year,
MONTH(STR_TO_DATE(order_purchase_timestamp,'%d-%m-%Y %H:%i')) AS Month,
SUM(price + freight_value) AS Revenue
FROM olist_orders_dataset o
JOIN olist_order_items_dataset oi
ON o.order_id = oi.order_id
GROUP BY
YEAR(STR_TO_DATE(order_purchase_timestamp,'%d-%m-%Y %H:%i')),
MONTH(STR_TO_DATE(order_purchase_timestamp,'%d-%m-%Y %H:%i'));

SELECT * FROM monthly_revenue;