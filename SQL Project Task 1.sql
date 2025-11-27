
 /* Walmarts wants to identify which branch has exhibited the highest sales growth over time. 
 Analyze the total sales for each branch and compare the growth rate across months to find the top performer.*/
use walmartsales;
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