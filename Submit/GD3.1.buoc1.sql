-- Add new column "Full_Date"
ALTER TABLE [talent5_0971488888].[Quantity]
ADD Sales_date date NULL

-- Populate data for "Full_Date"
UPDATE [talent5_0971488888].[Quantity] 
SET   Sales_date = '01-' + Date

-- Count rows for both tables Sales and Quantity
select count(*) from [talent5_0971488888].Quantity where [Post code] <>'0' --count = 28984
select count(*) from [talent5_0971488888].Sales	--count = 22419

-- Count and check if we have duplicates in the table Quantity and Sales
	--Table Sales has no duplicates:
	select [Product name]
      ,[Latitude]
      ,[Longitude]
      ,[Customer ID]
      ,[Post code]      
      ,[Sales_date]
	  ,count(*)
	from [talent5_0971488888].Sales
	group by [Product name]
		  ,[Latitude]
		  ,[Longitude]
		  ,[Customer ID]
		  ,[Post code]      
		  ,[Sales_date]
	having count(*) > 1
	
	--Table Quantity has some duplicates:
	select [Product name]
		  ,[Latitude]
		  ,[Longitude]
		  ,[Customer ID]
		  ,[Post code]      
		  ,[Sales_date]
		  ,count(*)
	from [talent5_0971488888].[Quantity]
	where [Post code] <>'0'
	group by [Product name]
		  ,[Latitude]
		  ,[Longitude]
		  ,[Customer ID]
		  ,[Post code]      
		  ,[Sales_date]
	having count(*) > 1

-- Full outer join table Quantity and Sales:
	-- Aggregate table Quantity first:
WITH Quantity_Aggregate
AS	(
	select [Product name]
		  ,[Latitude]
		  ,[Longitude]
		  ,[Customer ID]
		  ,[Post code]      
		  ,[Sales_date]
		  ,sum(Quantity) as 'Quantity'
	from [talent5_0971488888].[Quantity]
	where [Post code] <> '0'
	group by [Product name]
		  ,[Latitude]
		  ,[Longitude]
		  ,[Customer ID]
		  ,[Post code]      
		  ,[Sales_date]
	)
	
	-- Full outer join
SELECT	Q.[Product name]
		  ,Q.[Latitude]
		  ,Q.[Longitude]
		  ,Q.[Customer ID]
		  ,Q.[Post code]      
		  ,Q.[Sales_date]
		  ,Q.Quantity
		  ,S.Sales
INTO [talent5_0971488888].Sales_Quantity
FROM Quantity_Aggregate Q
FULL JOIN [talent5_0971488888].Sales S
ON Q.[Product name] = S.[Product name]
		  and Q.[Latitude] = S.[Latitude]
		  and Q.[Longitude] = S.[Longitude]
		  and Q.[Customer ID] = S.[Customer ID]
		  and Q.[Post code] = S.[Post code]
		  and Q.[Sales_date] = S.[Sales_date]


-- Double check and confirm:
SELECT count(*) FROM [talent5_0971488888].[Sales_Quantity] --count = 22419 = Sales table
SELECT *  FROM [talent5_0971488888].[Sales_Quantity]  WHERE Sales is null --no null Sales
SELECT *  FROM [talent5_0971488888].[Sales_Quantity]