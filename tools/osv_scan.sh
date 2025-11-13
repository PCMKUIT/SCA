#!/bin/bash
mkdir -p report
echo "Running OSV scanner..."
osv-scanner --recursive --output report/osv_report.json --json .
echo "OSV scan completed. Report saved to report/osv_report.json"
