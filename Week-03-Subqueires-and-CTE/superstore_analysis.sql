-- ============================================================
-- CEI Internship - Week 3: SQL Advanced Analysis
-- Superstore Dataset: Subqueries, CTEs & Window Functions
-- ============================================================


-- ============================================================
-- STEP 1: SETUP — Create Raw Table & Normalized Tables
-- ============================================================

-- 1.1 Drop tables if they already exist (for re-runs)
DROP TABLE IF EXISTS superstore_raw;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS products;


-- 1.2 Create raw staging table
CREATE TABLE superstore_raw (
    row_id        INTEGER,
    order_id      TEXT,
    order_date    TEXT,
    ship_date     TEXT,
    ship_mode     TEXT,
    customer_id   TEXT,
    customer_name TEXT,
    segment       TEXT,
    country       TEXT,
    city          TEXT,
    state         TEXT,
    postal_code   TEXT,
    region        TEXT,
    product_id    TEXT,
    category      TEXT,
    sub_category  TEXT,
    product_name  TEXT,
    sales         REAL,
    quantity      INTEGER,
    discount      REAL,
    profit        REAL
);

-- 1.3 Create normalized tables

CREATE TABLE customers (
    customer_id   TEXT PRIMARY KEY,
    customer_name TEXT,
    segment       TEXT,
    country       TEXT,
    city          TEXT,
    state         TEXT,
    postal_code   TEXT,
    region        TEXT
);

CREATE TABLE products (
    product_id   TEXT PRIMARY KEY,
    product_name TEXT,
    category     TEXT,
    sub_category TEXT
);

CREATE TABLE orders (
    row_id      INTEGER PRIMARY KEY,
    order_id    TEXT,
    order_date  TEXT,
    ship_date   TEXT,
    ship_mode   TEXT,
    customer_id TEXT,
    product_id  TEXT,
    sales       REAL,
    quantity    INTEGER,
    discount    REAL,
    profit      REAL,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id)  REFERENCES products(product_id)
);


-- 1.4 Insert data using SELECT DISTINCT

INSERT INTO customers (customer_id, customer_name, segment, country, city, state, postal_code, region)
SELECT DISTINCT
    customer_id,
    customer_name,
    segment,
    country,
    city,
    state,
    postal_code,
    region
FROM superstore_raw;

INSERT INTO products (product_id, product_name, category, sub_category)
SELECT DISTINCT
    product_id,
    product_name,
    category,
    sub_category
FROM superstore_raw;

INSERT INTO orders (row_id, order_id, order_date, ship_date, ship_mode, customer_id, product_id, sales, quantity, discount, profit)
SELECT
    row_id,
    order_id,
    order_date,
    ship_date,
    ship_mode,
    customer_id,
    product_id,
    sales,
    quantity,
    discount,
    profit
FROM superstore_raw;


-- ============================================================
-- STEP 2: REQUIRED QUERIES
-- ============================================================


-- -----------------------------------------------------------
-- Q1: Orders where sales > average sales  [Subquery]
-- -----------------------------------------------------------
-- Business insight: Identifies high-value transactions above the mean.
SELECT
    o.order_id,
    c.customer_name,
    p.product_name,
    o.sales
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
JOIN products  p ON o.product_id  = p.product_id
WHERE o.sales > (
    SELECT AVG(sales)
    FROM orders
)
ORDER BY o.sales DESC;


-- -----------------------------------------------------------
-- Q2: Highest sales order for each customer  [Subquery]
-- -----------------------------------------------------------
-- Business insight: Pinpoints the single largest purchase per customer.
SELECT
    c.customer_name,
    o.order_id,
    o.sales AS max_order_sales
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
WHERE o.sales = (
    SELECT MAX(o2.sales)
    FROM orders o2
    WHERE o2.customer_id = o.customer_id
)
ORDER BY o.sales DESC;


