# azure-fintech-data-migration
# FinTech Data Migration Pipeline

An end-to-end **Azure Data Engineering project** that demonstrates the migration of financial data from **Azure SQL Database to Azure Data Lake Storage Gen2 (ADLS Gen2)** using **Azure Synapse Analytics**.

The project follows the **Medallion Architecture** to organize data into Bronze, Silver, and Gold layers and includes data-quality validation to verify successful data movement.

---

## 🏗️ Architecture

```text
                    ┌─────────────────────┐
                    │    Azure SQL DB     │
                    │    Source System    │
                    └──────────┬──────────┘
                               │
                               │ Extract
                               ▼
                    ┌─────────────────────┐
                    │  Azure Synapse      │
                    │     Pipeline        │
                    └──────────┬──────────┘
                               │
                               │ Load
                               ▼
              ┌──────────────────────────────┐
              │          ADLS Gen2           │
              │                              │
              │  ┌────────┐ ┌────────┐       │
              │  │ Bronze │→│ Silver │→ Gold │
              │  └────────┘ └────────┘       │
              └──────────────┬───────────────┘
                             │
                             ▼
                    ┌─────────────────┐
                    │ Synapse         │
                    │ Serverless SQL  │
                    └─────────────────┘

                    Data Validation
                          │
                          ▼
                 Source vs Target
                  Record Counts
                          │
                    ┌─────┴─────┐
                    │           │
                  Match       Mismatch
                    │           │
                    ▼           ▼
                 Success    Failure Alert
                              │
                              ▼
                         Logic App
```

> The architecture diagram represents the implemented components of the project. Components will be updated as additional transformations and orchestration capabilities are added.

---

## 🎯 Project Objective

The objective of this project is to build a scalable cloud-based data migration pipeline for a hypothetical FinTech organization.

The pipeline:

* Extracts data from **Azure SQL Database**
* Ingests the data using **Azure Synapse Pipelines**
* Stores the raw data in **ADLS Gen2**
* Organizes the data using the **Medallion Architecture**
* Performs data-quality validation
* Provides analytical access using **Synapse Serverless SQL**
* Uses **Logic Apps** for workflow notification and error handling

---

## 🛠️ Technologies Used

| Technology                       | Purpose                                    |
| -------------------------------- | ------------------------------------------ |
| **Azure SQL Database**           | Source database                            |
| **Azure Data Lake Storage Gen2** | Data lake storage                          |
| **Azure Synapse Analytics**      | Data ingestion, orchestration and querying |
| **Synapse Pipelines**            | ETL/ELT pipeline orchestration             |
| **Synapse Serverless SQL Pool**  | Querying data stored in ADLS               |
| **Azure Logic Apps**             | Workflow automation and notifications      |
| **SQL**                          | Data extraction and validation             |
| **ADLS Gen2**                    | Bronze/Silver/Gold data storage            |

---

## 🥉 Medallion Architecture

The data lake follows the Medallion Architecture.

### Bronze Layer

The Bronze layer stores the **raw data** extracted from the source Azure SQL Database.

```text
ADLS Gen2
└── bronze
    └── fintech
        └── <source-data>
```

The objective of this layer is to preserve the data as close to the source format as possible.

---

### 🥈 Silver Layer

The Silver layer contains **cleaned and processed data**.

Typical processing includes:

* Data type standardization
* Null handling
* Duplicate removal
* Data cleansing
* Schema standardization

```text
ADLS Gen2
└── silver
    └── fintech
        └── <processed-data>
```

---

### 🥇 Gold Layer

The Gold layer contains **business-ready data** intended for analytics and reporting.

```text
ADLS Gen2
└── gold
    └── fintech
        └── <business-data>
```

---

## 🔄 Data Pipeline

The primary data flow is:

```text
Azure SQL Database
        │
        ▼
Synapse Pipeline
        │
        ▼
Bronze Layer
        │
        ▼
Data Transformation
        │
        ▼
Silver Layer
        │
        ▼
Business Transformation
        │
        ▼
Gold Layer
```

The Synapse pipeline is responsible for orchestrating the movement and processing of the data.

---

## 🔍 Data Quality Validation

A source-to-target validation mechanism is implemented to verify that the migration completed successfully.

The pipeline compares:

```text
Source Record Count
        │
        ▼
Target Record Count
        │
        ▼
      Compare
        │
   ┌────┴────┐
   │         │
 Match    Mismatch
   │         │
   ▼         ▼
Success    Failure
```

For example:

```sql
SELECT COUNT(*) AS src_count
FROM <source_table>;
```

The destination count is then compared against the source count.

If the counts match, the migration is considered successful.

If they do not match, the pipeline can be treated as failed and the appropriate notification workflow can be triggered.

