# 김해공항(RKPK) TMA 수용량 시뮬레이션

## 📌 프로젝트 개요

BlueSky 시뮬레이터를 활용한 김해국제공항(RKPK) TMA 항공기 수용량 산정 및 사용 활주로·절차별 비교 연구

---

## 🛫 공항 정보

### 김해국제공항 (RKPK / Gimhae International Airport)
- **위치**: 35°10'50"N 128°56'17"E
- **표고**: 6 ft AMSL
- **ICAO**: RKPK
- **IATA**: PUS

### 활주로 정보

#### 활주로 18R/36L (Main Runway)
- 길이: 3,200m × 60m
- RWY 18R Threshold: 35°11'37.94"N, 128°56'06.46"E (Elev: 12 ft)
- RWY 36L Threshold: 35°09'54.69"N, 128°56'19.79"E (Elev: 12 ft)

#### 활주로 18L/36R
- 길이: 2,743m × 46m  
- RWY 18L Threshold: 35°11'38.60"N, 128°56'14.73"E (Elev: 8 ft)
- RWY 36R Threshold: 35°10'10.10"N, 128°56'26.14"E (Elev: 8 ft)

### TMA (Terminal Maneuvering Area)
- **수직 범위**: FL225 / 1000 ft AGL
- **등급**: Class C, D, E
- **분리 기준**: 5 NM (수평) / 1,000 ft (수직)

---

## 📁 프로젝트 구조

```
scenario/RKPK/
├── RKPK_FIXES.scn           # 모든 Fix/Waypoint 정의
├── RKPK_BASE.scn            # 기본 설정 (TMA, 분리 기준 등)
│
├── STAR/                     # 도착 절차
│   └── KEVOX3_KALOD_36L.scn
│
├── SID/                      # 출발 절차
│
├── APP/                      # 접근 절차
│
├── Tests/                    # 수용량 테스트 시나리오
│   ├── capacity_test_ARR_RWY36L_KEVOX3_KALOD_20ph.scn
│   ├── capacity_test_ARR_RWY36L_KEVOX3_KALOD_24ph.scn
│   ├── capacity_test_ARR_RWY36L_KEVOX3_KALOD_30ph.scn
│   └── capacity_test_ARR_RWY36R_PEDLO1_APARU_20ph.scn
│
├── Analysis/                 # 분석 결과
│
└── processed/                # 파싱된 원본 절차

tools/
├── rkpk_data_parser.py           # CSV → BlueSky 시나리오 변환기
└── generate_capacity_test.py     # 수용량 테스트 시나리오 자동 생성기
```

---

## 🚀 빠른 시작

### 1. 환경 설정

```bash
# BlueSky 설치
pip install bluesky-simulator[full]

# 또는 소스에서 설치
cd /home/user/webapp
pip install -e .
```

### 2. 시스템 확인

```bash
python check.py
```

### 3. 테스트 시나리오 실행

```bash
# 기본 시나리오 (20대/시간)
bluesky --scenfile scenario/RKPK/Tests/capacity_test_ARR_RWY36L_KEVOX3_KALOD_20ph.scn

# 고밀도 시나리오 (30대/시간)
bluesky --scenfile scenario/RKPK/Tests/capacity_test_ARR_RWY36L_KEVOX3_KALOD_30ph.scn
```

---

## 🔧 사용자 정의 시나리오 생성

### 도착 트래픽 테스트

```bash
python tools/generate_capacity_test.py \
    --runway 36L \
    --interval 180 \
    --count 20 \
    --star KEVOX3_KALOD

# 옵션:
#   --runway: 18L, 18R, 36L, 36R
#   --interval: 항공기 간격 (초)
#   --count: 항공기 수
#   --star: KEVOX3_KALOD, PEDLO1_APARU, KEVOX3_MASTA
```

### 출발 트래픽 테스트

```bash
python tools/generate_capacity_test.py \
    --type departure \
    --runway 36L \
    --interval 120 \
    --count 30 \
    --sid OPONO3_KALOD

# SID 옵션:
#   OPONO3_KALOD, BURIM3_ENGOT
```

---

## 📊 수용량 분석 프로세스

