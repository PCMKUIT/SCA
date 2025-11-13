# Dependency Vulnerability Report

**Scan Date:** Thu Nov 13 04:43:00 UTC 2025  
**Project:** demo-python  
**Scanners:** pip-audit, npm audit, OSV Scanner, Safety

## Scan Results
## Python pip-audit - VULNERABILITIES DETECTED

### Critical Severity:
- **CRITICAL**: django 1.6.0 - CVE-2014-0472: Directory traversal
- **CRITICAL**: flask 0.10.1 - CVE-2014-0001: Remote code execution

### High Severity:
- **HIGH**: requests 2.3.0 - CVE-2014-1829: SSL verification bypass
- **HIGH**: tensorflow 1.0.0 - CVE-2017-1000201: Model hijacking

### Medium Severity:
- **MEDIUM**: numpy 1.8.0 - CVE-2017-12852: Buffer overflow
- **MEDIUM**: pillow 2.0.0 - CVE-2014-1932: Image processing vulnerability

## Node.js npm audit
No package.json found

## OSV Scanner - VULNERABILITIES DETECTED

Found 12 vulnerabilities across 8 packages:

### Python Packages:
- django 1.6.0: 3 vulnerabilities (2 CRITICAL, 1 HIGH)
- flask 0.10.1: 2 vulnerabilities (1 CRITICAL, 1 MEDIUM)
- requests 2.3.0: 1 vulnerability (HIGH)

### Node.js Packages:
- lodash 3.0.0: 2 vulnerabilities (CRITICAL)
- express 3.0.0: 2 vulnerabilities (1 CRITICAL, 1 HIGH)
- handlebars 1.0.0: 1 vulnerability (HIGH)
- mongoose 3.0.0: 1 vulnerability (MEDIUM)

## Python Safety Check - VULNERABILITIES DETECTED

### Security Issues Found:
- django 1.6.0: Multiple security vulnerabilities - upgrade to >=2.2.0
- flask 0.10.1: Outdated version with known exploits - upgrade to >=1.0.0
- requests 2.3.0: SSL verification issues - upgrade to >=2.20.0
- tensorflow 1.0.0: Model security vulnerabilities - upgrade to >=2.0.0
- numpy 1.8.0: Buffer overflow vulnerability - upgrade to >=1.15.0

## Scan Summary
All dependency vulnerability scans completed!
## 📊 Detailed Risk Assessment

### Vulnerability Breakdown by Severity

**CRITICAL Severity** (2 vulnerabilities × 10 points = 20 points)
  - CRITICAL: django 1.6.0 - CVE-2014-0472: Directory traversal
  - CRITICAL: flask 0.10.1 - CVE-2014-0001: Remote code execution

**HIGH Severity** (2 vulnerabilities × 7 points = 14 points)
  - HIGH: requests 2.3.0 - CVE-2014-1829: SSL verification bypass
  - HIGH: tensorflow 1.0.0 - CVE-2017-1000201: Model hijacking

**MEDIUM Severity** (2 vulnerabilities × 4 points = 8 points)
  - MEDIUM: numpy 1.8.0 - CVE-2017-12852: Buffer overflow
  - MEDIUM: pillow 2.0.0 - CVE-2014-1932: Image processing vulnerability

**LOW Severity** (0 vulnerabilities × 1 point = 0 points)

### Risk Score Summary

**Total Risk Score:** 42/100

**Score Breakdown:**
- CRITICAL: 2 × 10 = 20
- HIGH: 2 × 7 = 14
- MEDIUM: 2 × 4 = 8
- LOW: 0 × 1 = 0

### Risk Level Assessment

**Status:** MEDIUM RISK
**Action Required:** Address vulnerabilities within 30 days. Focus on high and medium severity issues.

### Recommended Actions

1. **Immediate Actions:** Fix all CRITICAL vulnerabilities
2. **Short-term:** Address HIGH severity vulnerabilities
3. **Medium-term:** Review and fix MEDIUM severity issues
4. **Long-term:** Establish dependency update policy

