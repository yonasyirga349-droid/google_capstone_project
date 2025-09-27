
/*
CREATE TABLE tripdata_202408 (
    ride_id VARCHAR(50),
    rideable_type VARCHAR(50),
    started_at TIMESTAMP,
    ended_at TIMESTAMP,
    start_station_name VARCHAR(100),
    start_station_id VARCHAR(50),
    end_station_name VARCHAR(100),
    end_station_id VARCHAR(50),
    start_lat NUMERIC(10, 8),
    start_lng NUMERIC(11, 8),
    end_lat NUMERIC(10, 8),
    end_lng NUMERIC(11, 8),
    member_casual VARCHAR(50)
);
*/
-------------------------------------------------------------

/* Load the data in to the tables created by pasting on PSQL tool on postgres

\COPY tripdata_202408 FROM 'C:\Users\ASUS\Documents\cyclistic\202408-divvy-tripdata.csv' DELIMITER ',' CSV HEADER;
\COPY tripdata_202409 FROM 'C:\Users\ASUS\Documents\cyclistic\202409-divvy-tripdata.csv' DELIMITER ',' CSV HEADER;
\COPY tripdata_202410 FROM 'C:\Users\ASUS\Documents\cyclistic\202410-divvy-tripdata.csv' DELIMITER ',' CSV HEADER;
\COPY tripdata_202411 FROM 'C:\Users\ASUS\Documents\cyclistic\202411-divvy-tripdata.csv' DELIMITER ',' CSV HEADER;
\COPY tripdata_202412 FROM 'C:\Users\ASUS\Documents\cyclistic\202412-divvy-tripdata.csv' DELIMITER ',' CSV HEADER;
\COPY tripdata_202501 FROM 'C:\Users\ASUS\Documents\cyclistic\202501-divvy-tripdata.csv' DELIMITER ',' CSV HEADER;
\COPY tripdata_202502 FROM 'C:\Users\ASUS\Documents\cyclistic\202502-divvy-tripdata.csv' DELIMITER ',' CSV HEADER;
\COPY tripdata_202503 FROM 'C:\Users\ASUS\Documents\cyclistic\202503-divvy-tripdata.csv' DELIMITER ',' CSV HEADER;
\COPY tripdata_202504 FROM 'C:\Users\ASUS\Documents\cyclistic\202504-divvy-tripdata.csv' DELIMITER ',' CSV HEADER;
\COPY tripdata_202505 FROM 'C:\Users\ASUS\Documents\cyclistic\202505-divvy-tripdata.csv' DELIMITER ',' CSV HEADER;
\COPY tripdata_202506 FROM 'C:\Users\ASUS\Documents\cyclistic\202506-divvy-tripdata.csv' DELIMITER ',' CSV HEADER;
\COPY tripdata_202507 FROM 'C:\Users\ASUS\Documents\cyclistic\202507-divvy-tripdata.csv' DELIMITER ',' CSV HEADER;
\COPY tripdata_202508 FROM 'C:\Users\ASUS\Documents\cyclistic\202508-divvy-tripdata.csv' DELIMITER ',' CSV HEADER;
*/

-- chaning data type of member_casual
ALTER TABLE tripdata_202408
ALTER COLUMN member_casual TYPE BOOLEAN USING CASE
    WHEN member_casual = 'member' THEN TRUE
    WHEN member_casual = 'casual' THEN FALSE
    ELSE NULL
END;

SELECT * FROM tripdata_202408 LIMIT 100;
SELECT * FROM tripdata_202409 LIMIT 100;
SELECT * FROM tripdata_202410 LIMIT 100;
SELECT * FROM tripdata_202411 LIMIT 100;
SELECT * FROM tripdata_202412 LIMIT 100;
SELECT * FROM tripdata_202501 LIMIT 100;
SELECT * FROM tripdata_202502 LIMIT 100;
SELECT * FROM tripdata_202503 LIMIT 100;
SELECT * FROM tripdata_202504 LIMIT 100;
SELECT * FROM tripdata_202505 LIMIT 100;
SELECT * FROM tripdata_202506 LIMIT 100;
SELECT * FROM tripdata_202507 LIMIT 100;
SELECT * FROM tripdata_202508 LIMIT 100;

/*  a short list of tables with the number of recoreds,  NO duplicate records*/

SELECT
    '2024-08' AS month,
    COUNT(DISTINCT ride_id) AS total_rides
FROM
    tripdata_202408
UNION ALL
SELECT
    '2024-09' AS month,
    COUNT(DISTINCT ride_id) AS total_rides
FROM
    tripdata_202409
UNION ALL
SELECT
    '2024-10' AS month,
    COUNT(DISTINCT ride_id) AS total_rides
FROM
    tripdata_202410
UNION ALL
SELECT
    '2024-11' AS month,
    COUNT(DISTINCT ride_id) AS total_rides
FROM
    tripdata_202411
UNION ALL
SELECT
    '2024-12' AS month,
    COUNT(DISTINCT ride_id) AS total_rides
FROM
    tripdata_202412
UNION ALL
SELECT
    '2025-01' AS month,
    COUNT(DISTINCT ride_id) AS total_rides
FROM
    tripdata_202501
UNION ALL
SELECT
    '2025-02' AS month,
    COUNT(DISTINCT ride_id) AS total_rides
FROM
    tripdata_202502
