-- Giai doan 2: Create/alter Procedure Sales_Transform
ALTER PROCEDURE Sales_Transform
AS 
	-- Declare a table variable
	DECLARE @__UNPIVOT TABLE
		(
		[Product name] nvarchar(255), 
		Latitude float,
		Longitude float, 
		[Customer ID] nvarchar(255),
		[Post code] nvarchar(255),
		Sales_date date,
		Sales float
		);

	-- Giai doan 1: unpivot table to convert the months into one column, and insert to the @__UNPIVOT
	INSERT INTO @__UNPIVOT
	SELECT a.[Product name], a.Latitude, a.Longitude, a.[Customer ID], a.[Post code], '01-' + a.Sales_date + '-2013' as Sales_date, a.Sales
	FROM [talent5_0971488888].[Sales_staging]
		unpivot
			  (
				Sales
				for Sales_date in (Jan, Feb, Mar, Apr, May, Jun, Jul, Aug, Sep, Oct, Nov, Dec)
			  ) a

	-- Save records into Sales table, ignore error records (Post_code = '0')
	INSERT INTO [talent5_0971488888].Sales
	SELECT * FROM @__UNPIVOT
	WHERE [Post code] <> '0'

	-- Save error records into table ERRORS_LOG	
	INSERT INTO [talent5_0971488888].ERRORS_LOG
	SELECT FORMAT(GETDATE(), 'yyyy-MM-dd') as Import_date, [Product name], Latitude, Longitude, [Customer ID], [Post code], Sales_date, Sales, 'Post_code = 0' as Error_description 
	FROM @__UNPIVOT
	WHERE [Post code] = '0'

	-- Delete data from Sales_staging table so it's ready for the next import
	DELETE FROM [talent5_0971488888].[Sales_staging]
		

EXEC Sales_Transform