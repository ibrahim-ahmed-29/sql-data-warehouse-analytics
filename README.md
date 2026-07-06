# 🏗️ SQL Data Warehouse & Analytics Project (MySQL)

An end-to-end data project built in **MySQL**: a data warehouse following the **Medallion Architecture** (Bronze → Silver → Gold), plus a full SQL-based analytics layer on top of it. The project ingests raw CRM and ERP source data, cleans and standardizes it, models it into a star schema, and then uses that schema to answer real business questions — from basic exploration through segmentation, ranking, trend, and customer/product reporting.

This project was built as part of a structured SQL learning path, with a focus on real-world ETL design, data quality, dimensional modeling, and analytical query patterns.

---

## 📐 Data Architecture

The warehouse follows a 3-layer Medallion Architecture:

<img width="1677" height="918" alt="DateWarehouse" src="https://github.com/user-attachments/assets/03647b2c-4627-48c5-842f-67859af747d7" />

| Layer        | Purpose                 | Contents                                                               |
| ------------ | ----------------------- | ---------------------------------------------------------------------- |
| 🥉 **Bronze** | Raw ingestion           | Unmodified data loaded as-is from CRM and ERP CSV source files         |
| 🥈 **Silver** | Cleansed & standardized | Deduplicated, trimmed, type-cast, and business-rule-corrected data     |
| 🥇 **Gold**   | Business-ready          | Star schema views (dimensions + fact table) for analytics and BI tools |

The **Gold** layer is the foundation the entire analysis section below is built on.

---

## 📂 Repository Structure

```
sql-data-warehouse-analytics/
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
├── analysis/                      # SQL analytics built on top of the Gold layer
│   ├── 01_data_exploration.sql        # Database/table/column structure
│   ├── 02_dimensions_exploration.sql  # Unique values across key dimensions
│   ├── 03_date_range_exploration.sql  # Order date range & customer age range
│   ├── 04_measures_exploration.sql    # Core business metrics + summary report
│   ├── 05_magnitude_analysis.sql      # Totals grouped by country, gender, category
│   ├── 06_ranking_analysis.sql        # Top/bottom products & customers
│   ├── 07_change_over_time_analysis.sql   # Monthly/yearly sales trends
│   ├── 08_cumulative_analysis.sql     # Running totals & YTD sales
│   ├── 09_performance_analysis.sql    # YoY product performance vs. average
│   ├── 10_data_segmentation.sql       # Product cost tiers & customer segments (VIP/Regular/New)
│   ├── 11_part_to_whole_analysis.sql  # Category contribution to total sales
│   ├── 12_report_customers.sql        # Consolidated customer report (segments + KPIs)
│   └── 13_report_products.sql         # Consolidated product report (segments + KPIs)
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

## 📊 Data Analysis

Once the Gold layer is built, the `analysis/` folder walks through a full SQL analytics workflow — from first exploring the schema to producing consolidated business reports. Each script builds on the last:

**Exploration** (01–04)
Understand the database structure, the dimension values available, the date/age ranges in the data, and the core business measures (total sales, orders, customers, products).

**Analysis** (05–11)
Break metrics down by dimension (magnitude), rank top/bottom performers, track sales over time and cumulatively, compare year-over-year product performance, segment products by cost and customers by spending behavior (VIP/Regular/New), and measure each category's contribution to total sales.

**Reporting** (12–13)
Two consolidated, reusable reports:
- **`report_customers.sql`** — one view per customer with age group, VIP/Regular/New segment, recency, total orders/sales/quantity, lifespan, average order value, and average monthly spend.
- **`report_products.sql`** — one view per product with performance segment (High/Mid/Low), recency, total orders/sales/quantity, lifespan, average order revenue, and average monthly revenue.

Together these two reports are the capstone of the analysis layer — they turn raw transactional data into ready-to-use, decision-support views.

---

## 🛠️ Tech Stack

- **Database:** MySQL 8.0
- **Tools:** MySQL Workbench
- **Concepts applied:** Medallion Architecture, ETL design, dimensional modeling (star schema), surrogate keys, window functions (`ROW_NUMBER()`, `LEAD()`, `RANK()`, `LAG()`, running/partitioned aggregates), CTEs, data segmentation, KPI reporting, data quality validation

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
8. Once the Gold layer is in place, run any script in `analysis/` — they're numbered in a logical order (01 → 13) but each runs independently against the Gold views.

---

## 📄 License

This project is licensed under the terms of the [MIT License](https://github.com/ibrahim-ahmed-29/sql-data-warehouse-analytics/blob/main/LICENSE).

## 👤 Author

**Ibrahim Ahmed**
Aspiring Data Analyst | SQL · Python · Power BI
