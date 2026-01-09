@echo off
REM ==============================================================================
REM BlueSky 설치 스크립트 (Windows)
REM BlueSky Installation Script for Windows
REM ==============================================================================
chcp 65001 >nul
echo.
echo ========================================================
echo   BlueSky 시뮬레이터 설치 (Windows)
echo   BlueSky Simulator Installation for Windows
echo ========================================================
echo.

REM Python 설치 확인
echo [1/4] Python 설치 확인...
python --version 2>nul
if errorlevel 1 (
    echo [오류] Python이 설치되지 않았습니다.
    echo.
    echo Python 3.10 이상을 설치해주세요:
    echo   https://www.python.org/downloads/
    echo.
    echo 설치 시 "Add Python to PATH" 옵션을 체크하세요.
    pause
    exit /b 1
)

for /f "tokens=2" %%i in ('python --version 2^>^&1') do set PYTHON_VERSION=%%i
echo Python %PYTHON_VERSION% 설치 확인됨
echo.

REM pip 업그레이드
echo [2/4] pip 업그레이드...
python -m pip install --upgrade pip
echo.

REM BlueSky 설치 옵션 선택
echo [3/4] BlueSky 설치 옵션 선택
echo.
echo 설치 옵션:
echo   [1] 전체 기능 (권장) - Qt6 GUI + 모든 기능
echo   [2] Pygame GUI - 가벼운 2D GUI
echo   [3] Headless - GUI 없이 배치 실행용
echo   [0] 취소
echo.

set /p install_choice="선택하세요 (0-3): "

if "%install_choice%"=="0" (
    echo 취소되었습니다.
    pause
    exit /b 0
)

if "%install_choice%"=="1" set install_package=bluesky-simulator[full]
if "%install_choice%"=="2" set install_package=bluesky-simulator[pygame]
if "%install_choice%"=="3" set install_package=bluesky-simulator[headless]

if not defined install_package (
    echo [오류] 잘못된 선택입니다.
    pause
    exit /b 1
)

echo.
echo [4/4] BlueSky 설치 중...
echo 패키지: %install_package%
echo.
echo 설치에는 수 분이 걸릴 수 있습니다...
echo.

python -m pip install %install_package%

if errorlevel 1 (
    echo.
    echo [오류] BlueSky 설치 중 오류가 발생했습니다.
    echo.
    echo 해결 방법:
    echo   1. Visual C++ Redistributable 설치
    echo      https://aka.ms/vs/17/release/vc_redist.x64.exe
    echo.
    echo   2. 가상환경 사용:
    echo      python -m venv venv
    echo      venv\Scripts\activate
    echo      pip install %install_package%
    echo.
    pause
    exit /b 1
)

echo.
echo ========================================================
echo   BlueSky 설치 완료!
echo ========================================================
echo.
echo 다음 단계:
echo   1. 데이터 분석용 패키지 설치 (선택사항):
echo      pip install pandas numpy matplotlib seaborn
echo.
echo   2. 시뮬레이션 실행:
echo      RKPK_RUN_WINDOWS.bat 실행
echo.
echo   3. 수동 실행:
echo      bluesky --scenfile scenario\RKPK\Tests\capacity_test_ARR_RWY36L_KEVOX3_KALOD_20ph.scn
echo.
pause
