WITH ranked_cities AS (
    SELECT
        dim_city.city_name,
        SUM(fact_passenger_summary.new_passengers) AS total_new_passengers,
        RANK() OVER (ORDER BY SUM(fact_passenger_summary.new_passengers) DESC) AS city_rank
    FROM
        fact_passenger_summary
    JOIN dim_city
    ON dim_city.city_id = fact_passenger_summary.city_id
    GROUP BY
        dim_city.city_name
)
SELECT  
    city_name,
    total_new_passengers,
    CASE
        WHEN city_rank <= 3 THEN 'Top 3'
        WHEN city_rank >= 8 THEN 'Bottom 3'
        ELSE 'other'
    END AS city_category
FROM ranked_cities
ORDER BY city_rank;
