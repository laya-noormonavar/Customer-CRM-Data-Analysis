WITH persona AS (
    SELECT
        customerid,
        CASE
            WHEN purchaseamount > 0 AND satisfactionscore >= 4 THEN 'وفادار'
            WHEN purchaseamount > 0 AND satisfactionscore <= 2 THEN 'در خطر'
            WHEN purchaseamount = 0 AND status = 'فعال' THEN 'بالقوه'
            ELSE 'تازه‌وارد'
        END AS persona_group,
        satisfactionscore
    FROM leads
)

SELECT
    persona_group,
    ROUND(AVG(satisfactionscore), 2) AS avg_satisfaction,
    COUNT(*) AS num_customers
FROM persona
GROUP BY persona_group
ORDER BY avg_satisfaction DESC;
