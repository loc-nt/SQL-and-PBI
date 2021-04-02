-- Step 4: Join Quantity and Sales table, extract the error records having Post_code = 0
    -- Update date column for "Quantity"
UPDATE [talent5_0971488888].[Quantity] 
SET   [Date] = '01-' + [Date]

    -- Reformat Quantity column data type:
ALTER TABLE [talent5_0971488888].[Quantity]
ALTER COLUMN Quantity float

    -- Declare @Aggregate_table:
DECLARE @Aggregate_table TABLE
		(
		[Product name] nvarchar(255), 
		Latitude float,
		Longitude float, 
		[Customer ID] nvarchar(255),
		[Post code] nvarchar(255),
		Sales_date date,
		Quantity float
		)

    -- Declare @Join_table:
DECLARE @Join_table TABLE
		(
		[Product name] nvarchar(255), 
		Latitude float,
		Longitude float, 
		[Customer ID] nvarchar(255),
		[Post code] nvarchar(255),
		Sales_date date,
		Quantity float,
		Sales float
		)

    -- Aggregate Quantity data
INSERT INTO @Aggregate_table
SELECT [Product name],
		  cast([Latitude] as float) as Latitude,
		  cast([Longitude] as float) as Longitude,
		  [Customer ID],
		  [Post code],   
		  CONVERT(varchar, [Date], 105) as Sales_date,
		  sum(Quantity) as 'Quantity'
FROM [talent5_0971488888].[Quantity]
GROUP BY [Product name],
		  [Latitude],
		  [Longitude],
		  [Customer ID],
		  [Post code],  
		  [Date]
	
	-- Full outer join
INSERT INTO @Join_table
SELECT	Q.[Product name]
		  ,Q.[Latitude]
		  ,Q.[Longitude]
		  ,Q.[Customer ID]
		  ,Q.[Post code]      
		  ,Q.[Sales_date]
		  ,Q.Quantity
		  ,S.Sales
FROM @Aggregate_table Q
FULL JOIN [talent5_0971488888].Sales S
ON Q.[Product name] = S.[Product name]
		  and Q.[Latitude] = S.[Latitude]
		  and Q.[Longitude] = S.[Longitude]
		  and Q.[Customer ID] = S.[Customer ID]
		  and Q.[Post code] = S.[Post code]
		  and Q.[Sales_date] = S.[Sales_date]

    -- Save records into Sales_Quantity table, ignore error records (Post_code = '0')
INSERT INTO [talent5_0971488888].Sales_Quantity
SELECT * FROM @Join_table
WHERE [Post code] <> '0'

	-- Save error records into table ERRORS_LOG	
INSERT INTO [talent5_0971488888].ERRORS_LOG
SELECT FORMAT(GETDATE(), 'yyyy-MM-dd') as Import_date, [Product name], Latitude, Longitude, [Customer ID], [Post code], Sales_date, Sales, 'Post_code = 0' as Error_description 
FROM @Join_table
WHERE [Post code] = '0'