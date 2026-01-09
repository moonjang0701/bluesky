#!/usr/bin/env python3
"""
김해공항(RKPK) 수용량 테스트 시나리오 자동 생성기
Gimhae Airport Capacity Test Scenario Generator

Usage:
    python generate_capacity_test.py --runway 36L --interval 180 --count 20 --star KEVOX3
"""

import argparse
from pathlib import Path


# STAR 경로 정의
STAR_ROUTES = {
    'KEVOX3_KALOD': {
        'entry_lat': 35.900000,
        'entry_lon': 128.774028,
        'waypoints': [
            ('KALOD', 'FL150', 280),
            ('OVTUS', 10000, 260),
            ('KEVOX', 6000, 230),
            ('PK711', 6000, 230),
            ('PK712', 3300, 180),
        ]
    },
    'PEDLO1_APARU': {
        'entry_lat': 35.300000,
        'entry_lon': 129.600000,
        'waypoints': [
            ('APARU', 'FL150', 280),
            ('PEDLO', 7000, 260),
            ('AKEVI', 3300, 230),
        ]
    },
    'KEVOX3_MASTA': {
        'entry_lat': 35.900000,
        'entry_lon': 128.658333,
        'waypoints': [
            ('MASTA', 'FL150', 280),
            ('OVTUS', 10000, 260),
            ('KEVOX', 6000, 230),
            ('PK711', 6000, 230),
            ('PK712', 3300, 180),
        ]
    },
}

# SID 경로 정의
SID_ROUTES = {
    'OPONO3_KALOD': {
        'waypoints': [
            ('OPONO', 5000, 200),
            ('KALOD', 'FL150', 250),
        ]
    },
    'BURIM3_ENGOT': {
        'waypoints': [
            ('BURIM', 3000, 200),
            ('BAHDA', 5000, 220),
            ('ENGOT', 'FL100', 250),
        ]
    },
}

RUNWAYS = {
    '18L': {'lat': 35.194056, 'lon': 128.937425, 'hdg': 187, 'elevation': 8},
    '18R': {'lat': 35.193872, 'lon': 128.935128, 'hdg': 186, 'elevation': 12},
    '36L': {'lat': 35.164914, 'lon': 128.938831, 'hdg': 2, 'elevation': 12},
    '36R': {'lat': 35.169472, 'lon': 128.940594, 'hdg': 2, 'elevation': 8},
}


def generate_arrival_scenario(runway, interval, count, star):
    """도착 트래픽 시나리오 생성"""
    
    if star not in STAR_ROUTES:
        raise ValueError(f"Unknown STAR: {star}. Available: {list(STAR_ROUTES.keys())}")
    
    if runway not in RUNWAYS:
        raise ValueError(f"Unknown runway: {runway}. Available: {list(RUNWAYS.keys())}")
    
    route = STAR_ROUTES[star]
    rwy = RUNWAYS[runway]
    rwy_name = f"RW{runway}"
    
    lines = []
    
    # Header
    lines.append("# " + "=" * 78)
    lines.append(f"# 김해공항(RKPK) 수용량 테스트 - 도착 트래픽")
    lines.append(f"# Arrival Capacity Test")
    lines.append("# " + "=" * 78)
    lines.append(f"# 활주로: RWY {runway}")
    lines.append(f"# STAR: {star}")
    lines.append(f"# 간격: {interval}초 ({3600/interval:.1f}대/시간)")
    lines.append(f"# 항공기 수: {count}대")
    lines.append("# " + "=" * 78)
    lines.append("")
    
    # 기본 설정 로드
    lines.append("# 기본 설정")
    lines.append("00:00:00>PCALL RKPK/RKPK_BASE.scn")
    lines.append("")
    
    lines.append(f"# STAR: {star} to RWY {runway}")
    lines.append(f"# 간격: {interval}초 = {3600/interval:.1f}대/시간")
    lines.append("")
    
    # 항공기 생성
    for i in range(1, count + 1):
        time_sec = 60 + (i - 1) * interval  # 1분 후부터 시작
        hours = time_sec // 3600
        minutes = (time_sec % 3600) // 60
        seconds = time_sec % 60
        time_str = f"{hours:02d}:{minutes:02d}:{seconds:02d}"
        
        acid = f"ARR{i:03d}"
        
        # 다양한 기종 사용
        aircraft_types = ['B738', 'A320', 'B77W', 'A333', 'B763']
        actype = aircraft_types[i % len(aircraft_types)]
        
        lines.append(f"# Aircraft {i}/{count}")
        lines.append(f"{time_str}>CRE {acid},{actype},{route['entry_lat']},{route['entry_lon']},180,FL200,280")
        lines.append(f"{time_str}>LNAV {acid},ON")
        lines.append(f"{time_str}>VNAV {acid},ON")
        
        # Waypoints 추가
        for wp_name, alt, spd in route['waypoints']:
            lines.append(f"{time_str}>ADDWPT {acid},{wp_name},{alt},{spd}")
        
        # 최종 목적지 (활주로)
        lines.append(f"{time_str}>ADDWPT {acid},{rwy_name},0,140")
        lines.append(f"{time_str}>DEST {acid},RKPK")
        lines.append("")
    
    # Footer
    lines.append("# " + "=" * 78)
    lines.append(f"# 총 {count}대 항공기, {interval}초 간격")
    lines.append(f"# 이론적 도착률: {3600/interval:.1f}대/시간")
    lines.append(f"# 시뮬레이션 시간: {time_sec//60}분 {time_sec%60}초")
    lines.append("# " + "=" * 78)
    
    return '\n'.join(lines)


