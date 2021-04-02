-- Step 1: create tables sales_staging, Sales, Quantity, Sales_Quantity, ERRORS_LOG using sqlcmd
IF EXISTS (SELECT 1 FROM SYS.TABLES WHERE NAME = 'Sales_staging') DROP TABLE Sales_staging
CREATE TABLE Sales_staging
(	[Product name] nvarchar(255)
      ,[Latitude] nvarchar(255)
      ,[Longitude] nvarchar(255)
      ,[Customer ID] nvarchar(255)
      ,[Post code] nvarchar(255)
      ,[Jan] nvarchar(255)
      ,[Feb] nvarchar(255)
      ,[Mar] nvarchar(255)
      ,[Apr] nvarchar(255)
      ,[May] nvarchar(255)
      ,[Jun] nvarchar(255)
      ,[Jul] nvarchar(255)
      ,[Aug] nvarchar(255)
      ,[Sep] nvarchar(255)
      ,[Oct] nvarchar(255)
      ,[Nov] nvarchar(255)
      ,[Dec] nvarchar(255)
)

IF EXISTS (SELECT 1 FROM SYS.TABLES WHERE NAME = 'Sales') DROP TABLE Sales
CREATE TABLE Sales
(	[Product name] nvarchar(255)
      ,[Latitude] float
      ,[Longitude] float
      ,[Customer ID] nvarchar(255)
      ,[Post code] nvarchar(255)
      ,[Sales_date] date
      ,[Sales] float
)

IF EXISTS (SELECT 1 FROM SYS.TABLES WHERE NAME = 'Quantity') DROP TABLE Quantity
CREATE TABLE Quantity
(	[Date] nvarchar(255)
      ,[Product name] nvarchar(255)
      ,[Latitude] nvarchar(255)
      ,[Longitude] nvarchar(255)
      ,[Customer ID] nvarchar(255)
      ,[Post code] nvarchar(255)
      ,[Quantity] nvarchar(255)
)

IF EXISTS (SELECT 1 FROM SYS.TABLES WHERE NAME = 'Sales_Quantity') DROP TABLE Sales_Quantity
CREATE TABLE Sales_Quantity
(	[Product name] nvarchar(255)
      ,[Latitude] float
      ,[Longitude] float
      ,[Customer ID] nvarchar(255)
      ,[Post code] nvarchar(255)
      ,[Sales_date] date
      ,[Quantity] float
      ,[Sales] float
)

-- Step 2: Create Procedure Sales_Transform to unpivot raw tables, using sqlcmd
DROP PROCEDURE IF EXISTS Sales_Transform
GO

CREATE PROCEDURE Sales_Transform
    (@year as int)
AS 
	-- Unpivot table to convert the months into one column, and insert to the @__UNPIVOT
    INSERT INTO [talent5_0971488888].Sales
    SELECT  a.[Product name], 
            cast(a.Latitude as float) as Latitude, 
            cast(a.Longitude as float) as Longitude, 
            a.[Customer ID], 
            a.[Post code], 
            CONVERT(varchar, '01-' + a.Sales_date + '-' + str(@year), 105) as Sales_date, 
            cast(a.Sales as float) as Sales	
	FROM [talent5_0971488888].[Sales_staging]
		unpivot
		(
			Sales
			for Sales_date in (Jan, Feb, Mar, Apr, May, Jun, Jul, Aug, Sep, Oct, Nov, Dec)
		) a;

    -- Delete data from Sales_staging table so it's ready for the next import
	DELETE FROM [talent5_0971488888].[Sales_staging]

