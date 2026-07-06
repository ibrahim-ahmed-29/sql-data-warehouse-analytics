/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - To calculate running totals or moving averages for key metrics.
    - To track performance over time cumulatively.
    - Useful for growth analysis and identifying long-term trends.

SQL Functions Used:
    - Window Functions: SUM() OVER(), AVG() OVER()
===============================================================================
*/

-- Calculate the total sales per month
-- and the running total of sales over time
SELECT
date_format(order_date,'%Y-%m') as order_date,
sum(sales_amount) as total_sales,
SUM(sum(sales_amount)) over(ORDER BY date_format(order_date,'%Y-%m')) as running_sales
FROM gold.fact_sales
where order_date is not null
GROUP BY date_format(order_date,'%Y-%m') ;


-- Calculate the monthly sales and the year-to-date (YTD) running total of sales
-- (running total resets at the start of each year via PARTITION BY order_year)
with monthly_sales AS (
SELECT
year(order_date) as order_year,
date_format(order_date,'%Y-%m') as order_date,
sum(sales_amount) as total_sales
FROM gold.fact_sales
where order_date is not null
GROUP BY 
year(order_date),
date_format(order_date,'%Y-%m') 
)
SELECT
order_date,
total_sales,
SUM(total_sales) OVER(PARTITION BY order_year ORDER BY order_date) as running_total_sales
from monthly_sales
