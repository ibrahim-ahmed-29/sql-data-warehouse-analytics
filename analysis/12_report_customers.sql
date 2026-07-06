/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - This report consolidates key customer metrics and behaviors.

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
    2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
       - total orders
       - total sales
       - total quantity purchased
       - total products
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (months since last order)
       - average order value (AOV)
       - average monthly spend
===============================================================================
*/

/*---------------------------------------------------------------------------
1) Base Query: Retrieves core columns from tables
---------------------------------------------------------------------------*/
with base_query as (
select
	s.order_number as order_number,
	s.product_key as product_key,
	s.order_date as order_date,
	s.sales_amount as sales_amount,
	s.quantity as quantity,
	s.customer_key as customer_key,
	c.customer_number as customer_number,
	concat(c.first_name,' ', c.last_name) as customer_name,
	timestampdiff(YEAR	, c.birthdate, CURDATE()) as age
from gold.fact_sales as s
LEFT JOIN gold.dim_customers as c
on s.customer_key = c.customer_key
),
/*---------------------------------------------------------------------------
2) Customer Aggregations: Summarizes key metrics at the customer level
---------------------------------------------------------------------------*/
customer_aggregation as(
SELECT
	customer_key,
    customer_number,
    customer_name,
    age,
	count(DISTINCT order_number) as total_orders,
	sum(sales_amount) as total_sales,
    sum(quantity) as total_quantity,
    count(DISTINCT product_key) as total_products,
    min(order_date) as first_order_date,
    max(order_date) as last_order_date,
    timestampdiff(month, min(order_date), max(order_date)) as lifespan
FROM base_query
GROUP BY customer_key,
		customer_number,
		customer_name,
		age

)

/*---------------------------------------------------------------------------
3) Final Query: Combines all customer results into one output, with
   segmentation and derived KPIs
---------------------------------------------------------------------------*/
SELECT
	customer_key,
	customer_number,
	customer_name,
	age,
	CASE WHEN age < 20 then 'Under 20'
		WHEN age BETWEEN 20 and 29 then '20-29'
		WHEN age BETWEEN 30 and 39 THEN '30-39'
		WHEN age BETWEEN 40 and 49 THEN '40-49'
		ELSE '50+'
	END as age_group,

	-- Customer value segmentation
	CASE WHEN lifespan >= 12 and total_sales > 5000 THEN 'VIP'
		WHEN lifespan >= 12 THEN 'Regular'
		ELSE 'NEW'
	END as customer_segment,

	last_order_date,
	timestampdiff(MONTH,last_order_date,CURDATE()) as recency,  -- months since last order
	total_orders,
	total_sales,
	total_quantity,
	total_products,	
	lifespan,

	-- Average Order Value (AOV)
	CASE WHEN total_orders = 0 then 0
		ELSE total_sales / total_orders
	END as avg_order_value,

	-- Average Monthly Spend
	CASE WHEN lifespan = 0 THEN total_sales
		 ELSE total_sales / lifespan
	END AS avg_monthly_spend
FROM customer_aggregation
