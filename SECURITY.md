<!--
SPDX-FileCopyrightText: Copyright (c) 2025 Broadsage <opensource@broadsage.com>

SPDX-License-Identifier: Apache-2.0
-->

# Security Policy & Release Process

## Overview

We are committed to ensuring the security and integrity of our open-source projects. We value the contributions of security researchers and the broader community in helping us identify and address vulnerabilities in our software. This document outlines our security disclosure and response policy to ensure we responsibly handle critical issues while maintaining transparency and protecting our users.

## Supported Versions

We provide security updates for the following versions of our projects. For a complete list of supported versions that this project will potentially create security fixes for, please refer to the Releases page on this project's GitHub and/or project related documentation on release cadence and support.

| Project Name | Version        | Supported Until         |
|--------------|----------------|-------------------------|
| Core         | 2.x            | Ongoing                 |
| OpenCore     | 1.x            | End of Life: 2025-12-31 |
| OpenAPI      | 3.x            | Ongoing                 |
| OpenAPI      | 2.x            | End of Life: 2024-06-30 |
| OpenSuite    | Latest Release | Ongoing                 |

Please ensure you are using a supported version to receive security updates. We recommend upgrading to the latest stable release as soon as possible.

## Reporting a Vulnerability - Private Disclosure Process

Security is of the highest importance and all security vulnerabilities or suspected security vulnerabilities should be reported to this project privately, to minimize attacks against current users before they are fixed. Vulnerabilities will be investigated and patched on the next patch (or minor) release as soon as possible.

> **IMPORTANT**: Do not file public issues on GitHub for security vulnerabilities

If you discover a security vulnerability in any of our open-source projects, we encourage you to report it to us responsibly. Please contact the maintainers through one of the following secure channels:

### Reporting Channels

