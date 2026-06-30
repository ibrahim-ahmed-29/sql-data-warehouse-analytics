/*
===============================================================================
Gold Layer - Data Warehouse Views
===============================================================================

Purpose:
    This script creates the Gold layer dimensional model used for analytics
    and reporting.

Objects:
    1. gold.dim_customers
    2. gold.dim_product
    3. gold.fact_sales

Design:
    - Star Schema
    - Dimension tables contain descriptive business attributes.
    - Fact table stores sales transactions and references dimensions.

Source Layer:
    Silver

Author: <Your Name>
Created: <Date>
===============================================================================
*/


/*=============================================================================
  Create Customer Dimension
===============================================================================
Description:
    Creates the customer dimension by combining CRM customer information
    with ERP demographic and location data.

Business Rules:
    - Generates a surrogate key using ROW_NUMBER().
    - Uses CRM gender when available.
    - Falls back to ERP gender if CRM value is 'n/a'.
    - Includes customer demographic information.
=============================================================================*/

CREATE VIEW gold.dim_customers AS

SELECT
    ROW_NUMBER() OVER (ORDER BY ci.cst_id) AS customer_key,

    ci.cst_id              AS customer_id,
    ci.cst_key             AS customer_number,
    ci.cst_firstname       AS first_name,
    ci.cst_lastname        AS last_name,

    cl.cntry               AS country,

    ci.cst_marital_status  AS marital_status,

    CASE
        WHEN ci.cst_gndr <> 'n/a'
            THEN ci.cst_gndr
        ELSE COALESCE(ca.gen, 'n/a')
    END AS gender,

    ca.bdate               AS birthdate,

    ci.cst_create_date     AS create_date

FROM silver.crm_cust_info AS ci

LEFT JOIN silver.erp_cust_az12 AS ca
       ON ca.cid = ci.cst_key

LEFT JOIN silver.erp_loc_a101 AS cl
       ON cl.cid = ci.cst_key;



/*=============================================================================
  Create Product Dimension
===============================================================================
Description:
    Creates the product dimension by combining CRM product information
    with ERP category data.

Business Rules:
    - Generates a surrogate key.
    - Returns only active products.
    - Active products have NULL end date.
=============================================================================*/

CREATE VIEW gold.dim_products AS

SELECT

    ROW_NUMBER() OVER (
        ORDER BY pn.prd_start_dt, pn.prd_key
    ) AS product_key,

    pn.prd_id         AS product_id,
    pn.prd_key        AS product_number,
    pn.prd_nm         AS product_name,

    pn.cat_id         AS category_id,
    pc.cat            AS category,
    pc.subcat         AS subcategory,
    pc.maintenance,

    pn.prd_cost       AS cost,
    pn.prd_line       AS product_line,

    pn.prd_start_dt   AS start_date

FROM silver.crm_prd_info AS pn

LEFT JOIN silver.erp_px_cat_g1v2 AS pc
       ON pn.cat_id = pc.id

WHERE pn.prd_end_dt IS NULL;



/*=============================================================================
  Create Sales Fact Table
===============================================================================
Description:
    Creates the central sales fact table.

Business Rules:
    - Links sales transactions to customer and product dimensions.
    - Stores transactional sales measures.
    - Uses surrogate keys from dimension tables.
=============================================================================*/

CREATE VIEW gold.fact_sales AS

SELECT

    sd.sls_ord_num     AS order_number,

    pr.product_key,
    cu.customer_key,

    sd.sls_order_dt    AS order_date,
    sd.sls_ship_dt     AS shipping_date,
    sd.sls_due_dt      AS due_date,

    sd.sls_sales       AS sales_amount,
    sd.sls_quantity    AS quantity,
    sd.sls_price       AS price

FROM silver.crm_sales_details AS sd

LEFT JOIN gold.dim_product AS pr
       ON sd.sls_prd_key = pr.product_number

LEFT JOIN gold.dim_customers AS cu
       ON sd.sls_cust_id = cu.customer_id;
