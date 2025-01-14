WITH TotalTrips AS (
    SELECT 
        COUNT(*) AS total_trip_count
    FROM 
        fact_trips
),
CityTripStats AS (
    SELECT 
        dim_city.city_name AS city,
        COUNT(fact_trips.trip_id) AS total_trips,
        ROUND(AVG(fact_trips.fare_amount / fact_trips.distance_travelled_km), 2) AS avg_fare_per_km,
        ROUND(AVG(fact_trips.fare_amount), 2) AS avg_fare_per_trip
    FROM 
        fact_trips
    JOIN 
        dim_city 
        ON dim_city.city_id = fact_trips.city_id
    GROUP BY 
        dim_city.city_name
)
SELECT 
    city,
    total_trips,
    avg_fare_per_km,
    avg_fare_per_trip,
    ROUND((total_trips * 100.0) / (SELECT total_trip_count FROM TotalTrips), 2) AS percentage_contribution
FROM 
    CityTripStats
ORDER BY 
    total_trips DESC;
