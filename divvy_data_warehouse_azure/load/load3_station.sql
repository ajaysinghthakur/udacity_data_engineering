IF NOT EXISTS (SELECT * FROM sys.external_file_formats WHERE name = 'SynapseDelimitedTextFormat') 
	CREATE EXTERNAL FILE FORMAT [SynapseDelimitedTextFormat] 
	WITH ( FORMAT_TYPE = DELIMITEDTEXT ,
	       FORMAT_OPTIONS (
			 FIELD_TERMINATOR = ',',
			 USE_TYPE_DEFAULT = FALSE
			))
GO

IF NOT EXISTS (SELECT * FROM sys.external_data_sources WHERE name = 'divvydemofile_divvydemolake_dfs_core_windows_net') 
	CREATE EXTERNAL DATA SOURCE [divvydemofile_divvydemolake_dfs_core_windows_net] 
	WITH (
		LOCATION = 'abfss://divvydemofile@divvydemolake.dfs.core.windows.net', 
		TYPE = HADOOP 
	)
GO

CREATE EXTERNAL TABLE staging_station (
	[station_id] nvarchar(4000),
	[name] nvarchar(4000),
	[latitude] float,
	[longitude] float
	)
	WITH (
	LOCATION = 'publicstation.txt',
	DATA_SOURCE = [divvydemofile_divvydemolake_dfs_core_windows_net],
	FILE_FORMAT = [SynapseDelimitedTextFormat]
	)
GO


SELECT TOP 100 * FROM dbo.staging_station
GO