# 김해공항(RKPK) TMA 수용량 시뮬레이션 - Windows 설치 및 실행 가이드

## 🚀 빠른 시작 (Quick Start)

### 1단계: 사전 준비
- **Python 3.10 이상** 설치 필요
  - 다운로드: https://www.python.org/downloads/
  - ⚠️ 설치 시 **"Add Python to PATH"** 체크 필수!
- **Visual C++ Redistributable** 설치
  - 다운로드: https://aka.ms/vs/17/release/vc_redist.x64.exe

### 2단계: BlueSky 설치

**방법 1: 자동 설치 스크립트 사용 (권장)**
```batch
INSTALL_BLUESKY_WINDOWS.bat
```
실행 후 화면 안내에 따라 설치 옵션 선택

**방법 2: 수동 설치**
```batch
# 전체 기능 설치 (권장)
pip install bluesky-simulator[full]

# 또는 가벼운 버전 (Pygame GUI)
pip install bluesky-simulator[pygame]
```

### 3단계: 시뮬레이션 실행

**방법 1: 자동 실행 스크립트 사용 (권장)**
```batch
RKPK_RUN_WINDOWS.bat
```
실행 후 테스트 시나리오 선택

**방법 2: 명령줄 직접 실행**
```batch
# RWY 36L, 20대/시간 테스트
bluesky --scenfile scenario\RKPK\Tests\capacity_test_ARR_RWY36L_KEVOX3_KALOD_20ph.scn

# RWY 36L, 24대/시간 테스트
bluesky --scenfile scenario\RKPK\Tests\capacity_test_ARR_RWY36L_KEVOX3_KALOD_24ph.scn

# RWY 36L, 30대/시간 테스트
bluesky --scenfile scenario\RKPK\Tests\capacity_test_ARR_RWY36L_KEVOX3_KALOD_30ph.scn

# RWY 36R, 20대/시간 테스트
bluesky --scenfile scenario\RKPK\Tests\capacity_test_ARR_RWY36R_PEDLO1_APARU_20ph.scn
```

---

## 📋 시스템 요구사항

### 최소 사양
- **OS**: Windows 10/11 (64-bit)
- **Python**: 3.10 이상 (3.12 권장)
- **RAM**: 4GB 이상
- **디스크**: 2GB 이상 여유 공간

### 권장 사양
- **RAM**: 8GB 이상
- **GPU**: OpenGL 3.3+ 지원 (Qt6 GUI 사용 시)
- **디스플레이**: 1920x1080 이상

---

## 🎮 시뮬레이션 조작법

### BlueSky 콘솔 명령어

#### 기본 제어
```
OP              # 시뮬레이션 시작/재개
HOLD            # 일시정지
STOP            # 시뮬레이션 정지 및 초기화
QUIT            # 종료
```

#### 시간 제어
```
DTMULT 1        # 실시간 속도 (1배속)
DTMULT 10       # 10배속
DTMULT 60       # 60배속
FF              # 빨리 감기
```

#### 화면 제어
```
PAN RKPK        # 김해공항으로 이동
ZOOM 40         # 줌 레벨 40
TRAIL ON        # 항적 표시
TRAIL OFF       # 항적 숨김
```

#### 충돌 감지
```
ASAS ON         # 충돌 감지 활성화
ASAS CONF       # 충돌 상황 표시
ASAS OFF        # 충돌 감지 비활성화
```

#### 항공기 제어
```
POS ARR001      # ARR001 항공기 위치 조회
ALT ARR001 5000 # ARR001 고도를 5000ft로 변경
SPD ARR001 250  # ARR001 속도를 250kt로 변경
```

---

## 📊 시나리오 구성

### 제공되는 테스트 시나리오

| 파일명 | 활주로 | STAR | 간격 | 수용량 | 비고 |
|--------|--------|------|------|--------|------|
| `capacity_test_ARR_RWY36L_KEVOX3_KALOD_20ph.scn` | 36L | KEVOX3_KALOD | 180초 | 20대/시간 | 기본 테스트 |
| `capacity_test_ARR_RWY36L_KEVOX3_KALOD_24ph.scn` | 36L | KEVOX3_KALOD | 150초 | 24대/시간 | 중간 밀도 |
| `capacity_test_ARR_RWY36L_KEVOX3_KALOD_30ph.scn` | 36L | KEVOX3_KALOD | 120초 | 30대/시간 | 고밀도 |
| `capacity_test_ARR_RWY36R_PEDLO1_APARU_20ph.scn` | 36R | PEDLO1_APARU | 180초 | 20대/시간 | 비교용 |

