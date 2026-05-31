-- ============================================================
-- SUPERSTORE SALES ANALYSIS - SQL SCRIPT
-- Celebal Technologies Internship | Week 2 Assignment
-- ============================================================

-- ============================================================
-- SECTION 1: DATABASE SETUP & DATA LOADING
-- ============================================================

-- Create the main table
CREATE TABLE IF NOT EXISTS superstore (
    row_id          INTEGER PRIMARY KEY,
    order_id        TEXT,
    order_date      DATE,
    ship_date       DATE,
    ship_mode       TEXT,
    customer_id     TEXT,
    customer_name   TEXT,
    segment         TEXT,
    country         TEXT,
    city            TEXT,
    state           TEXT,
    postal_code     TEXT,
    region          TEXT,
    product_id      TEXT,
    category        TEXT,
    sub_category    TEXT,
    product_name    TEXT,
    sales           REAL,
    quantity        INTEGER,
    discount        REAL,
    profit          REAL
);

-- NOTE: Load data using your environment's import method, e.g.:
-- SQLite:  .mode csv | .import superstore.csv superstore
-- Python:  df.to_sql('superstore', conn, if_exists='replace', index=False)
-- MySQL:   LOAD DATA INFILE 'superstore.csv' INTO TABLE superstore FIELDS TERMINATED BY ',';


-- ============================================================
-- SECTION 2: SCHEMA EXPLORATION
-- ============================================================

-- 2.1 Preview first 10 rows
SELECT * FROM superstore LIMIT 10;

-- 2.2 Total row count
SELECT COUNT(*) AS total_rows FROM superstore;

-- 2.3 Date range of orders
SELECT
    MIN(order_date) AS earliest_order,
    MAX(order_date) AS latest_order,
    (julianday(MAX(order_date)) - julianday(MIN(order_date))) / 365 AS years_span
FROM superstore;

-- 2.4 Distinct value counts per dimension
SELECT
    COUNT(DISTINCT order_id)     AS unique_orders,
    COUNT(DISTINCT customer_id)  AS unique_customers,
    COUNT(DISTINCT product_id)   AS unique_products,
    COUNT(DISTINCT state)        AS unique_states,
    COUNT(DISTINCT city)         AS unique_cities
FROM superstore;

-- 2.5 Segment distribution
SELECT segment, COUNT(*) AS order_count,
       ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM superstore), 2) AS pct
FROM superstore
GROUP BY segment
ORDER BY order_count DESC;

-- 2.6 Ship mode distribution
SELECT ship_mode, COUNT(*) AS count,
       ROUND(AVG(julianday(ship_date) - julianday(order_date)), 1) AS avg_ship_days
FROM superstore
GROUP BY ship_mode
ORDER BY count DESC;


-- ============================================================
-- SECTION 3: WHERE FILTERS
-- ============================================================

-- 3.1 Filter: West Region only
SELECT order_id, customer_name, state, sales, profit
FROM superstore
WHERE region = 'West'
ORDER BY sales DESC
LIMIT 15;

-- 3.2 Filter: Technology category
SELECT product_name, sub_category, sales, profit, discount
FROM superstore
WHERE category = 'Technology'
ORDER BY profit DESC
LIMIT 10;

-- 3.3 Filter: Orders in year 2017
SELECT COUNT(*) AS orders_2017,
       ROUND(SUM(sales), 2) AS total_sales_2017,
       ROUND(SUM(profit), 2) AS total_profit_2017
FROM superstore
WHERE strftime('%Y', order_date) = '2017';

-- 3.4 Filter: High-value orders (Sales > 2000)
SELECT order_id, customer_name, category, product_name, sales, profit
FROM superstore
WHERE sales > 2000
ORDER BY sales DESC
LIMIT 20;

-- 3.5 Filter: Loss-making orders (Profit < 0)
SELECT order_id, product_name, category, sub_category, sales, discount, profit
FROM superstore
WHERE profit < 0
ORDER BY profit ASC
LIMIT 15;

-- 3.6 Filter: Heavy discounts (>= 40%) that cause losses
SELECT category, sub_category, COUNT(*) AS count,
       ROUND(AVG(discount), 2) AS avg_discount,
       ROUND(SUM(profit), 2) AS total_profit
FROM superstore
WHERE discount >= 0.4
GROUP BY category, sub_category
ORDER BY total_profit ASC;

-- 3.7 Filter: Consumer segment in the South region
SELECT customer_name, city, state, SUM(sales) AS total_sales, SUM(profit) AS total_profit
FROM superstore
WHERE segment = 'Consumer' AND region = 'South'
GROUP BY customer_id, customer_name, city, state
ORDER BY total_sales DESC
LIMIT 10;


