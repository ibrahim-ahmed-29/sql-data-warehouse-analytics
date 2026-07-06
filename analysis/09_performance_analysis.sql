/*
===============================================================================
Performance Analysis (Year-over-Year, Vs Average)
===============================================================================
Purpose:
    - To measure the performance of products, customers, or regions over time.
    - For benchmarking and identifying high-performing entities.
    - To track yearly trends and growth.

SQL Functions Used:
    - LAG(): Accesses data from previous rows (previous year comparison).
    - AVG() OVER(): Computes average values within a partition.
    - CASE: Defines conditional logic for trend analysis.
===============================================================================
*/

-- Analyze the yearly performance of products by comparing their sales
-- to both the average sales performance of the product and the previous year's sales
with yearly_product_sales as (
SELECT
year(s.order_date) as order_year,
p.product_name as product_name,
sum(s.sales_amount) as current_sales
from gold.fact_sales as s
LEFT JOIN gold.dim_product as p
ON s.product_key = p.product_key
where order_date is not null
GROUP BY p.product_name, year(s.order_date)
)
SELECT
product_name,
order_year,
current_sales,

-- Compare current year sales to the product's average sales across all years
avg(current_sales) over(PARTITION BY product_name) as avg_sales,
current_sales - avg(current_sales) over(PARTITION BY product_name) as avg_diff,
case
when current_sales - avg(current_sales) over(PARTITION BY product_name) > 0 then 'above_avg'
when current_sales - avg(current_sales) over(PARTITION BY product_name) < 0 then 'below_avg'
else 'avg'
END as avg_change ,

-- Compare current year sales to the previous year's sales (Year-over-Year)
lag(current_sales) over(PARTITION BY product_name ORDER BY order_year) as previous_sales,
current_sales - lag(current_sales) over(PARTITION BY product_name ORDER BY order_year) as sales_diff,
CASE 
WHEN current_sales - lag(current_sales) over(PARTITION BY product_name ORDER BY order_year) > 0 then 'increase'
WHEN current_sales - lag(current_sales) over(PARTITION BY product_name ORDER BY order_year) < 0 then 'decrease'
else 'No change'
END as sales_change
FROM yearly_product_sales
