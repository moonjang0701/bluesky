@echo off
REM ==============================================================================
REM 김해공항(RKPK) BlueSky 시뮬레이션 실행 스크립트 (Windows)
REM Gimhae Airport BlueSky Simulation Launcher for Windows
REM ==============================================================================
chcp 65001 >nul
echo.
echo ========================================================
echo   김해공항 TMA 수용량 시뮬레이션 (RKPK)
echo   Gimhae Airport TMA Capacity Simulation
echo ========================================================
echo.

REM 현재 디렉토리 확인
echo [1/5] 현재 작업 디렉토리 확인...
cd
echo.

REM BlueSky 설치 확인
echo [2/5] BlueSky 설치 확인...
python -c "import bluesky" 2>nul
if errorlevel 1 (
    echo [오류] BlueSky가 설치되지 않았습니다.
    echo.
    echo BlueSky 설치 방법:
    echo   pip install bluesky-simulator[full]
    echo.
    echo 또는 간단 버전:
    echo   pip install bluesky-simulator[pygame]
    echo.
    pause
    exit /b 1
)
echo BlueSky 설치 확인됨
echo.

REM 시나리오 선택
echo [3/5] 시나리오 선택
echo.
echo 실행 가능한 테스트 시나리오:
echo   [1] RWY 36L - KEVOX3_KALOD STAR (20대/시간)
echo   [2] RWY 36L - KEVOX3_KALOD STAR (24대/시간)
echo   [3] RWY 36L - KEVOX3_KALOD STAR (30대/시간)
echo   [4] RWY 36R - PEDLO1_APARU STAR (20대/시간)
echo   [0] 취소
echo.

set /p choice="선택하세요 (0-4): "

if "%choice%"=="0" (
    echo 취소되었습니다.
    pause
    exit /b 0
)

if "%choice%"=="1" set scenario=scenario\RKPK\Tests\capacity_test_ARR_RWY36L_KEVOX3_KALOD_20ph.scn
if "%choice%"=="2" set scenario=scenario\RKPK\Tests\capacity_test_ARR_RWY36L_KEVOX3_KALOD_24ph.scn
if "%choice%"=="3" set scenario=scenario\RKPK\Tests\capacity_test_ARR_RWY36L_KEVOX3_KALOD_30ph.scn
if "%choice%"=="4" set scenario=scenario\RKPK\Tests\capacity_test_ARR_RWY36R_PEDLO1_APARU_20ph.scn

if not defined scenario (
    echo [오류] 잘못된 선택입니다.
    pause
    exit /b 1
)

REM 시나리오 파일 존재 확인
echo.
echo [4/5] 시나리오 파일 확인...
if not exist "%scenario%" (
    echo [오류] 시나리오 파일을 찾을 수 없습니다: %scenario%
    echo.
    echo 현재 디렉토리가 BlueSky 프로젝트 루트인지 확인하세요.
    pause
    exit /b 1
)
echo 시나리오 파일 확인됨: %scenario%
echo.

REM BlueSky 실행
echo [5/5] BlueSky 시뮬레이션 시작...
echo.
echo ========================================================
echo   시뮬레이션이 시작됩니다.
echo   
echo   콘솔 명령어:
echo     OP           - 시뮬레이션 시작/재개
echo     HOLD         - 일시정지
echo     DTMULT 10    - 10배속 실행
echo     TRAIL ON     - 항적 표시
echo     ASAS CONF    - 충돌 상황 표시
echo     
echo   종료: 창을 닫거나 Ctrl+C
echo ========================================================
echo.

bluesky --scenfile "%scenario%"

if errorlevel 1 (
    echo.
    echo [오류] BlueSky 실행 중 오류가 발생했습니다.
    echo.
    pause
    exit /b 1
)

echo.
echo 시뮬레이션이 종료되었습니다.
pause
