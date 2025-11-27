/* Walmart needs to identify customers who made repeat purchases within a specific time frame (e.g., within 30
days). */

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
