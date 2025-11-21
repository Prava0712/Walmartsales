# Project Title: Walmart Sales Analysis
# Sales Performance Analysis of Walmart Stores Using Advanced MySQL Techniques
Introduction:
Walmart, a major retail chain, operates across several cities, offering a wide range of products. The dataset
provided contains detailed transaction data, including customer demographics, product lines, sales figures, and
payment methods. This project will use advanced SQL techniques to uncover actionable insights into sales
performance, customer behavior, and operational efficiencies.
Business Problem:
Walmart wants to optimize its sales strategies by analyzing historical transaction data across branches,
customer types, payment methods, and product lines. To achieve this, advanced MySQL queries will be
employed to answer challenging business questions related to sales performance, customer segmentation, and
product trends.
# Task 1: Identifying the Top Branch by Sales Growth Rate 
/* Walmart wants to identify which branch has exhibited the highest sales growth over time. Analyze the total sales
for each branch and compare the growth rate across months to find the top performer. */

#use walmartsales;
select * from walmartsales;

WITH MonthlySales AS (
    SELECT  Branch, Date AS sale_month, SUM(Total) AS MonthlyTotalSales
    FROM walmartsales
    GROUP BY 
        Branch, sale_month
),
SalesWithLag AS (
    SELECT Branch, sale_month, MonthlyTotalSales,
        LAG(MonthlyTotalSales) OVER (PARTITION BY Branch ORDER BY sale_month) AS PrevMonthSales
    FROM MonthlySales
),
GrowthRates AS (
    SELECT Branch, sale_month, MonthlyTotalSales, PrevMonthSales,
        CASE 
            WHEN PrevMonthSales = 0 OR PrevMonthSales IS NULL THEN 0
            ELSE ROUND(((MonthlyTotalSales - PrevMonthSales) / PrevMonthSales) * 100, 2)
        END AS GrowthRate
    FROM  SalesWithLag
)
SELECT 
    Branch, ROUND(AVG(GrowthRate), 2) AS TopPerformer
FROM GrowthRates
GROUP BY Branch
ORDER BY TopPerformer DESC
LIMIT 3;

# Task 2: Finding the Most Profitable Product Line for Each Branch 
/* Walmart needs to determine which product line contributes the highest profit to each branch.The profit margin
should be calculated based on the difference between the gross income and cost of goods sold.*/
use walmartsales;
WITH ProfitCalculation AS (
    SELECT
        Branch,
        `Product line` AS ProductLine,
        ('grossincome' - cogs) AS ProfitMargin
    FROM
        walmartsales
),
RankedProfits AS (
    SELECT
        Branch,
        ProductLine ,
        ProfitMargin,
        ROW_NUMBER() OVER (PARTITION BY Branch ORDER BY ProfitMargin DESC) AS rankk
    FROM
        ProfitCalculation
)
SELECT
    Branch,
    ProductLine,
    ProfitMargin
FROM
    RankedProfits
WHERE
    rankk = 1;
    select * from walmartsales;
  
# Task 3: Analyzing Customer Segmentation Based on Spending
/* Walmart wants to segment customers based on their average spending behavior. Classify customers into three
tiers: High, Medium, and Low spenders based on their total purchase amounts.*/

Select * from walmartsales;
 Use walmartsales;
SELECT 
	Branch,
    Gender,
    Date,
    `Customer type`,
    Round(sum(Total),2) AS TotalSpent,
    CASE 
        WHEN SUM(Total) >= 300 THEN 'High'
        WHEN SUM(Total) >=200 THEN 'Medium'
        ELSE 'Low'
    END AS SpendingCategory
FROM walmartsales
GROUP BY `Customer type`,Branch, Gender, Date;

# Task 4: Detecting Anomalies in Sales Transactions
/* Walmart suspects that some transactions have unusually high or low sales compared to the average for the
product line. Identify these anomalies.*/
Select * from walmartsales;
Use walmartsales;

   WITH product_stats AS (
    SELECT 
		`Product line`,
        round(AVG(Total),2) AS avg_total,
        round(STDDEV(Total),2) AS std_total
    FROM walmartsales
    GROUP BY `Product line`
)
SELECT 
    w.Date,
    w.`Product line`,
    w.Total,
    ps.avg_total,
    ps.std_total,
    CASE 
        WHEN w.Total > ps.avg_total + 2 * ps.std_total THEN 'High Anomaly'
        WHEN w.Total < ps.avg_total - 2 * ps.std_total THEN 'Low Anomaly'
        ELSE 'Normal'
    END AS Anomaly_Type
FROM walmartsales w
JOIN product_stats ps ON w.`Product line` = ps.`Product line`
WHERE w.Total > ps.avg_total + 2 * ps.std_total
   OR w.Total < ps.avg_total - 2 * ps.std_total;
   
# Task 5: Most Popular Payment Method by City
/* Walmart needs to determine the most popular payment method in each city to tailor marketing strategies. */

select * from walmartsales;
use walmartsales;
SELECT Branch,
		City,
       Payment,
       COUNT(*) AS payment_count
FROM walmartsales
GROUP BY Branch, City, Payment
ORDER BY Branch, payment_count DESC;

# Task 6: Monthly Sales Distribution by Gender 
/* Walmart wants to understand the sales distribution between male and female customers on a monthly basis. */
Select * from walmartsales;
use walmartsales;

SELECT 
     Date AS Month,
    Gender,
    Round(SUM(Total),2) AS TotalSales
FROM walmartsales
GROUP BY Month, Gender
ORDER BY Month;

# Task 7: Best Product Line by Customer Type 
/* Walmart wants to know which product lines are preferred by different customer types(Member vs. Normal).*/
Use walmartsales;
Select * from walmartsales;
SELECT 
    `Customer type`,
    `Product line`
FROM walmartsales
GROUP BY `Customer type`, `Product line`
ORDER BY `Customer type` DESC;

# Task 8: Identifying Repeat Customers 
/* Walmart needs to identify customers who made repeat purchases within a specific time frame (e.g., within 30 days). */
select * from walmartsales;
Use walmartsales;

WITH RankedPurchases AS (
    SELECT 
        `Customer ID`,
        Date,
        LAG(Date) OVER (PARTITION BY `Customer ID` ORDER BY Date) AS PrevDate
    FROM walmartsales
)
SELECT 
    `Customer ID`,
    Date AS currentpurchase,
    PrevDate,
    DATEDIFF(Date, PrevDate) AS Daysbetween 
FROM RankedPurchases
WHERE PrevDate is not null
and datediff( date, PrevDate)<=30;

# Task 9: Finding Top 5 Customers by Sales Volume 
/* Walmart wants to reward its top 5 customers who have generated the most sales Revenue. */
Use walmartsales;
select * from walmartsales;

SELECT 
    `Customer ID`,
    round(SUM(Total),2) AS TotalSales
FROM walmartsales
GROUP BY `Customer ID`
ORDER BY TotalSales DESC
LIMIT 5;

# Task 10: Analyzing Sales Trends by Day of the Week 
/* Walmart wants to analyze the sales patterns to determine which day of the week
brings the highest sales. */

select * from walmartsales;
SELECT 
    DayofWeek,
    TotalSales
FROM (
    SELECT 
        DAYNAME(STR_TO_DATE(Date, '%d-%m-%Y')) AS DayofWeek,
        ROUND(SUM(Total), 0) AS TotalSales
    FROM walmartsales
    WHERE Date IS NOT NULL AND Date != ''
    GROUP BY DAYNAME(STR_TO_DATE(Date, '%d-%m-%Y'))
) AS sub
ORDER BY 
    FIELD(DayofWeek, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday');
  

