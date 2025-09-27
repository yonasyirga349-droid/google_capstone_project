/*
 -- continuedFAILED IMPUTATION 
-- Impute start station names from station table to tripdata_202408
WITH new_table AS (
SELECT 
    *
FROM tripdata_202408 AS t1
), TT as(
SELECT *,
        CASE
        WHEN new_table.start_station_name IS NULL THEN station_table.start_station_name ELSE NULL END AS imputed_column
FROM new_table
JOIN stations_table ON new_table.new_lat = stations_table.rounded_lat 
AND new_table.new_lng = stations_table.rounded_lng
)

SELECT * 
FROM stations_table

 */


--  number of casual and annual users in a year
SELECT COUNT(*), member_casual
FROM  all_trips
GROUP BY member_casual 



--A collection table of modal day of week, mean, median, standard deviation, through out months of both user type

    WITH all_tripdata AS (

        SELECT
            started_at,
            ended_at,
            member_casual,
            EXTRACT(EPOCH FROM (ended_at - started_at)) AS ride_length_seconds, 
            EXTRACT(DOW FROM started_at) AS day_of_week
        FROM
            tripdata_202408_split
        WHERE
            EXTRACT(EPOCH FROM (ended_at - started_at)) >= 60
            AND EXTRACT(EPOCH FROM (ended_at - started_at)) <= 72000
        
        UNION ALL
        
        SELECT
            started_at,
            ended_at,
            member_casual,
            EXTRACT(EPOCH FROM (ended_at - started_at)) AS ride_length_seconds, 
            EXTRACT(DOW FROM started_at) AS day_of_week
        FROM
            tripdata_202409_split
        WHERE
            EXTRACT(EPOCH FROM (ended_at - started_at)) >= 60
            AND EXTRACT(EPOCH FROM (ended_at - started_at)) <= 72000
        UNION ALL
    
    SELECT
        started_at,
        ended_at,
        member_casual,
        EXTRACT(EPOCH FROM (ended_at - started_at)) AS ride_length_seconds,
        EXTRACT(DOW FROM started_at) AS day_of_week
    FROM
        tripdata_202410_split
    WHERE
            EXTRACT(EPOCH FROM (ended_at - started_at)) >= 60
            AND EXTRACT(EPOCH FROM (ended_at - started_at)) <= 72000

    UNION ALL

    SELECT
        started_at,
        ended_at,
        member_casual,
        EXTRACT(EPOCH FROM (ended_at - started_at)) AS ride_length_seconds,
        EXTRACT(DOW FROM started_at) AS day_of_week
    FROM
        tripdata_202411_split
    WHERE
            EXTRACT(EPOCH FROM (ended_at - started_at)) >= 60
            AND EXTRACT(EPOCH FROM (ended_at - started_at)) <= 72000

    UNION ALL

    SELECT
        started_at,
        ended_at,
        member_casual,
        EXTRACT(EPOCH FROM (ended_at - started_at)) AS ride_length_seconds,
        EXTRACT(DOW FROM started_at) AS day_of_week
    FROM
        tripdata_202412_split
    WHERE
            EXTRACT(EPOCH FROM (ended_at - started_at)) >= 60
            AND EXTRACT(EPOCH FROM (ended_at - started_at)) <= 72000
    UNION ALL

    SELECT
        started_at,
        ended_at,
        member_casual,
        EXTRACT(EPOCH FROM (ended_at - started_at)) AS ride_length_seconds,
        EXTRACT(DOW FROM started_at) AS day_of_week
    FROM
        tripdata_202501_split
    WHERE
            EXTRACT(EPOCH FROM (ended_at - started_at)) >= 60
            AND EXTRACT(EPOCH FROM (ended_at - started_at)) <= 72000
    UNION ALL

    SELECT
        started_at,
        ended_at,
        member_casual,
        EXTRACT(EPOCH FROM (ended_at - started_at)) AS ride_length_seconds,
        EXTRACT(DOW FROM started_at) AS day_of_week
    FROM
        tripdata_202502_split
    WHERE
            EXTRACT(EPOCH FROM (ended_at - started_at)) >= 60
            AND EXTRACT(EPOCH FROM (ended_at - started_at)) <= 72000
    UNION ALL

    SELECT
        started_at,
        ended_at,
        member_casual,
        EXTRACT(EPOCH FROM (ended_at - started_at)) AS ride_length_seconds,
        EXTRACT(DOW FROM started_at) AS day_of_week
    FROM
        tripdata_202503_split
    WHERE
            EXTRACT(EPOCH FROM (ended_at - started_at)) >= 60
            AND EXTRACT(EPOCH FROM (ended_at - started_at)) <= 72000
    UNION ALL

    SELECT
        started_at,
        ended_at,
        member_casual,
        EXTRACT(EPOCH FROM (ended_at - started_at)) AS ride_length_seconds,
        EXTRACT(DOW FROM started_at) AS day_of_week
    FROM
        tripdata_202504_split
    WHERE
            EXTRACT(EPOCH FROM (ended_at - started_at)) >= 60
            AND EXTRACT(EPOCH FROM (ended_at - started_at)) <= 72000
    UNION ALL

    SELECT
        started_at,
        ended_at,
        member_casual,
        EXTRACT(EPOCH FROM (ended_at - started_at)) AS ride_length_seconds,
        EXTRACT(DOW FROM started_at) AS day_of_week
    FROM
        tripdata_202505_split
    WHERE
            EXTRACT(EPOCH FROM (ended_at - started_at)) >= 60
            AND EXTRACT(EPOCH FROM (ended_at - started_at)) <= 72000
    UNION ALL

    SELECT
        started_at,
        ended_at,
        member_casual,
        EXTRACT(EPOCH FROM (ended_at - started_at)) AS ride_length_seconds,
        EXTRACT(DOW FROM started_at) AS day_of_week
    FROM
        tripdata_202506_split
    WHERE
            EXTRACT(EPOCH FROM (ended_at - started_at)) >= 60
            AND EXTRACT(EPOCH FROM (ended_at - started_at)) <= 72000
    UNION ALL

    SELECT
        started_at,
        ended_at,
        member_casual,
        EXTRACT(EPOCH FROM (ended_at - started_at)) AS ride_length_seconds,
        EXTRACT(DOW FROM started_at) AS day_of_week
    FROM
        tripdata_202507_split
    WHERE
            EXTRACT(EPOCH FROM (ended_at - started_at)) >= 60
            AND EXTRACT(EPOCH FROM (ended_at - started_at)) <= 72000    
    ),
    day_counts AS (                -- working out modal day of week
        SELECT
            DATE_TRUNC('month', started_at) AS trip_month, 
            member_casual,
            day_of_week,
            COUNT(*) AS daily_count
        FROM
            all_tripdata
        GROUP BY
            trip_month,
            member_casual,
            day_of_week
    ),
    ranked_days AS (
        SELECT
            trip_month,
            member_casual,
            day_of_week, daily_count,
            RANK() OVER (PARTITION BY trip_month, member_casual ORDER BY daily_count DESC) AS daily_rank
        FROM
            day_counts
    )

    SELECT
        DATE_TRUNC('month', t1.started_at) AS trip_month,
        t1.member_casual,
        TO_CHAR(MIN(t1.ride_length_seconds) * INTERVAL '1 second', 'HH24:MI:SS') AS minimum_duration,
        TO_CHAR(MAX(t1.ride_length_seconds) * INTERVAL '1 second', 'HH24:MI:SS') AS maximum_duration,
        TO_CHAR(AVG(t1.ride_length_seconds) * INTERVAL '1 second', 'HH24:MI:SS') AS average_duration,

        -- Add percentiles
        TO_CHAR(
            PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY t1.ride_length_seconds) 
            * INTERVAL '1 second', 'HH24:MI:SS'
        ) AS p25_duration,
        TO_CHAR(
            PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY t1.ride_length_seconds) 
            * INTERVAL '1 second', 'HH24:MI:SS'
        ) AS median_duration,
        TO_CHAR(
            PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY t1.ride_length_seconds) 
            * INTERVAL '1 second', 'HH24:MI:SS'
        ) AS p75_duration, 

        MAX(CASE WHEN rd.daily_rank = 1 THEN
            CASE rd.day_of_week
                WHEN 0 THEN 'Sunday'
                WHEN 1 THEN 'Monday'
                WHEN 2 THEN 'Tuesday'
                WHEN 3 THEN 'Wednesday'
                WHEN 4 THEN 'Thursday'
                WHEN 5 THEN 'Friday'
                WHEN 6 THEN 'Saturday'
            END
        END) AS most_frequent_day, rd.daily_count ,

        STDDEV(t1.ride_length_seconds) AS standard_deviation_seconds
    FROM
        all_tripdata AS t1
    LEFT JOIN
        ranked_days AS rd 
        ON DATE_TRUNC('month', t1.started_at) = rd.trip_month 
        AND t1.member_casual = rd.member_casual
    WHERE daily_rank = 1
    GROUP BY
        DATE_TRUNC('month', started_at),
        t1.member_casual, rd.daily_count
    ORDER BY
        trip_month,
        t1.member_casual;



