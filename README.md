# 🏗️ SQL Data Warehouse Project (MySQL)

An end-to-end data warehouse built in **MySQL**, following the **Medallion Architecture** (Bronze → Silver → Gold). The project ingests raw CRM and ERP source data, cleans and standardizes it, and models it into a star schema ready for business analytics and reporting.

This project was built as part of a structured SQL learning path, with a focus on real-world ETL design, data quality, and dimensional modeling practices.

---

## 📐 Data Architecture

The warehouse follows a 3-layer Medallion Architecture:

<img width="1677" height="918" alt="DateWarehouse" src="https://github.com/user-attachments/assets/03647b2c-4627-48c5-842f-67859af747d7" />


| Layer | Purpose | Contents |
|-------|---------|----------|
| 🥉 **Bronze** | Raw ingestion | Unmodified data loaded as-is from CRM and ERP CSV source files |
| 🥈 **Silver** | Cleansed & standardized | Deduplicated, trimmed, type-cast, and business-rule-corrected data |
| 🥇 **Gold** | Business-ready | Star schema views (dimensions + fact table) for analytics and BI tools |

---

## 📂 Repository Structure

```
Data-warehouse-project-mysql/
│
├── datasets/                      # Source CSV files (CRM & ERP)
│
├── docs/                          # Project documentation / diagrams
│
├── scripts/
│   ├── init_databases.sql         # Creates/resets Bronze, Silver, Gold databases
│   │
│   ├── bronze/
│   │   ├── create_tables_bronze.sql   # Raw table definitions
│   │   └── data_loading-bronze.sql    # LOAD DATA INFILE ingestion from CSVs
│   │
│   ├── silver/
│   │   ├── create_tables_silver.sql   # Cleansed table definitions
│   │   ├── load_data_silver.sql       # Bronze → Silver ETL & transformations
│   │   └── quality_checks.sql         # Post-load validation queries
│   │
│   └── gold/
│       ├── create_layer_gold.sql      # Star schema views (dims + fact)
│       └── quality_check.sql          # Gold layer integrity & business rule checks
│
├── LICENSE
└── README.md
```

---

## 🗃️ Data Sources

The warehouse integrates two source systems:

**CRM**
- `crm_cust_info` — customer master data
- `crm_prd_info` — product master data
- `crm_sales_details` — sales transactions

**ERP**
- `erp_cust_az12` — customer demographics (birthdate, gender)
- `erp_loc_a101` — customer location/country
- `erp_px_cat_g1v2` — product category, subcategory, and maintenance info

---

## 🔄 ETL Highlights (Silver Layer)

Key transformation rules applied while moving data from Bronze to Silver:

- **Customers** — deduplicated by keeping the most recent record per `cst_id`; standardized marital status (`S`/`M` → `Single`/`Married`) and gender (`M`/`F` → `Male`/`Female`).
- **Products** — split the raw product key into `category_id` and `product_key`; standardized product line codes (`M`, `R`, `S`, `T`) into readable names; derived product end dates using `LEAD()` over product key history.
- **Sales** — converted integer-encoded dates to proper `DATE` types (with invalid dates set to `NULL`); recalculated sales amount where it didn't match `price × quantity`; backfilled missing/invalid prices.
- **ERP Customers** — stripped `NAS` prefixes from customer IDs; nulled out future birthdates; standardized gender values.
- **ERP Locations** — removed hyphens from customer IDs; standardized country codes (`US`/`USA` → `United States`, `DE` → `Germany`).

---

## ⭐ Gold Layer — Star Schema

The Gold layer exposes three analytics-ready views:

- **`gold.dim_customers`** — combines CRM customer info with ERP demographic and location data; resolves gender conflicts between source systems.
- **`gold.dim_products`** — combines CRM product info with ERP category data; filters to currently active products only.
- **`gold.fact_sales`** — sales transactions linked to customer and product dimensions via surrogate keys, with order/ship/due dates and sales measures (amount, quantity, price).

---

## ✅ Data Quality Checks

Two dedicated validation scripts ensure trustworthy data at each stage:

- **`silver/quality_checks.sql`** — checks for duplicate customer IDs, invalid dates, unstandardized category values, and row count validation across all Silver tables.
- **`gold/quality_check.sql`** — validates surrogate/business key uniqueness, referential integrity between fact and dimension tables, and business rules (e.g. `sales_amount = quantity × price`).

---

## 🛠️ Tech Stack

- **Database:** MySQL 8.0
- **Tools:** MySQL Workbench
- **Concepts applied:** Medallion Architecture, ETL design, dimensional modeling (star schema), surrogate keys, window functions (`ROW_NUMBER()`, `LEAD()`), data quality validation

---

## 🚀 How to Run

1. Open the scripts in **MySQL Workbench** (or another MySQL client) connected to a local MySQL 8.0 instance.
2. Run `scripts/init_databases.sql` to create the `Bronze`, `Silver`, and `Gold` databases.
   > ⚠️ This script drops and recreates all three databases — for development/learning use only.
3. Run `scripts/bronze/create_tables_bronze.sql`, then `scripts/bronze/data_loading-bronze.sql` to load the raw CSVs.
   - Update the file paths inside `data_loading-bronze.sql` to match where your CSVs are stored locally, and make sure `local_infile` is enabled on your MySQL server.
4. Run `scripts/silver/create_tables_silver.sql`, then `scripts/silver/load_data_silver.sql` to populate the cleansed layer.
5. Run `scripts/silver/quality_checks.sql` to validate the Silver layer.
6. Run `scripts/gold/create_layer_gold.sql` to build the star schema views.
7. Run `scripts/gold/quality_check.sql` to validate the final Gold layer.


---

## 📄 License

This project is licensed under the terms of the [MIT License](LICENSE).

## 👤 Author

**Ibrahim Ahmed**
Aspiring Data Analyst | SQL · Python · Power BI
