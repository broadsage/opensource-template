#!/usr/bin/env python3

# SPDX-FileCopyrightText: Copyright (c) 2025 Broadsage <opensource@broadsage.com>
# SPDX-License-Identifier: Apache-2.0

"""
CodeQL SARIF Post-Processor
Enhances CodeQL SARIF results with additional metadata and filtering
"""

import argparse
import json
import sys
from datetime import datetime
from pathlib import Path


def load_sarif(file_path):
    """Load SARIF file"""
    with open(file_path, "r") as f:
        return json.load(f)


def enhance_sarif(sarif_data, metadata=None):
    """Enhance SARIF data with additional metadata"""

    # Add timestamp
    sarif_data["$schema"] = "https://json.schemastore.org/sarif-2.1.0.json"
    sarif_data["version"] = "2.1.0"

    # Add custom metadata if provided
    if metadata:
        if "properties" not in sarif_data:
            sarif_data["properties"] = {}
        sarif_data["properties"].update(metadata)

    # Process each run
    for run in sarif_data.get("runs", []):
        # Add analysis timestamp
        run["invocations"] = run.get("invocations", [])
        if not run["invocations"]:
            run["invocations"].append({})

        invocation = run["invocations"][0]
        invocation["startTimeUtc"] = datetime.utcnow().isoformat() + "Z"

        # Enhance rules with severity mapping
        rules = run.get("tool", {}).get("driver", {}).get("rules", [])
        for rule in rules:
            # Map CodeQL security levels to SARIF levels
            if "security-severity" in rule.get("properties", {}):
                security_severity = rule["properties"]["security-severity"]
                if float(security_severity) >= 9.0:
                    rule["defaultConfiguration"] = {"level": "error"}
                elif float(security_severity) >= 7.0:
                    rule["defaultConfiguration"] = {"level": "warning"}
                else:
                    rule["defaultConfiguration"] = {"level": "note"}

        # Filter results by severity if needed
        results = run.get("results", [])
        filtered_results = []

        for result in results:
            # Keep high and medium severity findings
            rule_id = result.get("ruleId", "")
            level = result.get("level", "note")

            # Always include errors and warnings
            if level in ["error", "warning"]:
                filtered_results.append(result)
            # Include notes from security rules
            elif level == "note" and "security" in rule_id.lower():
                filtered_results.append(result)

        run["results"] = filtered_results

    return sarif_data


def save_sarif(sarif_data, file_path):
    """Save enhanced SARIF file"""
    with open(file_path, "w") as f:
        json.dump(sarif_data, f, indent=2)


def generate_summary(sarif_data):
    """Generate a summary of findings"""
    summary = {
        "total_runs": len(sarif_data.get("runs", [])),
        "total_results": 0,
        "by_severity": {"error": 0, "warning": 0, "note": 0},
        "by_category": {},
        "rules_triggered": set(),
    }

    for run in sarif_data.get("runs", []):
        results = run.get("results", [])
        summary["total_results"] += len(results)

        for result in results:
            # Count by severity
            level = result.get("level", "note")
            summary["by_severity"][level] += 1

            # Track rules
            rule_id = result.get("ruleId", "unknown")
            summary["rules_triggered"].add(rule_id)

            # Count by category (extract from rule ID)
            category = rule_id.split("/")[0] if "/" in rule_id else "general"
            summary["by_category"][category] = (
                summary["by_category"].get(category, 0) + 1
            )

    # Convert set to list for JSON serialization
    summary["rules_triggered"] = list(summary["rules_triggered"])
    summary["total_rules"] = len(summary["rules_triggered"])

    return summary


def main():
    parser = argparse.ArgumentParser(description="Process CodeQL SARIF results")
    parser.add_argument("input", help="Input SARIF file")
    parser.add_argument("--output", help="Output SARIF file (default: enhanced_input)")
    parser.add_argument("--summary", help="Output summary JSON file")
    parser.add_argument("--metadata", help="Additional metadata JSON file")

    args = parser.parse_args()

    try:
        # Load input SARIF
        sarif_data = load_sarif(args.input)

        # Load metadata if provided
        metadata = None
        if args.metadata and Path(args.metadata).exists():
            with open(args.metadata, "r") as f:
                metadata = json.load(f)

        # Enhance SARIF
        enhanced_sarif = enhance_sarif(sarif_data, metadata)

        # Generate summary
        summary = generate_summary(enhanced_sarif)

        # Save enhanced SARIF
        output_file = args.output or f"enhanced_{args.input}"
        save_sarif(enhanced_sarif, output_file)

        # Save summary if requested
        if args.summary:
            with open(args.summary, "w") as f:
                json.dump(summary, f, indent=2)

        # Print summary to stdout
        print("CodeQL Analysis Summary:")
        print(f"  Total Results: {summary['total_results']}")
        print(f"  Errors: {summary['by_severity']['error']}")
        print(f"  Warnings: {summary['by_severity']['warning']}")
        print(f"  Notes: {summary['by_severity']['note']}")
        print(f"  Rules Triggered: {summary['total_rules']}")

        if summary["by_category"]:
            print("  By Category:")
            for category, count in sorted(summary["by_category"].items()):
                print(f"    {category}: {count}")

        return 0

    except Exception as e:
        print(f"Error processing SARIF: {e}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())
