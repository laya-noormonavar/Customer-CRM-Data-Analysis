SELECT
    product,
    SUM(purchaseamount) AS total_sales,
    ROUND(100.0 * SUM(purchaseamount) / SUM(SUM(purchaseamount)) OVER (), 2) AS sales_share_percent
FROM leads
WHERE status = 'خرید'
GROUP BY product
ORDER BY total_sales DESC;
