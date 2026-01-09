#!/usr/bin/env python3
"""
김해공항(RKPK) 데이터 파서
CSV 파일을 읽어서 BlueSky 시나리오 파일 생성
"""

import csv
import re
import os
from pathlib import Path


def parse_coordinate(coord_str):
    """
    좌표 문자열 파싱
    예: "35°00'51.7"N 128°43'47.2"E" → (35.0144, 128.7298)
    """
    # 도분초 형식 파싱
    pattern = r'(\d+)°(\d+)\'([\d.]+)"([NS])\s+(\d+)°(\d+)\'([\d.]+)"([EW])'
    match = re.search(pattern, coord_str)
    
    if match:
        lat_deg, lat_min, lat_sec, lat_dir = match.groups()[:4]
        lon_deg, lon_min, lon_sec, lon_dir = match.groups()[4:]
        
        # 십진법으로 변환
        lat = float(lat_deg) + float(lat_min)/60 + float(lat_sec)/3600
        lon = float(lon_deg) + float(lon_min)/60 + float(lon_sec)/3600
        
        if lat_dir == 'S':
            lat = -lat
        if lon_dir == 'W':
            lon = -lon
            
        return round(lat, 6), round(lon, 6)
    
    return None, None


def parse_altitude(alt_str):
    """
    고도 문자열 파싱
    예: "+6 000" → 6000, "FL100" → 10000
    """
    if not alt_str or alt_str == '-':
        return None
    
    # 공백 제거
    alt_str = alt_str.replace(' ', '').replace(',', '')
    
    # FL (Flight Level) 처리
    if 'FL' in alt_str.upper():
        fl = int(re.findall(r'\d+', alt_str)[0])
        return fl * 100
    
    # + 또는 - 제거
    alt_str = alt_str.replace('+', '').replace('-', '')
    
    try:
        return int(alt_str)
    except:
        return None


def parse_speed(spd_str):
    """
    속도 문자열 파싱
    예: "-230" → 230, "250" → 250
    """
    if not spd_str or spd_str == '-':
        return None
    
    # - 기호 제거
    spd_str = spd_str.replace('-', '').replace('+', '').strip()
    
    try:
        return int(spd_str)
    except:
        return None


def parse_csv_procedure(csv_file):
    """
    CSV 파일에서 절차 정보 추출
    """
    waypoints = []
    
    with open(csv_file, 'r', encoding='utf-8') as f:
        reader = csv.DictReader(f)
        
        for row in reader:
            # Waypoint 이름
            wp_name = row.get('Waypoint', '').strip()
            if not wp_name:
                continue
            
            # 좌표 파싱
            coord_str = row.get('Coordinates', '')
            lat, lon = parse_coordinate(coord_str)
            
            if lat is None or lon is None:
                continue
            
            # 고도 파싱
            alt = parse_altitude(row.get('Alt (ft)', ''))
            
            # 속도 파싱
            spd = parse_speed(row.get('Speed (kt)', ''))
            
            waypoints.append({
                'name': wp_name,
                'lat': lat,
                'lon': lon,
                'alt': alt,
                'spd': spd,
                'remarks': row.get('Remarks', '').strip()
            })
    
    return waypoints


def generate_bluesky_scenario(waypoints, procedure_name, runway=''):
    """
    BlueSky 시나리오 파일 생성
    """
    lines = []
    lines.append(f"# {procedure_name} {runway}")
    lines.append("")
    
    # Fix 정의
    lines.append("# Waypoint Definitions")
    for wp in waypoints:
        lines.append(f"00:00:00>DEFWPT {wp['name']},{wp['lat']},{wp['lon']}")
    
    lines.append("")
    lines.append("# Route Waypoints")
    lines.append(f"# {len(waypoints)} waypoints in this procedure")
    
    for i, wp in enumerate(waypoints, 1):
        alt_str = f"{wp['alt']}" if wp['alt'] else "---"
        spd_str = f"{wp['spd']}" if wp['spd'] else "---"
        remark = f"  # {wp['remarks']}" if wp['remarks'] else ""
        lines.append(f"# {i}. {wp['name']:<12} {wp['lat']:>10.6f}, {wp['lon']:>10.6f}, {alt_str:>6} ft, {spd_str:>3} kts{remark}")
    
    return '\n'.join(lines)


def main():
    """메인 함수"""
    print("=" * 80)
    print("김해공항(RKPK) 데이터 파싱 시작")
    print("=" * 80)
    
    base_dir = Path('/tmp/rkpk_data')
    output_dir = Path('/home/user/webapp/scenario/RKPK')
    
    # 모든 CSV 파일 찾기
    csv_files = list(base_dir.rglob('*.csv'))
    
    print(f"\n발견된 CSV 파일: {len(csv_files)}개")
    
    for csv_file in csv_files:
        # 파일 이름에서 절차 유형 및 이름 추출
        rel_path = csv_file.relative_to(base_dir)
        parts = rel_path.parts
        
        print(f"\n처리 중: {csv_file.name}")
        
        try:
            # CSV 파싱
            waypoints = parse_csv_procedure(csv_file)
            
            if not waypoints:
                print(f"  ⚠️  Waypoint 없음, 건너뜀")
                continue
            
            print(f"  ✓ {len(waypoints)}개 waypoint 파싱 완료")
            
            # 출력 파일명 생성
            safe_name = csv_file.stem.replace(' ', '_').replace('#U2013', '-')
            output_file = output_dir / 'processed' / f"{safe_name}.scn"
            
            # 출력 디렉토리 생성
            output_file.parent.mkdir(exist_ok=True, parents=True)
            
            # 시나리오 생성
            scenario = generate_bluesky_scenario(waypoints, csv_file.stem)
            
            # 파일 저장
            with open(output_file, 'w', encoding='utf-8') as f:
                f.write(scenario)
            
            print(f"  ✓ 저장: {output_file.name}")
            
        except Exception as e:
            print(f"  ✗ 오류: {e}")
    
    print("\n" + "=" * 80)
    print("파싱 완료!")
    print("=" * 80)


if __name__ == '__main__':
    main()