---

## 🔔 Logic App Integration

Azure Logic Apps is used to automate workflow actions based on pipeline execution results.

Example workflow:

```text
Synapse Pipeline
       │
       ▼
Pipeline Completed
       │
       ▼
Check Status
   ┌───┴────┐
   │        │
Success   Failure
   │        │
   ▼        ▼
Success   Notification
          / Alert
```

This allows the pipeline to communicate its execution status without requiring manual monitoring.

---

## 🗄️ Synapse Serverless SQL

The data stored in ADLS Gen2 can be queried using the Synapse Serverless SQL Pool.

This provides a SQL-based interface for analytical workloads without requiring a dedicated SQL warehouse.

Example:

```sql
SELECT *
FROM OPENROWSET(
    BULK 'https://<storage-account>.dfs.core.windows.net/<container>/<path>',
    FORMAT = 'PARQUET'
) AS rows;
```

Serverless SQL can be used to query the processed data directly from the data lake.

---

## 📁 Repository Structure

```text
azure-fintech-data-migration/
│
├── README.md
│
├── architecture/
│   └── architecture.png
│
├── sql/
│   ├── source_tables.sql
│   └── validation_queries.sql
│
├── pipelines/
│   └── pipeline-documentation.md
│
├── screenshots/
│   ├── azure-sql.png
│   ├── synapse-pipeline.png
│   ├── adls-bronze.png
│   ├── adls-silver.png
│   ├── adls-gold.png
│   ├── validation.png
│   └── logic-app.png
│
└── docs/
    └── project-documentation.md
```

---

## 📸 Project Screenshots

### Synapse Pipeline

*Add screenshot of the completed Synapse pipeline here.*

### ADLS Gen2 — Bronze Layer

*Add screenshot of the Bronze container/folder here.*

### ADLS Gen2 — Silver Layer

*Add screenshot of the Silver container/folder here.*

### ADLS Gen2 — Gold Layer

*Add screenshot of the Gold container/folder here.*

### Data Validation

*Add screenshot showing the source/target validation here.*

### Logic App

*Add screenshot of the Logic App workflow here.*

---

## ⚙️ Project Workflow

### Step 1 — Source

Financial data is maintained in an Azure SQL Database.

### Step 2 — Ingestion

Azure Synapse Pipelines connects to the source database and extracts the required data.

### Step 3 — Bronze

The extracted data is written to ADLS Gen2 in the Bronze layer.

### Step 4 — Transformation

The data can then be cleaned and transformed before being moved into the Silver layer.

### Step 5 — Gold

Business-ready datasets are created in the Gold layer for analytical consumption.

### Step 6 — Validation

Source and destination record counts are compared to verify successful data migration.

### Step 7 — Notification

Logic Apps can be used to trigger notifications based on pipeline execution results.

### Step 8 — Analytics

Synapse Serverless SQL provides SQL-based access to data stored in the data lake.

---

## 🔐 Security Considerations

Sensitive credentials and secrets are **not stored in this repository**.

The project should use Azure-native authentication mechanisms such as:

* Managed Identity
* Azure Key Vault
* Role-Based Access Control (RBAC)
* Secure linked-service configurations

> Never commit passwords, connection strings, access keys, SAS tokens, or other credentials to GitHub.

---

## 🚀 Future Improvements

Potential improvements include:

* Incremental data loading using timestamps/watermarks
* Metadata-driven pipelines
* Parameterized pipelines
* Automated schema validation
* More comprehensive data-quality checks
* Azure Key Vault integration
* Managed Identity authentication
* Pipeline monitoring and alerting
* Power BI integration for reporting
* CI/CD using GitHub Actions or Azure DevOps
* Automated deployment between development and production environments

---

## 📚 Key Data Engineering Concepts Demonstrated

This project demonstrates practical understanding of:

* ETL/ELT pipelines
* Azure Data Lake Storage
* Medallion Architecture
* Data ingestion
* Pipeline orchestration
* Batch data processing
* Data-quality validation
* Source-to-target reconciliation
* Serverless SQL
* Cloud storage
* Workflow automation
* Azure security concepts
* Data Engineering architecture

---

## 👨‍💻 Project Author

**Debayudh Kundu**

B.Tech — Computer Science & Engineering

**Focus:** Data Engineering | Azure | SQL | Python | Big Data

---

## ⭐ Project Summary

This project demonstrates an end-to-end Azure data engineering workflow for migrating and processing FinTech data using **Azure SQL Database, Azure Synapse Analytics, ADLS Gen2, Synapse Serverless SQL, and Logic Apps**.

The project focuses on building a reliable data pipeline with **layered data storage, validation, orchestration, and analytical access**.
