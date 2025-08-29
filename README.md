<!--
SPDX-FileCopyrightText: Copyright (c) 2025 Broadsage <opensource@broadsage.com>

SPDX-License-Identifier: Apache-2.0
-->

# Enterprise Open Source Project Template

![Broadsage Official](https://github.com/broadsage/branding/blob/main/banners/official.png)

## Production-ready open source template for enterprise development teams

A comprehensive, enterprise-grade template designed to accelerate open source project creation while ensuring security, compliance, and governance standards. Built for organizations that need robust, scalable, and maintainable open source solutions from day one.

[![License: Apache 2.0](https://img.shields.io/badge/License-Apache_2.0-blue.svg?style=flat&logo=apache)](https://www.apache.org/licenses/LICENSE-2.0)
[![CodeQL](https://github.com/broadsage/opensource-template/actions/workflows/codeql-analysis.yml/badge.svg)](https://github.com/broadsage/opensource-template/actions/workflows/codeql-analysis.yml)
[![OpenSSF Best Practices](https://www.bestpractices.dev/projects/11079/badge)](https://www.bestpractices.dev/projects/11079)
[![OpenSSF Scorecard](https://img.shields.io/ossf-scorecard/github.com/broadsage/opensource-template?label=OpenSSF%20Scorecard&style=flat&logo=ossf)](https://securityscorecards.dev/viewer/?uri=github.com/broadsage/opensource-template)
[![GitHub Release](https://img.shields.io/github/v/release/broadsage/opensource-template?label=Release&style=flat&logo=github)](https://github.com/broadsage/opensource-template/releases)
[![Broadsage on LinkedIn](https://img.shields.io/badge/LinkedIn-Broadsage-blue?style=flat&logo=linkedin)](https://www.linkedin.com/company/broadsage)

## Overview

This enterprise-grade open source template provides organizations with a production-ready foundation for creating, managing, and scaling open source projects. Designed with enterprise requirements in mind, it includes comprehensive security policies, compliance frameworks, automated quality assurance, and governance structures that meet the demands of modern software development teams.

## Enterprise Value Proposition

### 🏢 Enterprise Ready

- **Compliance First**: Full REUSE compliance, automated license scanning, and enterprise-grade security policies
- **Governance Structure**: Clear roles, responsibilities, and decision-making processes aligned with enterprise standards
- **Security by Design**: Integrated vulnerability management, automated security scanning, and incident response procedures
- **Audit Trail**: Comprehensive logging, documentation, and traceability for regulatory compliance

### ⚡ Accelerated Development

- **Zero-to-Production**: Launch compliant open source projects in minutes, not weeks
- **Automated CI/CD**: Pre-configured pipelines with quality gates, security checks, and deployment automation
- **Developer Experience**: Streamlined contribution workflows, comprehensive documentation, and developer tooling
- **Scalable Architecture**: Modular structure that grows with your organization's needs

### 🛡️ Risk Mitigation

- **Legal Protection**: Clear licensing, contributor agreements, and intellectual property protection
- **Security Assurance**: Vulnerability scanning, dependency management, and security policy enforcement
- **Quality Guarantee**: Automated testing, code quality checks, and peer review processes
- **Community Management**: Structured community engagement and contributor onboarding

## Key Features

### 🚀 Rapid Project Initialization

- **Template-based Setup**: Instantly create new projects with pre-configured structure and best practices
- **Customizable Configuration**: Easily adapt templates to your technology stack and organizational requirements
- **Multi-language Support**: Extensible framework supporting various programming languages and frameworks
- **Environment Automation**: Automated development environment setup with DevContainers and configuration

### 🔒 Security & Compliance

- **REUSE Compliance**: Full license compliance with automated REUSE specification validation
- **Security Scanning**: Integrated CodeQL, dependency scanning, and vulnerability assessment
- **SBOM Generation**: Software Bill of Materials generation for transparency and compliance
- **Governance Framework**: Clear governance model with defined roles, responsibilities, and decision-making processes

### 🤖 Automation & Quality Assurance

- **MegaLinter Integration**: Multi-language linting and code quality enforcement
- **GitHub Actions**: Pre-configured workflows for testing, building, and deployment
- **Automated Releases**: Semantic versioning and automated release management
- **Quality Gates**: Automated quality gates and approval processes
- **Documentation Standards**: Comprehensive documentation templates and automation
- **Community Health**: Complete set of community health files and contribution guidelines

## Quick Start

### For Development Teams

1. **Create from Template**

   ```bash
   # Use GitHub CLI
   gh repo create my-org/my-project --template broadsage/opensource-template --public
   
   # Or click "Use this template" on GitHub
   ```

2. **Configure Project**

   ```bash
   # Clone and customize
   git clone https://github.com/my-org/my-project
   cd my-project
   
   # Run setup script
   ./scripts/setup-project.sh
   ```

3. **Customize Configuration**

   - Update `publiccode.yml` with project metadata
   - Modify `CONTRIBUTING.md` and `docs/governance.md` for your organization
   - Configure `config/mega-linter.yml` for your tech stack
   - Update badges and links in README

4. **Initialize Development Environment**

   ```bash
   # Using DevContainer (recommended)
   code .
   # VS Code will prompt to open in container
   
   # Or setup locally
   make setup
   ```

### For Enterprise Teams

1. **Review Compliance Requirements**

   - Ensure alignment with your organization's open source policy
   - Review security and governance frameworks
   - Validate license compatibility with your project goals

2. **Customize Governance**

   - Adapt `docs/governance.md` to your organizational structure
   - Configure contributor agreement and approval processes
   - Set up security incident response procedures

3. **Integrate with Enterprise Systems**

   - Connect to your organization's identity management
   - Configure enterprise-specific CI/CD pipelines
   - Set up compliance reporting and audit trails

## Project Structure

This template follows enterprise-grade organizational patterns designed for scalability and maintainability:

```text
├── .devcontainer/              # Development environment configuration
├── .github/                    # GitHub workflows, issue/PR templates, and automation
│   ├── ISSUE_TEMPLATE/         # Standardized issue templates
│   ├── PULL_REQUEST_TEMPLATE/  # PR guidelines and checklists
│   └── workflows/              # CI/CD automation workflows
├── config/                     # Configuration files and linting rules
│   └── mega-linter.yml         # Code quality and security scanning configuration
├── docs/                       # Project documentation
│   ├── README.md               # Documentation index and navigation
│   ├── development.md          # Developer setup and workflow documentation
│   ├── governance.md           # Project governance and decision-making processes
│   ├── community-guidelines.md # Detailed community interaction guidelines
│   ├── support.md              # Support channels and community resources
│   ├── contributors.md         # Contributor recognition and hall of fame
│   └── security/               # Security-specific documentation
│       └── codeql-implementation.md # CodeQL security analysis setup
├── scripts/                    # Automation and utility scripts
│   ├── compliance.sh           # Compliance validation tools
│   ├── setup-project.sh        # Project initialization script
│   └── update-contributors.py  # Contributor management automation
├── security-reports/           # Security assessment and vulnerability reports
├── LICENSES/                   # License files for compliance
├── megalinter-reports/         # Code quality and security scan results
├── CHANGELOG.md                # Version history and release notes
├── CODE_OF_CONDUCT.md          # Community standards and behavior guidelines
├── CONTRIBUTING.md             # Contribution guidelines and processes
├── LICENSE                     # Primary project license
├── README.md                   # Project overview (this file)
├── SECURITY.md                 # Security policy and vulnerability reporting
├── publiccode.yml              # Public administration metadata
└── REUSE.toml                  # REUSE compliance configuration
```

### Key Directory Functions

- **`.devcontainer/`**: Standardized development environments using VS Code DevContainers
- **`.github/`**: Complete GitHub automation including workflows, templates, and community health files
- **`config/`**: Centralized configuration management for tools and processes
- **`docs/`**: Comprehensive project documentation including governance, development guides, and security docs
- **`scripts/`**: Automation tools for project maintenance, compliance, and contributor management
- **`security-reports/`**: Security assessment documentation and vulnerability tracking

## Technology Stack & Standards

### Compliance Frameworks

- **[REUSE](https://reuse.software/)**: Automated license compliance and SPDX compatibility
- **[OpenSSF Best Practices](https://bestpractices.coreinfrastructure.org/)**: Security and quality standards
- **[OpenSSF Scorecard](https://securityscorecards.dev/)**: Automated security assessment
- **[PublicCode.yml](https://docs.italia.it/italia/developers-italia/publiccodeyml-en/)**: Public administration metadata standard

### Quality Assurance

- **[MegaLinter](https://megalinter.io/)**: Multi-language code quality and security scanning
- **Pre-commit Hooks**: Automated code formatting and validation
- **Conventional Commits**: Standardized commit message format for automated changelog generation
- **Semantic Versioning**: Automated version management and release processes

### Development Environment

- **DevContainers**: Standardized, reproducible development environments
- **GitHub Codespaces**: Cloud-based development environment support
- **VS Code Extensions**: Recommended extensions for optimal development experience
- **Docker Support**: Containerized development and deployment workflows

## Security & Compliance

### Security Framework

- **Vulnerability Management**: Comprehensive security policy with clear reporting and response procedures
- **Dependency Scanning**: Automated dependency vulnerability assessment and updates
- **Code Security**: Static application security testing (SAST) with CodeQL integration
- **Supply Chain Security**: SBOM generation and dependency verification
- **Incident Response**: Structured security incident response procedures and communication protocols

### Compliance Standards

- **License Compliance**: REUSE specification compliance with automated validation
- **SPDX Compatibility**: Software Package Data Exchange format for license information
- **Audit Trail**: Comprehensive logging and documentation for regulatory compliance
- **Documentation Requirements**: Complete documentation standards for enterprise adoption

### Enterprise Integration

- **SSO Integration**: Single sign-on compatibility for enterprise identity management
- **Policy Enforcement**: Configurable policies for code quality, security, and compliance
- **Approval Workflows**: Multi-stage approval processes for enterprise governance
- **Reporting & Analytics**: Comprehensive reporting for project health and compliance metrics

## Community & Contribution

### 🌟 Community Health Features

- **🎯 Issue Templates**: Structured templates for bugs, features, questions, and documentation
- **📝 Pull Request Templates**: Comprehensive PR guidelines and checklists
- **💬 Discussion Templates**: Templates for ideas, polls, and show-and-tell
- **🤖 Automated Workflows**: Welcome messages, triage, stale issue management, and contributor recognition
- **🏆 Contributor Recognition**: [Hall of Fame](docs/contributors.md) and achievement system
- **🛟 Comprehensive Support**: [Support Guide](docs/support.md) with multiple channels
- **📋 Community Guidelines**: [Community Guidelines](docs/community-guidelines.md) for healthy collaboration

### How to Contribute

- **Read the [CONTRIBUTING.md](CONTRIBUTING.md)**: Review our guidelines for code, documentation, and issue contributions
- **Fork the Repository**: Click the "Fork" button to create your own copy of the project
- **Create a Branch**: Work on your feature or fix in a new branch (use descriptive names, e.g., `fix/readme-typo`)
- **Make Changes**: Write clear, well-documented code. Update or add tests as needed
- **Write Good Commit Messages**: Summarize your changes and reference related issues
- **Open a Pull Request**: Submit your PR to the `develop` branch. Fill out the PR template and link relevant issues
- **Participate in Code Review**: Respond to feedback and make requested changes
- **Documentation & Translations**: Help improve docs or translate content for broader reach

We welcome all types of contributions—code, documentation, design, tests, translations, and more!

### Support & Community Channels

We believe in building together! Here's how you can connect and get support:

- **Open an Issue**: Use [GitHub Issues](https://github.com/broadsage/opensource-template/issues) for bugs, feature requests, or questions
- **Join Discussions**: Participate in our [GitHub Discussions](https://github.com/broadsage/opensource-template/discussions) to share ideas, get help, and connect with others
- **Community Calls**: Watch for regular community call announcements in Discussions and project updates. Join to meet maintainers and other contributors
- **Email Us**: Contact maintainers at [opensource@broadsage.com](mailto:opensource@broadsage.com) for private or sensitive matters
- **Code of Conduct**: Please review our [Code of Conduct](CODE_OF_CONDUCT.md) to help us maintain a welcoming and respectful community

### Contributor Recognition

- **Recognition**: Top contributors are highlighted in release notes and may be invited to join the core team
- **Community Badges**: Earn badges for your contributions and community support

Your feedback and participation make this project better for everyone. Thank you for being part of our community!

## Documentation

### Core Documentation

- **[CONTRIBUTING.md](CONTRIBUTING.md)**: Comprehensive contribution guidelines and development workflow
- **[docs/governance.md](docs/governance.md)**: Project governance model and decision-making processes
- **[SECURITY.md](SECURITY.md)**: Security policy and vulnerability reporting procedures
- **[CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md)**: Community standards and behavioral expectations
- **[docs/development.md](docs/development.md)**: Developer setup, tools, and workflow documentation

### Additional Resources

- **[docs/support.md](docs/support.md)**: Support channels and community resources
- **[CHANGELOG.md](CHANGELOG.md)**: Version history and release notes
- **[docs/community-guidelines.md](docs/community-guidelines.md)**: Detailed community interaction guidelines
- **[docs/contributors.md](docs/contributors.md)**: Contributor recognition and hall of fame
- **[docs/security/](docs/security/)**: Security-specific documentation and implementation guides

### Documentation Navigation

For comprehensive documentation navigation and organization, see [docs/README.md](docs/README.md).

## License

Copyright © 2025 Broadsage. The term "Broadsage" refers to Broadsage Corporation and/or its subsidiaries.

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at

<http://www.apache.org/licenses/LICENSE-2.0>

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

---

**Ready to launch?** This template empowers your team to ship enterprise-grade open-source projects from day one. Join the open source movement with confidence, backed by comprehensive governance, security, and community management frameworks.

*Built with ❤️ by [Broadsage](https://broadsage.com) for the global open source community.*
