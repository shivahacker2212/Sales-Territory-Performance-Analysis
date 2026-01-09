📌 Project Overview
This project focuses on analyzing sales performance across different territories to help business stakeholders understand revenue distribution, sales trends, and territory effectiveness.
Using a SQL Server sample sales database, raw sales data was extracted, cleaned, and aggregated with production-quality SQL queries. The processed data was then visualized in Tableau Desktop to create an interactive dashboard showcasing key sales KPIs by territory.
🛠️ Technologies Used
SQL Server – Data extraction, cleaning, transformation, and aggregation
Tableau Desktop – Data visualization and interactive dashboard creation
🎯 Key Objectives
Analyze sales performance by territory
Clean and standardize raw sales data
Identify top and bottom performing territories
Track sales trends over time
Deliver actionable insights through interactive dashboards
🗂️ Dataset
Source: SQL Server Sample Sales Database
Data Type: Transaction-level sales data
Key Fields:
Order ID
Order Date
Territory
Product
Sales Amount
Quantity
🔍 Data Exploration & Cleaning (SQL Server)
Data Cleaning Tasks:
Handled missing values in sales amount, territory, and date columns
Standardized inconsistent territory names (case, spelling, nulls)
Identified and removed duplicate records
Ensured data accuracy before analysis
Example SQL Operations:
GROUP BY, HAVING
JOINs (if multiple tables)
Date functions for time-based analysis
Aggregations for KPI calculations
📈 Sales Analysis Performed
Key Metrics:
Total Revenue by Territory
Monthly & Quarterly Sales Trends
Average Order Value per Territory
Top and Bottom Performing Territories
SQL Outputs:
Territory-wise aggregated revenue
Time-based sales summaries
Tableau-ready views for visualization
📊 Tableau Dashboard
Dashboard Components:
KPIs:
Total Sales Revenue
Total Orders
Average Order Value
Best Performing Territory
Visualizations:
Bar Chart: Revenue by Territory
Line Chart: Monthly Sales Trend
Heatmap: Territory Performance Comparison
