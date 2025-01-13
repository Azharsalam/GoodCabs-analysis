WITH CityTotals AS (
    SELECT
        city_id,
        SUM(total_passengers) AS total_passengers,
        SUM(repeat_passengers) AS total_repeat_passengers,
        (SUM(repeat_passengers) / SUM(total_passengers)) * 100 AS city_repeat_passenger_rate
    FROM
        fact_passenger_summary
    GROUP BY
        city_id
)
SELECT
    dc.city_name,
    MONTHNAME(fps.month) AS month,
    SUM(fps.total_passengers) AS total_passengers,
    ROUND((SUM(fps.repeat_passengers) / SUM(fps.total_passengers)) * 100, 2) AS monthly_repeat_passenger_rate,
    ROUND(ct.city_repeat_passenger_rate, 2) AS city_repeat_passenger_rate
FROM
    fact_passenger_summary AS fps
JOIN dim_city AS dc
    ON fps.city_id = dc.city_id
JOIN CityTotals AS ct
    ON fps.city_id = ct.city_id
GROUP BY
    dc.city_name, MONTHNAME(fps.month), ct.city_repeat_passenger_rate
ORDER BY
    dc.city_name, MONTHNAME(fps.month);
