-- Средний LTV активных пользователей Москвы и Санкт-Петербурга.
-- Период наблюдения: 01.09.2024–11.12.2024.
-- Стоимость подписки: 399 рублей за каждый активный месяц.

WITH user_months AS (
    SELECT DISTINCT
        au.puid,
        g.usage_geo_id_name AS city,
        DATE_TRUNC(
            'month',
            CAST(au.msk_business_dt_str AS DATE)
        ) AS active_month
    FROM bookmate.audition AS au
    JOIN bookmate.geo AS g
        ON au.usage_geo_id = g.usage_geo_id
    WHERE g.usage_geo_id_name IN ('Москва', 'Санкт-Петербург')
      AND CAST(au.msk_business_dt_str AS DATE) >= DATE '2024-09-01'
      AND CAST(au.msk_business_dt_str AS DATE) < DATE '2024-12-12'
),

user_active_months AS (
    SELECT
        city,
        puid,
        COUNT(*) AS active_months
    FROM user_months
    GROUP BY
        city,
        puid
)

SELECT
    city,
    COUNT(*) AS total_users,
    ROUND(
        SUM(active_months * 399)::NUMERIC / COUNT(*),
        2
    ) AS ltv
FROM user_active_months
GROUP BY city
ORDER BY city;