UNION ALL
SELECT
    '2025-03' AS month,
    COUNT(DISTINCT ride_id) AS total_rides
FROM
    tripdata_202503
UNION ALL
SELECT
    '2025-04' AS month,
    COUNT(DISTINCT ride_id) AS total_rides
FROM
    tripdata_202504
UNION ALL
SELECT
    '2025-05' AS month,
    COUNT(DISTINCT ride_id) AS total_rides
FROM
    tripdata_202505
UNION ALL
SELECT
    '2025-06' AS month,
    COUNT(DISTINCT ride_id) AS total_rides
FROM
    tripdata_202506
UNION ALL
SELECT
    '2025-07' AS month,
    COUNT(DISTINCT ride_id) AS total_rides
FROM
    tripdata_202507
UNION ALL
SELECT
    '2025-08' AS month,
    COUNT(DISTINCT ride_id) AS total_rides
FROM
    tripdata_202508

ORDER BY month;
     


-- To use station names that have NULL values in analysis, I tried to create a look up table of station names and modal location coordinates.
-- FAILED IMPUTATION, LOCATION COORDINATES CAN'T BE UNIQUE IDENTIFIERS TO USE JOIN
/* 

WITH StationCounts AS (
    SELECT
        start_station_name,start_station_id,
        start_lat AS rounded_lat,
        start_lng AS rounded_lng,
        COUNT(*) AS station_count
    FROM tripdata_202408
    WHERE start_station_name IS NOT NULL
    GROUP BY start_station_name, start_station_id, rounded_lat, rounded_lng
),
 RankedStations AS (
    SELECT
        start_station_id,
        start_station_name,
        rounded_lat,
        rounded_lng,
        station_count,
        ROW_NUMBER() OVER(
            PARTITION BY start_station_name
            ORDER BY station_count DESC, rounded_lat, rounded_lng
        ) AS rank_num
    FROM StationCounts
    ) 

-- add a column filled_station_name to original table
 SELECT
    t.*,
    CASE
        WHEN t.start_station_name IS NULL
             AND t.start_lat IS NOT NULL
             AND t.start_lng IS NOT NULL
        THEN s.start_station_name
        ELSE t.start_station_name
    END AS filled_station_name
FROM tripdata_202408 t
LEFT JOIN RankedStations AS s
     ON ROUND(t.start_lat::numeric,5) = s.rounded_lat
    AND ROUND(t.start_lng::numeric,5) = s.rounded_lng;

-- FAILED IMPUTATION, LOCATION COORDINATES CAN'T BE UNIQUE IDENTIFIERS TO USE JOIN */



 -- for more accurate representation of time I divided the months to include all the days of that month from merged dataset named all_trips
-- 2024
CREATE TABLE tripdata_202408_split AS
SELECT *
FROM all_trips
WHERE EXTRACT(YEAR FROM started_at) = 2024
  AND EXTRACT(MONTH FROM started_at) = 8;

CREATE TABLE tripdata_202409_split AS
SELECT *
FROM all_trips
WHERE EXTRACT(YEAR FROM started_at) = 2024
  AND EXTRACT(MONTH FROM started_at) = 9;

CREATE TABLE tripdata_202410_split AS
SELECT *
FROM all_trips
WHERE EXTRACT(YEAR FROM started_at) = 2024
  AND EXTRACT(MONTH FROM started_at) = 10;

CREATE TABLE tripdata_202411_split AS
SELECT *
FROM all_trips
WHERE EXTRACT(YEAR FROM started_at) = 2024
  AND EXTRACT(MONTH FROM started_at) = 11;

CREATE TABLE tripdata_202412_split AS
SELECT *
FROM all_trips
WHERE EXTRACT(YEAR FROM started_at) = 2024
  AND EXTRACT(MONTH FROM started_at) = 12;

-- 2025
CREATE TABLE tripdata_202501_split AS
SELECT *
FROM all_trips
WHERE EXTRACT(YEAR FROM started_at) = 2025
  AND EXTRACT(MONTH FROM started_at) = 1;

CREATE TABLE tripdata_202502_split AS
SELECT *
FROM all_trips
WHERE EXTRACT(YEAR FROM started_at) = 2025
  AND EXTRACT(MONTH FROM started_at) = 2;

CREATE TABLE tripdata_202503_split AS
SELECT *
FROM all_trips
WHERE EXTRACT(YEAR FROM started_at) = 2025
  AND EXTRACT(MONTH FROM started_at) = 3;

CREATE TABLE tripdata_202504_split AS
SELECT *
FROM all_trips
WHERE EXTRACT(YEAR FROM started_at) = 2025
  AND EXTRACT(MONTH FROM started_at) = 4;

CREATE TABLE tripdata_202505_split AS
SELECT *
FROM all_trips
WHERE EXTRACT(YEAR FROM started_at) = 2025
  AND EXTRACT(MONTH FROM started_at) = 5;

CREATE TABLE tripdata_202506_split AS
SELECT *
FROM all_trips
WHERE EXTRACT(YEAR FROM started_at) = 2025
  AND EXTRACT(MONTH FROM started_at) = 6;

CREATE TABLE tripdata_202507_split AS
SELECT *
FROM all_trips
WHERE EXTRACT(YEAR FROM started_at) = 2025
  AND EXTRACT(MONTH FROM started_at) = 7;