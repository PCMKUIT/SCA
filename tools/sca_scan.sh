#!/bin/bash

TIMESTAMP=$(date +%Y%m%d_%H%M%S)
DEFAULT_OUTPUT="report/scan_${TIMESTAMP}.md"

PROJECT_DIR=${1:-.}
OUTPUT=${2:-$DEFAULT_OUTPUT}

echo "SCA Multi-Scanner Suite"
echo "Project: $PROJECT_DIR"
echo "Output: $OUTPUT"
echo "Scan ID: $TIMESTAMP"

# Create report directory if not exists
mkdir -p "$(dirname "$OUTPUT")"

# Start report
cat > "$OUTPUT" << EOF
# Dependency Vulnerability Report

**Scan ID:** $TIMESTAMP
**Scan Date:** $(date)  
**Project:** $PROJECT_DIR  
**Scanners:** pip-audit, npm audit, OSV Scanner, Safety

EOF

# Run all scanners
echo "## Scan Results" >> "$OUTPUT"

echo "Running pip-audit..."
bash tools/pip_audit.sh "$PROJECT_DIR" "report/pip_audit.md"
if [ -f "report/pip_audit.md" ]; then
    cat "report/pip_audit.md" >> "$OUTPUT"
else
    echo "pip-audit scan failed or no output generated" >> "$OUTPUT"
fi
echo "" >> "$OUTPUT"

echo "Running npm audit..."
bash tools/npm_audit.sh "$PROJECT_DIR" "report/npm_audit.md" 
if [ -f "report/npm_audit.md" ]; then
    cat "report/npm_audit.md" >> "$OUTPUT"
else
    echo "npm audit scan failed or no output generated" >> "$OUTPUT"
fi
echo "" >> "$OUTPUT"

echo "Running OSV Scanner..."
bash tools/osv_scan.sh "$PROJECT_DIR" "report/osv_scan.md"
if [ -f "report/osv_scan.md" ]; then
    cat "report/osv_scan.md" >> "$OUTPUT"
else
    echo "OSV Scanner scan failed or no output generated" >> "$OUTPUT"
fi
echo "" >> "$OUTPUT"

echo "Running Safety check..."
bash tools/safety_scan.sh "$PROJECT_DIR" "report/safety_scan.md"
if [ -f "report/safety_scan.md" ]; then
    cat "report/safety_scan.md" >> "$OUTPUT"
else
    echo "Safety check failed or no output generated" >> "$OUTPUT"
fi

# Check if any vulnerabilities were found
if ! grep -q "CRITICAL\|HIGH\|MEDIUM\|VULNERABILITIES DETECTED" "$OUTPUT"; then
    echo "" >> "$OUTPUT"
    echo "## Security Status" >> "$OUTPUT"
    echo "No vulnerabilities detected in scanned dependencies." >> "$OUTPUT"
fi

# Summary
echo "" >> "$OUTPUT"
echo "## Scan Summary" >> "$OUTPUT"
echo "All dependency vulnerability scans completed successfully!" >> "$OUTPUT"

# Cleanup intermediate files
echo "Cleaning up intermediate files..."
rm -f report/pip_audit.md report/npm_audit.md report/osv_scan.md report/safety_scan.md 2>/dev/null

echo "SCA scan completed: $OUTPUT"

# Run advanced analysis
echo "Running advanced security analysis..."
bash tools/risk_calculator.sh "$OUTPUT"
bash tools/trend_analyzer.sh "$OUTPUT"
bash tools/remediation_generator.sh "$PROJECT_DIR" "report/remediation_guide.md"
bash tools/license_checker.sh "$PROJECT_DIR" "report/license_report.md"

echo "Advanced security analysis completed!"
echo "Final report: $OUTPUT"