def generate_departure_scenario(runway, interval, count, sid):
    """출발 트래픽 시나리오 생성"""
    
    if sid not in SID_ROUTES:
        raise ValueError(f"Unknown SID: {sid}. Available: {list(SID_ROUTES.keys())}")
    
    if runway not in RUNWAYS:
        raise ValueError(f"Unknown runway: {runway}. Available: {list(RUNWAYS.keys())}")
    
    route = SID_ROUTES[sid]
    rwy = RUNWAYS[runway]
    
    lines = []
    
    # Header
    lines.append("# " + "=" * 78)
    lines.append(f"# 김해공항(RKPK) 수용량 테스트 - 출발 트래픽")
    lines.append(f"# Departure Capacity Test")
    lines.append("# " + "=" * 78)
    lines.append(f"# 활주로: RWY {runway}")
    lines.append(f"# SID: {sid}")
    lines.append(f"# 간격: {interval}초 ({3600/interval:.1f}대/시간)")
    lines.append(f"# 항공기 수: {count}대")
    lines.append("# " + "=" * 78)
    lines.append("")
    
    # 기본 설정 로드
    lines.append("# 기본 설정")
    lines.append("00:00:00>PCALL RKPK/RKPK_BASE.scn")
    lines.append("")
    
    lines.append(f"# SID: {sid} from RWY {runway}")
    lines.append(f"# 간격: {interval}초 = {3600/interval:.1f}대/시간")
    lines.append("")
    
    # 항공기 생성
    for i in range(1, count + 1):
        time_sec = 60 + (i - 1) * interval
        hours = time_sec // 3600
        minutes = (time_sec % 3600) // 60
        seconds = time_sec % 60
        time_str = f"{hours:02d}:{minutes:02d}:{seconds:02d}"
        
        acid = f"DEP{i:03d}"
        
        aircraft_types = ['B738', 'A320', 'B77W', 'A333', 'B763']
        actype = aircraft_types[i % len(aircraft_types)]
        
        lines.append(f"# Aircraft {i}/{count}")
        lines.append(f"{time_str}>CRE {acid},{actype},{rwy['lat']},{rwy['lon']},{rwy['hdg']},0,0")
        lines.append(f"{time_str}>LNAV {acid},ON")
        lines.append(f"{time_str}>VNAV {acid},ON")
        
        # Waypoints 추가
        for wp_name, alt, spd in route['waypoints']:
            lines.append(f"{time_str}>ADDWPT {acid},{wp_name},{alt},{spd}")
        
        lines.append(f"{time_str}>ORIG {acid},RKPK")
        lines.append("")
    
    # Footer
    lines.append("# " + "=" * 78)
    lines.append(f"# 총 {count}대 항공기, {interval}초 간격")
    lines.append(f"# 이론적 출발률: {3600/interval:.1f}대/시간")
    lines.append(f"# 시뮬레이션 시간: {time_sec//60}분 {time_sec%60}초")
    lines.append("# " + "=" * 78)
    
    return '\n'.join(lines)


def main():
    parser = argparse.ArgumentParser(description='김해공항 수용량 테스트 시나리오 생성기')
    parser.add_argument('--type', choices=['arrival', 'departure', 'mixed'], default='arrival',
                        help='트래픽 유형 (기본: arrival)')
    parser.add_argument('--runway', required=True, choices=['18L', '18R', '36L', '36R'],
                        help='활주로 선택')
    parser.add_argument('--interval', type=int, default=180,
                        help='항공기 간격 (초, 기본: 180 = 3분)')
    parser.add_argument('--count', type=int, default=20,
                        help='항공기 수 (기본: 20)')
    parser.add_argument('--star', default='KEVOX3_KALOD', choices=list(STAR_ROUTES.keys()),
                        help='STAR 선택 (도착 시)')
    parser.add_argument('--sid', default='OPONO3_KALOD', choices=list(SID_ROUTES.keys()),
                        help='SID 선택 (출발 시)')
    parser.add_argument('--output', type=str,
                        help='출력 파일명 (기본: 자동 생성)')
    
    args = parser.parse_args()
    
    # 출력 파일명 생성
    if args.output:
        output_file = Path(args.output)
    else:
        rate = 3600 / args.interval
        if args.type == 'arrival':
            filename = f"capacity_test_ARR_RWY{args.runway}_{args.star}_{rate:.0f}ph.scn"
        else:
            filename = f"capacity_test_DEP_RWY{args.runway}_{args.sid}_{rate:.0f}ph.scn"
        output_file = Path(f"/home/user/webapp/scenario/RKPK/Tests/{filename}")
    
    # 시나리오 생성
    print(f"시나리오 생성 중...")
    print(f"  유형: {args.type}")
    print(f"  활주로: RWY {args.runway}")
    print(f"  간격: {args.interval}초 ({3600/args.interval:.1f}대/시간)")
    print(f"  항공기 수: {args.count}대")
    
    if args.type == 'arrival':
        content = generate_arrival_scenario(args.runway, args.interval, args.count, args.star)
        print(f"  STAR: {args.star}")
    else:
        content = generate_departure_scenario(args.runway, args.interval, args.count, args.sid)
        print(f"  SID: {args.sid}")
    
    # 파일 저장
    output_file.parent.mkdir(parents=True, exist_ok=True)
    output_file.write_text(content, encoding='utf-8')
    
    print(f"\n✓ 시나리오 생성 완료:")
    print(f"  {output_file}")
    print(f"\n실행 명령어:")
    print(f"  bluesky --scenfile {output_file.relative_to('/home/user/webapp')}")


if __name__ == '__main__':
    main()
