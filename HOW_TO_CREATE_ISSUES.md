# How to Create GitHub Issues from ISSUES_TO_CREATE.md

This guide explains how to create the cleanup issues one at a time on GitHub.

## Prerequisites

- GitHub account with write access to the repository
- Familiarity with GitHub Issues interface

## Method 1: Using GitHub Web UI (Recommended)

For each issue in `ISSUES_TO_CREATE.md`:

1. **Navigate to Issues**
   - Go to https://github.com/Analytical-Guide/Product-Analytics-MasterClass/issues
   - Click "New Issue" button

2. **Copy Issue Content**
   - Open `ISSUES_TO_CREATE.md` in the repository
   - Find the issue section (e.g., "## Issue #1: ...")
   - Copy everything from the title to the end of that issue's content
   - Stop before the next "## Issue #X" heading

3. **Create the Issue**
   - Paste the copied content into the issue description
   - Extract the title from the first line (e.g., "Consolidate duplicate build_book.sh scripts")
   - Add appropriate labels as specified in the issue
   - Submit the issue

4. **Repeat for Each Issue**
   - Follow the recommended order:
     1. Issue #1 (Build scripts)
     2. Issue #2 (Content folder)
     3. Issue #3 (Week directories)
     4. Issue #4 (Report files)
     5. Issue #5 (Documentation)
     6. Issue #6 (SUMMARY.md)
     7. Issue #7 (Audit roadmap)

## Method 2: Using GitHub CLI

If you have `gh` CLI installed and authenticated:

```bash
# Navigate to repository
cd /path/to/Product-Analytics-MasterClass

# Create Issue #1
gh issue create \
  --title "Consolidate duplicate build_book.sh scripts" \
  --label "cleanup,documentation,scripts" \
  --body-file <(sed -n '/^## Issue #1/,/^## Issue #2/p' ISSUES_TO_CREATE.md | head -n -1)

# Create Issue #2
gh issue create \
  --title "Evaluate Content folder usage and redundancy" \
  --label "cleanup,documentation,content-structure" \
  --body-file <(sed -n '/^## Issue #2/,/^## Issue #3/p' ISSUES_TO_CREATE.md | head -n -1)

# ... repeat for issues #3-7
```

## Method 3: Automated Script

A bash script to create all issues at once:

```bash
#!/bin/bash

# Array of issue titles
titles=(
  "Consolidate duplicate build_book.sh scripts"
  "Evaluate Content folder usage and redundancy"
  "Restore or remove week directory structure in book-src"
  "Populate or remove empty placeholder report files"
  "Review and update documentation files for consistency"
  "Improve SUMMARY.md generation and book navigation"
  "Comprehensive codebase audit and cleanup roadmap"
)

# Array of labels
labels=(
  "cleanup,documentation,scripts"
  "cleanup,documentation,content-structure"
  "cleanup,structure,decision-needed"
  "cleanup,content,reports"
  "documentation,cleanup,consistency"
  "enhancement,user-experience,mdbook"
  "epic,cleanup,planning"
)

# Create each issue
for i in {1..7}; do
  echo "Creating Issue #$i: ${titles[$i-1]}"
  
  # Extract issue content from ISSUES_TO_CREATE.md
  if [ $i -eq 7 ]; then
    # Last issue goes to end of file
    body=$(sed -n "/^## Issue #$i:/,\$p" ISSUES_TO_CREATE.md)
  else
    # Other issues go until next issue
    next=$((i + 1))
    body=$(sed -n "/^## Issue #$i:/,/^## Issue #$next:/p" ISSUES_TO_CREATE.md | head -n -1)
  fi
  
  # Create the issue
  echo "$body" | gh issue create \
    --title "${titles[$i-1]}" \
    --label "${labels[$i-1]}" \
    --body-file -
  
  echo "✓ Issue #$i created"
  echo ""
  
  # Brief pause to avoid rate limiting
  sleep 2
done

echo "All issues created successfully!"
```

Save this as `create_issues.sh`, make it executable with `chmod +x create_issues.sh`, and run it.

## Issue Creation Checklist

For each issue you create, verify:

- [ ] Title matches the issue heading
- [ ] All content from that issue section is included
- [ ] Labels are added as specified
- [ ] The issue number is visible in the created issue
- [ ] Related issues are cross-referenced (you may need to edit and add links after all issues are created)

## After Creating All Issues

1. **Update Cross-References**
   - Go back through each issue
   - Update "Related Issues" sections with actual issue numbers
   - Add links to related issues

2. **Create Project Board (Optional)**
   - Create a GitHub Project for "Codebase Cleanup"
   - Add all 7 issues to the project
   - Organize by priority/status

3. **Assign and Prioritize**
   - Assign issues to team members
   - Set milestones if appropriate
   - Add to project boards

## Notes

- The issues are designed to be created in order, as later issues reference earlier ones
- Each issue is self-contained with full context
- Issues #1-3 should be prioritized as they unblock other work
- Issue #7 serves as an epic to track overall progress

