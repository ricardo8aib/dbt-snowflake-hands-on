{{ config(materialized='table', dist='all') }}

SELECT
    distinct sellers.seller_id,
    sellers.seller_zip_code_prefix,
    geolocation.geolocation_city,
    geolocation.geolocation_state
FROM {{ ref('stg_sellers') }} AS sellers
left join {{ ref('stg_geolocation') }} as geolocation
on sellers.seller_zip_code_prefix = geolocation.geolocation_zip_code_prefix