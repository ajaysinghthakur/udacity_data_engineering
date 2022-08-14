CREATE TABLE [dbo].[dim_rider] (
    [rider_id] bigint,
	[first] nvarchar(4000),
	[last] nvarchar(4000),
	[address] nvarchar(4000),
	[birthday] varchar(50),
	[account_start_date] Datetime,
	[account_end_date] Datetime,
	[is_member] bit
)
GO

INSERT INTO [dim_rider]
SELECT
        [rider_id]
        ,[first]
        ,[last]
        ,[address]
        ,[birthday]
        ,CONVERT(Datetime, SUBSTRING([account_start_date], 1, 19),120) AS [account_start_date]
        ,CONVERT(Datetime, SUBSTRING([account_end_date], 1, 19),120) AS [account_end_date]
        ,[is_member]
     FROM [dbo].[staging_rider]