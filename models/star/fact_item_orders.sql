{{ config(materialized='table', dist='auto') }}

SELECT
	ROW_NUMBER() OVER(ORDER BY orders.order_purchase_timestamp ASC) AS item_order_key,
    items.product_id,
    items.order_id,
    items.seller_id,
    items.price,
    items.freight_value,
    1 AS item_qty,
    (items.price*1) AS amount_paid
FROM {{ ref('stg_order_items') }} AS items
LEFT JOIN {{ ref('stg_orders') }} AS orders ON items.order_id = orders.order_id
ORDER BY orders.order_purchase_timestamp ASC