-- ============================================================
-- SECTION 4: AGGREGATIONS WITH GROUP BY
-- ============================================================

-- 4.1 Sales & Profit by Region
SELECT
    region,
    COUNT(DISTINCT order_id)    AS total_orders,
    ROUND(SUM(sales), 2)        AS total_sales,
    ROUND(SUM(profit), 2)       AS total_profit,
    ROUND(AVG(sales), 2)        AS avg_order_value,
    ROUND(SUM(profit)/SUM(sales)*100, 2) AS profit_margin_pct
FROM superstore
GROUP BY region
ORDER BY total_sales DESC;

-- 4.2 Sales by Category
SELECT
    category,
    COUNT(*)                    AS total_orders,
    SUM(quantity)               AS total_units_sold,
    ROUND(SUM(sales), 2)        AS total_sales,
    ROUND(SUM(profit), 2)       AS total_profit,
    ROUND(AVG(discount)*100, 1) AS avg_discount_pct,
    ROUND(SUM(profit)/SUM(sales)*100, 2) AS profit_margin_pct
FROM superstore
GROUP BY category
ORDER BY total_sales DESC;

-- 4.3 Sales by Sub-Category
SELECT
    category,
    sub_category,
    COUNT(*)                 AS order_count,
    ROUND(SUM(sales), 2)     AS total_sales,
    ROUND(SUM(profit), 2)    AS total_profit,
    ROUND(AVG(sales), 2)     AS avg_sale,
    ROUND(SUM(profit)/SUM(sales)*100, 2) AS margin_pct
FROM superstore
GROUP BY category, sub_category
ORDER BY total_profit DESC;

-- 4.4 Sales by Customer Segment
SELECT
    segment,
    COUNT(DISTINCT customer_id) AS unique_customers,
    COUNT(DISTINCT order_id)    AS total_orders,
    ROUND(SUM(sales), 2)        AS total_sales,
    ROUND(SUM(profit), 2)       AS total_profit,
    ROUND(AVG(sales), 2)        AS avg_order_value
FROM superstore
GROUP BY segment
ORDER BY total_sales DESC;

-- 4.5 Sales by State
SELECT
    state, region,
    COUNT(DISTINCT order_id) AS orders,
    ROUND(SUM(sales), 2)     AS total_sales,
    ROUND(SUM(profit), 2)    AS total_profit
FROM superstore
GROUP BY state, region
ORDER BY total_sales DESC
LIMIT 15;


-- ============================================================
-- SECTION 5: SORTING & LIMITING (TOP N ANALYSIS)
-- ============================================================

-- 5.1 Top 10 Products by Total Sales
SELECT
    product_name,
    category,
    sub_category,
    COUNT(*)             AS times_ordered,
    ROUND(SUM(sales), 2) AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM superstore
GROUP BY product_name, category, sub_category
ORDER BY total_sales DESC
LIMIT 10;

-- 5.2 Top 10 Products by Profit
SELECT
    product_name,
    category,
    ROUND(SUM(profit), 2)  AS total_profit,
    ROUND(SUM(sales), 2)   AS total_sales,
    ROUND(SUM(profit)/SUM(sales)*100, 1) AS margin_pct
FROM superstore
GROUP BY product_name, category
ORDER BY total_profit DESC
LIMIT 10;

-- 5.3 Bottom 10 Products (Biggest Loss Makers)
SELECT
    product_name,
    category,
    sub_category,
    COUNT(*)               AS order_count,
    ROUND(SUM(profit), 2)  AS total_profit,
    ROUND(AVG(discount)*100,1) AS avg_discount_pct
FROM superstore
GROUP BY product_name, category, sub_category
ORDER BY total_profit ASC
LIMIT 10;

-- 5.4 Top 5 Categories by Sales
SELECT
    category,
    ROUND(SUM(sales), 2)  AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit
FROM superstore
GROUP BY category
ORDER BY total_sales DESC
LIMIT 5;

-- 5.5 Top 10 Cities by Revenue
SELECT
    city, state, region,
    COUNT(DISTINCT order_id) AS orders,
    ROUND(SUM(sales), 2)     AS total_sales,
    ROUND(SUM(profit), 2)    AS total_profit
FROM superstore
GROUP BY city, state, region
ORDER BY total_sales DESC
LIMIT 10;


-- ============================================================
-- SECTION 6: BUSINESS USE CASES
-- ============================================================

