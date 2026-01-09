@echo off
REM ==============================================================================
REM RKPK Diagnostic Tool for D:\bluesky-master
REM ==============================================================================
chcp 65001 >nul
cls
echo.
echo ============================================================
echo   RKPK Diagnostic Tool
echo   D:\bluesky-master
echo ============================================================
echo.

REM 1. Check current directory
echo [1] Current Directory:
cd
echo.

REM 2. Check if D:\bluesky-master exists
echo [2] Checking D:\bluesky-master:
if exist "D:\bluesky-master" (
    echo    OK: D:\bluesky-master exists
) else (
    echo    ERROR: D:\bluesky-master does NOT exist!
    echo.
    echo    Action needed:
    echo      - Extract files to D:\ drive
    echo      - Ensure folder name is "bluesky-master"
)
echo.

REM 3. Check scenario folder
echo [3] Checking scenario\RKPK folder:
if exist "D:\bluesky-master\scenario\RKPK" (
    echo    OK: scenario\RKPK exists
    D:
    cd \bluesky-master
    dir scenario\RKPK /B
) else (
    echo    ERROR: scenario\RKPK does NOT exist!
    echo.
    echo    Action needed:
    echo      - Download latest code from GitHub
    echo      - Extract ALL files to D:\bluesky-master
)
echo.

REM 4. Check test scenarios
echo [4] Checking test scenarios:
if exist "D:\bluesky-master\scenario\RKPK\Tests" (
    echo    OK: Tests folder exists
    D:
    cd \bluesky-master\scenario\RKPK\Tests
    echo.
    echo    Available scenario files:
    dir *.scn /B
) else (
    echo    ERROR: Tests folder does NOT exist!
)
echo.

REM 5. Check Python
echo [5] Python Installation:
python --version 2>nul
if errorlevel 1 (
    echo    ERROR: Python not found!
    echo.
    echo    Action needed:
    echo      - Install Python 3.10 or higher
    echo      - https://www.python.org/downloads/
    echo      - Check "Add Python to PATH" during install
) else (
    echo    OK: Python installed
    echo.
    echo    Python encoding:
    python -c "import sys; print('   Default:', sys.getdefaultencoding()); print('   Filesystem:', sys.getfilesystemencoding())"
)
echo.

REM 6. Check BlueSky installation
echo [6] BlueSky Installation:
python -c "import bluesky; print('   OK: BlueSky version', bluesky.__version__)" 2>nul
if errorlevel 1 (
    echo    ERROR: BlueSky not installed!
    echo.
    echo    Action needed:
    echo      pip install bluesky-simulator[full]
    echo.
    echo    Or quick install:
    echo      INSTALL_BLUESKY_WINDOWS.bat
) else (
    echo    OK: BlueSky installed
)
echo.

REM 7. Check encoding of scenario files
echo [7] Scenario File Encoding Check:
if exist "D:\bluesky-master\scenario\RKPK\Tests\simple_test_EN.scn" (
    echo    Checking simple_test_EN.scn...
    python -c "try: f=open('D:/bluesky-master/scenario/RKPK/Tests/simple_test_EN.scn','r',encoding='utf-8'); f.read(); print('   OK: UTF-8 readable'); f.close(); except: print('   ERROR: Cannot read as UTF-8')" 2>nul
) else (
    echo    ERROR: simple_test_EN.scn not found!
)
echo.

REM 8. Check PYTHONUTF8 environment
echo [8] Python UTF-8 Mode:
if defined PYTHONUTF8 (
    echo    OK: PYTHONUTF8 = %PYTHONUTF8%
) else (
    echo    WARNING: PYTHONUTF8 not set
    echo.
    echo    To fix cp949 errors, run:
    echo      set PYTHONUTF8=1
    echo.
    echo    Or add to system environment variables.
)
echo.

REM 9. Summary
echo ============================================================
echo   Diagnostic Summary
echo ============================================================
echo.
echo Ready to run? Use this command:
echo.
echo   D:
echo   cd \bluesky-master
echo   RKPK_RUN_D_DRIVE.bat
echo.
echo Or direct command:
echo   bluesky --scenfile scenario\RKPK\Tests\simple_test_EN.scn
echo.
echo If you see cp949 errors:
echo   1. Run: RKPK_FIX_ENCODING.bat
echo   2. Or use: set PYTHONUTF8=1
echo   3. Or use: English scenario files (*_EN.scn)
echo.
echo ============================================================
pause
