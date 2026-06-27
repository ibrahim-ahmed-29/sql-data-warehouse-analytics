```sql
/*
=========================================================
 Data Warehouse Project
 Bronze Layer - Data Loading Script
 Database: MySQL
=========================================================

Description:
This script truncates the Bronze tables and reloads
raw data from CSV files using LOAD DATA INFILE.

Note:
Update the file paths below to match your MySQL
Uploads directory.
=========================================================
*/

-- ==========================================
-- Load CRM Customer Information
-- ==========================================

TRUNCATE TABLE bronze.crm_cust_info;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/cust_info.csv'
IGNORE
INTO TABLE bronze.crm_cust_info
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- ==========================================
-- Load CRM Product Information
-- ==========================================

TRUNCATE TABLE bronze.crm_prd_info;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/prd_info.csv'
IGNORE
INTO TABLE bronze.crm_prd_info
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- ==========================================
-- Load CRM Sales Details
-- ==========================================

TRUNCATE TABLE bronze.crm_sales_details;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/sales_details.csv'
IGNORE
INTO TABLE bronze.crm_sales_details
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- ==========================================
-- Load ERP Customer Information
-- ==========================================

TRUNCATE TABLE bronze.erp_cust_az12;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/CUST_AZ12.csv'
IGNORE
INTO TABLE bronze.erp_cust_az12
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- ==========================================
-- Load ERP Location Information
-- ==========================================

TRUNCATE TABLE bronze.erp_loc_a101;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/LOC_A101.csv'
IGNORE
INTO TABLE bronze.erp_loc_a101
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;

-- ==========================================
-- Load ERP Product Categories
-- ==========================================

TRUNCATE TABLE bronze.erp_px_cat_g1v2;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/PX_CAT_G1V2.csv'
IGNORE
INTO TABLE bronze.erp_px_cat_g1v2
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS;
```
