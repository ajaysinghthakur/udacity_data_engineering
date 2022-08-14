CREATE TABLE [dbo].[dim_station]
(
    [station_id] nvarchar(4000),
    [name] nvarchar(4000),
    [latitude] float,
    [longitude] float
)
GO

INSERT INTO [dbo].[dim_station]
    (
    station_id,
    name,
    latitude,
    longitude
    )
SELECT
    [station_id],
    [name],
    [latitude],
    [longitude]
FROM [dbo].[staging_station]

GO