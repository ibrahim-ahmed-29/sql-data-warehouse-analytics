/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To rank items (products, customers, etc.) based on performance or
      other metrics.
    - To identify top and bottom performers.

Tables Used:
    - gold.fact_sales
    - gold.dim_product
    - gold.dim_customers

SQL Functions Used:
    - Window Ranking Functions: RANK()
    - Clauses: GROUP BY, ORDER BY, LIMIT
===============================================================================
*/

-- Which 5 products are generating the highest revenue?
SELECT
p.product_name as product_name,
sum(s.sales_amount) as total_sales
FROM gold.fact_sales as s
LEFT JOIN gold.dim_product as p
ON s.product_key = p.product_key
GROUP BY p.product_name
ORDER BY sum(s.sales_amount) desc
limit 5 ;

-- OR using rank (handles ties, and is easier to filter by rank threshold)
SELECT
*
from(
	SELECT
	p.product_name,
	sum(s.sales_amount) as total_sales,
	RANK() over(ORDER BY sum(s.sales_amount) desc) as `rank_products`
	FROM gold.fact_sales as s
	LEFT JOIN gold.dim_product as p
	ON s.product_key = p.product_key
	GROUP BY p.product_name ) t
WHERE `rank_products` <= 5;


-- What are the 5 worst-performing products in terms of sales?
SELECT
p.product_name as product_name,
sum(s.sales_amount) as total_sales
FROM gold.fact_sales as s
LEFT JOIN gold.dim_product as p
ON s.product_key = p.product_key
GROUP BY p.product_name
ORDER BY sum(s.sales_amount)
limit 5 ;

-- or using rank
SELECT
*
from(
	SELECT
	p.product_name,
	sum(s.sales_amount) as total_sales,
	RANK() over(ORDER BY sum(s.sales_amount)) as `rank_products`
	FROM gold.fact_sales as s
	LEFT JOIN gold.dim_product as p
	ON s.product_key = p.product_key
	GROUP BY p.product_name ) t
WHERE `rank_products` <= 5;


-- Find the top 10 customers who have generated the highest revenue
SELECT
c.customer_key,
c.first_name,
c.last_name,
sum(s.sales_amount) as total_sales
FROM gold.fact_sales as s
LEFT JOIN gold.dim_customers as c
ON s.customer_key = c.customer_key
GROUP BY 
c.customer_key,
c.first_name,
c.last_name
ORDER BY total_sales desc
limit 10;


-- The 3 customers with the fewest orders placed
SELECT
c.customer_key,
c.first_name,
c.last_name,
count(DISTINCT s.order_number) as total_orders
FROM gold.fact_sales as s
LEFT JOIN gold.dim_customers as c
ON s.customer_key = c.customer_key
GROUP BY 
c.customer_key,
c.first_name,
c.last_name
ORDER BY total_orders
limit 3;
