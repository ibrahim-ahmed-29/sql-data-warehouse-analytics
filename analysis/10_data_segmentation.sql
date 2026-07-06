/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - To group data into meaningful categories for targeted insights.
    - For customer segmentation, product categorization, or regional analysis.

SQL Functions Used:
    - CASE: Defines custom segmentation logic.
    - GROUP BY: Groups data into segments.
===============================================================================
*/

/*Segment products into cost ranges and
count how many products fall into each segment*/
WITH product_cost_segment AS (
	SELECT
		product_key,
		product_name,
		cost,
		CASE WHEN cost < 100 THEN 'Below 100'
			WHEN cost BETWEEN 100 and 500  THEN '100-500'
			WHEN cost BETWEEN 500 and 1000 THEN '500-1000'
			ELSE 'above 1000'
		END as cost_range
	from gold.dim_product
)
SELECT
cost_range,
count(cost_range) as total_product
from product_cost_segment
GROUP BY cost_range
ORDER BY total_product DESC;

/*Group customers into three segments based on their spending behavior:
	- VIP: Customers with at least 12 months of history and spending more than €5,000.
	- Regular: Customers with at least 12 months of history but spending €5,000 or less.
	- New: Customers with a lifespan less than 12 months.
And find the total number of customers by each group
*/
with customer_spending as(
SELECT
customer_key,
min(order_date) as first_order_date,
max(order_date) as last_order_date,
timestampdiff(month, min(order_date) ,max(order_date)) as total_months,
sum(sales_amount)  as total_sales
from gold.fact_sales
WHERE order_date is not null
GROUP BY customer_key
)
, customer_segmentation as (
SELECT
*,
CASE WHEN total_months >= 12 and total_sales > 5000 then 'vip'
	WHEN total_months >= 12  then 'Regular'
    ELSE 'new'
END as customer_segment
FROM customer_spending )

SELECT 
customer_segment,
count(*)
from customer_segmentation
GROUP BY customer_segment;
