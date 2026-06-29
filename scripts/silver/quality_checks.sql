# =====================================================
# SILVER LAYER POST-LOAD DATA QUALITY CHECKS
# =====================================================
# Purpose:
# This script validates data after loading into the Silver layer.
# It ensures data quality, consistency, and correctness of transformations.
# =====================================================


# =====================================================
# 1. CUSTOMER TABLE CHECKS
# =====================================================

-- Check duplicates (should be 0)
SELECT
    cst_id,
    COUNT(*) AS cnt
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1;

-- Check invalid or missing IDs
SELECT *
FROM silver.crm_cust_info
WHERE cst_id IS NULL OR cst_id = 0;

-- Check standardized marital status values
SELECT DISTINCT cst_marital_status
FROM silver.crm_cust_info;

-- Check standardized gender values
SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info;



# =====================================================
# 2. PRODUCT TABLE CHECKS
# =====================================================

-- Check missing start dates
SELECT *
FROM silver.crm_prd_info
WHERE prd_start_dt IS NULL;

-- Check invalid costs
SELECT *
FROM silver.crm_prd_info
WHERE prd_cost < 0;

-- Check product line standardization
SELECT DISTINCT prd_line
FROM silver.crm_prd_info;

-- Check date consistency (end date should not be before start date)
SELECT *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;



# =====================================================
# 3. SALES TABLE CHECKS
# =====================================================

-- Check invalid quantities
SELECT *
FROM silver.crm_sales_details
WHERE sls_quantity <= 0;

-- Check sales consistency (Sales = Price × Quantity)
SELECT *
FROM silver.crm_sales_details
WHERE sls_sales <> sls_price * sls_quantity;

-- Check missing dates
SELECT *
FROM silver.crm_sales_details
WHERE sls_order_dt IS NULL
   OR sls_ship_dt IS NULL
   OR sls_due_dt IS NULL;

-- Check invalid prices
SELECT *
FROM silver.crm_sales_details
WHERE sls_price <= 0;



# =====================================================
# 4. ERP CUSTOMER TABLE CHECKS
# =====================================================

-- Check future birth dates (should not exist)
SELECT *
FROM silver.erp_cust_az12
WHERE bdate > NOW();

-- Check gender values
SELECT DISTINCT gen
FROM silver.erp_cust_az12;



# =====================================================
# 5. ERP LOCATION TABLE CHECKS
# =====================================================

-- Check country standardization
SELECT DISTINCT cntry
FROM silver.erp_loc_a101;

-- Check missing or invalid customer IDs
SELECT *
FROM silver.erp_loc_a101
WHERE cid IS NULL OR cid = '';



# =====================================================
# 6. PRODUCT CATEGORY TABLE CHECKS
# =====================================================

-- Check total rows loaded
SELECT COUNT(*) AS total_rows
FROM silver.erp_px_cat_g1v2;

-- Check NULL values in key fields
SELECT *
FROM silver.erp_px_cat_g1v2
WHERE id IS NULL
   OR cat IS NULL
   OR subcat IS NULL;

-- Check duplicate IDs (should not exist)
SELECT
    id,
    COUNT(*) AS cnt
FROM silver.erp_px_cat_g1v2
GROUP BY id
HAVING COUNT(*) > 1;

-- Check distinct categories
SELECT DISTINCT cat
FROM silver.erp_px_cat_g1v2;

-- Check maintenance values
SELECT DISTINCT maintenance
FROM silver.erp_px_cat_g1v2;



# =====================================================
# 7. OVERALL ROW COUNT VALIDATION
# =====================================================

SELECT 'crm_cust_info' AS table_name, COUNT(*) FROM silver.crm_cust_info
UNION ALL
SELECT 'crm_prd_info', COUNT(*) FROM silver.crm_prd_info
UNION ALL
SELECT 'crm_sales_details', COUNT(*) FROM silver.crm_sales_details
UNION ALL
SELECT 'erp_cust_az12', COUNT(*) FROM silver.erp_cust_az12
UNION ALL
SELECT 'erp_loc_a101', COUNT(*) FROM silver.erp_loc_a101
UNION ALL
SELECT 'erp_px_cat_g1v2', COUNT(*) FROM silver.erp_px_cat_g1v2;
