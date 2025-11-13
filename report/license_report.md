# Open Source License Compliance Report

**Scan Date:** Thu Nov 13 06:10:10 UTC 2025
**Project:** /mnt/c/Users/Pham Cao Minh Kien/Documents/INTERN/SCA
**Scan Type:** Automated License Compliance Check

## Scan Summary

## Python Dependencies

### License Analysis
- **django**: BSD-3-Clause - 🟢 LOW
- **flask**: BSD-3-Clause - 🟢 LOW
- **requests**: Apache-2.0 - 🟢 LOW
- **numpy**: BSD-3-Clause - 🟢 LOW
- **tensorflow**: Apache-2.0 - 🟢 LOW
- **pillow**: HPND - 🟢 LOW
- **urllib3**: MIT - 🟢 LOW
- **pyyaml**: MIT - 🟢 LOW
- **jinja2**: BSD-3-Clause - 🟢 LOW
- **gunicorn**: MIT - 🟢 LOW

## Node.js Dependencies

### License Analysis
- **express**: MIT - 🟢 LOW
- **lodash**: MIT - 🟢 LOW
- **axios**: MIT - 🟢 LOW
- **moment**: MIT - 🟢 LOW
- **mongoose**: MIT - 🟢 LOW
- **react**: MIT - 🟢 LOW
- **vue**: MIT - 🟢 LOW
- **webpack**: MIT - 🟢 LOW
- **babel**: MIT - 🟢 LOW
- **jest**: MIT - 🟢 LOW
- **typescript**: Apache-2.0 - 🟢 LOW
- **webpack**: MIT - 🟢 LOW
- **linux**: GPL-2.0 - 🔴 HIGH
- **ffmpeg**: LGPL-2.1 - 🟡 MEDIUM

## Risk Assessment

**Total Packages Scanned:** 24

### Risk Distribution:
- 🔴 High Risk (GPL/AGPL): 1
- 🟡 Medium Risk (LGPL): 1
- 🟢 Low Risk (MIT/BSD/Apache): 22

### Compliance Status:
❌ **NON-COMPLIANT** - High-risk licenses detected

**Immediate Action Required:**
1. Replace GPL/AGPL dependencies with permissive alternatives
2. Legal review required before production deployment

## Recommendations

### For Development Teams:
1. **Pre-approve licenses** before adding new dependencies
2. **Regular scanning** in CI/CD pipelines
3. **Documentation** of all third-party licenses
4. **Training** on open source compliance

### For Legal Teams:
1. **Quarterly audits** of dependency licenses
2. **Policy development** for license approval
3. **Vendor management** for third-party code

## Technical Details

### Scanned File Types:
- Python: requirements.txt, setup.py
- Node.js: package.json
- License files: LICENSE, COPYING

### Detection Methods:
- Package metadata analysis
- License file parsing
- Fallback to known license databases

### Tools Used:
- pip-licenses (Python)
- license-checker (Node.js)
- Manual license databases
