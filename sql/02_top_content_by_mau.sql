-- Топ-3 произведений по MAU за ноябрь 2024 года.

SELECT
    c.main_content_name,
    c.published_topic_title_list,
    a.main_author_name,
    COUNT(DISTINCT au.puid) AS mau
FROM bookmate.audition AS au
JOIN bookmate.content AS c
    ON au.main_content_id = c.main_content_id
JOIN bookmate.author AS a
    ON c.main_author_id = a.main_author_id
WHERE CAST(au.msk_business_dt_str AS DATE) >= DATE '2024-11-01'
  AND CAST(au.msk_business_dt_str AS DATE) < DATE '2024-12-01'
GROUP BY
    c.main_content_id,
    c.main_content_name,
    c.published_topic_title_list,
    a.main_author_id,
    a.main_author_name
ORDER BY mau DESC
LIMIT 3;
