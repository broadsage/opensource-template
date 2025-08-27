<!--
SPDX-FileCopyrightText: Copyright (c) 2025 Broadsage <opensource@broadsage.com>

SPDX-License-Identifier: Apache-2.0
-->

# CodeQL Security Analysis Setup

This directory contains the CodeQL configuration and custom security queries for the open source template project.

## 🔍 Overview

Our CodeQL setup provides comprehensive security analysis using GitHub Advanced Security, following industry best practices for open source projects.

## 📁 File Structure

```text
.github/codeql/
├── codeql-config.yml            # Main CodeQL configuration
├── custom-security-suite.qls    # Custom query suite definition
├── sarif-processor.py           # Post-processing script for SARIF results
├── custom-queries/              # Custom CodeQL queries
│   └── hardcoded-credentials.ql # Detects hardcoded sensitive information
└── README.md                    # This file
```

## ⚙️ Configuration Features

### Security Analysis

- **Extended Security Queries**: Comprehensive security vulnerability detection
- **Security and Quality**: Combines security with code quality analysis  
- **Custom Queries**: Project-specific security checks for open source projects
- **Multi-language Support**: Python, JavaScript/TypeScript, Java, C/C++, C#, Go, Ruby

### Scheduling & Triggers

- **Push/PR Analysis**: Automatic analysis on code changes
- **Daily Scheduled Scans**: Ensures regular security assessment
- **Manual Dispatch**: On-demand analysis with custom parameters

### Advanced Features

- **Hardened Runner**: Security-hardened GitHub Actions environment
- **SARIF Processing**: Enhanced reporting and filtering of results
- **Dependency Management**: Automatic setup for Python, Node.js dependencies
- **Performance Optimization**: Configurable threading and memory allocation

## 🚀 Usage

### Automatic Analysis

CodeQL runs automatically on:

- Push to `main` or `develop` branches
- Pull requests targeting `main` or `develop`
- Daily at 06:00 UTC

### Manual Execution

Trigger manual analysis via GitHub Actions with custom parameters:

```bash
# Via GitHub CLI
gh workflow run "CodeQL Advanced Security" \
  --field languages="python,javascript" \
  --field queries="security-extended"

# Via GitHub web interface
# Go to Actions → CodeQL Advanced Security → Run workflow
```

### Custom Parameters

- **Languages**: `python`, `javascript`, `typescript`, `java`, `cpp`, `csharp`, `go`, `ruby`
- **Query Suites**: `security-extended`, `security-and-quality`, `custom`

## 📊 Results & Reporting

### Viewing Results

1. **Security Tab**: `https://github.com/your-org/repo/security/code-scanning`
2. **Actions Summary**: Detailed workflow summaries with metrics
3. **SARIF Files**: Raw analysis results for further processing

### Result Processing

The included SARIF processor enhances results with:

- Severity mapping and filtering
- Custom metadata injection
- Statistical summaries
- Category-based organization

```bash
# Process SARIF results
python .github/codeql/sarif-processor.py results.sarif \
  --output enhanced_results.sarif \
  --summary summary.json
```

## 🛡️ Security Queries

### Standard Queries

- **CWE-based Detection**: Common Weakness Enumeration coverage
- **OWASP Top 10**: Web application security risks
- **Industry Standards**: NIST, SANS Top 25, etc.

### Project-Specific Custom Queries

- **Hardcoded Credentials**: Detects potential API keys, passwords, tokens
- **Open Source Specific**: Security issues common in open source projects
- **Configuration Issues**: Misconfigurations that could lead to vulnerabilities

### Query Categories

- **SQL Injection**: Database security vulnerabilities  
- **Cross-Site Scripting**: XSS prevention
- **Path Traversal**: File system security
- **Code Injection**: Dynamic code execution risks
- **Cryptographic Issues**: Weak encryption, insecure randomness
- **Authentication/Authorization**: Access control problems

## 🔧 Customization

### Adding Languages

Edit `.github/workflows/codeql-analysis.yml`:

```yaml
matrix:
  language: ['python', 'javascript-typescript', 'java-kotlin']
```

### Custom Queries

1. Create `.ql` files in `custom-queries/`
2. Add to `custom-security-suite.qls`
3. Update `codeql-config.yml` if needed

### Filtering Results

Modify `codeql-config.yml`:

```yaml
paths-ignore:
  - "/test/**"
  - "**/*.test.js"

paths:
  - "/src/**"
  - "/lib/**"
```

## 📈 Performance Tuning

### Resource Allocation

```yaml
# In codeql-config.yml
analysis:
  threads: 4      # Number of analysis threads
  ram: 8192       # RAM in MB
  timeout: 240    # Timeout in minutes
```

### Build Optimization

For compiled languages, customize build steps:

```yaml
# In workflow file
- name: Custom Build
  run: |
    # Optimized build commands
    make clean && make -j4
```

## 🏷️ Best Practices

### Repository Setup

1. **Enable Advanced Security**: Required for private repositories
2. **Configure Branch Protection**: Require CodeQL checks to pass
3. **Set Up Notifications**: Alert on new security findings

### Development Workflow

1. **Local Testing**: Use CodeQL CLI for local development
2. **Pre-commit Hooks**: Integrate basic security checks
3. **Regular Reviews**: Weekly security finding reviews

### Response Process

1. **Triage**: Classify findings by severity and validity
2. **Remediation**: Fix confirmed vulnerabilities promptly  
3. **Documentation**: Update security documentation
4. **Monitoring**: Track resolution metrics

## 🔗 Resources

- [CodeQL Documentation](https://codeql.github.com/docs/)
- [GitHub Advanced Security](https://docs.github.com/en/code-security/code-scanning)
- [Security Advisories](https://docs.github.com/en/code-security/repository-security-advisories)
- [CodeQL Query Libraries](https://github.com/github/codeql)

## 📞 Support

For issues with CodeQL configuration:

1. Check workflow logs in GitHub Actions
2. Review security findings in the Security tab  
3. Open an issue with the security team
4. Consult the [SECURITY.md](../../SECURITY.md) file

---

**Security is everyone's responsibility!** 🛡️