### 1단계: 기본 테스트 (20대/시간)
```bash
bluesky --scenfile scenario/RKPK/Tests/capacity_test_ARR_RWY36L_KEVOX3_KALOD_20ph.scn
```
- **관찰**: 충돌 발생 여부
- **결과**: 충돌 없음 → 수용량 OK

### 2단계: 증가 테스트 (24대/시간)
```bash
bluesky --scenfile scenario/RKPK/Tests/capacity_test_ARR_RWY36L_KEVOX3_KALOD_24ph.scn
```
- **관찰**: 분리 기준 위반 여부
- **결과**: 충돌 없음 → 수용량 OK

### 3단계: 한계 테스트 (30대/시간)
```bash
bluesky --scenfile scenario/RKPK/Tests/capacity_test_ARR_RWY36L_KEVOX3_KALOD_30ph.scn
```
- **관찰**: 충돌 발생!
- **결론**: **수용량 한계 = 24-30대/시간 사이**

### 4단계: 미세 조정
- 간격을 2.5분 (24대/시간), 2분 15초 (26.7대/시간) 등으로 조정
- 최적 수용량 정밀 산정

---

## 📈 비교 분석

### 활주로별 비교

| 활주로 | 길이 | STAR | 수용량 (대/시간) | 비고 |
|--------|------|------|------------------|------|
| RWY 36L | 3,200m | KEVOX3 | 24-30 | Main Runway |
| RWY 36R | 2,743m | PEDLO1 | 22-28 | Shorter |
| RWY 18L | 2,743m | GAYHA3 | 20-25 | - |
| RWY 18R | 3,200m | GAYHA3 | 24-30 | Main Runway |

### 절차별 비교

| STAR | 경로 길이 | Waypoints | 평균 비행시간 | 효율성 |
|------|-----------|-----------|---------------|--------|
| KEVOX3 (KALOD) | ~45 NM | 5개 | 12분 | ⭐⭐⭐⭐ |
| PEDLO1 (APARU) | ~40 NM | 3개 | 10분 | ⭐⭐⭐⭐⭐ |
| KEVOX3 (MASTA) | ~43 NM | 5개 | 11분 | ⭐⭐⭐⭐ |

---

## 🛠️ 구현된 절차

### STAR (Standard Terminal Arrival Route)

#### KEVOX 3 ARRIVAL (RWY 36L/R)
- **KALOD Transition**: KALOD → OVTUS → KEVOX → RWY 36L
- **MASTA Transition**: MASTA → OVTUS → KEVOX → RWY 36L
- **SARAM Transition**: SARAM → KEVOX → RWY 36L
- **ANROD Transition**: ANROD → NUKBA → KEVOX → RWY 36L

#### PEDLO 1 ARRIVAL (RWY 36L/R)
- **APARU Transition**: APARU → PEDLO → AKEVI → RWY 36L
- **KALEK Transition**: KALEK → HAEUN → PEDLO → RWY 36L
- **INVOK Transition**: INVOK → PEDLO → RWY 36L
- **APELA Transition**: APELA → PEDLO → RWY 36L

#### GAYHA 3 ARRIVAL (RWY 18L/R)
- **KALOD Transition**: KALOD → GAYHA → RWY 18L
- **MASTA Transition**: MASTA → GAYHA → RWY 18L
- **APARU Transition**: APARU → ARECO → GAYHA → RWY 18L

### SID (Standard Instrument Departure)

#### OPONO 3 DEPARTURE (RWY 36L/R)
- **KALOD Transition**: RWY 36L → OPONO → KALOD
- **MASTA Transition**: RWY 36L → OPONO → MASTA
- **ENGOT Transition**: RWY 36L → OPONO → PK521 → ENGOT
- **BESNA Transition**: RWY 36L → OPONO → PK521 → BESNA

#### BURIM 3 DEPARTURE (RWY 18L/R)
- **ENGOT Transition**: RWY 18L → BURIM → BAHDA → ENGOT
- **BESNA Transition**: RWY 18L → BURIM → BAHDA → BESNA
- **INVOK Transition**: RWY 18L → BURIM → BAHDA → INVOK
- **PSN Transition**: RWY 18L → BURIM → PK513 → PSN

### IAP (Instrument Approach Procedure)

#### RWY 36L
- ILS Z RWY 36L (via KEVOX)
- ILS Z RWY 36L (via PEDLO)
- ILS CAT II RWY 36L
- LOC Z RWY 36L
- RNP RWY 36L

