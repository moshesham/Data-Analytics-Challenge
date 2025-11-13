# 📋 Codebase Cleanup Issues - Quick Reference

> **Purpose:** This repository now contains comprehensive documentation for 7 GitHub issues to clean up and organize the codebase.

## 🎯 Quick Start

1. **Read:** [CLEANUP_SUMMARY.md](CLEANUP_SUMMARY.md) - Executive overview
2. **Create:** [HOW_TO_CREATE_ISSUES.md](HOW_TO_CREATE_ISSUES.md) - Step-by-step guide
3. **Reference:** [ISSUES_TO_CREATE.md](ISSUES_TO_CREATE.md) - Full issue details

## 📊 Issues Overview

| # | Title | Priority | Effort | Labels |
|---|-------|----------|--------|--------|
| 1 | Consolidate duplicate build scripts | High | 1-2h | `cleanup`, `documentation`, `scripts` |
| 2 | Evaluate Content folder usage | Medium | 3-4h | `cleanup`, `documentation`, `content-structure` |
| 3 | Restore/remove week directories | High | 2-3h | `cleanup`, `structure`, `decision-needed` |
| 4 | Populate/remove empty reports | Medium | 8-12h | `cleanup`, `content`, `reports` |
| 5 | Update documentation files | Medium | 3-4h | `documentation`, `cleanup`, `consistency` |
| 6 | Improve SUMMARY.md generation | High | 2-3h | `enhancement`, `user-experience`, `mdbook` |
| 7 | Comprehensive codebase audit | High | 4-6h | `epic`, `cleanup`, `planning` |

**Total Estimated Effort:** 20-31 hours

## 🔄 Creation Order

```
1. Issue #1 (Build scripts)     → Quick win, unblocks others
2. Issue #2 (Content folder)    → Strategic decision needed
3. Issue #3 (Week directories)  → Depends on #2
4. Issue #4 (Report files)      → Can run in parallel
5. Issue #5 (Documentation)     → After #1-3 resolved
6. Issue #6 (SUMMARY.md)        → Depends on #2 and #3
7. Issue #7 (Audit epic)        → Tracks overall progress
```

## 📁 Files in This Package

```
.
├── ISSUES_TO_CREATE.md          # Main document (1,581 lines)
│   ├── Issue #1: Build scripts
│   ├── Issue #2: Content folder
│   ├── Issue #3: Week directories
│   ├── Issue #4: Report files
│   ├── Issue #5: Documentation
│   ├── Issue #6: SUMMARY.md
│   └── Issue #7: Audit roadmap
│
├── HOW_TO_CREATE_ISSUES.md      # Creation guide (157 lines)
│   ├── Manual method (recommended)
│   ├── CLI method with gh
│   └── Automated script method
│
├── CLEANUP_SUMMARY.md           # Executive overview (167 lines)
│   ├── Overview and purpose
│   ├── Success criteria
│   └── Next steps
│
└── .github/
    └── ISSUE_TEMPLATE.md        # Template for future issues
```

## 🚀 How to Create Issues

### Option 1: Manual (Recommended)
```bash
1. Open GitHub Issues page
2. Click "New Issue"
3. Copy issue from ISSUES_TO_CREATE.md
4. Paste into new issue
5. Add labels as specified
6. Submit
7. Repeat for remaining issues
```

### Option 2: Automated
```bash
# Review the script in HOW_TO_CREATE_ISSUES.md
# Then run:
./create_issues.sh
```

## 🎁 What Each Issue Includes

Every issue contains:

- ✅ Clear problem description
- ✅ Current state analysis with file references
- ✅ Impact assessment
- ✅ Multiple solution options (pros/cons)
- ✅ Specific file checklists
- ✅ Definition of done
- ✅ Related issue cross-references
- ✅ Priority and effort estimates

## 🔗 Dependencies

```
Issue #1 ─┬─→ Issue #5 (docs reference scripts)
          │
Issue #2 ─┼─→ Issue #3 (structure decision)
          ├─→ Issue #6 (navigation depends on structure)
          │
Issue #3 ─┼─→ Issue #6 (navigation depends on structure)
          │
Issue #4 ─┴─→ Issue #6 (what to list in TOC)

Issue #7 ───→ All issues (meta-tracker)
```

## ✅ Success Criteria

Cleanup is successful when:

1. ✅ No duplicate or conflicting files
2. ✅ All documentation is current and accurate
3. ✅ Build process is streamlined
4. ✅ Content organization is clear
5. ✅ All files have clear purpose
6. ✅ Navigation is smooth for learners
7. ✅ Repository is easy to maintain

## 📞 Getting Help

- **Full details:** See [ISSUES_TO_CREATE.md](ISSUES_TO_CREATE.md)
- **How to create:** See [HOW_TO_CREATE_ISSUES.md](HOW_TO_CREATE_ISSUES.md)
- **Overview:** See [CLEANUP_SUMMARY.md](CLEANUP_SUMMARY.md)
- **Template:** See [.github/ISSUE_TEMPLATE.md](.github/ISSUE_TEMPLATE.md)

## 📝 Notes

- Issues designed to be created in order
- Each issue is self-contained
- Issues #1-3 are high priority
- Issue #7 tracks overall progress
- Estimated 20-31 hours total effort

---

**Created:** 2025-11-13  
**Repository:** Analytical-Guide/Product-Analytics-MasterClass  
**Branch:** copilot/review-bash-files-syllabus
