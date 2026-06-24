# Retail Analytics Case Study

## Project Overview

In the rapidly evolving retail industry, businesses rely on data-driven insights to improve sales performance, customer engagement, and inventory management. This project analyzes retail sales transactions, customer profiles, and product inventory data to uncover actionable business insights and support strategic decision-making.

The analysis was performed using **SQL**, **Python**, and **Power BI** to identify product performance trends, customer purchasing behavior, customer segmentation, and revenue growth opportunities.

---

## Business Problem

The retail company has experienced stagnant growth and declining customer engagement. Management seeks to understand:

* Which products are driving revenue and which are underperforming.
* How customers can be segmented for targeted marketing.
* Customer purchasing patterns and loyalty indicators.
* Inventory risks related to high-demand products.
* Opportunities to improve customer retention and business growth.

---

## Project Objectives

* Perform data cleaning and exploratory data analysis.
* Analyze sales and revenue performance.
* Identify top and low-performing products.
* Segment customers based on purchasing behavior.
* Measure customer loyalty and repeat purchase behavior.
* Generate business recommendations using data-driven insights.
* Build an interactive Power BI dashboard for executive reporting.

---

## Dataset Information

### Sales Transaction

Contains transactional sales data including:

* Transaction ID
* Customer ID
* Product ID
* Quantity Purchased
* Transaction Date
* Price

### Customer Profiles

Contains customer information including:

* Customer ID
* Age
* Gender
* Location
* Join Date

### Product Inventory

Contains inventory information including:

* Product ID
* Product Name
* Category
* Stock Level
* Price

---

## Tools & Technologies

* SQL (MySQL)
* Python (Pandas, NumPy, Matplotlib, Seaborn)
* Power BI
* Git & GitHub

---

## Business Questions Answered

### Sales Performance

1. Total Revenue, Quantity Sold, and Transactions
2. Month-over-Month Revenue Growth
3. Highest and Lowest Revenue Months

### Product Performance

4. Top 10 Products by Revenue
5. Bottom 10 Products by Units Sold
6. Revenue Contribution by Product Category
7. Products with High Sales Volume but Low Stock Levels

### Customer Analysis

8. Transactions Made by Each Customer
9. Top 10 Customers by Total Spending
10. Customers with Lowest Purchasing Activity
11. Average Order Value (AOV)

### Customer Loyalty

12. Percentage of Repeat Customers
13. Duration Between First and Last Purchase

### Customer Segmentation

14. Customers Registered but Never Purchased
15. Customer Segmentation Based on Quantity Purchased

| Total Quantity Purchased | Segment    |
| ------------------------ | ---------- |
| 0                        | No Orders  |
| 1 – 10                   | Low Value  |
| 11 – 30                  | Mid Value  |
| > 30                     | High Value |

---

## Power BI Dashboard

### Executive Summary Dashboard

#### KPI Cards

* Total Revenue
* Total Transactions
* Total Quantity Sold
* Average Order Value (AOV)
* Repeat Customer Percentage

#### Visualizations

* Revenue Trend Analysis
* Top 10 Products by Revenue
* Revenue Contribution by Category
* Customer Segmentation Analysis
* Top Customers by Spending
* High Sales & Low Stock Products
* Customers with No Purchases

---

## Key Insights

* A small number of products contribute a significant portion of total revenue.
* Certain product categories consistently outperform others.
* Repeat customers generate a substantial share of total sales.
* High-value customers contribute disproportionately to overall revenue.
* Several products face inventory shortage risks due to strong demand.
* A segment of registered customers has never completed a purchase.

---

## Business Recommendations

* Increase inventory levels for high-demand products.
* Focus marketing campaigns on top-performing product categories.
* Launch customer retention programs for repeat customers.
* Develop re-engagement campaigns for inactive customers.
* Introduce loyalty rewards for high-value customer segments.
* Review pricing and promotion strategies for underperforming products.
* Monitor stock levels proactively to avoid lost sales opportunities.

---

## Repository Structure

```text
Retail-Analytics-Case-Study/
│
├── Dataset/
├── SQL Queries/
├── Python Analysis/
├── Power BI Dashboard/
├── Reports/
├── Images/
└── README.md
```

---

## Author

Retail Analytics Case Study developed as an end-to-end Data Analytics project demonstrating skills in:

* SQL
* Data Analysis
* Data Visualization
* Business Intelligence
* Power BI Dashboard Development
