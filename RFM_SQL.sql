WITH rfm_base AS (
    SELECT
        customerid,
        MAX(leaddate) AS last_purchase_date,
        SUM(purchaseamount) AS monetary
    FROM leads
    WHERE status = 'خرید'
    GROUP BY customerid
),

rfm_calculated AS (
    SELECT
        r.*,
        (CURRENT_DATE - r.last_purchase_date::date) AS recency
    FROM rfm_base r
),

rfm_scores AS (
    SELECT
        customerid,
        NTILE(4) OVER (ORDER BY recency ASC) AS r_score,   -- Recency: جدیدترین خرید امتیاز بالاتر
        NTILE(4) OVER (ORDER BY monetary DESC) AS m_score  -- Monetary: مبلغ بیشتر امتیاز بالاتر
    FROM rfm_calculated
),

rfm_segments AS (
    SELECT
        customerid,
        r_score, m_score,
        (r_score + m_score) AS rfm_total
    FROM rfm_scores
)

SELECT
    customerid,
    r_score, m_score, rfm_total,
    CASE
        WHEN r_score >= 3 AND m_score >= 3 THEN 'مشتریان طلایی'
        WHEN r_score >= 3 AND m_score <= 2 THEN 'مشتریان وفادار'
        WHEN r_score <= 2 AND m_score >= 3 THEN 'مشتریان بالقوه'
        ELSE 'مشتریان کم‌ارزش'
    END AS rfm_segment
FROM rfm_segments
ORDER BY rfm_total DESC;
