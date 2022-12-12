{{ config(materialized='table', dist='even') }}

SELECT 
	ROW_NUMBER() OVER(ORDER BY payments.order_id, payments.payment_sequential ASC) AS payment_id,
	payments.order_id,
	payments.payment_sequential,
	payments.payment_type,
	payments.payment_installments,
	payments.payment_value
FROM {{ ref('stg_order_payments') }} AS payments