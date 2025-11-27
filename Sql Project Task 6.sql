/* Walmart wants to understand the sales distribution between male and female customers on a monthly basis */
Select * from walmartsales;
use walmartsales;

SELECT 
     Date AS Month,
    Gender,
    Round(SUM(Total),2) AS TotalSales
FROM walmartsales
GROUP BY Month, Gender
ORDER BY Month;