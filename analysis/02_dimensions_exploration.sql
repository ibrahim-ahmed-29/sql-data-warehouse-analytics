/*
===============================================================================
Dimensions Exploration
===============================================================================
Purpose:
    - To explore the structure of dimension tables.
    - To identify the distinct/unique values that exist across key
      categorical columns (geography, product hierarchy, etc).

Tables Used:
    - gold.dim_customers
    - gold.dim_product
===============================================================================
*/

-- Retrieve a list of unique countries from which customers originate
SELECT DISTINCT
country
From gold.dim_customers;


-- Retrieve a list of unique categories, subcategories, and products
-- (useful for understanding the product hierarchy)
SELECT DISTINCT
category,
subcategory,
product_name
FROM gold.dim_product
ORDER BY category, subcategory;
