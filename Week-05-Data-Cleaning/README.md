# Week 5 Assignment — Apache Spark Fundamentals & DataFrame Processing

**Celebal Technologies — CEI Internship | Data Engineer Track**
**Submitted by:** Mega Robot

## Objective

Understand Spark fundamentals and perform data cleaning, transformation, and aggregation using
DataFrames — covering MapReduce limitations, Spark's in-memory advantage, DataFrame immutability,
null and duplicate handling, filtering, groupBy and aggregation, wide transformations and shuffle,
schema modification, and a complete cleaning + aggregation pipeline.

## Contents

| File | Description |
|---|---|
| `Week5_Spark_Assignment.ipynb` | All 15 questions, each with a written explanation followed by runnable, executed PySpark code and its output. |
| `sales_data.csv` | Sample sales dataset (2,185 rows) with intentional duplicates, null values, and blank fields, used to demonstrate data cleaning at a realistic scale. |
| `README.md` | This file. |

## Topics covered

- MapReduce limitations vs. Spark's in-memory advantage
- DataFrame immutability and its effect on cleaning operations
- Removing duplicate rows and handling null values (`dropDuplicates`, `na.drop`, `na.fill`)
- Filtering on multiple conditions (range, category, region)
- Aggregations (`count`, `sum`, `avg`, `min`, `max`) using `.agg()`
- `groupBy` with post-aggregation filtering (HAVING-style conditions)
- Wide transformations and the shuffle process
- Schema modification: casting and renaming columns
- Handling inconsistent/messy data and schema inference risks
- A complete end-to-end cleaning and aggregation pipeline

## How to run

```bash
pip install pyspark jupyter
jupyter nbconvert --to notebook --execute --inplace Week5_Spark_Assignment.ipynb
```

Or open `Week5_Spark_Assignment.ipynb` directly in Jupyter, VS Code, or Google Colab and
run all cells in order. Requires Python 3.x, PySpark, and Java 8+.

## Environment

- PySpark 4.1.2
- Python 3.12
- Spark master: `local[*]`