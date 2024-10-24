SELECT * FROM cofee_shop_sales

-- CHECKING ALL TYPES
DESCRIBE cofee_shop_sales

--  transaction_date COLUMN IN TEXT CONVERT IT IN DATE DD/MM/YYYY
UPDATE cofee_shop_sales
SET transaction_date =STR_TO_DATE(transaction_date,'%d/%m/%y');

-- APPLYING CHANGES TO TABLE
ALTER TABLE cofee_shop_sales
MODIFY COLUMN transaction_date DATE;

-- CHECKING IF CHANGED OR NOT
DESCRIBE cofee_shop_sales

-- SAME FOR transaction_time TEXT TO TIME
UPDATE cofee_shop_sales
SET transaction_time TIME;

ALTER TABLE cofee_shop_sales
MODIFY COLUMN transaction_time TIME;

-- CHANGING COLUMN NAME I>>?transaction_id TO transaction_id
ALTER TABLE cofee_shop_sales
CHANGE COLUMN I>>?transaction_id transaction_id

-- A TOTAL SALES ANALYSIS
-- 1.CALCULATE THE TOTAL SALES FOR EACH RESPECTIVE MONTH
SELECT ROUND(SUM(unit_price * transaction_qty),1) as Total_Sales 
FROM cofee_shop_sales 
WHERE MONTH(transaction_date) = 5 -- for month of (CM-May)

-- 2.DETERMINE THE MONTH-ON-MONTH INCREASE OR DECRESE IN SALES
SELECT 
    MONTH(transaction_date) AS month,  -- Number of Month
    ROUND(SUM(unit_price * transaction_qty)) AS total_sales,  -- Total Sales Column
    (SUM(unit_price * transaction_qty) - LAG(SUM(unit_price * transaction_qty), 1)  -- Month Sales Difference
    OVER (ORDER BY MONTH(transaction_date))) / LAG(SUM(unit_price * transaction_qty), 1)  -- Percentage
    OVER (ORDER BY MONTH(transaction_date)) * 100 AS month_increase_percentage  -- Percentage Increase
FROM cofee_shop_sales
GROUP BY MONTH(transaction_date)
ORDER BY MONTH(transaction_date);

-- 3.TOTAL QUANTITY SOLD
SELECT SUM(transaction_qty) as Total_Quantity_Sold
FROM cofee_shop_sales 
WHERE MONTH(transaction_date) = 5 -- for month of (CM-May)

-- B Total Order Analysis
-- 4.Calculate the total number of orders for each respective month.
SELECT MONTH (transaction_date) AS month,COUNT(transaction_id) AS Total_orders
FROM cofee_shop_sales
GROUP  BY MONTH (transaction_date) 

-- 5.Determine the month-on-month percentage increase or decrease
SELECT 
    MONTH(transaction_date) AS month,
    ROUND(COUNT(transaction_id)) AS total_orders,
    (COUNT(transaction_id) - LAG(COUNT(transaction_id),1)
    OVER (ORDER BY MONTH(transaction_date))) / LAG(COUNT(transaction_id),1)
    OVER (ORDER BY MONTH(transaction_date)) * 100 AS month_increase_percentage
    FROM cofee_shop_sales
    WHERE MONTH(transaction_date)
    GROUP BY MONTH(transaction_date)

-- C Total Quantity Sold Analysis 
-- 6.1Calculate the total quantity sold for each respective month. With percentage increase or descrease
SELECT MONTH(transaction_date) AS Months, SUM(transaction_qty) AS total_quantity_solds
FROM cofee_shop_sales
GROUP BY MONTH(transaction_date)

-- 6.2With percentage increase or descrease
SELECT 
    MONTH(transaction_date) AS month, 
    ROUND(SUM(transaction_qty)) AS total_quantity_sold,  
    (SUM(transaction_qty) - LAG(SUM(transaction_qty), 1) 
    OVER (ORDER BY MONTH(transaction_date))) / LAG(SUM(transaction_qty), 1)  
    OVER (ORDER BY MONTH(transaction_date)) * 100 AS month_increase_percentage  -- Percentage Increase
FROM cofee_shop_sales
GROUP BY MONTH(transaction_date)
ORDER BY MONTH(transaction_date);

-- D Charts requirements
-- 7.Display detailed metrics (Sales , Orders , Quantity) DAILY 
SELECT
    transaction_date,
    CONCAT(ROUND(SUM(unit_price * transaction_qty)/1000,1),' K') AS Total_sales,
    CONCAT(ROUND(SUM(transaction_qty)/1000,1),' K') AS Total_qty_sold,
    CONCAT(ROUND(COUNT(transaction_qty)/1000,1),' K') AS Total_orders
FROM cofee_shop_sales
GROUP BY transaction_date

