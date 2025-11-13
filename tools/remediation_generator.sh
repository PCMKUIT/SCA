#!/bin/bash

PROJECT_DIR=${1:-.}
SCAN_REPORT=${2:-report/dependency_report.md}
OUTPUT=${3:-report/remediation_guide.md}

echo "Generating remediation guidance based on scan results..."
mkdir -p "$(dirname "$OUTPUT")"

if [ ! -f "$SCAN_REPORT" ]; then
    echo "Scan report not found: $SCAN_REPORT"
    echo "Run SCA scan first: bash tools/sca_scan.sh $PROJECT_DIR"
    exit 1
fi

cat > "$OUTPUT" << EOF
# Vulnerability Remediation Guide

**Generated:** $(date)
**Based on scan:** $SCAN_REPORT
**Project:** $PROJECT_DIR

## Recommended Fixes Based on Scan Results
EOF

# IMPROVED: Extract ONLY package vulnerability lines (not summaries)
VULNERABLE_PACKAGES=$(grep -E "^- \*\*(CRITICAL|HIGH|MEDIUM)\*\*: [a-zA-Z0-9_-]+ [0-9]" "$SCAN_REPORT" | sort -u)

if [ -n "$VULNERABLE_PACKAGES" ]; then
    echo "" >> "$OUTPUT"
    echo "## Identified Vulnerable Packages" >> "$OUTPUT"
    echo "" >> "$OUTPUT"
    
    # Python packages remediation
    if [ -f "$PROJECT_DIR/requirements.txt" ]; then
        PYTHON_PACKAGES=$(echo "$VULNERABLE_PACKAGES" | grep -E "django|flask|requests|tensorflow|numpy|pillow|urllib3|pyyaml|jinja2" | sort -u)
        if [ -n "$PYTHON_PACKAGES" ]; then
            echo "### Python Packages Requiring Updates" >> "$OUTPUT"
            echo "" >> "$OUTPUT"
            echo "The following Python packages have security vulnerabilities:" >> "$OUTPUT"
            echo "" >> "$OUTPUT"
            
            # Clean and format the packages list
            echo "$PYTHON_PACKAGES" | while read -r line; do
                # Extract clean package info
                package_info=$(echo "$line" | sed 's/^- \*\*\(.*\)\*\*: \(.*\) - .*/\1: \2/')
                echo "$package_info" >> "$OUTPUT"
            done
            
            echo "" >> "$OUTPUT"
            echo "**Recommended upgrade commands:**" >> "$OUTPUT"
            echo '```bash' >> "$OUTPUT"
            
            # Generate specific upgrade recommendations
            if echo "$PYTHON_PACKAGES" | grep -q "django"; then
                echo "# Fix Django directory traversal and other vulnerabilities" >> "$OUTPUT"
                echo "pip install django>=4.2.0" >> "$OUTPUT"
            fi
            
            if echo "$PYTHON_PACKAGES" | grep -q "flask"; then
                echo "# Fix Flask remote code execution vulnerability" >> "$OUTPUT"
                echo "pip install flask>=2.3.0" >> "$OUTPUT"
            fi
            
            if echo "$PYTHON_PACKAGES" | grep -q "requests"; then
                echo "# Fix Requests SSL verification bypass" >> "$OUTPUT"
                echo "pip install requests>=2.31.0" >> "$OUTPUT"
            fi
            
            if echo "$PYTHON_PACKAGES" | grep -q "tensorflow"; then
                echo "# Fix TensorFlow model hijacking vulnerability" >> "$OUTPUT"
                echo "pip install tensorflow>=2.13.0" >> "$OUTPUT"
            fi
            
            if echo "$PYTHON_PACKAGES" | grep -q "numpy"; then
                echo "# Fix NumPy buffer overflow" >> "$OUTPUT"
                echo "pip install numpy>=1.24.0" >> "$OUTPUT"
            fi
            
            if echo "$PYTHON_PACKAGES" | grep -q "pillow"; then
                echo "# Fix Pillow image processing vulnerability" >> "$OUTPUT"
                echo "pip install pillow>=10.0.0" >> "$OUTPUT"
            fi
            
            echo "" >> "$OUTPUT"
            echo "# Comprehensive upgrade of all dependencies" >> "$OUTPUT"
            echo "pip install -r requirements.txt --upgrade" >> "$OUTPUT"
            echo '```' >> "$OUTPUT"
            echo "" >> "$OUTPUT"
        fi
    fi
    
    # Node.js packages remediation
    if [ -f "$PROJECT_DIR/package.json" ]; then
        NODE_PACKAGES=$(echo "$VULNERABLE_PACKAGES" | grep -E "lodash|express|handlebars|mongoose|axios|moment|jsonwebtoken|redis" | sort -u)
        if [ -n "$NODE_PACKAGES" ]; then
            echo "### Node.js Packages Requiring Updates" >> "$OUTPUT"
            echo "" >> "$OUTPUT"
            echo "The following Node.js packages have security vulnerabilities:" >> "$OUTPUT"
            echo "" >> "$OUTPUT"
            
            echo "$NODE_PACKAGES" | while read -r line; do
                package_info=$(echo "$line" | sed 's/^- \*\*\(.*\)\*\*: \(.*\) - .*/\1: \2/')
                echo "$package_info" >> "$OUTPUT"
            done
            
            echo "" >> "$OUTPUT"
            echo "**Recommended upgrade commands:**" >> "$OUTPUT"
            echo '```bash' >> "$OUTPUT"
            
            if echo "$NODE_PACKAGES" | grep -q "lodash"; then
                echo "# Fix Lodash prototype pollution" >> "$OUTPUT"
                echo "npm install lodash@^4.17.21" >> "$OUTPUT"
            fi
            
            if echo "$NODE_PACKAGES" | grep -q "express"; then
                echo "# Fix Express security issues" >> "$OUTPUT"
                echo "npm install express@^4.18.0" >> "$OUTPUT"
            fi
            
            if echo "$NODE_PACKAGES" | grep -q "handlebars"; then
                echo "# Fix Handlebars RCE vulnerability" >> "$OUTPUT"
                echo "npm install handlebars@^4.7.8" >> "$OUTPUT"
            fi
            
            echo "" >> "$OUTPUT"
            echo "# Automated security fixes" >> "$OUTPUT"
            echo "npm audit fix" >> "$OUTPUT"
            echo "npm audit fix --force  # For major version updates" >> "$OUTPUT"
            echo '```' >> "$OUTPUT"
            echo "" >> "$OUTPUT"
        fi
    fi