-- -----------------------------------------------------------
-- Q3: Total sales per customer  [CTE]
-- -----------------------------------------------------------
-- Business insight: Provides a ranked view of customer revenue contribution.
WITH customer_sales AS (
    SELECT
        o.customer_id,
        c.customer_name,
        ROUND(SUM(o.sales), 2) AS total_sales
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    GROUP BY o.customer_id, c.customer_name
)
SELECT *
FROM customer_sales
ORDER BY total_sales DESC;


-- -----------------------------------------------------------
-- Q4: Customers with above-average total sales  [CTE + Subquery]
-- -----------------------------------------------------------
-- Business insight: Segments high-value customers for loyalty programs.
WITH customer_sales AS (
    SELECT
        o.customer_id,
        c.customer_name,
        ROUND(SUM(o.sales), 2) AS total_sales
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    GROUP BY o.customer_id, c.customer_name
)
SELECT
    customer_id,
    customer_name,
    total_sales
FROM customer_sales
WHERE total_sales > (
    SELECT AVG(total_sales) FROM customer_sales
)
ORDER BY total_sales DESC;


-- -----------------------------------------------------------
-- Q5: Rank all customers by total sales  [Window Function]
-- -----------------------------------------------------------
-- Business insight: Clear competitive ranking to identify VIP tiers.
WITH customer_sales AS (
    SELECT
        o.customer_id,
        c.customer_name,
        ROUND(SUM(o.sales), 2) AS total_sales
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    GROUP BY o.customer_id, c.customer_name
)
SELECT
    customer_name,
    total_sales,
    RANK()       OVER (ORDER BY total_sales DESC) AS sales_rank,
    DENSE_RANK() OVER (ORDER BY total_sales DESC) AS dense_rank
FROM customer_sales
ORDER BY sales_rank;


-- -----------------------------------------------------------
-- Q6: Row number per order within each customer  [Window Function + PARTITION BY]
-- -----------------------------------------------------------
-- Business insight: Tracks ordering history sequence per customer.
SELECT
    c.customer_name,
    o.order_id,
    o.order_date,
    ROUND(o.sales, 2) AS sales,
    ROW_NUMBER() OVER (
        PARTITION BY o.customer_id
        ORDER BY o.order_date ASC
    ) AS order_sequence
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
ORDER BY c.customer_name, order_sequence;


-- -----------------------------------------------------------
-- Q7: Top 3 customers by total sales  [Window Function]
-- -----------------------------------------------------------
-- Business insight: Quick identification of the highest-revenue accounts.
WITH customer_sales AS (
    SELECT
        o.customer_id,
        c.customer_name,
        ROUND(SUM(o.sales), 2) AS total_sales
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    GROUP BY o.customer_id, c.customer_name
),
ranked AS (
    SELECT
        customer_name,
        total_sales,
        RANK() OVER (ORDER BY total_sales DESC) AS rnk
    FROM customer_sales
)
SELECT customer_name, total_sales, rnk
FROM ranked
WHERE rnk <= 3;


-- ============================================================
-- STEP 3: FINAL COMBINED QUERY
-- Customer Name | Total Sales | Rank
-- (JOIN + CTE + Window Function)
-- ============================================================

WITH customer_sales AS (
    -- Aggregate sales per customer
    SELECT
        o.customer_id,
        c.customer_name,
        c.segment,
        c.region,
        ROUND(SUM(o.sales), 2)   AS total_sales,
        COUNT(DISTINCT o.order_id) AS total_orders,
        ROUND(AVG(o.sales), 2)   AS avg_order_value
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    GROUP BY o.customer_id, c.customer_name, c.segment, c.region
),
ranked_customers AS (
    -- Apply window function for ranking
    SELECT
        customer_name,
        segment,
        region,
        total_sales,
        total_orders,
        avg_order_value,
        RANK()       OVER (ORDER BY total_sales DESC) AS overall_rank,
        RANK()       OVER (PARTITION BY segment ORDER BY total_sales DESC) AS segment_rank
    FROM customer_sales
)
SELECT
    overall_rank  AS rank,
    customer_name,
    segment,
    region,
    total_sales,
    total_orders,
    avg_order_value,
    segment_rank
