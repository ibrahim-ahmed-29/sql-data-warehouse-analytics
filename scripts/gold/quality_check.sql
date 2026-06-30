/*
===============================================================================
Gold Layer - Data Quality Checks
===============================================================================

Purpose:
    Validate the integrity and quality of the Gold layer after loading.

Objects Checked:
    - gold.dim_customers
    - gold.dim_products
    - gold.fact_sales

Validation Categories:
    1. Primary Key Validation
    2. Duplicate Detection
    3. Null Value Checks
    4. Referential Integrity
    5. Business Rule Validation

Expected Result:
    Every query should return:
        - 0 rows
        - OR 0 as the count

Author: <Your Name>
Created: <Date>
===============================================================================
*/


/*=============================================================================
  DIM_CUSTOMERS
=============================================================================*/

-- Check for duplicate customer surrogate keys
SELECT
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;


-- Check for NULL surrogate keys
SELECT *
FROM gold.dim_customers
WHERE customer_key IS NULL;


-- Check for NULL business keys
SELECT *
FROM gold.dim_customers
WHERE customer_id IS NULL;


-- Check for duplicate customer IDs
SELECT
    customer_id,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_id
HAVING COUNT(*) > 1;


-- Check gender values
SELECT DISTINCT gender
FROM gold.dim_customers;


-- Check for future birthdates
SELECT *
FROM gold.dim_customers
WHERE birthdate > CURRENT_DATE;


/*=============================================================================
  DIM_PRODUCTs
=============================================================================*/

-- Check for duplicate product surrogate keys
SELECT
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;


-- Check for NULL surrogate keys
SELECT *
FROM gold.dim_products
WHERE product_key IS NULL;


-- Check for NULL business keys
SELECT *
FROM gold.dim_products
WHERE product_id IS NULL;


-- Check duplicate product IDs
SELECT
    product_id,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_id
HAVING COUNT(*) > 1;


-- Check for negative product cost
SELECT *
FROM gold.dim_products
WHERE cost < 0;


-- Verify only active products exist
SELECT *
FROM gold.dim_products
WHERE start_date IS NULL;


/*=============================================================================
  FACT_SALES
=============================================================================*/

-- Check for NULL customer keys
SELECT *
FROM gold.fact_sales
WHERE customer_key IS NULL;


-- Check for NULL product keys
SELECT *
FROM gold.fact_sales
WHERE product_key IS NULL;


-- Check for NULL order numbers
SELECT *
FROM gold.fact_sales
WHERE order_number IS NULL;


-- Check for negative sales
SELECT *
FROM gold.fact_sales
WHERE sales_amount < 0;


-- Check for negative quantity
SELECT *
FROM gold.fact_sales
WHERE quantity < 0;


-- Check for negative price
SELECT *
FROM gold.fact_sales
WHERE price < 0;


-- Check for invalid order dates
SELECT *
FROM gold.fact_sales
WHERE order_date > CURRENT_DATE;


-- Check shipping date before order date
SELECT *
FROM gold.fact_sales
WHERE shipping_date < order_date;


-- Check due date before order date
SELECT *
FROM gold.fact_sales
WHERE due_date < order_date;


/*=============================================================================
  Referential Integrity Checks
=============================================================================*/

-- Every customer in fact table must exist in customer dimension
SELECT *
FROM gold.fact_sales fs
LEFT JOIN gold.dim_customers dc
       ON fs.customer_key = dc.customer_key
WHERE dc.customer_key IS NULL;


-- Every product in fact table must exist in product dimension
SELECT *
FROM gold.fact_sales fs
LEFT JOIN gold.dim_products dp
       ON fs.product_key = dp.product_key
WHERE dp.product_key IS NULL;


/*=============================================================================
  Business Rule Validation
=============================================================================*/

-- Sales amount should equal Quantity × Price
SELECT *
FROM gold.fact_sales
WHERE sales_amount <> quantity * price;


-- Check for duplicate orders (if order_number should be unique)
SELECT
    order_number,
    COUNT(*) AS duplicate_count
FROM gold.fact_sales
GROUP BY order_number
HAVING COUNT(*) > 1;


/*=============================================================================
  Summary Counts
=============================================================================*/

SELECT 'dim_customers' AS table_name, COUNT(*) AS row_count
FROM gold.dim_customers

UNION ALL

SELECT 'dim_products', COUNT(*)
FROM gold.dim_products

UNION ALL

SELECT 'fact_sales', COUNT(*)
FROM gold.fact_sales;
