#!/usr/bin/env python3

# SPDX-FileCopyrightText: Copyright (c) 2025 Broadsage <opensource@broadsage.com>
#
# SPDX-License-Identifier: Apache-2.0

"""
Simple Python script to update dynamic statistics in CONTRIBUTORS.md
"""

import re
import subprocess
from datetime import datetime


def run_git_command(cmd):
    """Run a git command and return the output"""
    try:
        result = subprocess.run(
            cmd, shell=True, capture_output=True, text=True, check=True
        )
        return result.stdout.strip()
    except subprocess.CalledProcessError:
        return ""


def get_git_stats():
    """Collect all git statistics"""
    print("📊 Collecting git statistics...")

    stats = {}

    # Basic stats
    stats["total_commits"] = int(run_git_command("git rev-list --count HEAD") or 0)
    stats["total_contributors"] = len(run_git_command("git shortlog -sn").splitlines())
    stats["last_commit_date"] = run_git_command("git log -1 --pretty=format:'%Y-%m-%d'")
    stats["first_commit_year"] = run_git_command(
        "git log --reverse --pretty=format:'%Y' --date=short | head -1"
    )

    # Contributor types
    code_contributors = run_git_command(
        "git log --pretty=format:'%an' -- '*.sh' '*.yaml' '*.yml' '*.json' "
        "'*.toml' 'Makefile' | sort | uniq"
    )
    stats["code_contributors"] = len(
        [c for c in code_contributors.splitlines() if c.strip()]
    )

    doc_contributors = run_git_command(
        "git log --pretty=format:'%an' -- '*.md' '*.rst' '*.txt' | sort | uniq"
    )
    stats["doc_contributors"] = len(
        [c for c in doc_contributors.splitlines() if c.strip()]
    )

    bug_fixers = run_git_command(
        "git log --grep='fix\\|bug' --pretty=format:'%an' | sort | uniq"
    )
    stats["bug_fixers"] = len([c for c in bug_fixers.splitlines() if c.strip()])

    feature_contributors = run_git_command(
        "git log --grep='feat\\|feature' --pretty=format:'%an' | sort | uniq"
    )
    stats["feature_contributors"] = len(
        [c for c in feature_contributors.splitlines() if c.strip()]
    )

    # Recent activity (30 days)
    recent_contributors = run_git_command(
        "git log --since='30 days ago' --pretty=format:'%an' | sort | uniq"
    )
    stats["recent_count"] = len(
        [c for c in recent_contributors.splitlines() if c.strip()]
    )

    # Monthly stats
    first_of_month = datetime.now().strftime("%Y-%m-01")
    stats["monthly_commits"] = int(
        run_git_command(
            f"git log --since='{first_of_month}' --pretty=format:'%h' | wc -l"
        )
        or 0
    )
    monthly_contributors = run_git_command(
        f"git log --since='{first_of_month}' --pretty=format:'%an' | sort | uniq"
    )
    stats["monthly_contributors"] = len(
        [c for c in monthly_contributors.splitlines() if c.strip()]
    )

    # Top contributors
    top_contributors_raw = run_git_command("git shortlog -sn | head -3")
    stats["top_contributors"] = []
    for line in top_contributors_raw.splitlines():
        if line.strip():
            parts = line.strip().split(None, 1)
            if len(parts) == 2:
                commits, name = parts
                stats["top_contributors"].append((name, int(commits)))

    # Calculate percentages
    total = stats["total_contributors"]
    stats["code_percentage"] = (
        round(stats["code_contributors"] * 100 / total) if total > 0 else 0
    )
    stats["doc_percentage"] = (
        round(stats["doc_contributors"] * 100 / total) if total > 0 else 0
    )
    stats["bug_percentage"] = (
        round(stats["bug_fixers"] * 100 / total) if total > 0 else 0
    )
    stats["feature_percentage"] = (
        round(stats["feature_contributors"] * 100 / total) if total > 0 else 0
    )

    return stats


