# RKPK Encoding Problem Solution Guide
# D:\bluesky-master

## Problem: cp949 Encoding Error

**Error Message:**
```
Error calling function implementation of IC: cp949
Traceback printed to terminal.
```

## Root Cause

The cp949 error occurs because:
1. BlueSky tries to read scenario files using Windows default encoding (cp949)
2. Scenario files contain non-ASCII characters or wrong encoding
3. Python's locale settings default to cp949 on Korean Windows

## Solutions (Choose One)

### Solution 1: Use Pure ASCII Scenario Files (RECOMMENDED)

**All English scenario files with NO Korean characters:**

```batch
D:\bluesky-master> bluesky --scenfile scenario\RKPK\Tests\simple_test_EN.scn
```

**Available ASCII-only files:**
- `scenario\RKPK\Tests\simple_test_EN.scn` (3 aircraft test)
- `scenario\RKPK\Tests\capacity_test_ARR_RWY36L_KEVOX3_KALOD_20ph_EN.scn` (20/hour)
- `scenario\RKPK\RKPK_BASE_EN.scn` (base configuration)

### Solution 2: Fix File Encoding with PowerShell

**Run the encoding fix tool:**

```batch
D:\bluesky-master> RKPK_FIX_ENCODING.bat
```

This converts all .scn files to UTF-8 with BOM, which BlueSky can read correctly.

### Solution 3: Set Python UTF-8 Mode

**Add environment variable (Windows 10/11):**

1. Open System Properties → Environment Variables
2. Add new system variable:
   - Variable: `PYTHONUTF8`
   - Value: `1`
3. Restart terminal
4. Run BlueSky again

**Or use command line:**

```batch
set PYTHONUTF8=1
bluesky --scenfile scenario\RKPK\Tests\capacity_test_ARR_RWY36L_KEVOX3_KALOD_20ph_EN.scn
```

### Solution 4: Quick Script with UTF-8 Environment

**Run the D-drive launcher:**

```batch
D:\bluesky-master> RKPK_RUN_D_DRIVE.bat
```

This script:
- Sets correct working directory (D:\bluesky-master)
- Checks all files exist
- Uses ASCII-only scenario files
- Handles encoding automatically

## Step-by-Step Guide

### For D:\bluesky-master Installation

**1. Extract Files**
```
Extract bluesky-master.zip to D:\
Result: D:\bluesky-master\
```

**2. Verify File Structure**
```batch
D:\bluesky-master> dir scenario\RKPK\Tests
```

Expected files:
- simple_test_EN.scn
- capacity_test_ARR_RWY36L_KEVOX3_KALOD_20ph_EN.scn
- (and others)

**3. Run Encoding Fix (One Time)**
```batch
D:\bluesky-master> RKPK_FIX_ENCODING.bat
```

**4. Run Simulation**
```batch
D:\bluesky-master> RKPK_RUN_D_DRIVE.bat
```

## Quick Test Command

**To verify everything works:**

```batch
cd /d D:\bluesky-master
bluesky --scenfile scenario\RKPK\Tests\simple_test_EN.scn
```

If this works, all encoding issues are resolved!

## In BlueSky Console

After BlueSky opens:

```
OP              # Start simulation
DTMULT 10       # 10x speed
TRAIL ON        # Show aircraft trails
ASAS CONF       # Show conflicts
```

## Troubleshooting

### "File not found" Error

**Check current directory:**
```batch
cd
```

**Expected:** `D:\bluesky-master`

**If wrong, change:**
```batch
D:
cd \bluesky-master
```

### Still Getting cp949 Error

**Use the pure ASCII scenario:**
```batch
bluesky --scenfile scenario\RKPK\Tests\simple_test_EN.scn
```

This file has:
- No Korean characters
- Pure ASCII encoding
- All comments in English

### BlueSky Not Installed

```batch
pip install bluesky-simulator[full]
```

Or use pygame version:
```batch
pip install bluesky-simulator[pygame]
```

## Files Created to Fix cp949 Error

1. **RKPK_FIX_ENCODING.bat** - Converts all files to UTF-8
2. **RKPK_RUN_D_DRIVE.bat** - D:\ drive optimized launcher
3. **simple_test_EN.scn** - Pure ASCII test scenario
4. **capacity_test_*_EN.scn** - Pure ASCII capacity tests
5. **RKPK_BASE_EN.scn** - Pure ASCII base configuration

## Why cp949 Error Happens

**Windows Locale Issue:**
- Korean Windows default encoding: cp949
- Python default: follows Windows locale
- BlueSky file reading: uses default Python encoding
- Scenario files: may be saved in UTF-8

**Solution:**
Use files with NO Korean characters (pure ASCII/English)

## Success Checklist

- [ ] Files extracted to D:\bluesky-master
- [ ] scenario\RKPK\Tests folder exists
- [ ] RKPK_RUN_D_DRIVE.bat runs without error
- [ ] BlueSky opens and shows map
- [ ] "OP" command starts simulation
- [ ] Aircraft appear on screen

## Contact

If issues persist:
1. Run: `RKPK_DIAGNOSE.bat`
2. Share error messages
3. Check: `python --version`
4. Verify: `pip list | findstr bluesky`

---

**Summary:**
Use `RKPK_RUN_D_DRIVE.bat` for automatic setup and execution.
This avoids all cp949 encoding problems!
