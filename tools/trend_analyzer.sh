#!/bin/bash

CURRENT_REPORT=${1:-report/dependency_report.md}
TREND_FILE=${2:-report/scan_trends.json}

echo "Analyzing vulnerability trends..."
mkdir -p "$(dirname "$TREND_FILE")"

# EXTRACT METRICS FROM CURRENT SCAN
echo "Extracting metrics from: $CURRENT_REPORT"
CRITICAL=$(grep -c "CRITICAL" "$CURRENT_REPORT" 2>/dev/null || echo "0")
HIGH=$(grep -c "HIGH" "$CURRENT_REPORT" 2>/dev/null || echo "0") 
MEDIUM=$(grep -c "MEDIUM" "$CURRENT_REPORT" 2>/dev/null || echo "0")
TOTAL=$((CRITICAL + HIGH + MEDIUM))

echo "Found: $CRITICAL Critical, $HIGH High, $MEDIUM Medium (Total: $TOTAL)"

# GENERATE UNIQUE TIMESTAMP - PREVENT DUPLICATES
if [ -f "$TREND_FILE" ] && [ $(jq length "$TREND_FILE") -gt 0 ]; then
    LAST_TIMESTAMP=$(jq -r '.[-1].timestamp' "$TREND_FILE")
    CURRENT_TIMESTAMP=$(date -Iseconds)
    
    # If same second, add 1 second to avoid duplicate
    if [ "$LAST_TIMESTAMP" = "$CURRENT_TIMESTAMP" ]; then
        echo "Warning: Timestamp collision detected, adjusting..."
        CURRENT_TIMESTAMP=$(date -Iseconds -d "+1 second")
    fi
else
    CURRENT_TIMESTAMP=$(date -Iseconds)
fi

# CREATE CURRENT SCAN RECORD
CURRENT_SCAN=$(cat << JSON
{
  "timestamp": "$CURRENT_TIMESTAMP",
  "critical": $CRITICAL,
  "high": $HIGH,
  "medium": $MEDIUM, 
  "total": $TOTAL,
  "project": "$(basename "$(pwd)")"
}
JSON
)

echo "Current scan data: $CURRENT_SCAN"

# INITIALIZE OR UPDATE TREND HISTORY
if [ ! -f "$TREND_FILE" ]; then
    echo "Creating new trend file: $TREND_FILE"
    echo "[]" > "$TREND_FILE"
fi

# CHECK FOR DUPLICATE SCAN (same metrics within 1 hour)
DUPLICATE_FOUND=false
if [ $(jq length "$TREND_FILE") -gt 0 ]; then
    LAST_SCAN=$(jq '.[-1]' "$TREND_FILE")
    LAST_CRITICAL=$(jq '.[-1].critical' "$TREND_FILE")
    LAST_HIGH=$(jq '.[-1].high' "$TREND_FILE")
    LAST_MEDIUM=$(jq '.[-1].medium' "$TREND_FILE")
    LAST_TOTAL=$(jq '.[-1].total' "$TREND_FILE")
    
    # Check if metrics are identical to last scan
    if [ "$CRITICAL" -eq "$LAST_CRITICAL" ] && \
       [ "$HIGH" -eq "$LAST_HIGH" ] && \
       [ "$MEDIUM" -eq "$LAST_MEDIUM" ] && \
       [ "$TOTAL" -eq "$LAST_TOTAL" ]; then
        echo "Warning: Scan results identical to previous scan - possible duplicate"
        DUPLICATE_FOUND=true
    fi
fi

# ADD CURRENT SCAN TO HISTORY (only if not duplicate)
if [ "$DUPLICATE_FOUND" = false ]; then
    echo "Updating trend history..."
    jq --argjson current "$CURRENT_SCAN" '. + [$current]' "$TREND_FILE" > "${TREND_FILE}.tmp"
    mv "${TREND_FILE}.tmp" "$TREND_FILE"
else
    echo "Skipping duplicate scan entry"
fi

# GENERATE TREND ANALYSIS REPORT
echo "Generating trend analysis..."
cat > report/trend_analysis.md << EOF
# Vulnerability Trend Analysis

**Last Updated:** $(date)
**Data Source:** $CURRENT_REPORT
${DUPLICATE_FOUND:+**Note:** Possible duplicate scan detected - identical metrics to previous scan}

## Current Scan Results
- **Critical Vulnerabilities:** $CRITICAL
- **High Vulnerabilities:** $HIGH  
- **Medium Vulnerabilities:** $MEDIUM
- **Total Vulnerabilities:** $TOTAL

## Trend Analysis
EOF

# CALCULATE TRENDS
SCAN_COUNT=$(jq length "$TREND_FILE")
echo "Historical scans found: $SCAN_COUNT"

# Initialize trend variables
CRITICAL_CHANGE=0
HIGH_CHANGE=0
MEDIUM_CHANGE=0
TOTAL_CHANGE=0

