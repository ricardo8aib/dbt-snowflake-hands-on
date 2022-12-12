{{ config(materialized='table', dist='category_name') }}

SELECT
    distinct products.product_id,
    products.product_category_name,
    products.product_weight_g,
    products.product_length_cm,
    products.product_height_cm,
    products.product_width_cm
FROM {{ ref('stg_products') }} AS products