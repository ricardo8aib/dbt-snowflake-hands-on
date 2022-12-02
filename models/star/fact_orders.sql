{{ config(materialized='table', sort='purchase_timestamp_id', dist='purchase_timestamp_id') }}

with dates as (
	select purchase_timestamp as date from {{ ref('stg_orders') }}
	union select approved_at from {{ ref('stg_orders') }}
	union select delivered_carrier_date from {{ ref('stg_orders') }}
	union select delivered_customer_date from {{ ref('stg_orders') }}
	union select estimated_delivery_date from {{ ref('stg_orders') }}),
dim_date as (
	select 
		ROW_NUMBER() OVER(ORDER BY date ASC) AS date_id,
		date,
		to_char(date, 'DD') as day,
		to_char(date, 'MM') as month,
		to_char(date, 'YYYY') as year,
		to_char(date, 'DAY') as day_name,
		to_char(date, 'MONTH') as month_name,
		to_char(date, 'DDD') as day_of_year,
		to_char(date, 'D') as day_of_week,
		to_char(date, 'q') as quarter
	from dates 
	order by date asc),
payments as (select 
	ROW_NUMBER() OVER(ORDER BY o_payments.order_id, o_payments.sequential ASC) AS payment_id,
	o_payments.order_id,
	o_payments.sequential,
	o_payments.type,
	o_payments.payment_installments,
	o_payments.value
from {{ ref('stg_order_payments') }} as o_payments)
select 
	distinct orders.order_id,
	orders.status,
	customers.customer_id,
	p_timestamp.date_id as purchase_timestamp_id,
	approved.date_id as approved_at_id,
	delivered_ca.date_id as delivered_carrier_date_id,
	delivered_cu.date_id as delivered_customer_date_id,
	estimated.date_id as estimated_delivery_date_id,
	(select sum(p.value) from payments as p where orders.order_id = p.order_id) as amount_paid
from {{ ref('stg_orders') }} as orders
left join {{ ref('stg_customers') }} as customers on orders.customer_id = customers.customer_id
left join (select date_id, date from dim_date) as p_timestamp on orders.purchase_timestamp = p_timestamp.date
left join (select date_id, date from dim_date) as approved on orders.approved_at = approved.date
left join (select date_id, date from dim_date) as delivered_ca on orders.delivered_carrier_date = delivered_ca.date
left join (select date_id, date from dim_date) as delivered_cu on orders.delivered_customer_date = delivered_cu.date
left join (select date_id, date from dim_date) as estimated on orders.estimated_delivery_date = estimated.date