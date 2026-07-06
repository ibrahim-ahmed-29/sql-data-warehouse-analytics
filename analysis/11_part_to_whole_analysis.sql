/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - To compare performance or metrics across dimensions or time periods.
    - To evaluate differences between categories.
    - Useful for A/B testing or regional comparisons.

SQL Functions Used:
    - SUM(), AVG(): Aggregates values for comparison.
    - Window Functions: SUM() OVER() for total calculations.
===============================================================================
*/

-- Which categories contribute the most to overall sales?
WITH category_sales AS (
 SELECT
p.category,
sum(sales_amount) as total_sales
from gold.fact_sales as s
LEFT JOIN gold.dim_product as p
ON s.product_key = p.product_key
GROUP BY p.category
)

SELECT
category,
total_sales,
sum(total_sales) over() as overall_sales,
round(total_sales / sum(total_sales) over() * 100, 2) as percentage_of_total
from category_sales
ORDER BY percentage_of_total DESC
