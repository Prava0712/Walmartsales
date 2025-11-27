/* Walmart wants to reward its top 5 customers who have generated the most sales Revenue */

Use walmartsales;
select * from walmartsales;

SELECT 
    `Customer ID`,
    round(SUM(Total),2) AS TotalSales
FROM walmartsales
GROUP BY `Customer ID`
ORDER BY TotalSales DESC
LIMIT 5;
