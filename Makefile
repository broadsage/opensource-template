# SPDX-FileCopyrightText: Copyright (c) 2025 Broadsage <opensource@broadsage.com>
#
# SPDX-License-Identifier: Apache-2.0

## Catch-all for unknown targets
.DEFAULT:
	@echo "Error: Target '$@' not found." >&2
	@$(MAKE) help

# Makefile to check Docker and Podman installation and provide help
.PHONY: help check-docker check-podman check-containers check-compliance update-contributors validate-codeql-setup setup-template clean dev test lint format

help:
	@echo "Usage: make <target>"
	@echo ""
	@echo "Setup Targets:"
	@echo "  setup-template        	Run the interactive template setup script"
	@echo "  setup-dev             	Set up development environment"
	@echo ""
	@echo "Development Targets:"
	@echo "  dev                  	Start development environment"
	@echo "  test                 	Run all tests"
	@echo "  test-unit            	Run unit tests"
	@echo "  test-integration     	Run integration tests"
	@echo "  lint                 	Run linting checks"
	@echo "  format               	Format code"
	@echo "  clean                	Clean build artifacts and temporary files"
	@echo ""
	@echo "Quality Assurance Targets:"
	@echo "  check-compliance     	Run code quality & compliance checks using MegaLinter, PublicCodeLint, FSFE REUSE Compliance, and Conform"
	@echo "  check-security       	Run security scans and vulnerability checks"
	@echo "  check-dependencies   	Check for dependency vulnerabilities"
	@echo ""
	@echo "Infrastructure Targets:"
	@echo "  check-docker         	Check if Docker is installed and available in PATH"
	@echo "  check-podman         	Check if Podman is installed and available in PATH"
	@echo "  check-containers     	Check if both Docker and Podman are installed"
	@echo ""
	@echo "Documentation Targets:"
	@echo "  docs                 	Generate documentation"
	@echo "  docs-serve           	Serve documentation locally"
	@echo "  update-contributors  	Update dynamic statistics in CONTRIBUTORS.md file"
	@echo "  show-stats           	Display current contributor statistics"
	@echo ""
	@echo "Validation Targets:"
	@echo "  validate-codeql-setup   Validate CodeQL configuration and setup"
	@echo "  validate-workflows      Validate GitHub Actions workflows"
	@echo "  validate-templates      Validate issue and PR templates"
	@echo ""
	@echo "Advanced Usage:"
	@echo "  make check-containers # Checks both Docker and Podman installed."
	@echo ""
	@echo "Troubleshooting (OS-specific):"
	@sh -c "\
if [ \"\$OS\" = \"Windows_NT\" ]; then \
	echo '  - Windows:'; \
	echo '      * Install Docker Desktop: https://www.docker.com/products/docker-desktop/'; \
	echo '      * Install Podman: https://podman.io/getting-started/installation'; \
	echo '      * Ensure Docker Desktop or Podman Machine is running.'; \
	echo '      * Restart Command Prompt or PowerShell after installation.'; \
elif uname | grep -qi darwin; then \
	echo '  - macOS:'; \
	echo '      * Install Docker Desktop: https://www.docker.com/products/docker-desktop/'; \
	echo '      * Install Podman: brew install podman'; \
	echo '      * After installation, restart your terminal.'; \
elif uname | grep -qi linux; then \
	echo '  - Linux:'; \
	echo '      * Install Docker: https://docs.docker.com/engine/install/'; \
	echo '      * Install Podman: https://podman.io/getting-started/installation'; \
	echo '      * Ensure your user is in the '"'docker'"' group: sudo usermod -aG docker $USER && newgrp docker'; \
	echo '      * Restart your terminal or log out/in after installation.'; \
else \
	echo '  - Unknown OS: Please refer to your OS documentation for Docker/Podman installation.'; \
fi"
	@echo "  - PATH issues: If the command is still not found, check your PATH environment variable."

check-docker:
	@if command -v docker >/dev/null 2>&1; then \
		echo "Docker is installed."; \
	else \
		echo "Docker is NOT installed."; \
	fi

check-podman:
	@if command -v podman >/dev/null 2>&1; then \
		echo "Podman is installed."; \
	else \
		echo "Podman is NOT installed."; \
	fi

check-containers:
	$(MAKE) check-docker
	$(MAKE) check-podman

check-compliance:
	@bash scripts/compliance.sh
	@echo "All checks completed. Review output for any warnings or failures."

