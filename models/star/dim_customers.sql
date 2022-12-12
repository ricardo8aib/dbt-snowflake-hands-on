{{ config(materialized='table', dist='state') }}

SELECT
    distinct customers.customer_id,
    customers.customer_zip_code_prefix,
    geolocation.geolocation_city,
    geolocation.geolocation_state
FROM {{ ref('stg_customers') }} AS customers
left join {{ ref('stg_geolocation') }} as geolocation
on customers.customer_zip_code_prefix = geolocation.geolocation_zip_code_prefix