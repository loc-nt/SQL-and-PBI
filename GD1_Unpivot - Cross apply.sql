WITH __UNPIVOT 
-- unpivot table to convert the months into one column
AS (
SELECT [Product name]
		  ,[Latitude]
		  ,[Longitude]
		  ,[Customer ID]
		  ,[Post code]
		  ,[Month]
		  ,[Sales]
FROM [talent5_0971488888].[Sales_staging]
CROSS APPLY
	(
	VALUES
		('Jan-13', [Jan-13]), 
		('Feb-13', [Feb-13]),
		('Mar-13', [Mar-13]),
		('Apr-13', [Apr-13]),
		('May-13', [May-13]),
		('Jun-13', [Jun-13]),
		('Jul-13', [Jul-13]),
		('Aug-13', [Aug-13]),
		('Sep-13', [Sep-13]),
		('Oct-13', [Oct-13]),
		('Nov-13', [Nov-13]),
		('Dec-13', [Dec-13])
	) c ([Month], [Sales])
),

__removeNULL
-- remove null sales value
AS (
SELECT * 
FROM __UNPIVOT
WHERE [Sales] is not null
)

-- save into table Sales
SELECT * 
INTO Sales
FROM __removeNULL;
