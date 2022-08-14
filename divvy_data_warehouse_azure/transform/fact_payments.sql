CREATE TABLE [dbo].[fact_payment]
(
    [payment_id] BIGINT,
    [rider_id] BIGINT,
    [date] DATETIME2,
    [amount] DECIMAL,
    [rider_age] BIGINT
)
GO

INSERT INTO [dbo].[fact_payment](
    payment_id,
    rider_id,
    date,
    amount,
    rider_age
)
SELECT
    [payment_id]
    ,p.[rider_id]
    ,CONVERT(Datetime, SUBSTRING([date], 1, 19),120) AS [date]
    ,[amount]
    ,DATEDIFF(year, r.birthday,
        CONVERT(Datetime, SUBSTRING([account_start_date], 1, 19),120)) AS [rider_age]
    FROM [dbo].[staging_payment] p
    JOIN [dbo].[staging_rider] r
        ON p.[rider_id] = r.[rider_id] 