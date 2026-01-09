@echo off
REM ==============================================================================
REM RKPK 시뮬레이션 문제 진단 도구
REM ==============================================================================
chcp 65001 >nul
echo.
echo ========================================================
echo   RKPK 시뮬레이션 문제 진단
echo ========================================================
echo.

REM 현재 디렉토리 확인
echo [1] 현재 디렉토리:
cd
echo.

REM scenario 폴더 확인
echo [2] scenario 폴더 존재 확인:
if exist scenario (
    echo ✓ scenario 폴더 있음
) else (
    echo ✗ scenario 폴더 없음 - 프로젝트 루트로 이동 필요!
    echo.
    echo 해결방법:
    echo   cd C:\Users\장현진\Desktop\bluesky-master
    pause
    exit /b 1
)
echo.

REM RKPK 폴더 확인
echo [3] scenario\RKPK 폴더 확인:
if exist scenario\RKPK (
    echo ✓ RKPK 폴더 있음
    dir scenario\RKPK /b
) else (
    echo ✗ RKPK 폴더 없음!
    echo.
    echo 해결방법:
    echo   GitHub에서 최신 코드를 다시 다운로드하세요.
    echo   https://github.com/moonjang0701/bluesky
    pause
    exit /b 1
)
echo.

REM Tests 폴더 확인
echo [4] scenario\RKPK\Tests 폴더 확인:
if exist scenario\RKPK\Tests (
    echo ✓ Tests 폴더 있음
    dir scenario\RKPK\Tests /b
) else (
    echo ✗ Tests 폴더 없음!
    pause
    exit /b 1
)
echo.

REM 시나리오 파일 확인
echo [5] 시나리오 파일 확인:
if exist scenario\RKPK\Tests\capacity_test_ARR_RWY36L_KEVOX3_KALOD_20ph.scn (
    echo ✓ 시나리오 파일 있음
    echo.
    echo 파일 정보:
    dir scenario\RKPK\Tests\capacity_test_ARR_RWY36L_KEVOX3_KALOD_20ph.scn
) else (
    echo ✗ 시나리오 파일 없음!
    echo.
    echo 찾고 있는 파일:
    echo   scenario\RKPK\Tests\capacity_test_ARR_RWY36L_KEVOX3_KALOD_20ph.scn
    pause
    exit /b 1
)
echo.

REM Python 인코딩 확인
echo [6] Python 인코딩 설정:
python -c "import sys; print('기본 인코딩:', sys.getdefaultencoding()); print('파일시스템 인코딩:', sys.getfilesystemencoding())"
echo.

echo ========================================================
echo   진단 완료!
echo ========================================================
echo.
echo 모든 파일이 정상입니다.
echo.
echo 다음 명령어로 실행하세요:
echo   bluesky --scenfile scenario\RKPK\Tests\capacity_test_ARR_RWY36L_KEVOX3_KALOD_20ph.scn
echo.
pause
