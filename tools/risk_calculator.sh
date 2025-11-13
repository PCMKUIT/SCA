#!/bin/bash
REPORT=${1:-report/dependency_report.md}

echo "Calculating Risk Score..."

# Tạo file tạm để lọc vulnerabilities thực sự
TEMP_FILE=$(mktemp)

# Chỉ lọc các dòng vulnerability thực sự (bỏ qua summary lines)
grep -E "^- \*\*(CRITICAL|HIGH|MEDIUM|LOW)\*\*:" "$REPORT" > "$TEMP_FILE"

# Đếm chi tiết từng loại vulnerability từ các dòng thực sự
CRITICAL=$(grep -c "^- \*\*CRITICAL\*\*:" "$TEMP_FILE" 2>/dev/null || true)
HIGH=$(grep -c "^- \*\*HIGH\*\*:" "$TEMP_FILE" 2>/dev/null || true)
MEDIUM=$(grep -c "^- \*\*MEDIUM\*\*:" "$TEMP_FILE" 2>/dev/null || true) 
LOW=$(grep -c "^- \*\*LOW\*\*:" "$TEMP_FILE" 2>/dev/null || true)

# Đảm bảo là số
CRITICAL=${CRITICAL:-0}
HIGH=${HIGH:-0}
MEDIUM=${MEDIUM:-0}
LOW=${LOW:-0}

# Tính điểm risk
CRITICAL_SCORE=$((CRITICAL * 10))
HIGH_SCORE=$((HIGH * 7))
MEDIUM_SCORE=$((MEDIUM * 4))
LOW_SCORE=$((LOW * 1))
TOTAL_SCORE=$((CRITICAL_SCORE + HIGH_SCORE + MEDIUM_SCORE + LOW_SCORE))

# Lấy danh sách chi tiết vulnerabilities thực sự
echo "## 📊 Detailed Risk Assessment" >> "$REPORT"
echo "" >> "$REPORT"

echo "### Vulnerability Breakdown by Severity" >> "$REPORT"
echo "" >> "$REPORT"

echo "**CRITICAL Severity** ($CRITICAL vulnerabilities × 10 points = $CRITICAL_SCORE points)" >> "$REPORT"
grep "^- \*\*CRITICAL\*\*:" "$TEMP_FILE" | head -10 | sed 's/^- \*\*CRITICAL\*\*:/  - CRITICAL:/' >> "$REPORT"
if [ "$CRITICAL" -gt 10 ]; then
    echo "  - ... and $((CRITICAL - 10)) more CRITICAL vulnerabilities" >> "$REPORT"
fi
echo "" >> "$REPORT"

echo "**HIGH Severity** ($HIGH vulnerabilities × 7 points = $HIGH_SCORE points)" >> "$REPORT"
grep "^- \*\*HIGH\*\*:" "$TEMP_FILE" | head -10 | sed 's/^- \*\*HIGH\*\*:/  - HIGH:/' >> "$REPORT"
if [ "$HIGH" -gt 10 ]; then
    echo "  - ... and $((HIGH - 10)) more HIGH vulnerabilities" >> "$REPORT"
fi
echo "" >> "$REPORT"

echo "**MEDIUM Severity** ($MEDIUM vulnerabilities × 4 points = $MEDIUM_SCORE points)" >> "$REPORT"
grep "^- \*\*MEDIUM\*\*:" "$TEMP_FILE" | head -10 | sed 's/^- \*\*MEDIUM\*\*:/  - MEDIUM:/' >> "$REPORT"
if [ "$MEDIUM" -gt 10 ]; then
    echo "  - ... and $((MEDIUM - 10)) more MEDIUM vulnerabilities" >> "$REPORT"
fi
echo "" >> "$REPORT"

echo "**LOW Severity** ($LOW vulnerabilities × 1 point = $LOW_SCORE points)" >> "$REPORT"
grep "^- \*\*LOW\*\*:" "$TEMP_FILE" | head -5 | sed 's/^- \*\*LOW\*\*:/  - LOW:/' >> "$REPORT"
if [ "$LOW" -gt 5 ]; then
    echo "  - ... and $((LOW - 5)) more LOW vulnerabilities" >> "$REPORT"
fi
echo "" >> "$REPORT"

echo "### Risk Score Summary" >> "$REPORT"
echo "" >> "$REPORT"
echo "**Total Risk Score:** $TOTAL_SCORE/100" >> "$REPORT"
echo "" >> "$REPORT"
echo "**Score Breakdown:**" >> "$REPORT"
echo "- CRITICAL: $CRITICAL × 10 = $CRITICAL_SCORE" >> "$REPORT"
echo "- HIGH: $HIGH × 7 = $HIGH_SCORE" >> "$REPORT"
echo "- MEDIUM: $MEDIUM × 4 = $MEDIUM_SCORE" >> "$REPORT"
echo "- LOW: $LOW × 1 = $LOW_SCORE" >> "$REPORT"
echo "" >> "$REPORT"

# Risk level assessment
echo "### Risk Level Assessment" >> "$REPORT"
echo "" >> "$REPORT"
if [ $TOTAL_SCORE -gt 100 ]; then
    echo "**Status:** CRITICAL RISK" >> "$REPORT"
    echo "**Action Required:** IMMEDIATE remediation required. Project has severe security vulnerabilities that need urgent attention." >> "$REPORT"
elif [ $TOTAL_SCORE -gt 50 ]; then
    echo "**Status:** HIGH RISK" >> "$REPORT"
    echo "**Action Required:** Prioritize fixing critical and high severity vulnerabilities within 7 days." >> "$REPORT"
elif [ $TOTAL_SCORE -gt 20 ]; then
    echo "**Status:** MEDIUM RISK" >> "$REPORT"
    echo "**Action Required:** Address vulnerabilities within 30 days. Focus on high and medium severity issues." >> "$REPORT"
else
    echo "**Status:** LOW RISK" >> "$REPORT"
    echo "**Action Required:** Regular monitoring recommended. Address low severity issues in next development cycle." >> "$REPORT"
fi
echo "" >> "$REPORT"

echo "### Recommended Actions" >> "$REPORT"
echo "" >> "$REPORT"
echo "1. **Immediate Actions:** Fix all CRITICAL vulnerabilities" >> "$REPORT"
echo "2. **Short-term:** Address HIGH severity vulnerabilities" >> "$REPORT"
echo "3. **Medium-term:** Review and fix MEDIUM severity issues" >> "$REPORT"
echo "4. **Long-term:** Establish dependency update policy" >> "$REPORT"
echo "" >> "$REPORT"

# Dọn dẹp
rm -f "$TEMP_FILE"

echo "Risk assessment completed. Total Score: $TOTAL_SCORE"
echo "Found: $CRITICAL Critical, $HIGH High, $MEDIUM Medium, $LOW Low vulnerabilities"