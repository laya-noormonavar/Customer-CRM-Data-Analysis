SELECT
    leaddate::date AS day,
    status,
    COUNT(*) AS num_leads
FROM leads
GROUP BY day, status
ORDER BY day, status;
