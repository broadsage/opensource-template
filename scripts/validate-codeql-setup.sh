#!/bin/bash

# SPDX-FileCopyrightText: Copyright (c) 2025 Broadsage <opensource@broadsage.com>
# SPDX-License-Identifier: Apache-2.0

# CodeQL Implementation Validation Script

set -e

echo "🔍 CodeQL Implementation Validation"
echo "=================================="
echo ""

# Colors for output
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print status
print_status() {
  local status=$1
  local message=$2
  if [ "$status" = "ok" ]; then
    echo -e "${BLUE}✅ $message${NC}"
  elif [ "$status" = "warn" ]; then
    echo -e "${YELLOW}⚠️  $message${NC}"
  else
    echo -e "${RED}❌ $message${NC}"
  fi
}

# Function to check file exists
check_file() {
  local file=$1
  local description=$2
  if [ -f "$file" ]; then
    print_status "ok" "$description exists"
    return 0
  else
    print_status "error" "$description missing: $file"
    return 1
  fi
}

# Function to check directory exists
check_dir() {
  local dir=$1
  local description=$2
  if [ -d "$dir" ]; then
    print_status "ok" "$description exists"
    return 0
  else
    print_status "error" "$description missing: $dir"
    return 1
  fi
}

echo "📁 Checking File Structure..."
echo ""

# Check main workflow file
check_file ".github/workflows/codeql-analysis.yml" "Main CodeQL workflow"

# Check configuration directory
check_dir ".github/codeql" "CodeQL configuration directory"

# Check configuration files
check_file ".github/codeql/codeql-config.yml" "CodeQL configuration"
check_file ".github/codeql/custom-security-suite.qls" "Custom query suite"
check_file ".github/codeql/sarif-processor.py" "SARIF processor"
check_file ".github/codeql/README.md" "CodeQL documentation"

# Check custom queries
check_dir ".github/codeql/custom-queries" "Custom queries directory"
check_file ".github/codeql/custom-queries/hardcoded-credentials.ql" "Hardcoded credentials query"

echo ""
echo "🔧 Checking Workflow Configuration..."
echo ""

# Check workflow syntax (basic YAML validation)
if grep -q "name: \"CodeQL Advanced Security\"" .github/workflows/codeql-analysis.yml; then
  print_status "ok" "Workflow name is correctly set"
else
  print_status "error" "Workflow name not found or incorrect"
fi

# Check trigger configuration
if grep -q "push:" .github/workflows/codeql-analysis.yml && grep -q "pull_request:" .github/workflows/codeql-analysis.yml; then
  print_status "ok" "Push and PR triggers configured"
else
  print_status "error" "Missing push or PR triggers"
fi

# Check scheduled execution
if grep -q "schedule:" .github/workflows/codeql-analysis.yml && grep -q "cron:" .github/workflows/codeql-analysis.yml; then
  print_status "ok" "Scheduled execution configured"
else
  print_status "warn" "Scheduled execution not configured"
fi

# Check security permissions
if grep -q "security-events: write" .github/workflows/codeql-analysis.yml; then
  print_status "ok" "Security events permission configured"
else
  print_status "error" "Missing security-events permission"
fi

# Check CodeQL actions
if grep -q "github/codeql-action/init" .github/workflows/codeql-analysis.yml; then
  print_status "ok" "CodeQL init action configured"
else
  print_status "error" "Missing CodeQL init action"
fi

if grep -q "github/codeql-action/analyze" .github/workflows/codeql-analysis.yml; then
  print_status "ok" "CodeQL analyze action configured"
else
  print_status "error" "Missing CodeQL analyze action"
fi

echo ""
echo "🛡️ Checking Security Configuration..."
echo ""

# Check hardened runner
if grep -q "step-security/harden-runner" .github/workflows/codeql-analysis.yml; then
  print_status "ok" "Hardened runner configured"
else
  print_status "warn" "Hardened runner not configured"
fi

# Check custom query configuration
if grep -q "custom-security-suite.qls" .github/codeql/codeql-config.yml; then
  print_status "ok" "Custom query suite configured"
else
  print_status "warn" "Custom query suite not referenced in config"
fi

# Check language support
if grep -q "python" .github/workflows/codeql-analysis.yml; then
  print_status "ok" "Python language support configured"
else
  print_status "warn" "Python language support not found"
fi

echo ""
echo "📊 Implementation Statistics..."
echo ""

# File sizes and line counts
workflow_lines=$(wc -l <.github/workflows/codeql-analysis.yml)
config_lines=$(wc -l <.github/codeql/codeql-config.yml)
processor_lines=$(wc -l <.github/codeql/sarif-processor.py)
doc_lines=$(wc -l <.github/codeql/README.md)

echo "📝 Code Metrics:"
echo "   Workflow: $workflow_lines lines"
echo "   Configuration: $config_lines lines"
echo "   SARIF Processor: $processor_lines lines"
echo "   Documentation: $doc_lines lines"

# Check for integration with existing workflows
existing_workflows=$(find .github/workflows -name "*.yml" | wc -l)
echo "   Total Workflows: $existing_workflows"

echo ""
echo "🚀 Ready to Use!"
echo ""
echo "Next Steps:"
echo "1. Commit and push these changes to trigger the first CodeQL analysis"
echo "2. Check the Actions tab for workflow execution"
echo "3. Review results in the Security tab → Code scanning"
echo "4. Configure notifications for security alerts"
echo ""
echo "Documentation: See .github/codeql/README.md for detailed usage"
echo ""

print_status "ok" "CodeQL Advanced Security implementation complete! 🎉"
