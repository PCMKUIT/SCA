#!/bin/bash
mkdir -p report
echo "Running pip-audit..."
pip install pip-audit -q
pip-audit -r requirements.txt -f markdown -o report/pip_audit_report.md
echo "pip-audit completed. Report saved to report/pip_audit_report.md"
