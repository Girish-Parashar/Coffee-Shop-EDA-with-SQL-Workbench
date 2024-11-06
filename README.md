<p align="center">
  <img src="https://github.com/Girish-Parashar/Coffee-Shop-EDA-with-SQL-Workbench/blob/main/mysql.png" alt="MySQL Image">
</p>


# Coffee Shop EDA with SQL Workbench

## Project Overview
This project involves conducting exploratory data analysis (EDA) on a coffee shop's sales data using SQL Workbench. The goal is to derive meaningful insights from the transactional data by performing SQL queries on various metrics like total sales, total orders, quantity sold, and more.

## Dataset
The dataset used in this project is `cofee_shop_sales`, which contains details of sales transactions. The columns include:
- `transaction_id`: Unique identifier for each transaction.
- `transaction_date`: Date of the transaction (converted to `DATE` format).
- `transaction_time`: Time of the transaction (converted to `TIME` format).
- `store_location`: The location of the coffee shop.
- `product_category`: The category of the product sold.
- `product_type`: The specific product sold.
- `unit_price`: Price of a single unit.
- `transaction_qty`: Quantity of units sold in a transaction.

## SQL Analysis and Queries
Below is a summary of the key SQL queries used for the analysis:

### 1. Data Transformation
- **Converting `transaction_date` to `DATE` format**:
  ```sql
  UPDATE cofee_shop_sales
  SET transaction_date = STR_TO_DATE(transaction_date,'%d/%m/%y');
  
  ALTER TABLE cofee_shop_sales
  MODIFY COLUMN transaction_date DATE;

- **Converting transaction_time to TIME format:**:
  ```sql
  UPDATE cofee_shop_sales
  SET transaction_time = STR_TO_DATE(transaction_time,'%H:%i:%s');
  
  ALTER TABLE cofee_shop_sales
  MODIFY COLUMN transaction_time TIME;

### 2. Sales Analysis
- **Calculate total sales for each respective month:**:
  ```sql
    SELECT ROUND(SUM(unit_price * transaction_qty), 1) AS Total_Sales 
    FROM cofee_shop_sales 
    WHERE MONTH(transaction_date) = 5;

- **Month-on-month percentage increase or decrease in sales:**:
  ```sql
    SELECT 
        MONTH(transaction_date) AS month,
        ROUND(SUM(unit_price * transaction_qty)) AS total_sales,
        (SUM(unit_price * transaction_qty) - LAG(SUM(unit_price * transaction_qty), 1)  
        OVER (ORDER BY MONTH(transaction_date))) / LAG(SUM(unit_price * transaction_qty), 1)  
        OVER (ORDER BY MONTH(transaction_date)) * 100 AS month_increase_percentage
    FROM cofee_shop_sales
    GROUP BY MONTH(transaction_date)
    ORDER BY MONTH(transaction_date);

### 3. Total Quantity Sold
- **Total quantity sold for a specific month:**:
  ```sql
    SELECT SUM(transaction_qty) AS Total_Quantity_Sold
    FROM cofee_shop_sales 
    WHERE MONTH(transaction_date) = 5;

### 4. Total Orders Analysis
- **Calculate total number of orders for each respective month:**:
  ```sql
    SELECT MONTH(transaction_date) AS month, COUNT(transaction_id) AS Total_orders
    FROM cofee_shop_sales
    GROUP BY MONTH(transaction_date);

### 5. Sales by Weekdays and Weekends
- **Sales analysis by day type (weekdays vs weekends):**:
  ```sql
    SELECT 
        CASE WHEN DAYOFWEEK(transaction_date) IN (1, 7) THEN 'Weekends'
        ELSE 'Weekdays' END AS day_type,
        ROUND(SUM(unit_price * transaction_qty)/1000, 1) AS total_sales
    FROM cofee_shop_sales
    GROUP BY day_type;

### 6. Top Products by Sales
- **Top 10 products by sales for a selected month:**:
  ```sql
    SELECT product_type, 
        ROUND(SUM(unit_price * transaction_qty)/1000, 2) AS total_sales_in_k
    FROM cofee_shop_sales
    WHERE MONTH(transaction_date) = 5
    GROUP BY product_type
    ORDER BY total_sales_in_k DESC
    LIMIT 10;

### 7. Sales Analysis by Hour
- **Sales by hour of the day:**:
  ```sql
    SELECT HOUR(transaction_time) AS hour, 
        ROUND(SUM(unit_price * transaction_qty)/1000, 2) AS total_sales_in_k
    FROM cofee_shop_sales
    GROUP BY HOUR(transaction_time)
    ORDER BY HOUR(transaction_time);


## Documentation
Detailed documentation regarding the project, SQL queries, and analysis can be found in the document linked below:

- [Coffee Shop EDA Documentation](https://github.com/Girish-Parashar/Coffee-Shop-EDA-with-SQL-Workbench/blob/main/SQL%20WORKBENCH%20%20PROJECTS/coffee_doc.docx)

## Insights
- Month-on-month sales analysis showed seasonal variations with significant increases in certain months.
- Top products by sales gave an overview of which products were the most popular among customers.
- Sales by weekdays and weekends highlighted differences in customer behavior on different days of the week.

## Future Work
- Perform more advanced analytics such as customer segmentation.
- Add visualizations to further enhance the EDA.

## How to Run
1. Clone this repository.
2. Import the `cofee_shop_sales` dataset into your SQL Workbench.
3. Run the SQL queries provided in the [SQL codes file](https://github.com/Girish-Parashar/Coffee-Shop-EDA-with-SQL-Workbench/blob/main/SQL%20WORKBENCH%20%20PROJECTS/coffee_code.sql).

  
  
