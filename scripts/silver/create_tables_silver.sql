/*=========================================================
  SILVER LAYER - DATA WAREHOUSE SCHEMA
  =========================================================
  Description:
  This script creates the Silver layer tables of the data
  warehouse. The Silver layer stores cleansed, standardized,
  and integrated data from CRM and ERP source systems before
  it is transformed into business-ready Gold layer models.
=========================================================*/

-- ==========================================
-- Create Silver Database
-- ==========================================
-- Create the Silver database if it does not already exist.
-- UTF-8 encoding is used to support international characters.

CREATE DATABASE IF NOT EXISTS Silver
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci;

USE Silver;

-- ==========================================
-- CRM TABLES
-- ==========================================
------------------------------------------------------------
-- Customer Information
------------------------------------------------------------
-- Stores customer master data after cleansing and
-- standardization.

DROP TABLE IF EXISTS silver.crm_cust_info;

CREATE TABLE silver.crm_cust_info (
    cst_id INT,                         -- Unique customer identifier
    cst_key VARCHAR(50),                -- Business/customer key
    cst_firstname VARCHAR(50),          -- Customer first name
    cst_lastname VARCHAR(50),           -- Customer last name
    cst_material_status VARCHAR(50),    -- Customer marital status
    cst_gndr VARCHAR(50),               -- Customer gender
    cst_create_date DATE,               -- Date customer record was created in source
    dwh_create_date DATETIME DEFAULT CURRENT_TIMESTAMP -- Record load timestamp
);

------------------------------------------------------------
-- Product Information
------------------------------------------------------------
-- Stores product master data used by sales transactions.

DROP TABLE IF EXISTS silver.crm_prd_info;

CREATE TABLE silver.crm_prd_info (
    prd_id INT,                         -- Product identifier
    prd_key VARCHAR(50),                -- Business/product key
    prd_nm VARCHAR(50),                 -- Product name
    prd_cost INT,                       -- Product cost
    prd_line VARCHAR(50),               -- Product line/category
    prd_start_dt DATETIME,              -- Product validity start date
    prd_end_dt DATETIME,                -- Product validity end date
    dwh_create_date DATETIME DEFAULT CURRENT_TIMESTAMP -- Record load timestamp
);

------------------------------------------------------------
-- Sales Details
------------------------------------------------------------
-- Stores transactional sales data imported from CRM.

DROP TABLE IF EXISTS silver.crm_sales_details;

CREATE TABLE silver.crm_sales_details (
    sls_ord_num VARCHAR(50),            -- Sales order number
    sls_prd_key VARCHAR(50),            -- Product key
    sls_cust_id INT,                    -- Customer identifier
    sls_order_dt INT,                   -- Order date (YYYYMMDD)
    sls_ship_dt INT,                    -- Shipping date (YYYYMMDD)
    sls_due_dt INT,                     -- Due date (YYYYMMDD)
    sls_sales INT,                      -- Total sales amount
    sls_quantity INT,                   -- Quantity sold
    sls_price INT,                      -- Unit selling price
    dwh_create_date DATETIME DEFAULT CURRENT_TIMESTAMP -- Record load timestamp
);

-- ==========================================
-- ERP TABLES
-- ==========================================
-- These tables contain standardized data extracted from
-- the Enterprise Resource Planning (ERP) system.

------------------------------------------------------------
-- Customer Demographics
------------------------------------------------------------
-- Contains additional customer information maintained
-- in the ERP system.

DROP TABLE IF EXISTS silver.erp_cust_az12;

CREATE TABLE silver.erp_cust_az12 (
    cid VARCHAR(50),                    -- Customer identifier
    bdate DATE,                         -- Birth date
    gen VARCHAR(50),                    -- Gender
    dwh_create_date DATETIME DEFAULT CURRENT_TIMESTAMP -- Record load timestamp
);

------------------------------------------------------------
-- Customer Location
------------------------------------------------------------
-- Stores customer geographic information.

DROP TABLE IF EXISTS silver.erp_loc_a101;

CREATE TABLE silver.erp_loc_a101 (
    cid VARCHAR(50),                    -- Customer identifier
    cntry VARCHAR(50),                  -- Country
    dwh_create_date DATETIME DEFAULT CURRENT_TIMESTAMP -- Record load timestamp
);

------------------------------------------------------------
-- Product Category
------------------------------------------------------------
-- Stores product category hierarchy and maintenance data.

DROP TABLE IF EXISTS silver.erp_px_cat_g1v2;

CREATE TABLE silver.erp_px_cat_g1v2 (
    id VARCHAR(50),                     -- Product/category identifier
    cat VARCHAR(50),                    -- Product category
    subcat VARCHAR(50),                 -- Product subcategory
    maintenance VARCHAR(50),            -- Maintenance classification
    dwh_create_date DATETIME DEFAULT CURRENT_TIMESTAMP -- Record load timestamp
);