if [ "$SCAN_COUNT" -gt 1 ]; then
    # Get previous scan data
    PREV_CRITICAL=$(jq ".[$SCAN_COUNT-2].critical" "$TREND_FILE")
    PREV_HIGH=$(jq ".[$SCAN_COUNT-2].high" "$TREND_FILE")
    PREV_MEDIUM=$(jq ".[$SCAN_COUNT-2].medium" "$TREND_FILE") 
    PREV_TOTAL=$(jq ".[$SCAN_COUNT-2].total" "$TREND_FILE")
    
    # Calculate changes
    CRITICAL_CHANGE=$((CRITICAL - PREV_CRITICAL))
    HIGH_CHANGE=$((HIGH - PREV_HIGH))
    MEDIUM_CHANGE=$((MEDIUM - PREV_MEDIUM))
    TOTAL_CHANGE=$((TOTAL - PREV_TOTAL))
    
    echo "Changes: Critical $CRITICAL_CHANGE, High $HIGH_CHANGE, Medium $MEDIUM_CHANGE, Total $TOTAL_CHANGE"
    
    # Generate trend summary
    cat >> report/trend_analysis.md << TREND
    
### Changes Since Last Scan:
- **Critical:** $CRITICAL ($(printf "%+d" $CRITICAL_CHANGE))
- **High:** $HIGH ($(printf "%+d" $HIGH_CHANGE)) 
- **Medium:** $MEDIUM ($(printf "%+d" $MEDIUM_CHANGE))
- **Total:** $TOTAL ($(printf "%+d" $TOTAL_CHANGE))

### Trend Assessment:
TREND
    
    # Determine overall trend
    if [ "$TOTAL_CHANGE" -gt 2 ]; then
        echo "**Status:** 🔴 SIGNIFICANT INCREASE (+$TOTAL_CHANGE vulnerabilities)" >> report/trend_analysis.md
        echo "**Priority:** HIGH - Immediate review required" >> report/trend_analysis.md
    elif [ "$TOTAL_CHANGE" -gt 0 ]; then
        echo "**Status:** 🟡 SLIGHT INCREASE (+$TOTAL_CHANGE vulnerabilities)" >> report/trend_analysis.md
        echo "**Priority:** MEDIUM - Schedule review" >> report/trend_analysis.md
    elif [ "$TOTAL_CHANGE" -lt 0 ]; then
        echo "**Status:** 🟢 IMPROVING ($TOTAL_CHANGE vulnerabilities)" >> report/trend_analysis.md
        echo "**Priority:** LOW - Good progress" >> report/trend_analysis.md
    else
        echo "**Status:** ⚪ STABLE (no change)" >> report/trend_analysis.md
        echo "**Priority:** LOW - Maintain current practices" >> report/trend_analysis.md
    fi
    
    # Add historical chart data
    cat >> report/trend_analysis.md << CHART
    
## Historical Overview
\`\`\`
Timeline: $(jq -r '.[].timestamp | split("T")[0]' "$TREND_FILE" | tr '\n' ' ')
Critical:  $(jq -r '.[].critical' "$TREND_FILE" | tr '\n' ' ')
High:      $(jq -r '.[].high' "$TREND_FILE" | tr '\n' ' ')  
Medium:    $(jq -r '.[].medium' "$TREND_FILE" | tr '\n' ' ')
Total:     $(jq -r '.[].total' "$TREND_FILE" | tr '\n' ' ')
\`\`\`
CHART

else
    cat >> report/trend_analysis.md << NOTREND
**Status:** 📊 INITIAL SCAN - No historical data available
**Next:** Run another scan to establish baseline trends
NOTREND
fi

# ADD RECOMMENDATIONS
cat >> report/trend_analysis.md << EOF

## Recommendations

### Based on Current Trends:
EOF

if [ "$CRITICAL" -gt 0 ]; then
    echo "- 🔴 Address $CRITICAL critical vulnerabilities immediately" >> report/trend_analysis.md
fi

if [ "$HIGH" -gt 0 ]; then
    echo "- 🟡 Review $HIGH high severity vulnerabilities this week" >> report/trend_analysis.md
fi

# Only show trend-based recommendations if we have historical data
if [ "$SCAN_COUNT" -gt 1 ] && [ "$DUPLICATE_FOUND" = false ]; then
    if [ "$TOTAL_CHANGE" -gt 0 ]; then
        echo "- 🔍 Investigate new vulnerabilities introduced in latest changes" >> report/trend_analysis.md
    fi
    if [ "$CRITICAL_CHANGE" -gt 0 ]; then
        echo "- 🚨 Critical vulnerabilities increased by $CRITICAL_CHANGE - urgent action needed" >> report/trend_analysis.md
    fi
fi

if [ "$DUPLICATE_FOUND" = true ]; then
    echo "- ⚠️  Possible duplicate scan detected - verify scan results" >> report/trend_analysis.md
fi

cat >> report/trend_analysis.md << EOF
- 📅 Schedule regular vulnerability reviews
- 🔄 Monitor dependency updates for security fixes
- 🤖 Consider automated dependency updates

### Next Steps:
1. Review critical and high severity issues
2. Implement fixes from remediation guide  
3. Schedule next security scan in 1-2 weeks
4. Track progress using trend analysis

*Trend data stored in: $TREND_FILE*
EOF

echo "Trend analysis completed: report/trend_analysis.md"
if [ "$DUPLICATE_FOUND" = false ]; then
    echo "Historical data updated: $TREND_FILE"
else
    echo "Duplicate scan detected - historical data unchanged"
fi