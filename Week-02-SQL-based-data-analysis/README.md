# 🛒 Superstore Sales Analysis — SQL + Python
### Celebal Technologies Data Science Internship | Week 2 Assignment

<p align="center">
  <img src="visualizations/dashboard_overview.png" alt="Sales Dashboard" width="900"/>
</p>

---

## 📌 Objective

Analyze the **Superstore Giant** dataset to surface actionable business insights using:
- SQL (via SQLite in-memory) for filtering, aggregation, and business queries
- Python (pandas, matplotlib, seaborn) for visualizations
- Scikit-learn for Regression modeling (Linear, Random Forest, Gradient Boosting)

> **Business Question:** Which products, regions, categories, and customer segments should the company target or avoid?

---

## 📁 Project Structure

```
superstore_analysis/
│
├── data/
│   └── superstore.csv            # Source dataset (download from Kaggle)
│
├── sql/
│   └── superstore_analysis.sql   # Full SQL script (7 sections, 30+ queries)
│
├── notebooks/
│   └── superstore_analysis.ipynb # Jupyter Notebook — end-to-end walkthrough
│
├── outputs/                      # CSV exports from every SQL query
│   ├── overview.csv
│   ├── region.csv
│   ├── category.csv
│   ├── subcat.csv
│   ├── segment.csv
│   ├── top_customers.csv
│   ├── monthly.csv
│   ├── yearly.csv
│   ├── discount_impact.csv
│   ├── ship_mode.csv
│   ├── top_products.csv
│   ├── loss_products.csv
│   ├── dq.csv
│   ├── model_sales.csv           # Regression results — Sales
│   └── model_profit.csv          # Regression results — Profit
│
├── visualizations/
│   ├── dashboard_overview.png    # Main KPI & trend dashboard
│   ├── advanced_analytics.png    # Heatmap, scatter, geographic
│   └── regression_models.png     # Model comparison & feature importance
│
└── README.md
```

---

## 📊 Dataset

| Field | Description |
|-------|-------------|
| **Source** | [Kaggle — Superstore Dataset](https://www.kaggle.com/datasets/vivek468/superstore-dataset-final) |
| **Rows** | 9,994 |
| **Columns** | 21 |
| **Period** | January 2014 – December 2017 |
| **Country** | United States |

> **Download:** Place `Sample - Superstore.csv` in the `data/` folder and rename to `superstore.csv`.

---

## 🗄️ SQL Script Overview (`sql/superstore_analysis.sql`)

| Section | Description | Queries |
|---------|-------------|---------|
| 1 | Database Setup & Data Loading | `CREATE TABLE`, import notes |
| 2 | Schema Exploration | Row count, date range, distinct values, ship mode stats |
| 3 | WHERE Filters | Region, category, date range, high-value orders, loss-makers |
| 4 | GROUP BY Aggregations | Region, category, sub-category, segment, state |
| 5 | Sort & Limit (Top N) | Top 10 products/categories by sales & profit |
| 6 | Business Use Cases | Monthly trends, YoY growth, top customers, discount impact, seasonality |
| 7 | Data Quality Validation | NULL checks, duplicate detection, outlier flagging |

---

## 📓 Notebook Walkthrough (`notebooks/superstore_analysis.ipynb`)

1. **Setup** — Libraries, SQLite connection
2. **Load Data** — CSV → DataFrame → SQLite
3. **Schema Exploration** — dtypes, sample rows, distinct counts
4. **WHERE Filters** — Targeted SQL queries with display output
5. **GROUP BY Aggregations** — Region, category, segment, cross-tab pivot
6. **Top N Analysis** — Top/bottom products, cities, states
7. **Business Use Cases** — Monthly trends (chart), discount impact (chart), top customers, seasonal analysis
8. **Data Quality** — Null checks, summary statistics
9. **Regression Models** — Feature engineering, model training, Actual vs Predicted, residuals
10. **Business Insights** — Summary table with actionable recommendations

---

## 📈 Key Business Insights

### ✅ What to Target
| Area | Finding |
|------|---------|
| **Technology** | Highest revenue ($5.98M) + 14.4% margin → Prioritize |
| **Office Supplies** | Best profit margin (20.3%) → Efficient category |
| **Home Office Segment** | Top revenue ($4.5M) → Primary B2C focus |
| **West & East Regions** | ~$3.3M each → Core market |
| **Copiers, Phones, Accessories** | Top-profit sub-categories → Premium positioning |

### ❌ What to Avoid / Fix
| Area | Problem |
|------|---------|
| **Discounts > 30%** | Profit margin turns **negative** (-3% to -11%) |
| **Tables Sub-category** | High volume, only ~9.8% margin → repricing needed |
| **Heavy-discount SKUs** | Destroying margin; review per-SKU discount policy |

### 💡 Growth Levers
- **Q4 Spike**: Revenue peaks every Q4 → pre-build inventory by September
- **Loyalty Program**: Customers with 10+ orders are highest LTV — invest in retention
- **Same Day Shipping**: Highest profit margin (14%) among ship modes → promote this tier
- **Corporate Segment**: Second highest profit ($580K) with fewer customers — upsell opportunity

---

## 🤖 Regression Results

| Target | Model | R² | RMSE | MAE |
|--------|-------|----|------|-----|
| Sales  | Linear Regression   | 0.01 | 944  | 811 |
| Sales  | Random Forest       | 0.22 | 837  | 662 |
| Sales  | **Gradient Boosting** | **0.28** | **804** | **641** |
| Profit | Linear Regression   | 0.50 | 191  | 142 |
| Profit | Random Forest       | 0.55 | 181  | 125 |
| Profit | **Gradient Boosting** | **0.59** | **172** | **120** |

**Key finding:** Profit is more predictable (R²=0.59) than Sales (R²=0.28). Discount and Category are the strongest predictors of profitability.

---

## 🚀 How to Run

### Requirements
```bash
pip install pandas numpy matplotlib seaborn scikit-learn nbformat jupyter sqlite3
```

### Steps
```bash
# 1. Clone the repository
git clone https://github.com/YOUR_USERNAME/celebal-week2-superstore.git
cd celebal-week2-superstore

# 2. Place dataset
# Download from Kaggle and save as: data/superstore.csv

# 3. Run the notebook
jupyter notebook notebooks/superstore_analysis.ipynb

# 4. Or run SQL queries directly in any SQLite client
# Load data first, then execute: sql/superstore_analysis.sql
```

---

## 🛠️ Tech Stack

| Tool | Purpose |
|------|---------|
| Python 3.10+ | Core analysis language |
| pandas | Data manipulation |
| SQLite3 | In-memory SQL engine |
| matplotlib / seaborn | Visualizations |
| scikit-learn | Regression modeling |
| Jupyter | Interactive notebook |

---

## 📜 License & Credits

- Dataset: [Tableau Community](https://community.tableau.com/) via Kaggle (vivek468) — Educational use only
- Assignment: [Celebal Technologies LMS](https://celebaltech.sharepoint.com)
- Author: *[Your Name]* | Celebal Tech Data Science Internship 2025

---

<p align="center">Made with ❤️ for Celebal Technologies Week 2 Assignment</p>
