/* Walmart needs to determine which product line contributes the highest profit to each branch.The profit margin
should be calculated based on the difference between the gross income and cost of goods sold. */
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