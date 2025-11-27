/* Walmart wants to know which product lines are preferred by different customer types(Member vs. Normal) */
Use walmartsales;
Select * from walmartsales;
SELECT 
    `Customer type`,
    `Product line`
FROM walmartsales
GROUP BY `Customer type`, `Product line`
ORDER BY `Customer type` DESC;