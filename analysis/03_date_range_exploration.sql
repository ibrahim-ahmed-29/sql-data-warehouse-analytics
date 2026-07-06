/*
===============================================================================
Date Range Exploration
===============================================================================
Purpose:
    - To determine the temporal boundaries of key data points.
    - To understand the range of historical data and the age range of
      customers.

Tables Used:
    - gold.fact_sales
    - gold.dim_customers
===============================================================================
*/

-- Determine the first and last order date, and the total duration in months
SELECT
min(order_date) as `first_order_date`,
max(order_date) as `last_order_date`,
timestampdiff(month,min(order_date),max(order_date)) as `orders_range_months`
FROM
gold.fact_sales;


-- Find the youngest and oldest customer based on birthdate
SELECT
max(birthdate) as `youngest_customer_birthdate`,
timestampdiff(year,max(birthdate),now()) as `youngest_customer_age`,
min(birthdate) as `older_customer_birthdate`,
timestampdiff(year,min(birthdate),now()) as `oldest_customer_age`
from gold.dim_customers;
