{{ config(materialized='table', dist='even') }}

SELECT 
	ROW_NUMBER() OVER(ORDER BY payments.order_id, payments.sequential ASC) AS payment_id,
	payments.order_id,
	payments.sequential,
	payments.type,
	payments.payment_installments,
	payments.value
FROM {{ ref('stg_order_payments') }} AS payments