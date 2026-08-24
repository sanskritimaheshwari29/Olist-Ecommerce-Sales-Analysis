USE olist;
SELECT
COUNT(DISTINCT o.order_id) AS Total_Orders,
COUNT(DISTINCT c.customer_id) AS Total_Customers,
COUNT(DISTINCT s.seller_id) AS Total_Sellers,
COUNT(DISTINCT p.product_id) AS Total_Products,
ROUND(SUM(oi.price + oi.freight_value),2) AS Total_Revenue
FROM olist_orders_dataset o
JOIN olist_order_items_dataset oi
ON o.order_id = oi.order_id
JOIN olist_customers_dataset c
ON o.customer_id = c.customer_id
JOIN olist_products_dataset p
ON oi.product_id = p.product_id
JOIN olist_sellers_dataset s
ON oi.seller_id = s.seller_id;

SELECT
ROUND(SUM(price + freight_value) /
COUNT(DISTINCT order_id),2) AS Average_Order_Value
FROM olist_order_items_dataset;

SELECT
    YEAR(STR_TO_DATE(order_purchase_timestamp,'%d-%m-%Y %H:%i:%s')) AS Year,
    MONTH(STR_TO_DATE(order_purchase_timestamp,'%d-%m-%Y %H:%i:%s')) AS Month,
    ROUND(SUM(oi.price),2) AS Monthly_Revenue
FROM olist_orders_dataset o
JOIN olist_order_items_dataset oi
ON o.order_id = oi.order_id
GROUP BY Year, Month
ORDER BY Year, Month;

USE olist;

SELECT
    p.product_category_name AS Category,
    ROUND(SUM(oi.price),2) AS Revenue
FROM olist_order_items_dataset oi
JOIN olist_products_dataset p
ON oi.product_id = p.product_id
GROUP BY p.product_category_name
ORDER BY Revenue DESC
LIMIT 10;

SELECT
c.customer_unique_id,
ROUND(SUM(oi.price + oi.freight_value),2) AS Total_Spending
FROM olist_customers_dataset c
JOIN olist_orders_dataset o
ON c.customer_id=o.customer_id
JOIN olist_order_items_dataset oi
ON o.order_id=oi.order_id
GROUP BY c.customer_unique_id
ORDER BY Total_Spending DESC
LIMIT 10;

SELECT
seller_id,
ROUND(SUM(price + freight_value),2) AS Revenue
FROM olist_order_items_dataset
GROUP BY seller_id
ORDER BY Revenue DESC
LIMIT 10;

SELECT
customer_state,
ROUND(SUM(price + freight_value),2) AS Revenue
FROM olist_customers_dataset c
JOIN olist_orders_dataset o
ON c.customer_id=o.customer_id
JOIN olist_order_items_dataset oi
ON o.order_id=oi.order_id
GROUP BY customer_state
ORDER BY Revenue DESC;

SELECT
ROUND(AVG(DATEDIFF(order_delivered_customer_date,
order_purchase_timestamp)),2) AS Avg_Delivery_Days,

SUM(CASE
WHEN order_delivered_customer_date >
order_estimated_delivery_date
THEN 1 ELSE 0 END) AS Delayed_Orders

FROM olist_orders_dataset
WHERE order_status='delivered';

SELECT
payment_type,
COUNT(*) AS Total_Payments,
ROUND(AVG(payment_installments),2) AS Avg_Installments
FROM olist_order_payments_dataset
GROUP BY payment_type
ORDER BY Total_Payments DESC;

SELECT
c.customer_unique_id,
COUNT(o.order_id) AS Total_Orders
FROM olist_customers_dataset c
JOIN olist_orders_dataset o
ON c.customer_id=o.customer_id
GROUP BY c.customer_unique_id
HAVING COUNT(o.order_id)>1
ORDER BY Total_Orders DESC;

SELECT
    p.product_category_name,
    ROUND(SUM(oi.price + oi.freight_value),2) AS Revenue,
    DENSE_RANK() OVER (
        ORDER BY SUM(oi.price + oi.freight_value) DESC
    ) AS Category_Rank
FROM olist_order_items_dataset oi
JOIN olist_products_dataset p
    ON oi.product_id = p.product_id
GROUP BY p.product_category_name;