-- top 10 stations that are casual rider's hotspot and their duration in median
SELECT 
    start_station_name, 
   EXTRACT (EPOCH FROM(ended_at - started_at)) AS duration, 
    COUNT(*) AS ride_count 
FROM all_trips
WHERE  
     (WITH RideCounts AS (
        SELECT
            member_casual,
            start_station_name,
            COUNT(*) AS station_count
        FROM
            all_trips
        WHERE
            start_station_name IS NOT NULL
        GROUP BY
            member_casual,
            start_station_name
    )
    SELECT
        member_casual,
        start_station_name,
        station_count
    -- ,RANK() OVER(PARTITION BY start_station_name ORDER BY ride_number DESC) AS ranked_stations
    FROM
        RideCounts
    WHERE member_casual IS FALSE
    ORDER BY
    station_count DESC
    LIMIT 5;)

    SELECT *
    FROM all_trips
    LIMIT 10;

-- there are no distinct choice patterns of rideable types between the two types of users
SELECT month, member_casual, rideable_type,  COUNT(*) AS number, RANK() OVER(PARTITION month, member_casual, rideable_type ORDER BY DESC) AS  
FROM (
    SELECT DATE_TRUNC('MONTH', started_at) AS month, member_casual, rideable_type
FROM all_trips ) AS t
 WHERE member_casual IS FALSE 
GROUP BY 
    month, 
   member_casual,
    rideable_type
 ORDER BY month 


 -- Top 10 starting stations for casual users with percentage of coverage

SELECT
    start_station_name,
    member_casual,
    COUNT(*) AS station_count,
 COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(PARTITION BY member_casual) AS pct_within_user_type,
    TO_CHAR(
        (AVG(EXTRACT(EPOCH FROM (ended_at - started_at))) || ' second')::interval,
        'HH24:MI:SS'
    ) AS average_duration,
    TO_CHAR(
        (PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY EXTRACT(EPOCH FROM (ended_at - started_at))) || ' second')::interval,
        'HH24:MI:SS'
    ) AS median_duration
FROM
    all_trips
WHERE
    EXTRACT(EPOCH FROM (ended_at - started_at)) BETWEEN 60 AND 72000
    AND start_station_name IS NOT NULL AND member_casual IS FALSE
GROUP BY
    start_station_name,
    member_casual
ORDER BY
    station_count DESC
LIMIT 10;



