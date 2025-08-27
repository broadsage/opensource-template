// SPDX-FileCopyrightText: 2024 The OSS-Template Authors
// SPDX-License-Identifier: Apache-2.0

/**
 * @name Hardcoded sensitive information
 * @description Detects potential hardcoded sensitive information in source files
 * @kind problem
 * @problem.severity warning
 * @security-severity 7.0
 * @precision medium
 * @id py/hardcoded-credentials
 * @tags security
 *       external/cwe/cwe-798
 */

import python

/**
 * Patterns that might indicate hardcoded credentials or sensitive information
 */
predicate isSensitivePattern(string pattern) {
  pattern.regexpMatch("(?i).*(password|passwd|pwd|secret|token|key|api_key|apikey|auth|credential).*")
}

/**
 * String literals that might contain sensitive information
 */
class SensitiveStringLiteral extends StrConst {
  SensitiveStringLiteral() {
    exists(string value | value = this.getText() |
      // Avoid very short strings and common patterns
      value.length() > 8 and
      not value.regexpMatch(".*[\\s\\*\\-\\_\\=\\+]{3,}.*") and
      // Look for patterns that suggest credentials
      (
        value.regexpMatch("(?i).*[a-z0-9]{20,}.*") or  // Long alphanumeric strings
        value.regexpMatch("(?i).*[A-Z0-9]{16,}.*") or  // API key patterns
        value.regexpMatch("(?i).*[a-zA-Z0-9\\+\\/]{20,}={0,2}") or  // Base64 patterns
        value.regexpMatch("(?i).*[a-f0-9]{32,}.*")     // Hex patterns
      )
    )
  }
}

/**
 * Assignment to variables with sensitive names
 */
class SensitiveAssignment extends Assign {
  SensitiveAssignment() {
    exists(Name target, string name |
      target = this.getATarget() and
      name = target.getId() and
      isSensitivePattern(name) and
      // Make sure it's assigned a string literal
      this.getValue() instanceof SensitiveStringLiteral
    )
  }
  
  string getVariableName() {
    exists(Name target |
      target = this.getATarget() and
      result = target.getId()
    )
  }
}

from SensitiveAssignment assignment, SensitiveStringLiteral literal
where 
  assignment.getValue() = literal and
  // Exclude common test patterns and documentation
  not literal.getText().regexpMatch("(?i).*(test|example|dummy|fake|mock|placeholder|your_key_here|insert_key|replace_with).*")
select assignment, 
  "Potential hardcoded sensitive information in variable '" + assignment.getVariableName() + "'. " +
  "Consider using environment variables or secure configuration management."
