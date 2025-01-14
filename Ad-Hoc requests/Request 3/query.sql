WITH RepeatPassengerData AS (
    SELECT
        city_id,
        trip_count,
        repeat_passenger_count,
        SUM(repeat_passenger_count) OVER (PARTITION BY city_id) AS total_repeat_passengers
    FROM dim_repeat_trip_distribution
    WHERE trip_count BETWEEN 2 AND 10
),
RepeatPassengerSummary AS (
    SELECT
        city_id,
        ROUND(SUM(CASE WHEN trip_count = 2 THEN repeat_passenger_count ELSE 0 END) / MAX(total_repeat_passengers) * 100, 2) AS "2_trips",
        ROUND(SUM(CASE WHEN trip_count = 3 THEN repeat_passenger_count ELSE 0 END) / MAX(total_repeat_passengers) * 100, 2) AS "3_trips",
        ROUND(SUM(CASE WHEN trip_count = 4 THEN repeat_passenger_count ELSE 0 END) / MAX(total_repeat_passengers) * 100, 2) AS "4_trips",
        ROUND(SUM(CASE WHEN trip_count = 5 THEN repeat_passenger_count ELSE 0 END) / MAX(total_repeat_passengers) * 100, 2) AS "5_trips",
        ROUND(SUM(CASE WHEN trip_count = 6 THEN repeat_passenger_count ELSE 0 END) / MAX(total_repeat_passengers) * 100, 2) AS "6_trips",
        ROUND(SUM(CASE WHEN trip_count = 7 THEN repeat_passenger_count ELSE 0 END) / MAX(total_repeat_passengers) * 100, 2) AS "7_trips",
        ROUND(SUM(CASE WHEN trip_count = 8 THEN repeat_passenger_count ELSE 0 END) / MAX(total_repeat_passengers) * 100, 2) AS "8_trips",
        ROUND(SUM(CASE WHEN trip_count = 9 THEN repeat_passenger_count ELSE 0 END) / MAX(total_repeat_passengers) * 100, 2) AS "9_trips",
        ROUND(SUM(CASE WHEN trip_count = 10 THEN repeat_passenger_count ELSE 0 END) / MAX(total_repeat_passengers) * 100, 2) AS "10_trips"
    FROM RepeatPassengerData
    GROUP BY city_id
)
SELECT 
    c.city_name,
    rps.*
FROM 
    RepeatPassengerSummary rps
JOIN 
    dim_city c ON c.city_id = rps.city_id
ORDER BY 
    c.city_name;
