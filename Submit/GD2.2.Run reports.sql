-- Giai doan 2: Create/alter Procedure PR_REPORT_MASTER
ALTER PROCEDURE PR_REPORT_MASTER
	(
	@start_date as date,
	@end_date as date
	)
AS 
	-- Total Sales:
	SELECT FORMAT(SUM(Sales), 'C') as [Total Sales]
	FROM [talent5_0971488888].[Sales] 
	WHERE Sales_date >= @start_date and Sales_date <= @end_date

	-- Top 3 products with highest sales
	SELECT TOP(3) [Product name], FORMAT(SUM(Sales), 'c') as [Total Sales]
	FROM [talent5_0971488888].[Sales]
	WHERE Sales_date >= @start_date and Sales_date <= @end_date
	GROUP BY [Product name]
	ORDER BY SUM(Sales) DESC

	-- Top 5 clients with highest sales
	SELECT TOP(5) [Customer ID], FORMAT(SUM(Sales), 'c') as [Total Sales]
	FROM [talent5_0971488888].[Sales]
	WHERE Sales_date >= @start_date and Sales_date <= @end_date
	GROUP BY [Customer ID]
	ORDER BY SUM(Sales) DESC

EXEC PR_REPORT_MASTER '2013-11-01', '2014-02-01'