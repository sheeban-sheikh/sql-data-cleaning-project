# CleanCart: E-Commerce Data Cleaning Case Study

A comprehensive SQL-based data cleaning project on a synthetic Indian e-commerce dataset containing 112,092 rows across 4 tables. The goal was to identify, document, and resolve real-world data quality issues using MySQL.

---

## Project Overview

| Detail | Info |
|---|---|
| Tool Used | MySQL, MySQL Workbench |
| Dataset | Synthetic Indian E-Commerce Data |
| Tables | 4 (customers, products, orders, order_items) |
| Total Rows | 112,092 |
| Project Type | Data Cleaning Case Study |

---

## Dataset Description

The dataset simulates a real-world Indian e-commerce platform with intentional data quality issues including missing values, duplicates, inconsistent formatting, outliers, and invalid records.

> **Note:** All data is synthetically generated to replicate real-world messy data scenarios. No real customer or transaction data is used.

| Table | Rows | Description |
|---|---|---|
| customers | 10,000 | Customer profiles with personal and contact details |
| products | 2,000 | Product catalog with pricing and availability |
| orders | 25,000 | Order transactions with payment and delivery info |
| order_items | 75,092 | Line items for each order |

---

## Data Audit Summary

> All "null values" below refer to empty strings ('') as data was imported via MySQL Workbench Import Wizard which converts NULLs to empty strings.

### 1. Customers Table (10,000 rows)

| Column | Issue Found |
|---|---|
| name | 296 empty values, invalid placeholders (e.g. '.') |
| email | 727 empty values, 234 duplicate emails, 296 invalid formats (missing @), invalid placeholders |
| phone | 785 empty values, 213 duplicates, invalid placeholders (e.g. 0000000000, N/A), multiple formats (+91, 91, hyphen-separated) |
| city | 187 empty values, leading/trailing spaces, case inconsistencies |
| state | 593 empty values |
| pincode | 400 empty values, non-numeric values detected (e.g. ABCDE) |
| gender | 307 empty values, 10+ non-standardized values (M, MALE, FEMALE, F, 0, 1, NA, others) |
| age | 528 empty values, zero/negative values, unrealistic values (e.g. 999), range: -65 to 999 |
| registration_date | 769 empty values, future dates found, multiple date formats |
| loyalty_points | 998 empty values |
| is_premium | 174 empty values, non-standardized values (Yes, No, 0, 1, TRUE, FALSE) |

### 2. Products Table (2,000 rows)

| Column | Issue Found |
|---|---|
| product_name | 94 empty values |
| category | 49 empty values, case inconsistencies across 7 unique categories |
| sub_category | 206 empty values |
| brand | 142 empty values |
| price | 39 empty values, negative/zero values, outliers (e.g. 9999999), range: -79,925 to 9,999,999 |
| discount_percent | 56 empty values, negative values, impossible values (e.g. 150%), range: -10 to 150 |
| stock_quantity | 32 empty values, negative values, outliers (e.g. 99999), range: -5 to 99,999 |
| rating | 54 empty values, negative values, out-of-range values (e.g. 6.5), range: -1 to 6.5 |
| is_available | 69 empty values, non-standardized values (Yes, No, 0, 1), case inconsistencies |

### 3. Orders Table (25,000 rows)

| Column | Issue Found |
|---|---|
| order_date | 2,074 empty values, future dates, multiple formats (YYYY-MM-DD, DD-MM-YYYY, DD/MM/YYYY) |
| delivery_date | 3,888 empty values, future dates beyond 14 days, multiple formats |
| status | 1,448 empty values, leading/trailing spaces, 15+ variations (Delivered, delivered, DELIVERED, canceled, cancelled) |
| payment_method | 1,497 empty values, leading/trailing spaces, 14+ variations (UPI, upi, COD, Cod, N/A, online) |
| total_amount | 552 empty values, negative/zero values, outliers, range: -1,49,917 to 99,99,999 |
| shipping_charges | 863 empty values, negative values, outliers (e.g. 9999), range: -50 to 9,999 |
| discount_applied | 3,026 empty values, negative values, outliers |
| city | 491 empty values, leading/trailing spaces, case inconsistencies |
| promo_code | 17,355 empty values (valid — not all orders use promo codes) |

### 4. Order Items Table (75,092 rows)

| Column | Issue Found |
|---|---|
| quantity | 1,105 empty values, zero/negative values, outliers (e.g. 999), range: -1 to 999 |
| unit_price | 1,491 empty values, negative/zero values, range: -79,994 to 7,99,925 |
| total_price | 2,085 empty values, negative/zero values, range: -7,95,113 to 99,99,999 |
| return_requested | 2,568 empty values, non-standardized values (0, 1, Yes, No, yes, no) |
| warehouse_location | 12,319 empty values, case inconsistencies, invalid placeholder (NA) |

---

## Data Cleaning Steps

> Documented in `sql/03_cleaning.sql`

1. Convert empty strings to NULL across all tables
2. Remove duplicate rows (customers, orders)
3. Standardize date formats to YYYY-MM-DD (order_date, delivery_date, registration_date)
4. Flag and remove future dates
5. Handle NULL values — drop or default based on column criticality
6. Fix outliers — age, price, rating, discount_percent, stock_quantity
7. Standardize categorical columns — gender, city, status, payment_method, is_available, is_premium, warehouse_location
8. Fix phone number formats — standardize to 10-digit format
9. Remove invalid emails — missing @, placeholder values
10. Fix non-numeric pincode values
11. Remove orphan records — orders without valid customers, order_items without valid products

---

## Key Insights

> Documented in `sql/04_analysis.sql`

*To be updated after cleaning is complete.*

---

## Results / Impact

*To be updated after cleaning is complete.*

---

## File Structure

```
sql-data-cleaning-project/
│
├── data/
│   └── raw/
│       ├── customers.csv
│       ├── products.csv
│       ├── orders.csv
│       └── order_items.csv
│
├── sql/
│   ├── 01_create_tables.sql
│   ├── 02_audit.sql
│   ├── 03_cleaning.sql
│   └── 04_analysis.sql
│
└── README.md
```

---

## Tools Used

- MySQL 8.0
- MySQL Workbench

