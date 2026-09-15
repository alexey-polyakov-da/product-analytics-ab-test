-- MAU, суммарные часы и средняя выручка на час.
-- Период: сентябрь–ноябрь 2024 года.

SELECT
    DATE_TRUNC(
        'month',
        CAST(msk_business_dt_str AS DATE)
    )::DATE AS month,
    COUNT(DISTINCT puid) AS mau,
    ROUND(
        SUM(hours)::NUMERIC,
        2
    ) AS hours,
    ROUND(
        (COUNT(DISTINCT puid) * 399)::NUMERIC
        / NULLIF(SUM(hours)::NUMERIC, 0),
        2
    ) AS avg_hour_rev
FROM bookmate.audition
WHERE CAST(msk_business_dt_str AS DATE) >= DATE '2024-09-01'
  AND CAST(msk_business_dt_str AS DATE) < DATE '2024-12-01'
GROUP BY
    DATE_TRUNC(
        'month',
        CAST(msk_business_dt_str AS DATE)
    )
ORDER BY month;
