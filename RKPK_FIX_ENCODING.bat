@echo off
REM ==============================================================================
REM RKPK Encoding Fix Tool - Convert all scenario files to UTF-8 BOM
REM ==============================================================================
setlocal enabledelayedexpansion
chcp 65001 >nul

echo.
echo ========================================================
echo   RKPK Encoding Fix Tool
echo ========================================================
echo.

REM Check if in correct directory
if not exist scenario\RKPK (
    echo ERROR: scenario\RKPK folder not found!
    echo.
    echo Please run from project root: D:\bluesky-master
    echo Current directory:
    cd
    echo.
    pause
    exit /b 1
)

echo [1] Creating UTF-8 encoded scenario files...
echo.

REM Create UTF-8 BOM marker file
echo Creating encoding fix script...

REM Use PowerShell to convert files to UTF-8 with BOM
powershell -Command "$files = Get-ChildItem -Path 'scenario\RKPK' -Filter '*.scn' -Recurse; foreach($file in $files) { $content = Get-Content $file.FullName -Raw -Encoding UTF8; $Utf8BomEncoding = New-Object System.Text.UTF8Encoding $true; [System.IO.File]::WriteAllText($file.FullName, $content, $Utf8BomEncoding); Write-Host \"Converted: $($file.Name)\" }"

echo.
echo [2] Encoding fix completed!
echo.
echo All .scn files have been converted to UTF-8 with BOM.
echo This should resolve cp949 encoding errors.
echo.
pause
