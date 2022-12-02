{{ config(materialized='table', dist='state') }}

SELECT
    distinct customers.customer_id,
    customers.zip_code_prefix,
    geolocation.city,
    geolocation.state
FROM {{ ref('stg_customers') }} AS customers
left join {{ ref('stg_geolocation') }} as geolocation
on customers.zip_code_prefix = geolocation.zip_code_prefix