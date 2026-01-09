@echo off
REM ==============================================================================
REM RKPK Simulation Launcher for D:\bluesky-master
REM Pure ASCII - No encoding issues
REM ==============================================================================
chcp 65001 >nul
cls
echo.
echo ============================================================
echo   RKPK Gimhae Airport Capacity Simulation
echo   D:\bluesky-master
echo ============================================================
echo.

REM Check current directory
echo [Step 1/5] Checking current directory...
set "EXPECTED_DIR=D:\bluesky-master"
cd | findstr /I "bluesky-master" >nul
if errorlevel 1 (
    echo WARNING: Not in expected directory
    echo Current: 
    cd
    echo Expected: %EXPECTED_DIR%
    echo.
    echo Attempting to change directory...
    if exist "D:\bluesky-master" (
        D:
        cd \bluesky-master
        echo Changed to D:\bluesky-master
    ) else (
        echo ERROR: D:\bluesky-master does not exist!
        echo.
        echo Please ensure files are extracted to D:\bluesky-master
        pause
        exit /b 1
    )
) else (
    echo OK: In correct directory
)
echo.

REM Check scenario folder
echo [Step 2/5] Checking scenario folder...
if not exist scenario\RKPK\Tests (
    echo ERROR: scenario\RKPK\Tests folder not found!
    echo.
    echo Current location:
    cd
    echo.
    echo Please extract all files to D:\bluesky-master
    pause
    exit /b 1
)
echo OK: Scenario folder exists
echo.

REM List available scenarios
echo [Step 3/5] Available test scenarios:
echo.
echo   [1] RKPK Demo (3 aircraft) - Quick demo
echo   [2] Capacity Test 20/hour (5 aircraft) - Basic capacity
echo   [0] Cancel
echo.

set /p choice="Select scenario (0-2): "

if "%choice%"=="0" (
    echo Cancelled.
    pause
    exit /b 0
)

REM Set scenario file
if "%choice%"=="1" set "SCENARIO=scenario\RKPK\RKPK_demo.scn"
if "%choice%"=="2" set "SCENARIO=scenario\RKPK\Tests\capacity_test_20ph_NEW.scn"

if not defined SCENARIO (
    echo Invalid selection!
    pause
    exit /b 1
)

REM Check scenario file exists
echo.
echo [Step 4/5] Checking scenario file...
if not exist "%SCENARIO%" (
    echo ERROR: Scenario file not found!
    echo   %SCENARIO%
    echo.
    echo Please download latest files from GitHub.
    pause
    exit /b 1
)
echo OK: %SCENARIO%
echo.

REM Run BlueSky
echo [Step 5/5] Starting BlueSky...
echo.
echo ============================================================
echo   BlueSky Console Commands:
echo.
echo   OP             Start/resume simulation
echo   HOLD           Pause simulation  
echo   DTMULT 10      Run at 10x speed
echo   TRAIL ON       Show aircraft trails
echo   ASAS CONF      Show conflict status
echo   PAN RKPK       Pan to Gimhae Airport
echo   ZOOM 40        Set zoom level
echo.
echo   Close window or press Ctrl+C to exit
echo ============================================================
echo.
echo Starting in 3 seconds...
timeout /t 3 /nobreak >nul

bluesky --scenfile "%SCENARIO%"

if errorlevel 1 (
    echo.
    echo ============================================================
    echo ERROR: BlueSky execution failed
    echo ============================================================
    echo.
    echo Possible solutions:
    echo   1. Install BlueSky: pip install bluesky-simulator[full]
    echo   2. Run encoding fix: RKPK_FIX_ENCODING.bat
    echo   3. Check Python installation: python --version
    echo.
    pause
    exit /b 1
)

echo.
echo Simulation completed successfully.
pause