-- 6.1 Monthly Sales Trend (All Years)
SELECT
    strftime('%Y', order_date) AS year,
    strftime('%m', order_date) AS month,
    strftime('%Y-%m', order_date) AS year_month,
    COUNT(DISTINCT order_id)   AS total_orders,
    ROUND(SUM(sales), 2)       AS monthly_sales,
    ROUND(SUM(profit), 2)      AS monthly_profit
FROM superstore
GROUP BY year_month
ORDER BY year_month;

-- 6.2 Year-over-Year Growth
SELECT
    strftime('%Y', order_date) AS year,
    ROUND(SUM(sales), 2) AS annual_sales,
    ROUND(SUM(profit), 2) AS annual_profit,
    COUNT(DISTINCT order_id) AS total_orders,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM superstore
GROUP BY year
ORDER BY year;

-- 6.3 Top 10 Customers by Lifetime Value
SELECT
    customer_id,
    customer_name,
    segment,
    state,
    COUNT(DISTINCT order_id)    AS total_orders,
    ROUND(SUM(sales), 2)        AS lifetime_sales,
    ROUND(SUM(profit), 2)       AS lifetime_profit,
    ROUND(AVG(sales), 2)        AS avg_order_value
FROM superstore
GROUP BY customer_id, customer_name, segment, state
ORDER BY lifetime_sales DESC
LIMIT 10;

-- 6.4 Customer Repeat Purchase Analysis
SELECT
    repeat_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(total_sales), 2) AS avg_sales_per_customer
FROM (
    SELECT
        customer_id,
        COUNT(DISTINCT order_id) AS order_count,
        SUM(sales) AS total_sales,
        CASE
            WHEN COUNT(DISTINCT order_id) = 1 THEN 'One-time'
            WHEN COUNT(DISTINCT order_id) BETWEEN 2 AND 5 THEN 'Occasional (2-5)'
            WHEN COUNT(DISTINCT order_id) BETWEEN 6 AND 10 THEN 'Regular (6-10)'
            ELSE 'Loyal (10+)'
        END AS repeat_category
    FROM superstore
    GROUP BY customer_id
) sub
GROUP BY repeat_category
ORDER BY customer_count DESC;

-- 6.5 Discount Impact on Profitability
SELECT
    CASE
        WHEN discount = 0     THEN '0% - No Discount'
        WHEN discount <= 0.1  THEN '1-10%'
        WHEN discount <= 0.2  THEN '11-20%'
        WHEN discount <= 0.3  THEN '21-30%'
        WHEN discount <= 0.4  THEN '31-40%'
        ELSE '41-50% - Heavy Discount'
    END AS discount_band,
    COUNT(*) AS order_count,
    ROUND(AVG(sales), 2) AS avg_sales,
    ROUND(AVG(profit), 2) AS avg_profit,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit)/SUM(sales)*100, 2) AS profit_margin_pct
FROM superstore
GROUP BY discount_band
ORDER BY discount_band;

-- 6.6 Seasonal Analysis (Q1-Q4 breakdown)
SELECT
    strftime('%Y', order_date) AS year,
    CASE
        WHEN CAST(strftime('%m', order_date) AS INT) BETWEEN 1 AND 3  THEN 'Q1 (Jan-Mar)'
        WHEN CAST(strftime('%m', order_date) AS INT) BETWEEN 4 AND 6  THEN 'Q2 (Apr-Jun)'
        WHEN CAST(strftime('%m', order_date) AS INT) BETWEEN 7 AND 9  THEN 'Q3 (Jul-Sep)'
        ELSE                                                               'Q4 (Oct-Dec)'
    END AS quarter,
    COUNT(DISTINCT order_id) AS orders,
    ROUND(SUM(sales), 2)     AS total_sales,
    ROUND(SUM(profit), 2)    AS total_profit
FROM superstore
GROUP BY year, quarter
ORDER BY year, quarter;

-- 6.7 Shipping Mode Profitability
SELECT
    ship_mode,
    COUNT(*)                     AS total_orders,
    ROUND(AVG(julianday(ship_date) - julianday(order_date)), 1) AS avg_ship_days,
    ROUND(SUM(sales), 2)         AS total_sales,
    ROUND(SUM(profit), 2)        AS total_profit,
    ROUND(SUM(profit)/SUM(sales)*100, 2) AS margin_pct
FROM superstore
GROUP BY ship_mode
ORDER BY total_sales DESC;

-- 6.8 Region x Category Heatmap (Cross-tab)
SELECT
    region,
    ROUND(SUM(CASE WHEN category='Furniture'       THEN sales ELSE 0 END), 0) AS furniture_sales,
    ROUND(SUM(CASE WHEN category='Office Supplies'  THEN sales ELSE 0 END), 0) AS office_supplies_sales,
    ROUND(SUM(CASE WHEN category='Technology'       THEN sales ELSE 0 END), 0) AS technology_sales,
    ROUND(SUM(sales), 0) AS total_sales
