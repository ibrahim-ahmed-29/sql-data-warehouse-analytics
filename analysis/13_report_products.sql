/*
===============================================================================
Product Report
===============================================================================
Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total customers (unique)
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (months since last sale)
       - average order revenue (AOR)
       - average monthly revenue
===============================================================================
*/

/*---------------------------------------------------------------------------
1) Base Query: Retrieves core columns from fact_sales and dim_product
---------------------------------------------------------------------------*/
with base_query as(
SELECT
	s.order_number,
	s.order_date,
	s.customer_key,
	s.product_key,
	p.product_name,
	p.category,
	p.subcategory,
	p.cost,
	s.sales_amount,
	s.quantity
from gold.fact_sales as s
LEFT JOIN gold.dim_product as p
ON s.product_key = p.product_key
WHERE s.order_date IS NOT NULL  -- only consider valid sales dates
),

/*---------------------------------------------------------------------------
2) Product Aggregations: Summarizes key metrics at the product level
---------------------------------------------------------------------------*/
product_aggregations as (
SELECT
    product_key,
    product_name,
    category,
    subcategory,
    cost,
	count(DISTINCT order_number) as total_orders,
	count(DISTINCT customer_key)as total_customers,
	sum(sales_amount)as total_sales,
	sum(quantity)as total_quantity,
	max(order_date) as last_sale_date,
	timestampdiff(MONTH, min(order_date), max(order_date)) as lifespan,
    round(avg(sales_amount / nullif(quantity,0) ), 2) as avg_selling_price  -- avoid divide-by-zero
from base_query
GROUP BY product_key,
		product_name,
		category,
		subcategory,
		cost
)

/*---------------------------------------------------------------------------
3) Final Query: Combines all product results into one output
---------------------------------------------------------------------------*/
SELECT
    product_key,
    product_name,
    category,
    subcategory,
    cost,

    last_sale_date,
	timestampdiff(month, last_sale_date, CURDATE()) as recency_in_months,  -- how long since last sale

	-- Segment products by total sales performance
	CASE WHEN total_sales > 50000 THEN 'High-Performance'
		WHEN total_sales >= 10000 THEN 'Mid-Range'
		ELSE 'Low-Performance'
	END As product_segment,

	lifespan,
    total_orders,
    total_sales,
    total_quantity,
    total_customers,
    avg_selling_price,

	-- Average Order Revenue (AOR)
    CASE
        WHEN total_orders = 0 THEN 0
        ELSE total_sales / total_orders
    END AS avg_order_revenue,

	-- Average Monthly Revenue
	CASE
        WHEN lifespan = 0 THEN total_sales
        ELSE total_sales / lifespan
    END AS avg_monthly_revenue	
from product_aggregations
