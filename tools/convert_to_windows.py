#!/usr/bin/env python3
"""
Windows 경로 변환 도구
Linux 샌드박스에서 생성된 BlueSky 시나리오를 Windows 환경에 맞게 변환
"""
import os
import re
from pathlib import Path

def convert_path_in_line(line, base_path="scenario"):
    """
    PCALL 명령어의 경로를 Windows 형식으로 변환
    RKPK/RKPK_BASE.scn -> scenario/RKPK/RKPK_BASE.scn
    """
    # PCALL 명령어 찾기
    pcall_pattern = r'(>PCALL\s+)([^\s]+)'
    
    def replace_pcall(match):
        prefix = match.group(1)
        path = match.group(2)
        
        # 이미 scenario/로 시작하면 그대로 유지
        if path.startswith('scenario/') or path.startswith('scenario\\'):
            return prefix + path
        
        # RKPK/로 시작하면 scenario/ 추가
        if path.startswith('RKPK/'):
            new_path = f"{base_path}/{path}"
            return prefix + new_path
        
        return match.group(0)
    
    return re.sub(pcall_pattern, replace_pcall, line)

def convert_file(input_path, output_path=None):
    """단일 파일 변환"""
    if output_path is None:
        output_path = input_path
    
    with open(input_path, 'r', encoding='utf-8') as f:
        lines = f.readlines()
    
    converted_lines = [convert_path_in_line(line) for line in lines]
    
    with open(output_path, 'w', encoding='utf-8', newline='\n') as f:
        f.writelines(converted_lines)
    
    return output_path

def convert_directory(root_dir):
    """디렉토리 내 모든 .scn 파일 변환"""
    converted_files = []
    
    for root, dirs, files in os.walk(root_dir):
        for file in files:
            if file.endswith('.scn'):
                file_path = os.path.join(root, file)
                try:
                    convert_file(file_path)
                    converted_files.append(file_path)
                    print(f"✓ 변환 완료: {file_path}")
                except Exception as e:
                    print(f"✗ 변환 실패: {file_path} - {e}")
    
    return converted_files

if __name__ == '__main__':
    import sys
    
    # scenario/RKPK 디렉토리 변환
    rkpk_dir = Path(__file__).parent.parent / 'scenario' / 'RKPK'
    
    if not rkpk_dir.exists():
        print(f"오류: {rkpk_dir} 디렉토리를 찾을 수 없습니다.")
        sys.exit(1)
    
    print(f"=== Windows 경로 변환 시작 ===")
    print(f"대상 디렉토리: {rkpk_dir}\n")
    
    converted = convert_directory(str(rkpk_dir))
    
    print(f"\n=== 변환 완료 ===")
    print(f"총 {len(converted)}개 파일 변환됨")
