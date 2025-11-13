# 🛡️ Software Composition Analysis (SCA) Automation

A comprehensive **dependency security scanning** suite that automatically detects vulnerabilities, license compliance issues, and provides remediation guidance for Python and JavaScript/Node.js projects.

## 🎯 **Features**

- **🔍 Multi-Tool Scanning**: pip-audit, npm audit, OSV Scanner, Safety
- **📊 License Compliance**: Open source license risk analysis
- **🔧 Auto-Remediation**: Generate fix commands and upgrade guidance
- **📈 Trend Analysis**: Track vulnerability changes over time
- **🐳 Docker-Based**: Zero-install, consistent execution environments
- **🚀 CI/CD Ready**: GitHub Actions integration with automated PR checks

## 📁 **Project Structure**

```
SCA-Automation/
├── 📂 tools/                 # Scanner scripts
│   ├── sca_scan.sh          # Main orchestrator
│   ├── pip_audit.sh         # Python vulnerability scanner
│   ├── npm_audit.sh         # Node.js vulnerability scanner
│   ├── osv_scan.sh          # Universal OSV database scanner
│   ├── safety_scan.sh       # Python security checker
│   ├── license_checker.sh   # License compliance analyzer
│   ├── remediation_generator.sh # Fix command generator
│   ├── trend_analyzer.sh    # Historical vulnerability tracking
│   ├── risk_calculator.sh   # Risk scoring
│   └── setup_environment.sh # Environment validation
├── 📂 report/               # Scan outputs
│   ├── dependency_report.md # Consolidated security report
│   ├── license_report.md    # License compliance analysis
│   ├── remediation_guide.md # Fix instructions
│   └── trend_analysis.md    # Historical trends
├── 📂 .github/workflows/    # CI/CD pipelines
│   └── sca_scan.yml         # Automated security scanning
└── 📂 config/               # Custom scan policies
    └── scan_policies.json   # Vulnerability thresholds
```

## 🚀 **Quick Start**

### **1. Environment Setup**
```bash
# Clone and setup
git clone <repository>
cd SCA-Automation

# Validate environment
bash tools/setup_environment.sh
```

### **2. Run Complete Security Scan**
```bash
# Scan current directory (auto-detects project type)
bash tools/sca_scan.sh . report/security_scan.md

# Scan specific project
bash tools/sca_scan.sh /path/to/your/project report/custom_scan.md
```

### **3. View Results**
```bash
# Main security report
cat report/dependency_report.md

# License compliance
cat report/license_report.md

# Fix instructions
cat report/remediation_guide.md
```

## 🔧 **Individual Scanners**

### **Python Projects**
```bash
# Python vulnerability scan
bash tools/pip_audit.sh /path/to/python/project

# Python security check
bash tools/safety_scan.sh /path/to/python/project
```

### **Node.js Projects**
```bash
# Node.js vulnerability scan
bash tools/npm_audit.sh /path/to/node/project
```

### **Universal Scanning**
```bash
# Cross-platform vulnerability scan
bash tools/osv_scan.sh /path/to/project

# License compliance check
bash tools/license_checker.sh /path/to/project
```

## 📊 **Sample Output**

### **Vulnerability Report**
```markdown
# Dependency Vulnerability Report

**Scan Date:** 2024-01-15
**Project:** /path/to/project

## Scan Results

## Python pip-audit
- **CRITICAL**: django@1.6.0 - CVE-2014-0472: Directory traversal
- **HIGH**: requests@2.3.0 - CVE-2014-1829: SSL verification bypass

## Node.js npm audit
- **HIGH**: lodash@3.0.0 - Prototype pollution vulnerability

## Risk Score: 85/100
Found 15 vulnerabilities across 8 packages
```

### **License Compliance**
```markdown
# License Compliance Report

## Risk Assessment
- 🔴 High Risk: 1 package (GPL-2.0)
- 🟢 Low Risk: 23 packages (MIT/BSD/Apache)

## Status: NON-COMPLIANT
Immediate action required for GPL dependencies
```

## 🔄 **CI/CD Integration**

### **GitHub Actions**
```yaml
# .github/workflows/sca.yml
name: SCA Security Scan

on: [push, pull_request]

jobs:
  security-scan:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run SCA Scan
        run: |
          bash tools/sca_scan.sh . report/dependency_report.md
      - name: Upload Security Report
        uses: actions/upload-artifact@v4
        with:
          name: security-report
          path: report/
```

### **Pre-commit Hook**
```bash
#!/bin/bash
# .git/hooks/pre-commit
bash tools/sca_scan.sh . report/pre_commit_scan.md
if grep -q "CRITICAL" report/pre_commit_scan.md; then
    echo "❌ Critical vulnerabilities detected - commit blocked"
    exit 1
fi
```

## ⚙️ **Configuration**

### **Custom Scan Policies**
Create `config/scan_policies.json`:
```json
{
  "fail_on_severity": "HIGH",
  "allowed_licenses": ["MIT", "BSD", "Apache-2.0"],
  "excluded_packages": ["internal-tool"],
  "scan_timeout": 300
}
```

### **Environment Variables**
```bash
# Custom Docker registry
export DOCKER_REGISTRY=ghcr.io

# Scan timeout
export SCAN_TIMEOUT=600

# Debug mode
export SCA_DEBUG=1
```

## 🛡️ **Security Features**

- **Isolated Execution**: All tools run in Docker containers
- **No Network Required**: Offline vulnerability database support
- **Tamper Detection**: Script integrity validation
- **Audit Logging**: Comprehensive scan history

## 📈 **Advanced Usage**

### **Trend Analysis**
```bash
# Track vulnerability trends
bash tools/trend_analyzer.sh report/dependency_report.md

# View historical data
cat report/trend_analysis.md
```

### **Risk Scoring**
```bash
# Calculate risk score
bash tools/risk_calculator.sh report/dependency_report.md
```

### **Remediation Guidance**
```bash
# Generate fix commands
bash tools/remediation_generator.sh /path/to/project
```

## 🐳 **Docker Support**

All scanners use Docker for consistent execution:

```bash
# Manual Docker execution
docker run --rm -v $(pwd):/scan pyfound/pip-audit -r /scan/requirements.txt

# Or use the provided scripts (recommended)
bash tools/pip_audit.sh /path/to/project
```

## 🔍 **Troubleshooting**

### **Common Issues**
```bash
# Fix line endings (Windows/WSL)
bash tools/setup_environment.sh

# Docker permission issues
sudo usermod -aG docker $USER
newgrp docker

# Tool execution problems
chmod +x tools/*.sh
export SCA_DEBUG=1
```

### **Debug Mode**
```bash
# Enable verbose output
export SCA_DEBUG=1
bash tools/sca_scan.sh /path/to/project
```

## 🤝 **Contributing**

1. Fork the repository
2. Create a feature branch
3. Add tests for new functionality
4. Submit a pull request

## 📄 **License**

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 **Support**

- **Documentation**: See individual tool README files
- **Issues**: [GitHub Issues](https://github.com/your-repo/issues)
- **Discussions**: [GitHub Discussions](https://github.com/your-repo/discussions)

---

**🛡️ Proactive Dependency Security - Shift Left Your Security Posture**