FROM ranked_customers
ORDER BY overall_rank;


-- ============================================================
-- MINI PROJECT: Customer Sales Insights
-- ============================================================


-- -----------------------------------------------------------
-- MI-1: Top 5 Customers
-- -----------------------------------------------------------
WITH customer_sales AS (
    SELECT
        c.customer_name,
        c.segment,
        c.region,
        ROUND(SUM(o.sales), 2) AS total_sales
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    GROUP BY o.customer_id, c.customer_name, c.segment, c.region
)
SELECT
    RANK() OVER (ORDER BY total_sales DESC) AS rank,
    customer_name,
    segment,
    region,
    total_sales
FROM customer_sales
ORDER BY total_sales DESC
LIMIT 5;


-- -----------------------------------------------------------
-- MI-2: Bottom 5 Customers
-- -----------------------------------------------------------
WITH customer_sales AS (
    SELECT
        c.customer_name,
        c.segment,
        c.region,
        ROUND(SUM(o.sales), 2) AS total_sales
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    GROUP BY o.customer_id, c.customer_name, c.segment, c.region
)
SELECT
    RANK() OVER (ORDER BY total_sales ASC) AS rank,
    customer_name,
    segment,
    region,
    total_sales
FROM customer_sales
ORDER BY total_sales ASC
LIMIT 5;


-- -----------------------------------------------------------
-- MI-3: Customers with only one order
-- -----------------------------------------------------------
SELECT
    c.customer_name,
    c.segment,
    COUNT(DISTINCT o.order_id) AS order_count
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
GROUP BY o.customer_id, c.customer_name, c.segment
HAVING COUNT(DISTINCT o.order_id) = 1
ORDER BY c.customer_name;


-- -----------------------------------------------------------
-- MI-4: Customers with above-average total sales
-- -----------------------------------------------------------
WITH customer_sales AS (
    SELECT
        c.customer_id,
        c.customer_name,
        c.segment,
        ROUND(SUM(o.sales), 2) AS total_sales
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    GROUP BY c.customer_id, c.customer_name, c.segment
),
avg_sales AS (
    SELECT ROUND(AVG(total_sales), 2) AS avg_total
    FROM customer_sales
)
SELECT
    cs.customer_name,
    cs.segment,
    cs.total_sales,
    av.avg_total                                   AS overall_avg,
    ROUND(cs.total_sales - av.avg_total, 2)        AS above_avg_by
FROM customer_sales cs
CROSS JOIN avg_sales av
WHERE cs.total_sales > av.avg_total
ORDER BY cs.total_sales DESC;


-- -----------------------------------------------------------
-- MI-5: Highest order value per customer
-- -----------------------------------------------------------
WITH order_totals AS (
    -- Sum sales at order level (orders can have multiple line items)
    SELECT
        o.customer_id,
        o.order_id,
        o.order_date,
        ROUND(SUM(o.sales), 2) AS order_total
    FROM orders o
    GROUP BY o.customer_id, o.order_id, o.order_date
),
ranked_orders AS (
    SELECT
        customer_id,
        order_id,
        order_date,
        order_total,
        RANK() OVER (PARTITION BY customer_id ORDER BY order_total DESC) AS rnk
    FROM order_totals
)
SELECT
    c.customer_name,
    c.segment,
    r.order_id,
    r.order_date,
    r.order_total AS highest_order_value
FROM ranked_orders r
JOIN customers c ON r.customer_id = c.customer_id
WHERE r.rnk = 1
ORDER BY r.order_total DESC;


-- ============================================================
-- END OF SCRIPT
-- ============================================================