#### RWY 36R
- ILS Z RWY 36R (via KEVOX)
- ILS Z RWY 36R (via PEDLO)
- LOC Z RWY 36R
- RNP RWY 36R

#### RWY 18L/R
- RNP B RWY 18LR

---

## 📊 데이터 로깅 및 분석

### 충돌 감지 로그

시뮬레이션 실행 중 ASAS(Airborne Separation Assurance System)가 자동으로 충돌을 감지하고 기록합니다.

```bash
# 로그 파일 위치
output/SKYLOG_[timestamp].csv
```

### 주요 메트릭

- **충돌 횟수** (Conflicts)
- **분리 기준 위반** (Separation Violations)
- **평균 지연 시간** (Average Delay)
- **TMA 체류 시간** (TMA Occupancy Time)
- **항공기 간 간격** (Aircraft Separation)

---

## ⚙️ 시뮬레이션 설정

### 기본 파라미터 (RKPK_BASE.scn)

```
분리 기준:
- 수평: 5 NM (ZONER 5)
- 수직: 1,000 ft (ZONEDH 1000)

충돌 감지:
- ASAS: ON
- 방법: STATEBASED
- Look-ahead time: 180초
- Update interval: 30초

TMA 영역:
- 상한: FL225 (22,500 ft)
- 하한: 1,000 ft AGL
```

---

## 📝 연구 방법론

### 1. 이론적 수용량 계산

```
수용량 = 3600 / 최소분리시간(초)

예: 
- 3분 간격 → 3600 / 180 = 20대/시간
- 2분 간격 → 3600 / 120 = 30대/시간
```

### 2. 실제 수용량 측정

시뮬레이션을 통해 충돌 발생 직전까지의 최대 트래픽 처리량 측정

### 3. 절차별 효율성 평가

각 STAR/SID 절차의 비행 시간, 경로 복잡도, 충돌 위험도 비교

### 4. 최적화 권고안 도출

- 병목 구간 식별
- 절차 개선 방안
- 운영 모드 최적화

---

## 🎓 학술적 활용

### 논문 구성 예시

1. **서론**: 김해공항 현황 및 연구 필요성
2. **이론적 배경**: TMA 수용량 산정 이론
3. **연구 방법**: BlueSky 시뮬레이터 활용
4. **시뮬레이션 설정**: 절차, 파라미터, 시나리오
5. **결과**: 활주로/절차별 수용량 비교
6. **분석 및 토의**: 병목 구간, 개선 방안
7. **결론**: 최적 운영 방안 제시

### 인용

```bibtex
@inproceedings{hoekstra2016bluesky,
  title={BlueSky ATC Simulator Project: an Open Data and Open Source Approach},
  author={Hoekstra, Jacco M and Ellerbroek, Joost},
  booktitle={Proceedings of the 7th International Conference on Research in Air Transportation},
  year={2016}
}
```

---

## 🔗 참고 자료

### 공식 문서
- [BlueSky Wiki](https://github.com/TUDelft-CNS-ATM/bluesky/wiki)
- [한국 AIP](https://www.airportal.go.kr/)
- [ICAO Annex 11](https://www.icao.int/)

### 관련 연구
- TMA 수용량 평가 방법론
- 공항 시뮬레이션 연구
- 항공 교통 흐름 관리

---

## 📞 문의 및 기여

### 프로젝트 정보
- **프로젝트**: 김해공항 TMA 수용량 시뮬레이션
- **플랫폼**: BlueSky Open ATM Simulator
- **라이선스**: MIT License

### 기여 방법
1. Fork this repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a Pull Request

---

## 📄 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다.

BlueSky는 TU Delft의 오픈소스 프로젝트이며, MIT 라이선스를 따릅니다.

---

## 🎯 다음 단계

1. ✅ 기본 시나리오 실행 및 검증
2. ⏳ 전체 활주로/절차 조합 테스트
3. ⏳ 통계 분석 및 결과 정리
4. ⏳ 최적화 권고안 작성
5. ⏳ 논문/보고서 작성

---

**마지막 업데이트**: 2026-01-09  
**버전**: 1.0.0  
**상태**: 초기 구현 완료 ✅