1. **Primary Contact**: Email security vulnerabilities to [security@broadsage.com](mailto:security@broadsage.com)
2. **GitHub Security Advisory**: Open a [GitHub Security Advisory](https://docs.github.com/en/code-security/security-advisories/guidance-on-reporting-and-writing/privately-reporting-a-security-vulnerability) to report vulnerabilities directly and privately to the maintainers via GitHub
3. **Direct Contact**: Contact maintainers directly via their individual email addresses (if publicly available)

The use of encrypted email is encouraged for sensitive reports.

### What to Include in Your Report

Provide a descriptive title and include the following information in your vulnerability report:

- **Basic identity information**: Your name and affiliation or company
- **Affected project and version**: Specify which project and version is vulnerable
- **Detailed reproduction steps**: POC scripts, screenshots, and logs are helpful
- **Impact description**: Effects of the vulnerability on the project and related configurations
- **Attack surface estimation**: How the vulnerability affects project usage and potential attack vectors
- **Dependencies**: List other projects or dependencies used in conjunction with this project to produce the vulnerability
- **Suggested fixes or mitigations**: If applicable

### When to Report a Vulnerability

- When you think this project has a potential security vulnerability
- When you suspect a potential vulnerability but are unsure if it impacts this project
- When you know of or suspect a potential vulnerability in another project that is used by this project

Do not report non-security-impacting bugs through this channel. Use GitHub issues for all non-security-impacting bugs.

## Response Timeline and Process

- **Initial acknowledgment**: We will acknowledge receipt of your report within 48 hours
- **Initial assessment**: We aim to provide an initial assessment within 3 business days
- **Regular updates**: We will keep you informed of our progress throughout the investigation
- **Resolution notification**: We will notify you when the issue is resolved

## Vulnerability Handling and Patch Process

The maintainers will respond to vulnerability reports using the following structured process:

### Investigation and Assessment

1. **Triage**: Our security team will investigate the vulnerability and determine its effects and criticality
2. **Validation**: If the issue is not deemed to be a vulnerability, we will follow up with a detailed reason for rejection
3. **Communication**: We will initiate a conversation with the reporter within 3 business days

### Resolution and Mitigation

1. **Mitigation Planning**: If a vulnerability is acknowledged and the timeline for a fix is determined, we will work on a plan to communicate with the appropriate community, including identifying mitigating steps that affected users can take to protect themselves until the fix is rolled out
2. **Security Advisory Creation**: We will create a [Security Advisory](https://docs.github.com/en/code-security/repository-security-advisories/publishing-a-repository-security-advisory) using the [CVSS Calculator](https://www.first.org/cvss/calculator/3.0). The maintainers make the final call on the calculated CVSS; it is better to move quickly than making the CVSS perfect. Issues may also be reported to [MITRE](https://cve.mitre.org/) using this [scoring calculator](https://nvd.nist.gov/vuln-metrics/cvss/v3-calculator).
   The draft advisory will initially be set to private
3. **Fix Development**: We will work on fixing the vulnerability and perform internal testing before preparing to roll out the fix
4. **Release**: Once the fix is confirmed, we will patch the vulnerability in the next patch or minor release, and backport a patch release into all earlier supported releases

### Credit and Recognition

We are happy to publicly credit you for your discovery (unless you prefer to remain anonymous).

## Public Disclosure Policy

Broadsage follows a **90-day coordinated disclosure policy** with transparency and community protection as our primary goals:

### Timeline and Process

- **Critical vulnerabilities**: We aim to resolve within 90 days of a report
- **Extended timeline**: If more time is needed, we will communicate transparently with the reporter and provide regular updates on our progress
- **Active exploitation**: In cases of active exploitation, we may expedite disclosure to protect users, while still aiming to coordinate with the reporter
- **Public advisory**: Once a fix is released, we will publish a security advisory with details of the vulnerability and credit to the reporter (if desired)

### Public Communication

The maintainers publish the public advisory to this project's community via GitHub. In most cases, additional communication via Slack, Twitter, mailing lists, blog, and other channels will assist in educating the project's users and rolling out the patched release to affected users.

The maintainers will also publish any mitigating steps users can take until the fix can be applied to their instances. This project's distributors will handle creating and publishing their own security advisories.

## Confidentiality, Integrity and Availability

We consider vulnerabilities leading to the compromise of data confidentiality, elevation of privilege, or integrity to be our highest priority concerns. Availability, in particular in areas relating to DoS and resource exhaustion, is also a serious security concern. The maintainer team takes all vulnerabilities, potential vulnerabilities, and suspected vulnerabilities seriously and will investigate them in an urgent and expeditious manner.

**Note on Security-by-Default**: We do not currently consider the default settings for this project to be secure-by-default. It is necessary for operators to explicitly configure settings, role-based access control, and other resource-related features in this project to provide a hardened environment. We will not act on any security disclosure that relates to a lack of safe defaults. Over time, we will work towards improved safe-by-default configuration, taking into account backwards compatibility.

## Security Best Practices

We encourage users and contributors to follow these best practices to enhance security:

- **Keep Software Updated**: Always use the latest supported version of our software.
- **Secure Configurations**: Follow our documentation for secure configuration guidelines.
- **Dependency Management**: Regularly update dependencies and monitor for known vulnerabilities.
- **Contribute Securely**: When contributing code, adhere to our coding standards and ensure your changes do not introduce vulnerabilities.

## Bug Bounty Program

Broadsage currently does not operate a formal bug bounty program. However, we deeply appreciate the efforts of security researchers and may offer recognition, swag, or other forms of gratitude for responsible disclosures at our discretion.

## Contact Information

For all security-related concerns, please contact us through the appropriate channels:

### Security Issues

📧 **Primary**: [security@broadsage.com](mailto:security@broadsage.com)  
🔒 **GitHub Security Advisory**: Use the repository's security advisory feature for private reporting  
👥 **Direct Contact**: Individual maintainer emails (if publicly available)

### General Inquiries

For general inquiries or non-security issues, please use our main contact channels listed on our website or GitHub issues for the specific project.

## Acknowledgments

We would like to thank the security researchers and contributors who have helped improve the security of our projects through responsible disclosure. Their efforts help make our open-source software safer for everyone.

Thank you for helping us keep Broadsage's open-source projects secure!

## Public Archive of Security Reports and Responses

In accordance with OpenSSF best practices, this project maintains a publicly available archive of security reports and our responses. This archive is intended to provide transparency and allow for later searching and review of past incidents and resolutions.

- The archive is available at [`security-reports/`](./security-reports/).
- Each report includes the date, description, investigation steps, resolution, and date of resolution.
- No sensitive or private information is included in the public archive.

For more details, see the [README in the security-reports directory](./security-reports/README.md).
