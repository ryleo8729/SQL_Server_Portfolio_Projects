-- Prepare Phase --

SELECT 
	ride_id,
    rideable_type,
    started_at,
    ended_at,
    start_station_name,
    start_station_id,
    end_station_name,
    end_station_id,
    start_lat,
    start_lng,
    end_lat,
    end_lng,
    member_casual
  FROM [cyclistic_bike_share].[dbo].[202201]
  UNION ALL
  SELECT 
	ride_id,
    rideable_type,
    started_at,
    ended_at,
    start_station_name,
    start_station_id,
    end_station_name,
    end_station_id,
    start_lat,
    start_lng,
    end_lat,
    end_lng,
    member_casual
  FROM [cyclistic_bike_share].[dbo].[202202]
  UNION ALL
  SELECT 
	ride_id,
    rideable_type,
    started_at,
    ended_at,
    start_station_name,
    start_station_id,
    end_station_name,
    end_station_id,
    start_lat,
    start_lng,
    end_lat,
    end_lng,
    member_casual
  FROM [cyclistic_bike_share].[dbo].[202203]
  UNION ALL
  SELECT 
	ride_id,
    rideable_type,
    started_at,
    ended_at,
    start_station_name,
    start_station_id,
    end_station_name,
    end_station_id,
    start_lat,
    start_lng,
    end_lat,
    end_lng,
    member_casual
  FROM [cyclistic_bike_share].[dbo].[202204]
  UNION ALL
  SELECT 
	ride_id,
    rideable_type,
    started_at,
    ended_at,
    start_station_name,
    start_station_id,
    end_station_name,
    end_station_id,
    start_lat,
    start_lng,
    end_lat,
    end_lng,
    member_casual
  FROM [cyclistic_bike_share].[dbo].[202205]
  UNION ALL
  SELECT 
	ride_id,
    rideable_type,
    started_at,
    ended_at,
    start_station_name,
    start_station_id,
    end_station_name,
    end_station_id,
    start_lat,
    start_lng,
    end_lat,
    end_lng,
    member_casual
  FROM [cyclistic_bike_share].[dbo].[202206]
  UNION ALL
  SELECT 
	ride_id,
    rideable_type,
    started_at,
    ended_at,
    start_station_name,
    start_station_id,
    end_station_name,
    end_station_id,
    start_lat,
    start_lng,
    end_lat,
    end_lng,
    member_casual
  FROM [cyclistic_bike_share].[dbo].[202207]
  UNION ALL
  SELECT 
	ride_id,
    rideable_type,
    started_at,
    ended_at,
    start_station_name,
    start_station_id,
    end_station_name,
    end_station_id,
    start_lat,
    start_lng,
    end_lat,
    end_lng,
    member_casual
  FROM [cyclistic_bike_share].[dbo].[202208]
  UNION ALL
  SELECT 
	ride_id,
    rideable_type,
    started_at,
    ended_at,
    start_station_name,
    start_station_id,
    end_station_name,
    end_station_id,
    start_lat,
    start_lng,
    end_lat,
    end_lng,
    member_casual
  FROM [cyclistic_bike_share].[dbo].[202209]
  UNION ALL
  SELECT 
	ride_id,
    rideable_type,
    started_at,
    ended_at,
    start_station_name,
    start_station_id,
    end_station_name,
    end_station_id,
    start_lat,
    start_lng,
    end_lat,
    end_lng,
    member_casual
  FROM [cyclistic_bike_share].[dbo].[202210]
  UNION ALL
  SELECT 
	ride_id,
    rideable_type,
    started_at,
    ended_at,
    start_station_name,
    start_station_id,
    end_station_name,
    end_station_id,
    start_lat,
    start_lng,
    end_lat,
    end_lng,
    member_casual
  FROM [cyclistic_bike_share].[dbo].[202211]
  UNION ALL
  SELECT 
	ride_id,
    rideable_type,
    started_at,
    ended_at,
    start_station_name,
    start_station_id,
    end_station_name,
    end_station_id,
    start_lat,
    start_lng,
    end_lat,
    end_lng,
    member_casual
  FROM [cyclistic_bike_share].[dbo].[202201]
  UNION ALL
  SELECT 
	ride_id,
    rideable_type,
    started_at,
    ended_at,
    start_station_name,
    start_station_id,
    end_station_name,
    end_station_id,
    start_lat,
    start_lng,
    end_lat,
    end_lng,
    member_casual
  FROM [cyclistic_bike_share].[dbo].[202212]

  -- Change Data Type from SMALLINT to NVARCHAR(50) to maintain consistent Data Types --
  
  SELECT
  end_station_id
  FROM [cyclistic_bike_share].[dbo].[202206];

  ALTER TABLE [cyclistic_bike_share].[dbo].[202206]
  ALTER COLUMN end_station_id NVARCHAR(50);

  ALTER TABLE [cyclistic_bike_share].[dbo].[202209]
  ALTER COLUMN end_station_id NVARCHAR(50);

