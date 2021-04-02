rem GHI CHU! VUI LONG DOI DUOI FILES .TXT --> .BAT: migrate_data.txt VA sys\ToCsv.txt

rem Convert importing files to csv:
call sys\toCsv.bat "%cd%\Raw_data\2013sales.xlsx" "2013 Data" "%cd%\Raw_data\2013sales.csv"
call sys\toCsv.bat "%cd%\Raw_data\2014sales.xlsx" "2014 Data" "%cd%\Raw_data\2014sales.csv"
call sys\toCsv.bat "%cd%\Raw_data\2015sales.xlsx" "2015 Data" "%cd%\Raw_data\2015sales.csv"
call sys\toCsv.bat "%cd%\Raw_data\Quantity_data.xlsx" "Quantity" "%cd%\Raw_data\Quantity_data.csv"

rem Step 1: create tables sales_staging, Sales, Quantity, Sales_Quantity, ERRORS_LOG using sqlcmd
rem Step 2: Create Procedure Sales_Transform to unpivot raw tables, using sqlcmd
sqlcmd -S tcp:talent5.database.windows.net -d talentdb -U talent5_0971488888 -P Abcd#12345 -i "sys\Step_1_2.sql"

rem Step 3: Import and execute the Sales_Transform for each sales table    
    rem Quantity table:
bcp talent5_0971488888.Quantity in "Raw_data\Quantity_data.csv" -c -t, -r\n -F2 -S tcp:talent5.database.windows.net -d talentdb -U talent5_0971488888 -P Abcd#12345
    rem 2013 sales:
bcp talent5_0971488888.Sales_staging in "Raw_data\2013sales.csv" -c -t, -r\n -F2 -S tcp:talent5.database.windows.net -d talentdb -U talent5_0971488888 -P Abcd#12345    
sqlcmd -S tcp:talent5.database.windows.net -d talentdb -U talent5_0971488888 -P Abcd#12345 -Q "EXEC Sales_Transform 2013"
    rem 2014 sales:
bcp talent5_0971488888.Sales_staging in "Raw_data\2014sales.csv" -c -t, -r\n -F2 -S tcp:talent5.database.windows.net -d talentdb -U talent5_0971488888 -P Abcd#12345
sqlcmd -S tcp:talent5.database.windows.net -d talentdb -U talent5_0971488888 -P Abcd#12345 -Q "EXEC Sales_Transform 2014"
    rem 2015 sales:
bcp talent5_0971488888.Sales_staging in "Raw_data\2015sales.csv" -c -t, -r\n -F2 -S tcp:talent5.database.windows.net -d talentdb -U talent5_0971488888 -P Abcd#12345
sqlcmd -S tcp:talent5.database.windows.net -d talentdb -U talent5_0971488888 -P Abcd#12345 -Q "EXEC Sales_Transform 2015"


rem Step 4: Join Quantity and Sales table, extract the error records having Post_code = 0
sqlcmd -S tcp:talent5.database.windows.net -d talentdb -U talent5_0971488888 -P Abcd#12345 -i "sys\Step_4.sql"

PAUSE