update-contributors:
	@echo "🔄 Updating contributor statistics..."
	@python3 scripts/update-contributors.py

validate-codeql-setup:
	@echo "Validating CodeQL configuration..."
	@./scripts/validate-codeql-setup.sh

# Template setup target
setup-template:
	@echo "Running template setup script..."
	@./scripts/setup-template.sh

# Development environment setup
setup-dev:
	@echo "Setting up development environment..."
	@echo "Installing git hooks..."
	@if [ -d ".git" ]; then 
		cp scripts/git-hooks/* .git/hooks/ 2>/dev/null || true; 
		chmod +x .git/hooks/* 2>/dev/null || true; 
		echo "Git hooks installed successfully"; 
	else 
		echo "Not a git repository - skipping git hooks"; 
	fi

# Development targets
dev:
	@echo "Starting development environment..."
	@echo "This target should be customized for your specific technology stack"
	@echo "Examples:"
	@echo "  npm run dev     # For Node.js projects"
	@echo "  python manage.py runserver  # For Django projects"
	@echo "  go run main.go  # For Go projects"

test:
	@echo "Running all tests..."
	@echo "This target should be customized for your specific technology stack"
	@echo "Examples:"
	@echo "  npm test        # For Node.js projects"
	@echo "  pytest          # For Python projects"
	@echo "  go test ./...   # For Go projects"

test-unit:
	@echo "Running unit tests..."
	@echo "Customize this target for your testing framework"

test-integration:
	@echo "Running integration tests..."
	@echo "Customize this target for your testing framework"

lint:
	@echo "Running linting checks..."
	@echo "This will run MegaLinter for comprehensive linting"
	@docker run --rm -v $(PWD):/tmp/lint oxsecurity/megalinter:latest || 
	echo "MegaLinter not available - install Docker or customize this target"

format:
	@echo "Formatting code..."
	@echo "This target should be customized for your specific technology stack"
	@echo "Examples:"
	@echo "  prettier --write .  # For JavaScript/TypeScript"
	@echo "  black .             # For Python"
	@echo "  go fmt ./...        # For Go"

clean:
	@echo "Cleaning build artifacts and temporary files..."
	@rm -rf dist/ build/ *.egg-info/ .coverage htmlcov/ .pytest_cache/
	@rm -rf node_modules/.cache/ .next/ out/
	@rm -rf target/ .gradle/
	@find . -name "*.pyc" -delete
	@find . -name "__pycache__" -type d -exec rm -rf {} + 2>/dev/null || true
	@echo "Clean completed"

# Quality assurance targets
check-security:
	@echo "Running security scans..."
	@echo "Checking for secrets in code..."
	@docker run --rm -v $(PWD):/tmp/gitleaks zricethezav/gitleaks:latest detect --source /tmp/gitleaks --verbose || 
	echo "Gitleaks not available - install Docker or use alternative security scanner"

check-dependencies:
	@echo "Checking for dependency vulnerabilities..."
	@echo "This target should be customized for your package manager"
	@echo "Examples:"
	@echo "  npm audit           # For Node.js projects"
	@echo "  safety check        # For Python projects"
	@echo "  go list -json -deps | nancy sleuth  # For Go projects"

# Documentation targets
docs:
	@echo "Generating documentation..."
	@echo "This target should be customized for your documentation system"
	@echo "Examples:"
	@echo "  sphinx-build docs/ docs/_build/  # For Sphinx"
	@echo "  gitbook build                    # For GitBook"
	@echo "  npm run docs:build               # For VuePress/Docusaurus"

docs-serve:
	@echo "Serving documentation locally..."
	@echo "This target should be customized for your documentation system"
	@echo "Examples:"
	@echo "  sphinx-autobuild docs/ docs/_build/  # For Sphinx"
	@echo "  gitbook serve                        # For GitBook"
	@echo "  npm run docs:serve                   # For VuePress/Docusaurus"

# Validation targets
validate-workflows:
	@echo "Validating GitHub Actions workflows..."
	@find .github/workflows -name "*.yml" -o -name "*.yaml" | xargs -I {} sh -c 'echo "Validating {}..." && yamllint {}'

validate-templates:
	@echo "Validating issue and PR templates..."
	@find .github/ISSUE_TEMPLATE -name "*.yml" | xargs -I {} sh -c 'echo "Validating {}..." && yamllint {}'
	@if [ -f ".github/pull_request_template.md" ]; then echo "PR template found: .github/pull_request_template.md"; fi
