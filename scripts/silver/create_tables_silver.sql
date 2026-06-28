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

CREATE TABLE silver.crm_cust_info(
    cst_id INT,
    cst_key VARCHAR(50),
    cst_firstname VARCHAR(50),
    cst_lastname VARCHAR(50),
    cst_marital_status VARCHAR(50),
    cst_gndr VARCHAR(20),
    cst_create_date DATE,
    dwh_create_date datetime default current_timestamp
);

------------------------------------------------------------
-- Product Information
------------------------------------------------------------
-- Stores product master data used by sales transactions.

DROP TABLE IF EXISTS silver.crm_prd_info;

CREATE TABLE silver.crm_prd_info(
    prd_id INT,
    cat_id varchar(50),
    prd_key VARCHAR(50),
    prd_nm VARCHAR(50),
    prd_cost INT,
    prd_line VARCHAR(50),
    dwh_create_date datetime default current_timestamp
);

------------------------------------------------------------
-- Sales Details
------------------------------------------------------------
-- Stores transactional sales data imported from CRM.

DROP TABLE IF EXISTS silver.crm_sales_details;

CREATE TABLE silver.crm_sales_details(
    sls_order_num VARCHAR(50),
    sls_prd_key VARCHAR(50),
    sls_cust_id INT,
    sls_order_dt date,
    sls_ship_dt date,
    sls_due_dt date,
    sls_quantity INT,
    sls_price INT,
    sls_sales INT,
    dwh_create_date datetime default current_timestamp
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

CREATE TABLE silver.erp_cust_az12(
    cid VARCHAR(50),
    bdate DATE,
    gen VARCHAR(50),
    dwh_create_date datetime default current_timestamp
);

------------------------------------------------------------
-- Customer Location
------------------------------------------------------------
-- Stores customer geographic information.

DROP TABLE IF EXISTS silver.erp_loc_a101;

CREATE TABLE silver.erp_loc_a101(
    cid VARCHAR(50),
    cntry VARCHAR(50),
    dwh_create_date datetime default current_timestamp
);

------------------------------------------------------------
-- Product Category
------------------------------------------------------------
-- Stores product category hierarchy and maintenance data.

DROP TABLE IF EXISTS silver.erp_px_cat_g1v2;

CREATE TABLE silver.erp_px_cat_g1v2(
    id VARCHAR(50),
    cat VARCHAR(50),
    subcat VARCHAR(50),
    maintenance VARCHAR(50),
    dwh_create_date datetime default current_timestamp
);

