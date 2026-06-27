/*
====================================================
 Modern Data Warehouse Setup (MySQL)
====================================================

This script initializes a 3-layer data warehouse:

1. Bronze → Raw data ingestion layer
2. Silver → Cleaned and standardized data layer
3. Gold   → Business-ready analytics layer

Each layer is stored in a separate database.

====================================================
⚠️ WARNING: RESET SCRIPT ⚠️

This script will DROP and RECREATE the entire
data warehouse structure (Bronze, Silver, Gold).

❗ ALL EXISTING DATA WILL BE LOST
❗ DO NOT RUN IN PRODUCTION ENVIRONMENTS
❗ INTENDED FOR DEVELOPMENT / LEARNING ONLY

Purpose:
- Reset environment safely
- Ensure repeatable ETL execution
====================================================
*/

-- =========================================
-- Drop existing databases (if they exist)
-- =========================================
DROP DATABASE IF EXISTS Bronze;
DROP DATABASE IF EXISTS Silver;
DROP DATABASE IF EXISTS Gold;

-- =========================================
-- Create fresh data warehouse layers
-- =========================================

-- Raw data from source systems
CREATE DATABASE IF NOT EXISTS Bronze
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci;

-- Cleaned and transformed data
CREATE DATABASE IF NOT EXISTS Silver
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci;

-- Final analytical layer (Star Schema)
CREATE DATABASE IF NOT EXISTS Gold
CHARACTER SET utf8mb4
COLLATE utf8mb4_general_ci;
