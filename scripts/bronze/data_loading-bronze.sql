/*
=========================================================
 Data Warehouse Project
 Bronze Layer - Data Loading Script
 Database    : MySQL
 Layer       : Bronze
=========================================================

Description:
This script truncates the Bronze layer tables and reloads
raw data from CSV files using MySQL's LOAD DATA INFILE.

Execution Flow:
1. Truncate existing data.
2. Load data from CSV files.
3. Display number of rows loaded.
4. Display execution time for each table.
=========================================================
*/

-- =====================================================
-- Load CRM Customer Information
-- =====================================================

SELECT 'Loading bronze.crm_cust_info...' AS Status;

SET @start_time = NOW();

TRUNCATE TABLE bronze.crm_cust_info;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/cust_info.csv'
IGNORE
INTO TABLE bronze.crm_cust_info
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

SET @end_time = NOW();

SELECT
    'bronze.crm_cust_info' AS Table_Name,
    COUNT(*) AS Rows_Loaded,
    TIMESTAMPDIFF(MICROSECOND, @start_time, @end_time) / 1000000 AS Duration_Seconds
FROM bronze.crm_cust_info;

-- =====================================================
-- Load CRM Product Information
-- =====================================================

SELECT 'Loading bronze.crm_prd_info...' AS Status;

SET @start_time = NOW();

TRUNCATE TABLE bronze.crm_prd_info;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/prd_info.csv'
IGNORE
INTO TABLE bronze.crm_prd_info
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

SET @end_time = NOW();

SELECT
    'bronze.crm_prd_info' AS Table_Name,
    COUNT(*) AS Rows_Loaded,
    TIMESTAMPDIFF(MICROSECOND, @start_time, @end_time) / 1000000 AS Duration_Seconds
FROM bronze.crm_prd_info;

-- =====================================================
-- Load CRM Sales Details
-- =====================================================

SELECT 'Loading bronze.crm_sales_details...' AS Status;

SET @start_time = NOW();

TRUNCATE TABLE bronze.crm_sales_details;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/sales_details.csv'
IGNORE
INTO TABLE bronze.crm_sales_details
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

SET @end_time = NOW();

SELECT
    'bronze.crm_sales_details' AS Table_Name,
    COUNT(*) AS Rows_Loaded,
    TIMESTAMPDIFF(MICROSECOND, @start_time, @end_time) / 1000000 AS Duration_Seconds
FROM bronze.crm_sales_details;

-- =====================================================
-- Load ERP Customer Information
-- =====================================================

SELECT 'Loading bronze.erp_cust_az12...' AS Status;

SET @start_time = NOW();

TRUNCATE TABLE bronze.erp_cust_az12;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/CUST_AZ12.csv'
IGNORE
INTO TABLE bronze.erp_cust_az12
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

SET @end_time = NOW();

SELECT
    'bronze.erp_cust_az12' AS Table_Name,
    COUNT(*) AS Rows_Loaded,
    TIMESTAMPDIFF(MICROSECOND, @start_time, @end_time) / 1000000 AS Duration_Seconds
FROM bronze.erp_cust_az12;

-- =====================================================
-- Load ERP Location Information
-- =====================================================

SELECT 'Loading bronze.erp_loc_a101...' AS Status;

SET @start_time = NOW();

TRUNCATE TABLE bronze.erp_loc_a101;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/LOC_A101.csv'
IGNORE
INTO TABLE bronze.erp_loc_a101
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

SET @end_time = NOW();

SELECT
    'bronze.erp_loc_a101' AS Table_Name,
    COUNT(*) AS Rows_Loaded,
    TIMESTAMPDIFF(MICROSECOND, @start_time, @end_time) / 1000000 AS Duration_Seconds
FROM bronze.erp_loc_a101;

-- =====================================================
-- Load ERP Product Categories
-- =====================================================

SELECT 'Loading bronze.erp_px_cat_g1v2...' AS Status;

SET @start_time = NOW();

TRUNCATE TABLE bronze.erp_px_cat_g1v2;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/PX_CAT_G1V2.csv'
IGNORE
INTO TABLE bronze.erp_px_cat_g1v2
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

SET @end_time = NOW();

SELECT
    'bronze.erp_px_cat_g1v2' AS Table_Name,
    COUNT(*) AS Rows_Loaded,
    TIMESTAMPDIFF(MICROSECOND, @start_time, @end_time) / 1000000 AS Duration_Seconds
FROM bronze.erp_px_cat_g1v2;

-- =====================================================
-- End of Script
-- =====================================================

SELECT 'Bronze Layer Data Load Completed Successfully.' AS Status;

