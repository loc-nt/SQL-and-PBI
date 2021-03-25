-- Step 1: There are many null values in the sales months. We need to check if there any null values in the other columns as well.

select COUNT(1)
from [talent5_0971488888].[Sales_staging]
where [Product name] is null

select COUNT(1)
from [talent5_0971488888].[Sales_staging]
where Latitude is null

select COUNT(1)
from [talent5_0971488888].[Sales_staging]
where [Customer ID] is null

select COUNT(1)
from [talent5_0971488888].[Sales_staging]
where [Post code] is null


