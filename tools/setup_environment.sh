#!/bin/bash

echo "SCA Environment Setup & Validation"
echo "=================================="

# Function to check and fix line endings
fix_line_endings() {
    echo "Checking and fixing line endings..."
    
    for file in tools/*.sh; do
        if [ -f "$file" ]; then
            echo "  Processing: $(basename "$file")"
            
            # Check if file has CRLF line endings
            if grep -q $'\r' "$file"; then
                echo "    [ERROR] Found Windows line endings - Converting to Unix..."
                sed -i 's/\r$//' "$file"
                echo "    [OK] Converted to Unix format"
            else
                echo "    [OK] Already in Unix format"
            fi
            
            # Ensure executable permission
            chmod +x "$file"
            echo "    [OK] Set executable permission"
        fi
    done
}

# Function to validate scripts
validate_scripts() {
    echo ""
    echo "Validating scripts..."
    echo "---------------------"
    
    for file in tools/*.sh; do
        if [ -f "$file" ]; then
            echo "  Validating: $(basename "$file")"
            
            # Check shebang
            if head -1 "$file" | grep -q "^#!/bin/bash"; then
                echo "    [OK] Shebang is correct"
            else
                echo "    [WARN] Shebang might be incorrect"
            fi
            
            # Check file command
            file_type=$(file "$file")
            echo "    File type: $file_type"
            
            # Check line endings
            cr_count=$(grep -c $'\r' "$file" || true)
            if [ "$cr_count" -eq 0 ]; then
                echo "    [OK] No CRLF line endings"
            else
                echo "    [ERROR] Still has $cr_count CRLF line endings"
            fi
            
            # Check if executable
            if [ -x "$file" ]; then
                echo "    [OK] Executable permission set"
            else
                echo "    [ERROR] Missing executable permission"
            fi
            
            # Basic syntax check
            if bash -n "$file" 2>/dev/null; then
                echo "    [OK] Syntax is valid"
            else
                echo "    [ERROR] Syntax error detected"
            fi
        fi
    done
}

# Function to check Docker availability
check_docker() {
    echo ""
    echo "Checking Docker environment..."
    echo "-----------------------------"
    
    if command -v docker >/dev/null 2>&1; then
        echo "  [OK] Docker is installed"
        docker_version=$(docker --version)
        echo "  Version: $docker_version"
        
        # Test Docker daemon
        if docker info >/dev/null 2>&1; then
            echo "  [OK] Docker daemon is running"
        else
            echo "  [ERROR] Docker daemon is not running"
        fi
    else
        echo "  [ERROR] Docker is not installed or not in PATH"
    fi
}

# Function to check required directories
check_directories() {
    echo ""
    echo "Checking directory structure..."
    echo "------------------------------"
    
    local dirs=("tools" "report" ".github/workflows")
    
    for dir in "${dirs[@]}"; do
        if [ -d "$dir" ]; then
            echo "  [OK] Directory exists: $dir"
        else
            echo "  [WARN] Directory missing: $dir"
            mkdir -p "$dir"
            echo "  [OK] Created directory: $dir"
        fi
    done
}

# Function to generate summary report
generate_summary() {
    echo ""
    echo "SETUP SUMMARY"
    echo "============="
    
    local total_scripts=$(find tools -name "*.sh" | wc -l)
    local executable_scripts=$(find tools -name "*.sh" -executable | wc -l)
    local valid_syntax=0
    
    for file in tools/*.sh; do
        if bash -n "$file" 2>/dev/null; then
            ((valid_syntax++))
        fi
    done
    
    echo "Scripts Status:"
    echo "  - Total scripts: $total_scripts"
    echo "  - Executable: $executable_scripts"
    echo "  - Valid syntax: $valid_syntax"
    
    if command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
        echo "Docker: [READY]"
    else
        echo "Docker: [NOT READY]"
    fi
    
    if [ "$total_scripts" -eq "$executable_scripts" ] && [ "$total_scripts" -eq "$valid_syntax" ]; then
        echo ""
        echo "SETUP COMPLETED SUCCESSFULLY!"
        echo "You can now run: bash tools/sca_scan.sh"
    else
        echo ""
        echo "SETUP COMPLETED WITH WARNINGS"
        echo "Please check the issues above before running scans."
    fi
}

# Main execution
main() {
    echo "Starting environment setup..."
    echo ""
    
    check_directories
    fix_line_endings
    validate_scripts
    check_docker
    generate_summary
    
    echo ""
    echo "Setup completed at: $(date)"
}

# Run main function
main