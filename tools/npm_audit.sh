#!/bin/bash
mkdir -p report
echo "Running npm audit..."
npm install --package-lock-only > /dev/null 2>&1
npm audit --json > report/npm_audit_raw.json
jq -r '.advisories[]? | "* \(.module_name): \(.title) — Severity: \(.severity)"' report/npm_audit_raw.json > report/npm_audit_report.md
echo "npm audit completed. Report saved to report/npm_audit_report.md"
