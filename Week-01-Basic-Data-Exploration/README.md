# Week 01 — Basic Data Exploration and Cleaning using Pandas

## 📌 Objective
Learn Python basics and perform basic data exploration and cleaning using Pandas.

## 📂 Dataset
**Ecommerce Shopping Dataset** — 1000+ products with pricing, ratings, seller info, and more.  
Source: [Kaggle – anvitkumar/shopping-dataset](https://www.kaggle.com/datasets/anvitkumar/shopping-dataset)

## ✅ Steps Performed

1. Loaded `ecommerce_dataset.csv` into a Pandas DataFrame
2. Explored the data — shape, columns, data types, head/tail
3. Identified and handled missing values (fill/drop)
4. Performed basic operations — filtered rows, selected columns
5. Removed duplicate entries
6. Created a derived column: `total_amount = initial_price * ratings_count`
7. Saved the cleaned dataset as `ecommerce_cleaned.csv`

## 📤 Output Files

| File | Description |
|------|-------------|
| `notebook.ipynb` | Jupyter Notebook with all steps and explanations |
| `ecommerce_cleaned.csv` | Cleaned version of the dataset |

## 🔍 Key Findings

- Dataset contains **1000+ products** across multiple categories
- Several columns had missing values — primarily `sizes`, `videos`, and `delivery_options`
- After cleaning, duplicates were removed and the dataset was standardized
- `total_amount` derived column added for potential revenue analysis