else
    echo "" >> "$OUTPUT"
    echo "No critical/high/medium vulnerabilities found in the scan report." >> "$OUTPUT"
    echo "" >> "$OUTPUT"
    echo "**Maintenance recommendations:**" >> "$OUTPUT"
    echo '```bash' >> "$OUTPUT"
    if [ -f "$PROJECT_DIR/requirements.txt" ]; then
        echo "pip install -r requirements.txt --upgrade  # Python" >> "$OUTPUT"
    fi
    if [ -f "$PROJECT_DIR/package.json" ]; then
        echo "npm update  # Node.js" >> "$OUTPUT"
    fi
    echo '```' >> "$OUTPUT"
fi

# Rest of the file remains the same...
cat >> "$OUTPUT" << EOF

## Security Best Practices

### Immediate Actions (Based on Scan):
1. **Prioritize critical vulnerabilities** - fix within 24 hours
2. **Test upgrades in development** before deploying to production
3. **Review changelogs** for breaking changes

### Prevention Strategies:
- Integrate SCA scanning in CI/CD pipeline
- Set up automated dependency updates
- Regular security training for developers
- Monthly dependency review meetings

### Verification:
After applying fixes, re-run the security scan:
\`\`\`bash
bash tools/sca_scan.sh $PROJECT_DIR report/rescan_after_fixes.md
\`\`\`

## Support
- **Security Team:** security@company.com
- **DevOps:** devops@company.com
- **Urgent Issues:** #security-alerts channel
EOF

echo "Remediation guide generated: $OUTPUT"
echo "Based on vulnerabilities found in: $SCAN_REPORT"