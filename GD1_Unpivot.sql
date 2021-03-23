SELECT a.[Product name], a.Latitude, a.Longitude, a.[Customer ID], a.[Post code], '01-' + a.Sales_date as Sales_date, a.Sales
into [talent5_0971488888].[Sales]
FROM [talent5_0971488888].[Sales_staging]
unpivot
  (
	Sales
	for Sales_date in ([Jan-13], [Feb-13], [Mar-13], [Apr-13], [May-13], [Jun-13], [Jul-13], [Aug-13], [Sep-13], [Oct-13], [Nov-13], [Dec-13])
  ) a;

-- remember to change datatype (from table Design) into date type for Sales_date


-- check:
select month(Sales_date) from [talent5_0971488888].[Sales]
select year(Sales_date) from [talent5_0971488888].[Sales]
select day(Sales_date) from [talent5_0971488888].[Sales]