def update_contributors_file(stats):
    """Update the CONTRIBUTORS.md file with new statistics"""
    print("📝 Updating CONTRIBUTORS.md...")

    contributors_file = "CONTRIBUTORS.md"
    current_date = datetime.now().strftime("%B %d, %Y")
    current_month = datetime.now().strftime("%B %Y")

    with open(contributors_file, "r") as f:
        content = f.read()

    # Update statistics table
    stats_pattern = (
        r"(## 📊 Contribution Statistics\n\n\| Contributor Type \| Count \| "
        r"Percentage \|\n\|------------------|-------|------------|)"
        r"(.*?)(\n\n> Statistics last updated:.*?\n)"
    )
    stats_replacement = f"""
| Code Contributors | {stats['code_contributors']} | {stats['code_percentage']}% |
| Documentation Contributors | {stats['doc_contributors']} | "
        f"{stats['doc_percentage']}% |
| Bug Fixers | {stats['bug_fixers']} | {stats['bug_percentage']}% |
| Feature Contributors | {stats['feature_contributors']} | "
        f"{stats['feature_percentage']}% |
| Community Helpers | 0 | 0% |
| **Total Contributors** | **{stats['total_contributors']}** | **100%** |

> Statistics last updated: {current_date}
"""

    content = re.sub(stats_pattern, r"\1" + stats_replacement, content, flags=re.DOTALL)

    # Update recent contributors
    recent_pattern = r"(## 🎉 Recent Contributors\n\n)(.*?)(\n\n## )"
    if stats["recent_count"] > 0:
        recent_replacement = (
            f"**{stats['recent_count']} contributors in the last 30 days** 🚀\n\n"
            f"*Thank you for keeping the project active!*"
        )
    else:
        recent_replacement = "*No recent contributions yet. Be the first!*"

    content = re.sub(
        recent_pattern, r"\1" + recent_replacement + r"\3", content, flags=re.DOTALL
    )

    # Update monthly highlights
    monthly_pattern = r"(### )[A-Za-z]+ [0-9]{4}(.*?)(\n## )"

    top_contributors_text = ""
    for i, (name, commits) in enumerate(stats["top_contributors"][:3]):
        top_contributors_text += f"- {name} ({commits} commits)\n"

    monthly_replacement = f"""### {current_month}

📊 **This Month Statistics:**

- 📈 Commits: {stats['monthly_commits']}
- 👥 Active Contributors: {stats['monthly_contributors']}
- 📅 Last Activity: {stats['last_commit_date']}

🎯 **Project Progress:**

- 🚀 Total Commits: {stats['total_commits']}
- 👥 Total Contributors: {stats['total_contributors']}
- 📅 Project Started: {stats['first_commit_year']}

🏆 **Top Contributors:**

{top_contributors_text}"""

    content = re.sub(
        monthly_pattern, r"\1" + monthly_replacement + r"\3", content, flags=re.DOTALL
    )

    # Write updated content
    with open(contributors_file, "w") as f:
        f.write(content)

    return stats


def main():
    """Main function"""
    print("🔄 Updating contributor statistics...")

    # Check if we're in a git repository
    try:
        subprocess.run(
            "git rev-parse --git-dir", shell=True, check=True, capture_output=True
        )
    except subprocess.CalledProcessError:
        print("❌ Error: Not in a git repository")
        return 1

    # Collect statistics
    stats = get_git_stats()

    # Update file
    update_contributors_file(stats)

    # Print summary
    print("✅ Successfully updated CONTRIBUTORS.md!")
    print("")
    print("📈 Statistics summary:")
    print(f"   📊 Total Contributors: {stats['total_contributors']}")
    print(
        f"   💻 Code Contributors: {stats['code_contributors']} "
        f"({stats['code_percentage']}%)"
    )
    print(
        f"   📖 Documentation Contributors: {stats['doc_contributors']} "
        f"({stats['doc_percentage']}%)"
    )
    print(f"   🐛 Bug Fixers: {stats['bug_fixers']} ({stats['bug_percentage']}%)")
    print(
        f"   ✨ Feature Contributors: {stats['feature_contributors']} "
        f"({stats['feature_percentage']}%)"
    )
    print(f"   🔄 Total Commits: {stats['total_commits']}")
    print(f"   📅 Recent Activity: {stats['recent_count']} contributors (30 days)")
    print(
        f"   📆 This Month: {stats['monthly_commits']} commits, "
        f"{stats['monthly_contributors']} contributors"
    )
    print(f"   🕒 Updated: {datetime.now().strftime('%B %d, %Y')}")

    return 0


if __name__ == "__main__":
    exit(main())
