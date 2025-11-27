
/* Walmart wants to segment customers based on their average spending behavior. Classify customers into three
tiers: High, Medium, and Low spenders based on their total purchase amounts. */

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