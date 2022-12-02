{{ config(materialized='table', sort='DATE', dist='auto') }}

WITH dates AS (
	SELECT purchase_timestamp AS DATE FROM {{ ref('stg_orders') }}
	UNION SELECT approved_at FROM {{ ref('stg_orders') }}
	UNION SELECT delivered_carrier_date FROM {{ ref('stg_orders') }}
	UNION SELECT delivered_customer_date FROM {{ ref('stg_orders') }}
	UNION SELECT estimated_delivery_date FROM {{ ref('stg_orders') }})
SELECT 
	ROW_NUMBER() OVER(ORDER BY DATE ASC) AS date_id,
	DATE,
	to_char(DATE, 'DD') as day,
	to_char(DATE, 'MM') as month,
	to_char(DATE, 'YYYY') as year,
	to_char(DATE, 'DAY') as day_name,
	to_char(DATE, 'MONTH') as month_name,
	to_char(DATE, 'DDD') as day_of_year,
	to_char(DATE, 'D') as day_of_week,
	to_char(DATE, 'q') as quarter
FROM dates 
order by DATE asc