### 시나리오 내용
- **항공기 기종**: A320, B738, B77W, A333, B763 혼합
- **초기 위치**: TMA 입구 (KALOD/PEDLO)
- **비행 고도**: FL200 → FL150 → 10000ft → 6000ft → 착륙
- **속도**: 280kt → 260kt → 230kt → 180kt → 140kt
- **경로**: STAR 표준 절차 준수

---

## 🛠️ 고급 기능

### 새로운 시나리오 생성
```batch
python tools\generate_capacity_test.py --runway 36L --interval 180 --count 20 --star KEVOX3_KALOD
```

**옵션 설명**:
- `--runway`: 목표 활주로 (18L, 18R, 36L, 36R)
- `--interval`: 항공기 간격 (초) - 간격이 짧을수록 수용량 증가
- `--count`: 항공기 수
- `--star`: STAR 절차명

**예시**:
```batch
# RWY 36R, 2분 간격(30대/시간), 25대
python tools\generate_capacity_test.py --runway 36R --interval 120 --count 25 --star PEDLO1_APARU

# RWY 18L, 3분 간격(20대/시간), 15대
python tools\generate_capacity_test.py --runway 18L --interval 180 --count 15 --star GUNAM1A
```

### 결과 분석
시뮬레이션 실행 후 `output/` 디렉토리에 로그 파일 생성:
- `SKYLOG_*.csv`: 전체 시뮬레이션 데이터
- 항공기별 위치, 고도, 속도, 충돌 정보 포함

**Python으로 결과 분석 예시**:
```python
import pandas as pd
import matplotlib.pyplot as plt

# 로그 파일 읽기
df = pd.read_csv('output/SKYLOG_20250109_123456.csv')

# 항공기별 착륙 시간 계산
landing_times = df[df['alt'] < 100].groupby('acid')['t'].min()

# 평균 분리 시간 계산
separation = landing_times.diff().mean()
print(f"평균 분리 시간: {separation:.1f}초")
print(f"실제 수용량: {3600/separation:.1f}대/시간")

# 고도 프로파일 그래프
for acid in df['acid'].unique():
    ac_data = df[df['acid'] == acid]
    plt.plot(ac_data['t'], ac_data['alt'], label=acid)

plt.xlabel('Time (s)')
plt.ylabel('Altitude (ft)')
plt.legend()
plt.show()
```

---

## 🔧 문제 해결 (Troubleshooting)

### 1. "Python을 찾을 수 없습니다" 오류
**원인**: Python이 PATH에 추가되지 않음

**해결책**:
1. Python 재설치 시 "Add Python to PATH" 체크
2. 또는 수동으로 PATH 추가:
   - 제어판 → 시스템 → 고급 시스템 설정 → 환경 변수
   - Path에 `C:\Users\사용자명\AppData\Local\Programs\Python\Python312` 추가

### 2. "bluesky 모듈을 찾을 수 없습니다" 오류
**원인**: BlueSky가 설치되지 않음

**해결책**:
```batch
pip install bluesky-simulator[full]
```

### 3. PyQt6 설치 오류
**원인**: Visual C++ Redistributable 미설치

**해결책**:
1. https://aka.ms/vs/17/release/vc_redist.x64.exe 다운로드 및 설치
2. 컴퓨터 재시작
3. 다시 `pip install bluesky-simulator[full]` 실행

### 4. 화면이 비어 있음
**원인**: 시나리오 파일 경로 문제

**해결책**:
1. 현재 디렉토리 확인: `cd`
2. 프로젝트 루트로 이동: `cd C:\Users\장현진\Desktop\webapp`
3. 상대 경로로 실행:
   ```batch
   bluesky --scenfile scenario\RKPK\Tests\capacity_test_ARR_RWY36L_KEVOX3_KALOD_20ph.scn
   ```

