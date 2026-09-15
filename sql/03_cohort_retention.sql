-- Retention пользователей, активных 2 декабря 2024 года.
-- День 0 — дата формирования когорты, а не дата установки приложения.

WITH cohort_users AS (
    SELECT DISTINCT
        puid
    FROM bookmate.audition
    WHERE CAST(msk_business_dt_str AS DATE) = DATE '2024-12-02'
),

user_daily_activity AS (
    SELECT
        cu.puid,
        CAST(au.msk_business_dt_str AS DATE) AS activity_date,
        CAST(au.msk_business_dt_str AS DATE) - DATE '2024-12-02'
            AS day_since_cohort
    FROM cohort_users AS cu
    JOIN bookmate.audition AS au
        ON cu.puid = au.puid
    WHERE CAST(au.msk_business_dt_str AS DATE) >= DATE '2024-12-02'
),

daily_retention AS (
    SELECT
        day_since_cohort,
        COUNT(DISTINCT puid) AS retained_users
    FROM user_daily_activity
    GROUP BY day_since_cohort
),

cohort_size AS (
    SELECT
        COUNT(*) AS cohort_users
    FROM cohort_users
)

SELECT
    dr.day_since_cohort,
    dr.retained_users,
    ROUND(
        dr.retained_users::NUMERIC / cs.cohort_users,
        4
    ) AS retention_rate
FROM daily_retention AS dr
CROSS JOIN cohort_size AS cs
ORDER BY dr.day_since_cohort;
