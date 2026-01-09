@echo off
REM ==============================================================================
REM RKPK Quick Start - English Version (Encoding Safe)
REM ==============================================================================
chcp 65001 >nul
echo.
echo ========================================================
echo   RKPK Capacity Test - Quick Start
echo ========================================================
echo.

REM Check current directory
echo [1/3] Checking current directory...
cd
if not exist scenario\RKPK (
    echo ERROR: scenario\RKPK folder not found!
    echo.
    echo Please run this from the project root directory:
    echo   cd C:\Users\장현진\Desktop\bluesky-master
    echo.
    pause
    exit /b 1
)
echo OK: In project root directory
echo.

REM Check scenario file
echo [2/3] Checking scenario file...
if not exist scenario\RKPK\Tests\capacity_test_ARR_RWY36L_KEVOX3_KALOD_20ph_EN.scn (
    echo ERROR: Scenario file not found!
    echo   scenario\RKPK\Tests\capacity_test_ARR_RWY36L_KEVOX3_KALOD_20ph_EN.scn
    echo.
    echo Please download the latest code from GitHub.
    pause
    exit /b 1
)
echo OK: Scenario file found
echo.

REM Run BlueSky
echo [3/3] Starting BlueSky...
echo.
echo ========================================================
echo   Simulation Commands:
echo     OP           - Start/Resume simulation
echo     HOLD         - Pause
echo     DTMULT 10    - 10x speed
echo     TRAIL ON     - Show aircraft trails
echo     ASAS CONF    - Show conflicts
echo.
echo   Close window or press Ctrl+C to exit
echo ========================================================
echo.

bluesky --scenfile scenario\RKPK\Tests\capacity_test_ARR_RWY36L_KEVOX3_KALOD_20ph_EN.scn

if errorlevel 1 (
    echo.
    echo ERROR: BlueSky execution failed
    echo.
    pause
    exit /b 1
)

echo.
echo Simulation completed.
pause
