WITH ActualTripsCTE AS (
    SELECT 
        dim_city.city_name AS city,
        dim_date.month_name AS month,
        COUNT(fact_trips.trip_id) AS actual_trips,
        fact_trips.city_id
    FROM 
        fact_trips
    JOIN 
        dim_city ON fact_trips.city_id = dim_city.city_id
    JOIN 
        dim_date ON fact_trips.date = dim_date.date
    GROUP BY 
        dim_city.city_name, fact_trips.city_id, dim_date.month_name
),
TargetTripsCTE AS (
    SELECT 
        city_id,
        DATE_FORMAT(month, '%M') AS month_name, 
        total_target_trips
    FROM 
        targets_db.monthly_target_trips
)
SELECT 
    a.city AS city_name,
    a.month AS month_name,
    a.actual_trips,
    t.total_target_trips AS target_trips,
    CASE
        WHEN a.actual_trips > t.total_target_trips THEN 'Above Target'
        ELSE 'Below Target'
    END AS performance_status,
    ROUND(
        ((a.actual_trips - t.total_target_trips) / t.total_target_trips) * 100, 2
    ) AS percentage_difference
FROM 
    ActualTripsCTE a
JOIN 
    TargetTripsCTE t 
    ON a.city_id = t.city_id 
    AND UPPER(TRIM(a.month)) = UPPER(TRIM(t.month_name))
ORDER BY 
    a.city, a.month;