-- 8.Sales Analysis by Weekdays and Weekends
SELECT 
    MONTH(transaction_date) AS month,  -- Number of Month
    CASE WHEN DAYOFWEEK(transaction_date) IN (1, 7) THEN 'Weekends'  -- Sunday (1) and Saturday (7)
	ELSE 'Weekdays'  -- All other days
    END AS day_type,
    CONCAT(ROUND(SUM(unit_price * transaction_qty)/1000),' K') AS total_sales  -- Total Sales
FROM cofee_shop_sales
GROUP BY 
    MONTH(transaction_date),  -- Group by each month
    CASE WHEN DAYOFWEEK(transaction_date) IN (1, 7) THEN 'Weekends'
	ELSE 'Weekdays'
    END
ORDER BY MONTH(transaction_date), day_type;


-- 9.Sales Analysis by Store Location
SELECT 
    store_location,  -- MONTH(transaction_date) AS MONTHS IF NEEDED MONTHLY
    CONCAT(ROUND(SUM(unit_price * transaction_qty)/1000,2),' K') AS total_sales
FROM cofee_shop_sales
WHERE MONTH(transaction_date) = 6
GROUP BY store_location -- ,MONTHS

-- 10.Daily Sales Analysis With Average Line
SELECT 
    AVG(total_sales) AS avg_sales
FROM (SELECT SUM(transaction_qty * unit_price) AS total_sales 
     FROM cofee_shop_sales
     WHERE MONTH(transaction_date) = 5
GROUP BY transaction_date) AS Internal_query


SELECT day_of_month,
  CASE
     WHEN total_sales > avg_sales THEN 'Above Average'
     WHEN total_sales < avg_sales THEN 'Below Average'
     ELSE 'Average'
  END AS sales_status,
  total_sales
FROM (
  SELECT 
		DAY(transaction_date) AS day_of_month,
        SUM(unit_price * transaction_qty) AS total_sales,
        AVG(SUM(unit_price * transaction_qty)) OVER () AS avg_sales
  FROM cofee_shop_sales
  WHERE MONTH(transaction_date) = 5
  GROUP BY DAY(transaction_date)
  ) AS sales_data
  ORDER BY day_of_month;
     
-- 11.Sales Analysis by Product Category:
SELECT 
    product_category,
    ROUND(SUM(unit_price * transaction_qty)/1000,5) AS total_sales_in_k
FROM cofee_shop_sales
WHERE MONTH(transaction_date) = 5
GROUP BY product_category
ORDER BY total_sales_in_k DESC

-- 12.Top 10 products by sales
SELECT 
    product_type,
    ROUND(SUM(unit_price * transaction_qty)/1000,2) AS total_sales_in_k
FROM cofee_shop_sales
WHERE MONTH(transaction_date) = 5 -- AND product_category ='Coffee'
GROUP BY product_type
ORDER BY total_sales_in_k DESC
LIMIT 10

-- 13.Sales Analysis by Day and Hour
SELECT 
    ROUND(SUM(unit_price * transaction_qty)/1000,2) AS total_sales_in_k,
    SUM(transaction_qty) AS total_qty_sold,
    COUNT(*)
FROM cofee_shop_sales
WHERE MONTH(transaction_date) = 5 -- 5 IS MAY ,AND product_category ='Coffee'
AND DAYOFWEEK(transaction_date) = 2 -- MONDAY
AND HOUR(transaction_time) = 8 -- HOUR 8

-- 14.Sales Analysis by Hour
SELECT 
    HOUR(transaction_time),
    ROUND(SUM(unit_price * transaction_qty)/1000,2) AS total_sales_in_k
FROM cofee_shop_sales
WHERE MONTH(transaction_time)
GROUP BY HOUR(transaction_time) 
ORDER BY HOUR(transaction_time) 

-- 15.The total sales for each day of the week for the selected month
SELECT 
    CASE 
        WHEN DAYOFWEEK(transaction_date) = 2 THEN 'Monday'
        WHEN DAYOFWEEK(transaction_date) = 3 THEN 'Tuesday'
        WHEN DAYOFWEEK(transaction_date) = 4 THEN 'Wednesday'
        WHEN DAYOFWEEK(transaction_date) = 5 THEN 'Thursday'
        WHEN DAYOFWEEK(transaction_date) = 6 THEN 'Friday'
        WHEN DAYOFWEEK(transaction_date) = 7 THEN 'Saturday'
        ELSE 'Sunday'
    END AS Day_of_Week,
    ROUND(SUM(unit_price * transaction_qty)) AS Total_Sales
FROM 
    cofee_shop_sales
WHERE 
    MONTH(transaction_date) = 5 -- Filter for May (month number 5)
GROUP BY Day_of_Week



