FROM superstore
GROUP BY region
ORDER BY total_sales DESC;

-- 6.9 Profitability by Segment x Region
SELECT
    segment,
    region,
    ROUND(SUM(sales), 2)  AS total_sales,
    ROUND(SUM(profit), 2) AS total_profit,
    ROUND(SUM(profit)/SUM(sales)*100, 2) AS margin_pct
FROM superstore
GROUP BY segment, region
ORDER BY segment, total_profit DESC;

-- 6.10 Sub-categories with Negative Total Profit (Avoid Targets)
SELECT
    category,
    sub_category,
    COUNT(*) AS order_count,
    ROUND(SUM(sales), 2)    AS total_sales,
    ROUND(SUM(profit), 2)   AS total_profit,
    ROUND(AVG(discount)*100,1) AS avg_discount_pct
FROM superstore
GROUP BY category, sub_category
HAVING SUM(profit) < 0
ORDER BY total_profit ASC;

-- 6.11 Days-to-Ship Analysis by Region and Ship Mode
SELECT
    region,
    ship_mode,
    COUNT(*) AS orders,
    ROUND(AVG(julianday(ship_date) - julianday(order_date)), 1) AS avg_days_to_ship,
    MIN(julianday(ship_date) - julianday(order_date)) AS min_days,
    MAX(julianday(ship_date) - julianday(order_date)) AS max_days
FROM superstore
GROUP BY region, ship_mode
ORDER BY region, avg_days_to_ship;


-- ============================================================
-- SECTION 7: DATA QUALITY & VALIDATION
-- ============================================================

-- 7.1 Check for NULL values across all key columns
SELECT
    SUM(CASE WHEN order_id IS NULL OR order_id = ''     THEN 1 ELSE 0 END) AS null_order_ids,
    SUM(CASE WHEN customer_id IS NULL OR customer_id='' THEN 1 ELSE 0 END) AS null_customer_ids,
    SUM(CASE WHEN sales IS NULL OR sales <= 0           THEN 1 ELSE 0 END) AS invalid_sales,
    SUM(CASE WHEN quantity IS NULL OR quantity <= 0     THEN 1 ELSE 0 END) AS invalid_qty,
    SUM(CASE WHEN discount < 0 OR discount > 1          THEN 1 ELSE 0 END) AS invalid_discount,
    SUM(CASE WHEN order_date IS NULL                    THEN 1 ELSE 0 END) AS null_dates,
    SUM(CASE WHEN ship_date < order_date               THEN 1 ELSE 0 END) AS ship_before_order
FROM superstore;

-- 7.2 Duplicate Order-Product combinations
SELECT
    order_id, product_id, COUNT(*) AS duplicate_count
FROM superstore
GROUP BY order_id, product_id
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC
LIMIT 10;

-- 7.3 Outlier detection: extremely high or low sales
SELECT
    'High Sales Outliers (> 3x avg)' AS check_type,
    COUNT(*) AS count,
    ROUND(MIN(sales), 2) AS min_val,
    ROUND(MAX(sales), 2) AS max_val
FROM superstore
WHERE sales > (SELECT 3 * AVG(sales) FROM superstore)
UNION ALL
SELECT
    'Low Sales (< $1)' AS check_type,
    COUNT(*), ROUND(MIN(sales), 2), ROUND(MAX(sales), 2)
FROM superstore
WHERE sales < 1;

-- 7.4 Summary statistics
SELECT
    COUNT(*)                     AS total_rows,
    ROUND(SUM(sales), 2)         AS total_revenue,
    ROUND(SUM(profit), 2)        AS total_profit,
    ROUND(SUM(quantity), 0)      AS total_units,
    ROUND(AVG(sales), 2)         AS avg_order_sales,
    ROUND(AVG(profit), 2)        AS avg_order_profit,
    ROUND(MIN(sales), 2)         AS min_sales,
    ROUND(MAX(sales), 2)         AS max_sales,
    ROUND(SUM(profit)/SUM(sales)*100, 2) AS overall_margin_pct
FROM superstore;

-- 7.5 Records with profit margin below -50%
SELECT
    order_id, product_name, category, sub_category,
    sales, profit, discount,
    ROUND(profit/sales*100, 1) AS margin_pct
FROM superstore
WHERE profit/sales < -0.5
ORDER BY margin_pct ASC
LIMIT 10;

-- ============================================================
-- END OF SCRIPT
-- ============================================================
