# Codebase Cleanup - Issues Summary

## Overview

This directory contains documentation for a comprehensive cleanup of the Product Analytics MasterClass repository. Seven detailed GitHub issues have been prepared to systematically address organizational and structural problems in the codebase.

## Files in This Package

1. **ISSUES_TO_CREATE.md** (Main document - ~500 lines)
   - Contains 7 fully detailed GitHub issues
   - Each issue includes problem description, analysis, solutions, and definition of done
   - Ready to be copied to GitHub Issues one at a time

2. **HOW_TO_CREATE_ISSUES.md** (Instructions)
   - Step-by-step guide for creating issues on GitHub
   - Includes manual method, CLI method, and automated script
   - Provides checklist and best practices

3. **.github/ISSUE_TEMPLATE.md** (Template)
   - Reusable template for future cleanup issues
   - Ensures consistency in issue creation

## The 7 Issues

### Issue #1: Consolidate duplicate build_book.sh scripts
- **Priority:** High
- **Effort:** Small (1-2 hours)
- **Labels:** `cleanup`, `documentation`, `scripts`
- **Summary:** Remove duplicate build scripts and standardize on one

### Issue #2: Evaluate Content folder usage and redundancy
- **Priority:** Medium
- **Effort:** Medium (3-4 hours)
- **Labels:** `cleanup`, `documentation`, `content-structure`
- **Summary:** Determine purpose of Content/ folder and eliminate redundancy

### Issue #3: Restore or remove week directory structure in book-src
- **Priority:** High
- **Effort:** Small-Medium (2-3 hours)
- **Labels:** `cleanup`, `structure`, `decision-needed`
- **Summary:** Decide whether to restore week-based organization or keep flat structure

### Issue #4: Populate or remove empty placeholder report files
- **Priority:** Medium
- **Effort:** Large (8-12 hours if creating content)
- **Labels:** `cleanup`, `content`, `reports`
- **Summary:** Fill in or remove 9 empty/placeholder report files

### Issue #5: Review and update documentation files for consistency
- **Priority:** Medium
- **Effort:** Medium (3-4 hours)
- **Labels:** `documentation`, `cleanup`, `consistency`
- **Summary:** Update README, CONTRIBUTING, and other docs to reflect current structure

### Issue #6: Improve SUMMARY.md generation and book navigation
- **Priority:** High
- **Effort:** Small-Medium (2-3 hours)
- **Labels:** `enhancement`, `user-experience`, `mdbook`
- **Summary:** Enhance mdBook table of contents for better navigation

### Issue #7: Comprehensive codebase audit and cleanup roadmap
- **Priority:** High
- **Effort:** Medium (4-6 hours for audit)
- **Labels:** `epic`, `cleanup`, `planning`
- **Summary:** Meta-issue to track overall cleanup progress and identify additional items

## Recommended Creation Order

1. **Issue #1** - Quick win that unblocks other work
2. **Issue #2** - Strategic decision about content organization
3. **Issue #3** - Depends on Issue #2 decision
4. **Issue #4** - Can be done in parallel with others
5. **Issue #5** - Should be done after #1-3 are resolved
6. **Issue #6** - Depends on decisions from #2 and #3
7. **Issue #7** - Meta-issue to track everything

## Quick Start

### Option 1: Manual Creation (5-10 minutes per issue)
1. Open `ISSUES_TO_CREATE.md`
2. Copy each issue section
3. Create new GitHub issue
4. Paste content and add labels
5. Repeat for all 7 issues

### Option 2: Automated Creation (5 minutes total)
1. Read `HOW_TO_CREATE_ISSUES.md`
2. Use the provided bash script
3. Run: `./create_issues.sh`
4. All 7 issues created automatically

## What's Included in Each Issue

Every issue contains:

- ✅ **Problem Description** - Clear explanation of what needs fixing
- ✅ **Current State Analysis** - Detailed assessment with file references
- ✅ **Impact** - Why this matters and what problems it causes
- ✅ **Recommended Solutions** - Multiple options with pros/cons
- ✅ **Files to Check/Update** - Specific file checklist
- ✅ **Definition of Done** - Clear completion criteria
- ✅ **Related Issues** - Cross-references to other issues
- ✅ **Additional Context** - Background information and rationale

## Total Effort Estimate

- **Audit & Planning:** 6-10 hours (Issues #7, #2, #3)
- **Quick Wins:** 3-5 hours (Issues #1, #6)
- **Documentation:** 3-4 hours (Issue #5)
- **Content Creation:** 8-12 hours (Issue #4, if creating content)

**Total:** 20-31 hours depending on decisions made

## Dependencies Between Issues

```
Issue #1 (Build scripts)
  └─> Issue #5 (Documentation) - docs reference build scripts

Issue #2 (Content folder)
  └─> Issue #3 (Week directories) - structure decision
  └─> Issue #6 (SUMMARY.md) - navigation depends on structure

Issue #3 (Week directories)
  └─> Issue #6 (SUMMARY.md) - navigation depends on structure

Issue #4 (Reports)
  └─> Issue #6 (SUMMARY.md) - what to list in TOC

Issue #7 (Audit)
  └─> All issues - tracks overall progress
```

## Success Criteria

This cleanup effort will be successful when:

1. ✅ No duplicate or conflicting files exist
2. ✅ All documentation is current and accurate
3. ✅ Build process is streamlined and well-documented
4. ✅ Content organization is clear and logical
5. ✅ All files have a clear purpose and are referenced
6. ✅ Navigation experience is smooth for learners
7. ✅ Repository is easy to maintain going forward

## Getting Help

- Read the full issue descriptions in `ISSUES_TO_CREATE.md`
- Follow the creation guide in `HOW_TO_CREATE_ISSUES.md`
- Use `.github/ISSUE_TEMPLATE.md` for any new cleanup issues
- Reference this summary for overview and priorities

## Next Steps

1. Review `ISSUES_TO_CREATE.md` to understand all issues
2. Follow `HOW_TO_CREATE_ISSUES.md` to create issues on GitHub
3. Prioritize and assign issues to team members
4. Begin work on Issue #1 (quick win)
5. Make strategic decisions on Issues #2 and #3
6. Track progress using Issue #7 as epic

---

**Created:** 2025-11-13  
**Repository:** Analytical-Guide/Product-Analytics-MasterClass  
**Purpose:** Comprehensive codebase cleanup and organization

