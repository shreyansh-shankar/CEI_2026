# Week 3 — SQL Advanced Analysis: Subqueries, CTEs & Window Functions

> **CEI (Celebal Tech) Internship** · Week 3 Assignment  
> Dataset: [Superstore Sales Dataset](https://www.kaggle.com/datasets/vivek468/superstore-dataset-final)

---

## Objective

Analyze Superstore sales data using advanced SQL techniques — **Subqueries**, **CTEs (Common Table Expressions)**, and **Window Functions** — to answer real business questions about customers, orders, and revenue.

---

## Files

| File | Description |
|------|-------------|
| `superstore_analysis.sql` | Pure SQL script — all queries from setup to mini project |
| `superstore_analysis.ipynb` | Jupyter notebook — runs every query and displays results inline |
| `superstore_sql_analysis.py` | Standalone Python script — same logic, runs without Jupyter |
| `superstore.csv` | *(Download separately — see below)* |

---

## Setup

### 1. Download the Dataset

Download `Sample_Superstore.csv` from Kaggle:  
👉 https://www.kaggle.com/datasets/vivek468/superstore-dataset-final

Place it in this folder (`Week-3/`).

### 2. Install Dependencies

```bash
pip install pandas jupyter
```

### 3. Run the Notebook

```bash
jupyter notebook superstore_analysis.ipynb
```

Or run the Python script directly:

```bash
python superstore_sql_analysis.py
```

For the pure SQL script, use any SQLite client (DB Browser for SQLite, DBeaver, etc.) and import the CSV first using the instructions at the top of the file.

---

## Data Model

The raw CSV is loaded into `superstore_raw`, then normalized into three tables:

```
superstore_raw
     │
     ├─► customers  (customer_id PK, name, segment, location)
     ├─► products   (product_id PK, name, category, sub_category)
     └─► orders     (row_id PK, order details, FK → customers + products)
```

Data is inserted using `SELECT DISTINCT` to eliminate duplicates in dimension tables.

---

## Queries Covered

### Step 2 — Required Queries

| # | Query | Technique |
|---|-------|-----------|
| Q1 | Orders with sales > average sales | **Subquery** |
| Q2 | Highest sales order per customer | **Correlated Subquery** |
| Q3 | Total sales per customer | **CTE** |
| Q4 | Customers with above-average total sales | **CTE + Subquery** |
| Q5 | Rank customers by total sales | **RANK() + DENSE_RANK()** |
| Q6 | Order sequence within each customer | **ROW_NUMBER() + PARTITION BY** |
| Q7 | Top 3 customers by total sales | **Window Function + LIMIT** |

### Step 3 — Final Combined Query

One query combining **JOIN + CTE + Window Function** to show:  
`Customer Name | Total Sales | Overall Rank | Segment Rank`

### Mini Project — Customer Sales Insights

| # | Business Question | Technique |
|---|-------------------|-----------|
| MI-1 | Who are the top 5 customers? | CTE + Window |
| MI-2 | Who are the bottom 5 customers? | CTE + Window |
| MI-3 | Which customers made only one order? | HAVING |
| MI-4 | Which customers have above-average sales? | CTE + CROSS JOIN |
| MI-5 | What is the highest order value per customer? | Window + RANK |

---

## Key Business Insights

1. **Revenue concentration** — The top 3 customers contribute a disproportionately large share of total revenue, validating the Pareto principle. A VIP loyalty program targeting these accounts would protect high-value revenue.

2. **Single-order churn risk** — A significant portion of customers placed only one order. Targeted re-engagement campaigns (discount codes, follow-up emails) could convert these into repeat buyers and substantially improve customer lifetime value.

3. **Discount impact on profit** — Orders with discounts above 40% frequently result in negative profit margins. A discount cap policy or tiered approval process for large discounts is recommended.

4. **Segment behavior** — Corporate customers tend to place larger, less-frequent orders, while Consumer segment customers are higher-frequency but lower-value. Each segment deserves a distinct sales strategy.

5. **Regional opportunity** — West and East regions lead in sales volume. The Central and South regions show relative underperformance and represent growth opportunity through targeted regional marketing.

6. **Category leadership** — Technology products command the highest per-unit sales values. Prioritizing inventory availability and promotions in this category can disproportionately lift total revenue.

---

## SQL Concepts Used

```sql
-- Subquery example
WHERE sales > (SELECT AVG(sales) FROM orders)

-- CTE example
WITH customer_sales AS (
    SELECT customer_id, SUM(sales) AS total_sales
    FROM orders GROUP BY customer_id
)
SELECT * FROM customer_sales WHERE total_sales > ...

-- Window Function example
RANK()       OVER (ORDER BY total_sales DESC)
ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date)
DENSE_RANK() OVER (ORDER BY total_sales DESC)
```
