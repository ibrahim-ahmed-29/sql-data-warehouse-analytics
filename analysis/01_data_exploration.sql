/*
===============================================================================
Database Exploration
===============================================================================
Purpose:
    - To explore the structure of the database, including the list of tables
      and their schemas.
    - To inspect the columns and metadata for specific tables.

Tables Used:
    - INFORMATION_SCHEMA.TABLES
    - INFORMATION_SCHEMA.COLUMNS
===============================================================================
*/

use gold;

-- Retrieve a list of all tables in the database
SELECT
TABLE_schema,
table_name,
table_type
FROM information_schema.Tables
where table_schema = 'gold';

-- Retrieve all columns for each table

-- * dim_customers
select
table_schema,
table_name,
Column_name,
data_type,
CHARACTER_MAXIMUM_LENGTH
from information_schema.Columns
WHERE table_name = 'dim_customers';


-- * fact_sales
select
table_schema,
table_name,
Column_name,
data_type,
CHARACTER_MAXIMUM_LENGTH
from information_schema.Columns
WHERE table_name = 'fact_sales';


-- * dim_product
select
table_schema,
table_name,
Column_name,
data_type,
CHARACTER_MAXIMUM_LENGTH
from information_schema.Columns
WHERE table_name = 'dim_product';
