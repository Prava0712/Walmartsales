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