-- Process Phase --

SELECT 
	ride_id,
    rideable_type,
    started_at,
    ended_at,
    start_station_name,
    start_station_id,
    end_station_name,
    end_station_id,
    start_lat,
    start_lng,
    end_lat,
    end_lng,
    member_casual
INTO [cyclistic_bike_share].[dbo].[2022]
FROM (
SELECT 
	ride_id,
    rideable_type,
    started_at,
    ended_at,
    start_station_name,
    start_station_id,
    end_station_name,
    end_station_id,
    start_lat,
    start_lng,
    end_lat,
    end_lng,
    member_casual
  FROM [cyclistic_bike_share].[dbo].[202201]
  UNION ALL
  SELECT 
	ride_id,
    rideable_type,
    started_at,
    ended_at,
    start_station_name,
    start_station_id,
    end_station_name,
    end_station_id,
    start_lat,
    start_lng,
    end_lat,
    end_lng,
    member_casual
  FROM [cyclistic_bike_share].[dbo].[202202]
  UNION ALL
  SELECT 
	ride_id,
    rideable_type,
    started_at,
    ended_at,
    start_station_name,
    start_station_id,
    end_station_name,
    end_station_id,
    start_lat,
    start_lng,
    end_lat,
    end_lng,
    member_casual
  FROM [cyclistic_bike_share].[dbo].[202203]
  UNION ALL
  SELECT 
	ride_id,
    rideable_type,
    started_at,
    ended_at,
    start_station_name,
    start_station_id,
    end_station_name,
    end_station_id,
    start_lat,
    start_lng,
    end_lat,
    end_lng,
    member_casual
  FROM [cyclistic_bike_share].[dbo].[202204]
  UNION ALL
  SELECT 
	ride_id,
    rideable_type,
    started_at,
    ended_at,
    start_station_name,
    start_station_id,
    end_station_name,
    end_station_id,
    start_lat,
    start_lng,
    end_lat,
    end_lng,
    member_casual
  FROM [cyclistic_bike_share].[dbo].[202205]
  UNION ALL
  SELECT 
	ride_id,
    rideable_type,
    started_at,
    ended_at,
    start_station_name,
    start_station_id,
    end_station_name,
    end_station_id,
    start_lat,
    start_lng,
    end_lat,
    end_lng,
    member_casual
  FROM [cyclistic_bike_share].[dbo].[202206]
  UNION ALL
  SELECT 
	ride_id,
    rideable_type,
    started_at,
    ended_at,
    start_station_name,
    start_station_id,
    end_station_name,
    end_station_id,
    start_lat,
    start_lng,
    end_lat,
    end_lng,
    member_casual
  FROM [cyclistic_bike_share].[dbo].[202207]
  UNION ALL
  SELECT 
	ride_id,
    rideable_type,
    started_at,
    ended_at,
    start_station_name,
    start_station_id,
    end_station_name,
    end_station_id,
    start_lat,
    start_lng,
    end_lat,
    end_lng,
    member_casual
  FROM [cyclistic_bike_share].[dbo].[202208]
  UNION ALL
  SELECT 
	ride_id,
    rideable_type,
    started_at,
    ended_at,
    start_station_name,
    start_station_id,
    end_station_name,
    end_station_id,
    start_lat,
    start_lng,
    end_lat,
    end_lng,
    member_casual
  FROM [cyclistic_bike_share].[dbo].[202209]
  UNION ALL
  SELECT 
	ride_id,
    rideable_type,
    started_at,
    ended_at,
    start_station_name,
    start_station_id,
    end_station_name,
    end_station_id,
    start_lat,
    start_lng,
    end_lat,
    end_lng,
    member_casual
  FROM [cyclistic_bike_share].[dbo].[202210]
  UNION ALL
  SELECT 
	ride_id,
    rideable_type,
    started_at,
    ended_at,
    start_station_name,
    start_station_id,
    end_station_name,
    end_station_id,
    start_lat,
    start_lng,
    end_lat,
    end_lng,
    member_casual
  FROM [cyclistic_bike_share].[dbo].[202211]
  UNION ALL
  SELECT 
	ride_id,
    rideable_type,
    started_at,
    ended_at,
    start_station_name,
    start_station_id,
    end_station_name,
    end_station_id,
    start_lat,
    start_lng,
    end_lat,
    end_lng,
    member_casual
  FROM [cyclistic_bike_share].[dbo].[202201]
  UNION ALL
  SELECT 
	ride_id,
    rideable_type,
    started_at,
    ended_at,
    start_station_name,
    start_station_id,
    end_station_name,
    end_station_id,
    start_lat,
    start_lng,
    end_lat,
    end_lng,
    member_casual
  FROM [cyclistic_bike_share].[dbo].[202212]
  ) AS [2022];

  -- Identify and Remove Null Values --

  SELECT *
  FROM [cyclistic_bike_share].[dbo].[2022]
  WHERE
  ride_id IS NULL
  OR rideable_type IS NULL
  OR started_at IS NULL
  OR ended_at IS NULL
  OR start_station_name IS NULL
  OR end_station_name IS NULL
  OR member_casual IS NULL;

  DELETE FROM [cyclistic_bike_share].[dbo].[2022]
  WHERE
  ride_id IS NULL
  OR rideable_type IS NULL
  OR started_at IS NULL
  OR ended_at IS NULL
  OR start_station_name IS NULL
  OR end_station_name IS NULL
  OR member_casual IS NULL;

  -- Identify and remove duplicate values --

  SELECT *,
  COUNT(*) AS duplicatecount
  FROM [cyclistic_bike_share].[dbo].[2022]
  GROUP BY 
  ride_id,
  rideable_type,
  started_at,
  ended_at,
  start_station_name,
  start_station_id,
  end_station_name,
  end_station_id,
  start_lat,
  start_lng,
  end_lat,
  end_lng,
  member_casual
  HAVING COUNT(*) > 1;

  ;WITH CTE AS (
  SELECT *,
    ROW_NUMBER() OVER (PARTITION BY
      ride_id,
      rideable_type,
      started_at,
      ended_at,
      start_station_name,
      start_station_id,
      end_station_name,
      end_station_id,
      start_lat,
      start_lng,
      end_lat,
      end_lng,
      member_casual
    ORDER BY (SELECT NULL)) AS row_num
  FROM [cyclistic_bike_share].[dbo].[2022]
)
DELETE FROM CTE
WHERE row_num > 1;

