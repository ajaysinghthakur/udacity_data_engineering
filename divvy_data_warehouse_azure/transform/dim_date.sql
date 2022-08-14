CREATE TABLE [dbo].[dim_dates]
(
    [datetime] datetime,
    [hour] int,
    [dayofweek] int,
    [dayofmonth] int,
    [weekofyear] int,
    [quarter] int,
    [month] int,
    [year] int
)
GO

DECLARE @StartDate DATETIME
DECLARE @EndDate DATETIME
SET @StartDate = (SELECT MIN(TRY_CONVERT(datetime, left(started_at, 19)))
FROM [dbo].[staging_trip])
DECLARE @num_years INT = 5;
SET @EndDate = DATEADD(year, @num_years, (SELECT MAX(TRY_CONVERT(datetime, left(started_at, 19)))
FROM [dbo].[staging_trip]))

WHILE @StartDate <= @EndDate
      BEGIN
    INSERT INTO [dbo].[dim_dates]
    SELECT
        @StartDate,
        DATEPART(HOUR, @StartDate),
        DATEPART(WEEKDAY, @StartDate),
        DATEPART(DAY, @StartDate),
        DATEPART(WEEK, @StartDate),
        DATEPART(QUARTER, @StartDate),
        DATEPART(MONTH, @StartDate),
        DATEPART(YEAR, @StartDate)

    SET @StartDate = DATEADD(dd, 1, @StartDate)
END