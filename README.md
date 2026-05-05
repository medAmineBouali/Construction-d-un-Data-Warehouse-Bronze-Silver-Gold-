# 🏗️ Data Warehouse Construction (Medallion Architecture)

## 📖 Project Overview
This project involves designing and building a modern **Data Warehouse** from scratch using a Medallion Architecture (Bronze 🥉, Silver 🥈, Gold 🥇). Developed as part of the Data Analyst program at JobInTech x Simplon, the objective is to centralize, clean, and structure raw operational and financial data (from CSV files) into a highly optimized analytical model ready for Business Intelligence (BI) reporting in tools like Tableau or Power BI.

## 🧱 Architecture Strategy

* 🥉 **Bronze Layer (Raw):** Exact replica of the source CSV files. Data is loaded "as-is" without transformations using `BULK INSERT`.
* 🥈 **Silver Layer (Cleaned & Standardized):** Data is cleaned (TRIM, UPPER), data types are explicitly cast, and business rules are applied (e.g., standardizing 'P L' to 'P&L', handling missing mappings).
* 🥇 **Gold Layer (Analytical / Star Schema):** A **Logical Data Warehouse** approach is used. Instead of physical tables, the Gold layer relies on SQL **Views** to create a Star Schema (`fact_gl`, `dim_account`, `dim_store`). This ensures real-time sync with the Silver layer and uses advanced SQL functions (`COALESCE`, `FULL OUTER JOIN`) to dynamically handle missing dimensions and mapping fallback strategies.

---

## 📂 Repository Structure

| File / Folder | Description |
| :--- | :--- |
| 📁 `data/` | Directory containing the raw source CSV files (financial and operational data). |
| 📄 `Table_definitions.sql` | DDL script to create the necessary schemas (`bronze`, `silver`, `gold`) and the initial table structures. |
| 📄 `bulkinsert.sql` | Contains the `BULK INSERT` commands to quickly load raw CSV files into the SQL Server. |
| 📄 `Bronze_data_loader.sql` | Handles the complete ingestion pipeline to move raw data into the Bronze tables. |
| 📄 `Data_Cleaning_silver.sql` | Core transformation logic. Applies CAST, handles NULLs, removes duplicates, and standardizes text formats to populate the Silver layer. |
| 📄 `Gold_Star_schema.sql` | Constructs the final Star Schema using Views. Merges mapping tables and transaction tables to create clean Dimensions (`dim_account`, `dim_store`) and Facts (`fact_gl`). |
| 📄 `Quality_Check.sql` | A suite of SQL queries to validate data integrity (e.g., checking for orphaned transactions, ensuring row counts match between layers). |
| 📄 `Construction dun data warehouse.slnx` | Visual Studio / SQL Server Data Tools solution file for the project. |

---

## 🚀 How to Run the Project

To execute this project locally, ensure you have **SQL Server** and **SQL Server Management Studio (SSMS)** (or Azure Data Studio) installed.

1.  **Clone the repository:**
    ```bash
    git clone <your-repository-url>