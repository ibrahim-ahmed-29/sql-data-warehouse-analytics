/*
===============================================================================
Measures Exploration (Key Business Metrics)
===============================================================================
Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick
      insights.
    - To identify overall trends and generate a business overview report.

Tables Used:
    - gold.fact_sales
    - gold.dim_product
    - gold.dim_customers
===============================================================================
*/

-- Find the Total Sales
SELECT
sum(sales_amount) as total_sales
from gold.fact_sales;

-- Find how many items are sold
SELECT 
sum(quantity) as total_sold_item
FROM gold.fact_sales;

-- Find the average selling price
SELECT
avg(price)
FROM gold.fact_sales;

-- Find the Total number of Orders
SELECT 
count(DISTINCT order_number)
FROM gold.fact_sales;

-- Find the total number of products
SELECT
count(product_name) as total_products_number
FROM gold.dim_product;


-- Find the total number of customers
SELECT 
    COUNT(customer_key) AS total_customers_number
FROM
    gold.dim_customers;


-- Generate a report that shows all key metrics of the business
SELECT 'Total Sales' as measure_name, sum(sales_amount) as measure_value
from gold.fact_sales
union all
SELECT 'Total sold Item', sum(quantity)
FROM gold.fact_sales
union all
SELECT 'Average Price', avg(price)
FROM gold.fact_sales
Union all
SELECT 'Order numbers', count(DISTINCT order_number)
FROM gold.fact_sales
union all
SELECT 'Total Products Number', count(product_name)
FROM gold.dim_product
union all
-- Find the total number of customers
SELECT 'Total Customers Number', count(customer_key)
from gold.dim_customers;
