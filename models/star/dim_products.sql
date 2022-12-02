{{ config(materialized='table', dist='category_name') }}

SELECT
    distinct products.product_id,
    products.category_name,
    products.weight_g,
    products.length_cm,
    products.height_cm,
    products.width_cm
FROM {{ ref('stg_products') }} AS products