-- Analysis Phase --

-- 1. Riders by member and casual users --

SELECT
COUNT(ride_id) AS no_of_riders,
member_casual
FROM [cyclistic_bike_share].[dbo].[2022]
GROUP BY
member_casual;

-- 2. Rideable-type by members and casual users --

SELECT
COUNT(ride_id) AS no_of_riders,
rideable_type,
member_casual  
FROM [cyclistic_bike_share].[dbo].[2022]
GROUP BY 
rideable_type,
member_casual
ORDER BY 
no_of_riders DESC

-- 3. Most commonly used start station by member and casual users --

SELECT
COUNT(ride_id) AS no_of_riders,
start_station_name,
member_casual
FROM [cyclistic_bike_share].[dbo].[2022]
GROUP BY
start_station_name,
member_casual
ORDER BY
no_of_riders DESC

-- 4. Start time analysis by member and casual users (Month, Day, Hour) --

SELECT
COUNT(ride_id) AS no_of_users,
DATEPART(MONTH, started_at) AS started_month,
DATEPART(WEEKDAY, started_at) AS started_day,
DATEPART(HOUR, started_at) AS started_hour,
member_casual
FROM [cyclistic_bike_share].[dbo].[2022]
GROUP BY
member_casual,
DATEPART(MONTH, started_at),
DATEPART(WEEKDAY, started_at),
DATEPART(HOUR, started_at)
ORDER BY
COUNT(ride_id) DESC;

-- 5. -- Start time analysis by member and casual users (Month, Day, Hour) --

SELECT
COUNT(ride_id) AS no_of_users,
DATEPART(MONTH, ended_at) AS ended_month,
DATEPART(WEEKDAY, ended_at) AS ended_day,
DATEPART(HOUR, ended_at) AS ended_hour,
member_casual
FROM [cyclistic_bike_share].[dbo].[2022]
GROUP BY
member_casual,
DATEPART(MONTH, ended_at),
DATEPART(WEEKDAY, ended_at),
DATEPART(HOUR, ended_at)
ORDER BY
COUNT(ride_id) DESC;