# RKPK (Gimhae International Airport) BlueSky Simulation

**✨ NEW: Automatic Capacity Analysis Plugin** - Measures TMA throughput, peak occupancy, and separation violations automatically!

## Overview

This repository contains BlueSky simulation scenarios for Gimhae International Airport (RKPK) Terminal Control Area (TMA) capacity analysis with automated metrics collection.

## Quick Start (Windows)

### Prerequisites
- Windows 10/11
- Python 3.8+
- Git (optional, for cloning)

### Installation

1. **Download this repository**
   ```cmd
   # Download ZIP from GitHub or clone:
   git clone https://github.com/moonjang0701/bluesky.git D:\bluesky-master
   cd D:\bluesky-master
   ```

2. **Install BlueSky**
   ```cmd
   pip install bluesky-simulator[full]
   ```

3. **Run the simulation**
   ```cmd
   # Double-click or run:
   RKPK_RUN_D_DRIVE.bat
   ```

## Project Structure

```
D:\bluesky-master/
├── scenario/
│   └── RKPK/
│       ├── RKPK_BASE.scn           # Base scenario with TMA definition
│       ├── RKPK_FIXES.scn          # Waypoint definitions
│       ├── RKPK_demo.scn           # Demo scenario (3 aircraft)
│       ├── STAR/
│       │   └── KEVOX3_KALOD_36L.scn  # STAR procedure
│       └── Tests/
│           ├── capacity_test_20ph_NEW.scn       # Capacity test (5 aircraft)
│           └── capacity_analysis_test.scn       # Auto-analysis test (10 aircraft)
├── plugins/
│   └── capacity_analysis.py              # Capacity metrics plugin
├── RKPK_RUN_D_DRIVE.bat            # Main launcher
├── INSTALL_BLUESKY_WINDOWS.bat     # BlueSky installer
└── README.md                        # This file
```

## Scenarios

### 1. RKPK Demo (`RKPK_demo.scn`)
- **Description**: Quick demonstration with 3 aircraft
- **Aircraft**: KAL001 (B738), KAL002 (A320), AAR003 (B77W)
- **Purpose**: Verify system setup and visualize basic operations

### 2. Capacity Test 20ph (`capacity_test_20ph_NEW.scn`)
- **Description**: Basic capacity test with 5 aircraft at 20 per hour rate
- **Spacing**: 180 seconds (3 minutes)
- **STAR**: KEVOX3 via KALOD transition
- **Runway**: 36L

### 3. **NEW: Capacity Analysis Test** (`capacity_analysis_test.scn`)
- **Description**: Automated capacity metrics collection with 10 aircraft
- **Spacing**: 180 seconds (20 aircraft/hour rate)
- **Features**:
  - Automatic throughput calculation (arrivals/hour)
  - Peak TMA occupancy tracking
  - Separation violation detection (5 NM horizontal / 1000 ft vertical)
  - Auto-generated capacity report
- **Usage**: After simulation ends, type `CAPA REPORT` to see results

## RKPK Airport Information

**Location**: 35°10'50"N 128°56'17"E

**Runways**:
- 18R/36L: 3200m x 60m (Main)
- 18L/36R: 2743m x 46m

**TMA**: FL225 - 1000ft AGL

**Key Waypoints**:
- KALOD (35°30'12.1"N 128°46'26.5"E) - North entry
- KEVOX (35°00'51.7"N 128°43'47.2"E) - Initial Approach Fix
- OVTUS (35°06'40.3"N 128°39'00.0"E) - Intermediate Fix
- PK711 (34°57'51.9"N 128°50'32.3"E) - Final Approach Fix
- PK712 (34°58'00.0"N 128°50'42.0"E) - Final Approach Point

## BlueSky Commands

After launching the simulation, use these commands in the BlueSky console:

```
OP             # Start/resume simulation
HOLD           # Pause simulation  
DTMULT 10      # Run at 10x speed
TRAIL ON       # Show aircraft trails
PAN RKPK       # Pan camera to Gimhae Airport
ZOOM 40        # Set zoom level

# Capacity Analysis Plugin Commands
CAPA ON        # Enable capacity analysis
CAPA REPORT    # Generate capacity metrics report
CAPA RESET     # Reset analyzer (start fresh)
CAPA OFF       # Disable capacity analysis
```

### Sample Capacity Report

When you run `CAPA REPORT`, you'll see:

```
============================================================
RKPK TMA CAPACITY ANALYSIS REPORT
============================================================
Simulation Time: 1800.0 seconds (0.50 hours)

Throughput:
  Total Arrivals: 10
  Total Departures: 8
  Arrival Rate: 20.0 aircraft/hour
  Departure Rate: 16.0 aircraft/hour

Occupancy:
  Peak Occupancy: 4 aircraft
  Current Occupancy: 2 aircraft

Separation Violations:
  Total Violations: 0

✅ CAPACITY: System can handle 20 arrivals/hour
============================================================
```

## File Format

All scenario files follow the BlueSky/EHAM format:

1. **Base scenario**:
   ```
   00:00:00.00>noise off
   00:00:00.00>ASAS ON
   00:00:00.00>pan RKPK
   00:00:00.00>POLY RKPK_TMA,...
   ```

2. **Fix definitions**:
   ```
   00:00:00.00>defwpt RKPK N35'10'50.00" E128'56'17.00"
   ```

3. **Aircraft creation**:
   ```
   00:01:00.00>CRE KAL001,B738,35.9,128.774028,180,FL200,280
   00:01:00.00>DEST KAL001,RKPK
   00:01:00.00>ADDWPT KAL001,KALOD
   ```

## Troubleshooting

### Error: "Scenario file not found"
- **Solution**: Ensure you extracted all files to `D:\bluesky-master`
- Verify the path matches: `D:\bluesky-master\scenario\RKPK\`

### Error: "BlueSky command not found"
- **Solution**: Install BlueSky:
  ```cmd
  pip install bluesky-simulator[full]
  ```

### Error: "cp949 encoding"
- **Cause**: Windows encoding issues with Korean characters
- **Solution**: All new scenarios use ASCII-only format (no Korean comments)

### TMA not showing
- **Verify**: The POLY command in RKPK_BASE.scn defines the TMA boundary
- **Check**: TMA polygon coordinates in scenario file

## Data Sources

- AIP Korea (www.airportal.go.kr)
- RKPK Standard Instrument Procedures (SID/STAR/IAP)
- Official aeronautical charts (AD 2-RKPK)

## Research Purpose

This simulation is designed for:
- TMA capacity analysis
- Runway utilization studies
- Procedure comparison (STAR/SID)
- Bottleneck identification
- Separation minima verification

## Contributing

Maintained by: moonjang0701  
Repository: https://github.com/moonjang0701/bluesky

## License

This project inherits the license from the original BlueSky simulator.

## Acknowledgments

- TU Delft BlueSky Development Team
- RKPK Airport Operations
- AIP Korea

---

**Last Updated**: 2026-01-09  
**Version**: 2.0 (EHAM Format Compatible)