### 5. 항공기가 나타나지 않음
**원인**: 시뮬레이션이 일시정지 상태

**해결책**:
- 콘솔에 `OP` 입력하여 시뮬레이션 시작
- `DTMULT 10` 입력으로 10배속 실행

### 6. Fix 정의 오류
**원인**: RKPK_FIXES.scn 경로 문제

**해결책**:
- RKPK_BASE.scn 파일에서 경로 확인:
  ```
  00:00:00>PCALL scenario/RKPK/RKPK_FIXES.scn
  ```
- 경로가 `RKPK/RKPK_FIXES.scn`로 되어 있으면 위처럼 수정

---

## 📁 디렉토리 구조

```
webapp/
├── INSTALL_BLUESKY_WINDOWS.bat    # 설치 스크립트
├── RKPK_RUN_WINDOWS.bat           # 실행 스크립트
├── WINDOWS_GUIDE.md               # 이 가이드 문서
├── scenario/
│   └── RKPK/
│       ├── README.md              # RKPK 시나리오 상세 설명
│       ├── RKPK_BASE.scn          # 기본 설정
│       ├── RKPK_FIXES.scn         # Fix/Waypoint 정의
│       ├── STAR/                  # STAR 절차
│       │   └── KEVOX3_KALOD_36L.scn
│       ├── SID/                   # SID 절차 (향후 추가)
│       ├── Tests/                 # 수용량 테스트 시나리오
│       │   ├── capacity_test_ARR_RWY36L_KEVOX3_KALOD_20ph.scn
│       │   ├── capacity_test_ARR_RWY36L_KEVOX3_KALOD_24ph.scn
│       │   ├── capacity_test_ARR_RWY36L_KEVOX3_KALOD_30ph.scn
│       │   └── capacity_test_ARR_RWY36R_PEDLO1_APARU_20ph.scn
│       └── processed/             # 변환된 SID/STAR 파일들
└── tools/
    ├── generate_capacity_test.py  # 시나리오 생성기
    └── convert_to_windows.py      # Windows 경로 변환 도구
```

---

## 📖 추가 자료

### 공식 문서
- **BlueSky Wiki**: https://github.com/TUDelft-CNS-ATM/bluesky/wiki
- **명령어 레퍼런스**: `docs/BLUESKY-COMMAND-TABLE.pdf`
- **항공기 성능**: `docs/Aircraft Performance in BlueSky_manual.pdf`

### 김해공항 관련
- **AIP Korea**: https://www.airportal.go.kr/
- **AD 2-RKPK**: 김해공항 공항 차트
- **STAR/SID**: `scenario/RKPK/README.md` 참조

---

## 💡 사용 팁

### 효율적인 테스트 방법
1. **단계적 접근**:
   - 20대/시간 → 24대/시간 → 30대/시간 순서로 테스트
   - 각 단계에서 충돌 발생 여부 확인

2. **배속 활용**:
   - 초기 진입: 1배속으로 관찰
   - 정상 비행: 10배속
   - 접근 단계: 1-5배속으로 세밀 관찰

3. **충돌 분석**:
   - `ASAS CONF` 명령어로 충돌 위험 항공기 확인
   - `TRAIL ON`으로 항적 표시하여 경로 분석
   - 로그 파일로 정량적 분석

### 연구 활용
- **수용량 산정**: 충돌 없이 처리 가능한 최대 항공기 수
- **절차 비교**: KEVOX3 vs PEDLO1 STAR 효율성
- **활주로 비교**: 36L vs 36R 수용량 차이
- **병목 지점**: TMA 내 대기/지연 발생 구간

---

## 🆘 지원 및 문의

### 문제 발생 시
1. 이 가이드의 "문제 해결" 섹션 확인
2. `scenario/RKPK/README.md` 상세 문서 참조
3. BlueSky 공식 Discord: https://discord.gg/wkBKgXCHYN
4. GitHub Issues: https://github.com/TUDelft-CNS-ATM/bluesky/issues

---

## 📝 버전 정보

- **작성일**: 2025-01-09
- **BlueSky 버전**: 1.6.0+
- **Python 버전**: 3.10+ (3.12 권장)
- **OS**: Windows 10/11

---

**즐거운 시뮬레이션 되세요! 🛫**
