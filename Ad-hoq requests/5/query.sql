WITH city_month_revenue AS (
    SELECT 
        dim_city.city_name,
        EXTRACT(MONTH FROM fact_trips.date) AS month,
        MONTHNAME(fact_trips.date) AS month_name,
        SUM(fact_trips.fare_amount) AS monthly_revenue
    FROM 
        fact_trips
    JOIN dim_city 
        ON dim_city.city_id = fact_trips.city_id
    GROUP BY 
        dim_city.city_name, 
        EXTRACT(MONTH FROM fact_trips.date), 
        MONTHNAME(fact_trips.date)
),
city_total_revenue AS (
    SELECT 
        dim_city.city_name,
        SUM(fact_trips.fare_amount) AS total_revenue
    FROM 
        fact_trips
    JOIN dim_city 
        ON dim_city.city_id = fact_trips.city_id
    GROUP BY 
        dim_city.city_name
),
highest_revenue_month AS (
    SELECT 
        cmr.city_name,
        cmr.month_name AS highest_revenue_month,
        cmr.monthly_revenue AS revenue,
        ROUND((cmr.monthly_revenue / ctr.total_revenue) * 100, 2) AS percentage_contribution
    FROM city_month_revenue cmr
    JOIN city_total_revenue ctr
        ON cmr.city_name = ctr.city_name
    WHERE cmr.monthly_revenue = (
        SELECT MAX(cmr2.monthly_revenue)
        FROM city_month_revenue cmr2
        WHERE cmr2.city_name = cmr.city_name
    )
)
SELECT *
FROM highest_revenue_month
ORDER BY revenue desc;
