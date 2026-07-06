/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    - To track trends, growth, and changes in key metrics over time.
    - For time-series analysis and identifying seasonality patterns.

SQL Functions Used:
    - Date Functions: MONTH(), YEAR(), DATE_FORMAT()
    - Aggregate Functions: SUM(), COUNT()
===============================================================================
*/

-- Analyse sales performance over time
-- Quick date functions approach
SELECT
month(order_date) as order_month,
year(order_date) as order_year, 
sum(sales_amount) as total_sales,
count(DISTINCT customer_key) as total_customer,
sum(quantity) as total_items,
count(DISTINCT order_number) as total_orders
FROM gold.fact_sales 
where order_date is NOT null
GROUP BY month(order_date), year(order_date)
ORDER BY year(order_date), month(order_date);

-- Using DATE_FORMAT() to get a single sortable "YYYY-MM" column
SELECT
DATE_FORMAT(order_date,'%Y-%m') as order_date,
sum(sales_amount) as total_sales,
count(DISTINCT customer_key) as total_customer,
sum(quantity) as total_items,
count(DISTINCT order_number) as total_orders
FROM gold.fact_sales 
where order_date is NOT null
GROUP BY DATE_FORMAT(order_date,'%Y-%m')
ORDER BY DATE_FORMAT(order_date,'%Y-%m');
