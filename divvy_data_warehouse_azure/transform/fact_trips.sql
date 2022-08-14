CREATE TABLE [dbo].[fact_trips]
(
    [trip_id] nvarchar(4000),
    [rider_id] bigint,
    [start_station_id] nvarchar(4000),
    [end_station_id] nvarchar(4000),
    [started_at] Datetime,
    [ended_at] Datetime,
    [rideable_type] nvarchar(4000),
    [rider_age] BIGINT,
    [duration_seconds] bigint

)
GO

INSERT INTO [dbo].[fact_trips]
    (
    trip_id,
    rider_id,
    start_station_id,
    end_station_id,
    started_at,
    ended_at,
    rideable_type,
    rider_age,
    duration_seconds
    )
SELECT [trip_id]
    , t.[rider_id]
    , [start_station_id]
    , [end_station_id]
    , CONVERT(Datetime, SUBSTRING([started_at], 1, 19),120) AS [started_at]
    , CONVERT(Datetime, SUBSTRING([ended_at], 1, 19),120) AS [ended_at]
    , [rideable_type]
    , DATEDIFF(year, r.birthday,
        CONVERT(Datetime, SUBSTRING([started_at], 1, 19),120)) AS [rider_age],
    DATEDIFF(SS, CONVERT(Datetime, SUBSTRING([started_at], 1, 19),120),
                  CONVERT(Datetime, SUBSTRING([ended_at], 1, 19),120))
        AS [duration_seconds]
FROM [dbo].[staging_trip] t
    JOIN [dbo].[staging_rider] r
    ON t.[rider_id] = r.[rider_id]
