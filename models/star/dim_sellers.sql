{{ config(materialized='table', dist='all') }}

SELECT
    distinct sellers.seller_id,
    sellers.zip_code_prefix,
    geolocation.city,
    geolocation.state
FROM {{ ref('stg_sellers') }} AS sellers
left join {{ ref('stg_geolocation') }} as geolocation
on sellers.zip_code_prefix = geolocation.zip_code_prefix