@if (@X)==(@Y) @end /* JScript comment
    @echo off


    cscript //E:JScript //nologo "%~f0" %*

    exit /b %errorlevel%

@if (@X)==(@Y) @end JScript comment */


var ARGS = WScript.Arguments;

var xlCSV = 6;

var objExcel = WScript.CreateObject("Excel.Application");
var objWorkbook = objExcel.Workbooks.Open(ARGS.Item(0));
objExcel.DisplayAlerts = false;
objExcel.Visible = false;

var objWorksheet = objWorkbook.Worksheets(ARGS.Item(1))
objWorksheet.SaveAs( ARGS.Item(2), xlCSV);

objExcel.Quit();