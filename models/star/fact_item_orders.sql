{{ config(materialized='table', dist='auto') }}

SELECT
	ROW_NUMBER() OVER(ORDER BY orders.purchase_timestamp ASC) AS item_order_key,
    items.product_id,
    items.order_id,
    items.seller_id,
    items.unit_price,
    items.freight_value,
    items.quantity AS item_qty,
    (items.unit_price*items.quantity) AS amount_paid
FROM {{ ref('stg_order_items') }} AS items
LEFT JOIN {{ ref('stg_orders') }} AS orders ON items.order_id = orders.order_id
ORDER BY orders.purchase_timestamp ASC
