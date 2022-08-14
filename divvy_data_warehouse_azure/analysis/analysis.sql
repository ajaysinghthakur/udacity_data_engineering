-- 1.a.1. Analyze how much time is spent per ride based on day of week

SELECT
    AVG([duration_seconds] / 60.0) AS avg_minutes
    ,day_of_week
FROM [fact_trips] t
JOIN [dates] d
    ON t.[started_at] = d.[datetime]
GROUP BY d.[day_of_week]

-- 1.a.2. Analyze how much time is spent per ride based on time of day
SELECT
    AVG([duration_seconds] / 60.0) AS avg_minutes
    ,d.[hour_of_day]
FROM [fact_trips] t
JOIN [dates] d
    ON t.[started_at] = d.[datetime]
GROUP BY d.[hour_of_day]
ORDER BY avg_minutes DESC

-- 1.b. Analyze how much time is spent per ride based on which station is the starting and / or ending station
SELECT
    AVG([duration_seconds] / 60.0) AS avg_minutes
    ,s.[name]
FROM [fact_trips] t
JOIN [stations] s
    ON t.[start_station_id] = s.[station_id]
    OR t.[end_station_id] = s.[station_id]
GROUP BY s.[name]

-- 1.c. Analyze how much time is spent per ride based on day of week
--      based on age of the rider at time of the ride
SELECT
    AVG([duration_seconds] / 60.0) AS avg_minutes
    ,[rider_age]
FROM [fact_trips] t
JOIN [riders] r
    ON t.[rider_id] = r.[rider_id]
GROUP BY [rider_age]
ORDER BY [rider_age]


-- 1.d. Analyze how much time is spent per ride based on day of week
--      based on whether the rider is a member or a casual rider
SELECT
    AVG([duration_seconds] / 60.0) AS avg_minutes,
    [member]
FROM [fact_trips] t
JOIN [riders] r
    ON t.[rider_id] = r.[rider_id]
GROUP BY [member]


-- 1.a. Analyze how much money is spent per month, quarter, year
SELECT SUM(p.[amount]),
[year], [month]
FROM [fact_payments] p
JOIN [dates] d
    ON p.[date] = d.[datetime]
GROUP BY [year], [month]
ORDER BY [year], [month]


-- 1.b. Analyze how much money is spent
--      per member, based on the age of the rider at account start

SELECT SUM([amount]),
    [rider_age]
FROM [fact_payments] p
JOIN [riders] r
    ON p.[rider_id] = r.[rider_id]
GROUP BY [rider_age]
ORDER BY [rider_age]





-- 3.a. EXTRA CREDIT - Analyze how much money is spent per member
--      based on how many rides the rider averages per month

WITH [rides_per_rider] ([rides], [rider_id], [year], [month])
AS (
    SELECT COUNT(*) AS rides,
        t.[rider_id], [year], [month]
    FROM [fact_trips] t
    JOIN [riders] r
        ON t.[rider_id] = r.[rider_id]
    JOIN [dates] d
        ON t.[started_at] = d.[datetime]
    GROUP BY t.[rider_id], d.[year], d.[month]
)

SELECT SUM(p.[amount]) AS money_spent,
    AVG(rr.[rides]) AS avg_monthly_num_rides,
    rr.[rider_id]
FROM [fact_payments] p
JOIN [rides_per_rider] rr
    ON p.[rider_id] = rr.[rider_id]
GROUP BY rr.[rider_id]
ORDER BY money_spent DESC


-- 3.b. EXTRA CREDIT - Analyze how much money is spent per member
--      based on how many minutes the rider spends on a bike per month

WITH [minutes_per_rider] ([minutes_spent], [rider_id], [year], [month])
AS (
    SELECT SUM([duration_seconds] / 60.0) AS minutes_spent,
        t.[rider_id], [year], [month]
    FROM [fact_trips] t
    JOIN [riders] r
        ON t.[rider_id] = r.[rider_id]
    JOIN [dates] d
        ON t.[started_at] = d.[datetime]
    GROUP BY t.[rider_id], d.[year], d.[month]
)

SELECT SUM(p.[amount]) AS money_spent,
    SUM(mr.[minutes_spent]) AS minutes_spent,
    mr.[rider_id]
FROM [fact_payments] p
JOIN [minutes_per_rider] mr
    ON p.[rider_id] = mr.[rider_id]
GROUP BY mr.[rider_id]
ORDER BY money_spent DESC