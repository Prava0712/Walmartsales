/* Walmart suspects that some transactions have unusually high or low sales compared to the average for the
product line. Identify these anomalies. */
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
    