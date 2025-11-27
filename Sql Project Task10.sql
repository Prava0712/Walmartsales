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