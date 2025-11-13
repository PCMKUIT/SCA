# 📁 **TOOLS DIRECTORY - SCA AUTOMATION SUITE**

## 🎯 **OVERVIEW**

The `tools/` directory contains a comprehensive Software Composition Analysis (SCA) automation suite designed to identify security vulnerabilities, license compliance issues, and provide remediation guidance for software dependencies.

## 🛠 **TOOLS LIST**

### **Core Scanners**
| Tool | Purpose | Usage |
|------|---------|-------|
| **`sca_scan.sh`** | Main orchestrator - runs all scanners | `bash sca_scan.sh [PROJECT_DIR] [OUTPUT_FILE]` |
| **`pip_audit.sh`** | Python dependency vulnerability scanner | `bash pip_audit.sh [PROJECT_DIR] [OUTPUT_FILE]` |
| **`npm_audit.sh`** | Node.js dependency vulnerability scanner | `bash npm_audit.sh [PROJECT_DIR] [OUTPUT_FILE]` |
| **`osv_scan.sh`** | Universal vulnerability scanner (OSV database) | `bash osv_scan.sh [PROJECT_DIR] [OUTPUT_FILE]` |
| **`safety_scan.sh`** | Python security check | `bash safety_scan.sh [PROJECT_DIR] [OUTPUT_FILE]` |

### **Advanced Analysis**
| Tool | Purpose | Usage |
|------|---------|-------|
| **`license_checker.sh`** | Open source license compliance scanner | `bash license_checker.sh [PROJECT_DIR] [OUTPUT_FILE]` |
| **`remediation_generator.sh`** | Auto-generates fix commands for vulnerabilities | `bash remediation_generator.sh [PROJECT_DIR] [OUTPUT_FILE]` |
| **`risk_calculator.sh`** | Calculates risk scores from scan results | `bash risk_calculator.sh [SCAN_REPORT]` |
| **`trend_analyzer.sh`** | Tracks vulnerability trends over time | `bash trend_analyzer.sh [CURRENT_REPORT] [TREND_FILE]` |

### **Utility Tools**
| Tool | Purpose | Usage |
|------|---------|-------|
| **`setup_environment.sh`** | Environment setup and validation | `bash setup_environment.sh` |

## 🚀 **QUICK START**

### **1. Environment Setup**
```bash
# Validate and setup environment
bash tools/setup_environment.sh
```

### **2. Run Complete SCA Scan**
```bash
# Scan a project (auto-detects Python/Node.js)
bash tools/sca_scan.sh /path/to/project report/security_scan.md
```

### **3. Individual Scans**
```bash
# Python-specific scan
bash tools/pip_audit.sh /path/to/python/project

# Node.js-specific scan  
bash tools/npm_audit.sh /path/to/node/project

# License compliance check
bash tools/license_checker.sh /path/to/project
```

## 📊 **OUTPUT FORMAT**

All tools generate **Markdown reports** with consistent structure:

### **Vulnerability Reports**
```markdown
# Dependency Vulnerability Report
## Scan Results
- **CRITICAL**: package@version - CVE-XXXX-XXXX
- **HIGH**: package@version - Security issue
```

### **License Reports**  
```markdown
# License Compliance Report
## Risk Assessment
- 🔴 HIGH: package (GPL-2.0)
- 🟢 LOW: package (MIT)
```

### **Remediation Guides**
```markdown
# Remediation Guide
## Fix Commands
```bash
pip install --upgrade vulnerable-package
npm audit fix
```

## 🔧 **TECHNICAL SPECIFICATIONS**

### **Supported Ecosystems**
- **Python**: `requirements.txt`, `setup.py`
- **Node.js**: `package.json`, `package-lock.json`
- **Universal**: OSV Scanner (multiple ecosystems)

### **Docker Integration**
All tools use Docker containers for:
- Zero-install deployment
- Consistent execution environments
- Version-pinned security tools

### **CI/CD Ready**
- Exit codes for pipeline integration
- Standardized output formats
- Configurable thresholds

## ⚙️ **CONFIGURATION**

### **Environment Variables**
```bash
# Optional: Custom Docker registry
export DOCKER_REGISTRY=ghcr.io

# Optional: Scan timeout
export SCAN_TIMEOUT=300
```

### **Custom Policies**
Create `config/` directory for:
- `scan_policies.json` - Vulnerability thresholds
- `license_whitelist.json` - Approved licenses
- `exclusions.txt` - Ignored packages

## 🛡️ **SECURITY FEATURES**

- **Isolated execution** via Docker containers
- **No network requirements** for core scanning
- **Tamper-resistant** script validation
- **Audit trails** with timestamps and hashes

## 📈 **PERFORMANCE**

- **Parallel execution** of compatible scanners
- **Incremental scanning** for repeated runs
- **Cached results** with validation
- **Minimal resource footprint**

## 🔍 **TROUBLESHOOTING**

### **Common Issues**
```bash
# Fix line ending issues (Windows/WSL)
bash tools/setup_environment.sh

# Docker permission denied
sudo usermod -aG docker $USER

# Tool not found
chmod +x tools/*.sh
```

### **Debug Mode**
```bash
# Enable verbose output
export SCA_DEBUG=1
bash tools/sca_scan.sh /path/to/project
```

## 📚 **INTEGRATION EXAMPLES**

### **GitHub Actions**
```yaml
- name: SCA Security Scan
  run: |
    bash tools/sca_scan.sh . report/security.md
    bash tools/license_checker.sh . report/licenses.md
```

### **Pre-commit Hook**
```bash
#!/bin/bash
# .git/hooks/pre-commit
bash tools/sca_scan.sh . report/pre_commit_scan.md
if grep -q "CRITICAL" report/pre_commit_scan.md; then
    echo "Blocking commit: Critical vulnerabilities detected"
    exit 1
fi
```

## 🎯 **BEST PRACTICES**

1. **Scan early** - Integrate in development workflow
2. **Scan often** - Automated daily/weekly scans
3. **Act quickly** - Fix critical vulnerabilities within 24 hours
4. **Monitor trends** - Use trend analysis for improvement
5. **Train teams** - Developer security awareness

## 📞 **SUPPORT**

- **Documentation**: See main README.md
- **Issues**: GitHub issue tracker
- **Contributing**: Pull requests welcome

---

**🛡️ Enterprise-Grade SCA Automation - Zero Installation Required**
