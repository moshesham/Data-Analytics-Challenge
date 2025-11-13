# GitHub Issues to Create for Codebase Cleanup

This document contains detailed issue descriptions to be created one at a time on GitHub for the Product Analytics MasterClass repository cleanup.

---

## Issue #1: Consolidate duplicate build_book.sh scripts

**Labels:** `cleanup`, `documentation`, `scripts`  
**Priority:** High  
**Effort:** Small (1-2 hours)

### Problem Description

The repository currently contains two build scripts with different implementations:
1. `/scripts/build_book.sh` - The older version
2. `/scripts/bash/build_book.sh` - The newer, cleaner version

The newer script (`/scripts/bash/build_book.sh`) has been updated but the older one (`/scripts/build_book.sh`) still contains logic that references week directories that no longer exist.

### Current State Analysis

#### scripts/bash/build_book.sh (UPDATED - WORKING)
- ✅ Clears old content before building
- ✅ Copies main curriculum as introduction.md
- ✅ Copies report files successfully
- ✅ Generates SUMMARY.md dynamically
- ✅ All file paths reference existing files
- ⚠️ File is executable (755 permissions)

#### scripts/build_book.sh (OUTDATED - BROKEN)
- ❌ No cleanup step before copying
- ❌ Contains useless loop copying week directories to themselves (lines 14-18)
- ❌ References week directories that have been deleted
- ❌ Does NOT generate SUMMARY.md
- ❌ File is not executable (644 permissions)

### Files Referenced in Scripts

The build scripts attempt to copy these files from `reports/`:
- ✅ `ab_test_analysis.md` - EXISTS but is EMPTY (0 bytes)
- ✅ `qbr_presentation.md` - EXISTS but is EMPTY (0 bytes)
- ✅ `Journals_Instrumentation_Plan.md` - EXISTS with placeholder content
- ✅ `Week1_Launch_Summary.md` - EXISTS with placeholder content
- ✅ `AB_Test_Final_Readout.md` - EXISTS with placeholder content
- ✅ `Pre_Mortem_Memo.md` - EXISTS with placeholder content
- ✅ `Journals_Launch_Monitoring_Dashboard.md` - EXISTS with placeholder content
- ✅ `DiD_Critical_Assessment.md` - EXISTS with placeholder content

### Impact

1. **Confusion**: Having two build scripts creates confusion about which one to use
2. **Maintenance**: Keeping two scripts in sync is error-prone
3. **Documentation**: README or other docs may reference the wrong script
4. **CI/CD**: Automated builds may use the wrong script

### Recommended Solution

#### Option 1: Remove Outdated Script (RECOMMENDED)
- Delete `/scripts/build_book.sh`
- Update any documentation referencing it to use `/scripts/bash/build_book.sh`
- Update any CI/CD pipelines if they reference the old script

#### Option 2: Consolidate at Root Level
- Keep the newer implementation at `/scripts/build_book.sh`
- Delete `/scripts/bash/build_book.sh`
- Move any other scripts from `/scripts/bash/` to `/scripts/` directly

#### Option 3: Make Scripts Modular
- Keep both locations but have `/scripts/build_book.sh` call `/scripts/bash/build_book.sh`
- Add documentation explaining the structure

### Alignment with 30-Day Syllabus

The 30-day syllabus (in `30-Day Product Analytics Masterclass.md`) defines the course structure with:
- Week 1 (Days 1-7): Foundations & Framing
- Week 2 (Days 8-14): Launch & Monitoring  
- Week 3 (Days 15-21): Deep Dive - Causal Impact
- Week 4 (Days 22-30): Strategy - From Analyst to Influencer

The build scripts should:
1. ✅ Copy the main curriculum as the introduction
2. ❓ Potentially organize content by week/day structure
3. ✅ Include key reports as referenced in the curriculum
4. ✅ Generate a coherent table of contents

### Files to Check/Update

- [ ] `/scripts/build_book.sh`
- [ ] `/scripts/bash/build_book.sh`
- [ ] `README.md` - Check for build script references
- [ ] `.github/workflows/*` - Check CI/CD references
- [ ] `CONTRIBUTING.md` - Check for build instructions
- [ ] `book.toml` - Verify mdBook configuration

### Additional Context

The `Content/` folder contains `Day_XX_Topic/README.md` files that provide detailed guidance for each day of the curriculum. The relationship between this content and the book-src structure needs clarification.

### Definition of Done

- [ ] Only one authoritative build script exists
- [ ] The script successfully builds the mdBook
- [ ] All file references in the script point to existing files
- [ ] Documentation is updated to reference the correct script
- [ ] Any CI/CD pipelines are updated
- [ ] The script aligns with the 30-day syllabus structure

### Related Issues
- Issue #2 (Content folder evaluation)
- Issue #4 (Empty report files)

---

## Issue #2: Evaluate Content folder usage and redundancy

**Labels:** `cleanup`, `documentation`, `content-structure`  
**Priority:** Medium  
**Effort:** Medium (3-4 hours)

### Problem Description

The repository contains a `Content/` directory with 30 subdirectories (`Day_01_Topic` through `Day_30_Topic`), each containing a `README.md` file. However, it's unclear how this content relates to:
1. The `book-src/src/` structure (which previously had week-based organization)
2. The main `30-Day Product Analytics Masterclass.md` curriculum file
3. The `notebooks/` directory

This creates confusion about the single source of truth for course content and may lead to content drift.

### Current State Analysis

#### Content Folder Structure
```
Content/
├── Day_01_Topic/README.md (4.4KB)
├── Day_02_Topic/README.md
├── Day_03_Topic/README.md
...
├── Day_30_Topic/README.md
```

Total size: ~368KB across 30 directories

#### Sample Content Analysis (Day_01_Topic/README.md)
- Contains detailed day-specific guidance
- Includes objectives, key concepts, step-by-step instructions
- References specific deliverables and notebooks
- Well-structured educational content
- Appears to be teaching material, not just metadata

#### Relationship to Other Content

**vs. 30-Day Product Analytics Masterclass.md:**
- Main curriculum file is comprehensive (49KB)
- Contains all 30 days of curriculum in one file
- Content appears to overlap with Day_XX_Topic files
- Main file is more concise; Day files are more detailed

**vs. book-src/src/:**
- book-src previously had week-N/day-N.md files (now deleted)
- Current book-src only has introduction.md and report files
- No clear linkage between Content/ and book-src/

**vs. notebooks/:**
- Notebooks directory contains actual code exercises
- Content/Day_XX files reference notebooks by name
- Acts as instruction manual for notebooks

### Impact

1. **Maintenance Burden**: Three potential sources of truth for curriculum content
2. **Inconsistency Risk**: Changes to one location may not propagate to others
3. **User Confusion**: Unclear which content users should follow
4. **Build Process**: Content/ folder is not currently used by build_book.sh scripts

### Questions to Answer

1. **Is Content/ folder actively used?**
   - Check if any scripts reference it
   - Check if README.md points to it
   - Check if it's linked in documentation

2. **Should Content/ be the source for book-src?**
   - If yes, update build scripts to copy from Content/
   - If no, consider removing or consolidating

3. **Is there value in the detailed Day-specific content?**
   - More detailed than main curriculum
   - Includes pedagogical elements
   - May be valuable for instructors

### Recommended Solutions

#### Option 1: Make Content/ the Source of Truth (RECOMMENDED)
- **Pro**: Most detailed content exists here
- **Pro**: Clear day-by-day organization
- **Con**: Requires updating build scripts
- **Action Items**:
  1. Update build scripts to copy from Content/Day_XX_Topic/README.md
  2. Rename files to more semantic names (e.g., day-01-opportunity-discovery.md)
  3. Update SUMMARY.md generation to include all 30 days
  4. Archive or remove content from main curriculum file

#### Option 2: Consolidate into Main Curriculum
- **Pro**: Single file is easier to maintain
- **Pro**: Already referenced by build scripts
- **Con**: Loss of detailed instructional content
- **Action Items**:
  1. Merge valuable content from Day_XX files into main curriculum
  2. Delete Content/ folder
  3. Keep build scripts as-is

#### Option 3: Hybrid Approach
- **Pro**: Preserves both levels of detail
- **Pro**: Main curriculum for overview, Content/ for deep-dive
- **Con**: Requires clear documentation of purpose
- **Action Items**:
  1. Document that main curriculum is the syllabus
  2. Document that Content/ contains instructor/student guides
  3. Update build scripts to include both
  4. Create clear navigation between them

#### Option 4: Move to book-src Week Structure
- **Pro**: Aligns with pedagogical weeks
- **Pro**: Restores original structure
- **Con**: Requires recreating deleted week directories
- **Action Items**:
  1. Create book-src/src/week-1/ through week-4/
  2. Move Day_XX content to appropriate week folders
  3. Update build scripts accordingly

### Files to Audit

- [ ] All 30 `Content/Day_XX_Topic/README.md` files
- [ ] `30-Day Product Analytics Masterclass.md`
- [ ] `README.md` - Check for Content/ references
- [ ] `scripts/bash/build_book.sh` - Currently doesn't use Content/
- [ ] `scripts/build_book.sh` - Currently doesn't use Content/
- [ ] `.github/workflows/*` - Check for Content/ usage
- [ ] `book.toml` - Check mdBook configuration

### Metrics to Consider

- Content overlap percentage between main curriculum and Day files
- Unique content in each location
- File size comparison
- Last modified dates

### Definition of Done

- [ ] Decision made on Content/ folder purpose
- [ ] If keeping: Build scripts updated to use Content/
- [ ] If removing: Content migrated or archived
- [ ] Documentation updated to explain content organization
- [ ] All references to Content/ are accurate
- [ ] No duplicate or conflicting content exists

### Related Issues
- Issue #1 (Build script consolidation)
- Issue #3 (Week directory structure)

---

## Issue #3: Restore or remove week directory structure in book-src

**Labels:** `cleanup`, `structure`, `decision-needed`  
**Priority:** High  
**Effort:** Small-Medium (2-3 hours)

### Problem Description

The `book-src/src/` directory previously contained a week-based organizational structure with individual day markdown files:
- `week-1/day-01.md` through `day-07.md`
- `week-2/day-08.md` through `day-14.md`
- `week-3/day-15.md` through `day-21.md`
- `week-4/day-22.md` through `day-30.md`

These 30 files were recently deleted (commit 18d9b74), and the structure was flattened. The current state leaves `book-src/src/` with only:
- `introduction.md` (the main curriculum)
- Report files copied from `reports/`
- `SUMMARY.md` (table of contents)

### Current State Analysis

#### What Was Deleted
```
book-src/src/
├── week-1/
│   ├── day-01.md (deleted)
│   ├── day-02.md (deleted)
│   ...
│   └── day-07.md (deleted)
├── week-2/ (all files deleted)
├── week-3/ (all files deleted)
└── week-4/ (all files deleted)
```

Total: 30 markdown files deleted across 4 week directories

#### What Remains
```
book-src/src/
├── introduction.md (main curriculum - 49KB)
├── SUMMARY.md (164 bytes - minimal TOC)
├── ab_test_analysis.md (0 bytes)
├── qbr_presentation.md (0 bytes)
└── [6 other report files with placeholder content]
```

#### Git History
```
commit 18d9b74
Author: moshesham
Date: [recent]

Deleted:
- book-src/src/week-1/day-01.md through day-07.md
- book-src/src/week-2/day-08.md through day-14.md  
- book-src/src/week-3/day-15.md through day-21.md
- book-src/src/week-4/day-22.md through day-30.md
```

### Impact

1. **Loss of Granular Content**: If those day files contained unique content, it's now inaccessible
2. **Navigation Issues**: mdBook users can't navigate by specific days
3. **Build Script References**: The old `scripts/build_book.sh` still references these directories
4. **Pedagogical Structure**: Week-based learning may be better than one large introduction

### Questions to Answer

1. **Did the deleted files contain unique content?**
   - Check git history: `git show <commit>:book-src/src/week-1/day-01.md`
   - Compare with Content/Day_01_Topic/README.md
   - Compare with 30-Day Product Analytics Masterclass.md

2. **Was the deletion intentional or accidental?**
   - Review commit message
   - Check PR/issue discussions
   - Consult with repository maintainers

3. **What should the book structure be?**
   - Single-page curriculum (current state)
   - Week-based chapters with day sections
   - Flat list of 30 day pages
   - Hybrid with weeks + reports

### Recommended Solutions

#### Option 1: Restore Week Structure from Content/ (RECOMMENDED IF UNIQUE CONTENT)
- **Action**: Copy `Content/Day_XX_Topic/README.md` to `book-src/src/week-N/day-XX.md`
- **Mapping**:
  - Days 01-07 → week-1/
  - Days 08-14 → week-2/
  - Days 15-21 → week-3/
  - Days 22-30 → week-4/
- **Update**: SUMMARY.md to include week-based navigation
- **Update**: Build scripts to maintain this structure

#### Option 2: Keep Flat Structure (CURRENT STATE)
- **Action**: Accept that introduction.md is the primary content
- **Update**: Remove week-copying logic from old build script
- **Update**: Documentation to reflect single-page approach
- **Benefit**: Simpler to maintain, easier to search
- **Downside**: Harder to navigate long document

#### Option 3: Restore from Git History
- **Action**: Cherry-pick the deleted files from git history
- **Command**: `git checkout <previous-commit> -- book-src/src/week-*/`
- **Benefit**: Preserves any unique content that was in those files
- **Requirement**: First verify content is unique and valuable

#### Option 4: Create New Week Structure from Main Curriculum
- **Action**: Split the main curriculum into week/day files programmatically
- **Script**: Parse markdown headers in main file
- **Benefit**: Clean split from authoritative source
- **Downside**: Requires markdown parsing logic

### Investigation Steps

#### Step 1: Check Git History for Content
```bash
# View what day-01.md contained before deletion
git show 574d4a5:book-src/src/week-1/day-01.md

# Compare all week files
for week in 1 2 3 4; do
  for day in $(seq 1 7 2>&1 | head -n $((week == 4 ? 9 : 7))); do
    git show 574d4a5:book-src/src/week-$week/day-$(printf "%02d" $day).md > /tmp/old-day-$day.md
  done
done
```

#### Step 2: Compare with Current Content Sources
```bash
# Compare old day files with Content/ folder
diff /tmp/old-day-01.md Content/Day_01_Topic/README.md

# Check if content exists in main curriculum
grep -A 50 "Day 01" "30-Day Product Analytics Masterclass.md"
```

#### Step 3: Analyze SUMMARY.md Evolution
```bash
# Check old SUMMARY.md structure
git show 574d4a5:book-src/src/SUMMARY.md

# Compare with current
cat book-src/src/SUMMARY.md
```

### Files to Review

- [ ] Git history of all 30 deleted day files
- [ ] Current `book-src/src/SUMMARY.md`
- [ ] Previous `book-src/src/SUMMARY.md` (from git)
- [ ] `scripts/build_book.sh` week-copying logic (lines 14-18)
- [ ] `Content/Day_XX_Topic/README.md` files for comparison
- [ ] `book.toml` - mdBook configuration

### Decision Matrix

| Criteria | Flat (Current) | Restore Weeks | New from Content |
|----------|---------------|---------------|------------------|
| Ease of navigation | Low | High | High |
| Maintenance effort | Low | Medium | Medium |
| Content richness | Medium | ? | High |
| Alignment with pedagogy | Low | High | High |
| Build complexity | Low | Medium | Medium |

### Definition of Done

- [ ] Decision made on book structure (flat vs. week-based)
- [ ] If restoring: Week directories recreated with content
- [ ] If staying flat: Week references removed from build scripts
- [ ] SUMMARY.md updated to match chosen structure
- [ ] Build scripts tested and working
- [ ] Documentation updated to explain structure choice

### Related Issues
- Issue #1 (Build script consolidation)
- Issue #2 (Content folder evaluation)

---

## Issue #4: Populate or remove empty placeholder report files

**Labels:** `cleanup`, `content`, `reports`  
**Priority:** Medium  
**Effort:** Large (8-12 hours) - if creating content

### Problem Description

The `reports/` directory contains several markdown files that are either completely empty (0 bytes) or contain only minimal placeholder text. These files are referenced and copied by the build scripts, creating an incomplete user experience in the generated mdBook.

### Current State Analysis

#### Empty Files (0 bytes)
1. **reports/ab_test_analysis.md** - 0 bytes
   - Referenced in build scripts
   - Copied to book-src/src/
   - Expected content: A/B test analysis report (from Day 15-16)

2. **reports/qbr_presentation.md** - 0 bytes
   - Referenced in build scripts
   - Listed in SUMMARY.md
   - Expected content: Quarterly Business Review presentation (from Days 27-30)

3. **reports/did_analysis.md** - 0 bytes
   - NOT currently referenced in build scripts
   - Likely intended for Difference-in-Differences analysis (Day 16)

#### Placeholder Files (minimal content)
4. **reports/AB_Test_Final_Readout.md** - 92 bytes
   ```
   # AB Test Final Readout

   Placeholder for AB Test Final Readout report (Day 15).
   ```

5. **reports/DiD_Critical_Assessment.md** - 87 bytes
   ```
   # DiD Critical Assessment

   Placeholder for DiD Critical Assessment (Day 16).
   ```

6. **reports/Journals_Instrumentation_Plan.md** - 87 bytes
   ```
   # Journals Instrumentation Plan

   Placeholder for instrumentation plan (Day 3).
   ```

7. **reports/Week1_Launch_Summary.md** - 91 bytes
   ```
   # Week 1 Launch Summary

   Placeholder for Week 1 Launch Summary Memo (Day 12).
   ```

8. **reports/Pre_Mortem_Memo.md** - 88 bytes
   ```
   # Pre-Mortem Memo

   Placeholder for Pre-Mortem Memo (Day 7).
   ```

9. **reports/Journals_Launch_Monitoring_Dashboard.md** - 92 bytes
   ```
   # Journals Launch Monitoring Dashboard

   Placeholder for dashboard specification (Day 6).
   ```

#### Complete Files (with content)
10. **reports/dashboards/journals_launch_monitoring_dashboard.md** - Has actual content
    - This appears to be a duplicate/alternate location for item #9

### Expected Content Based on Curriculum

According to the 30-Day Product Analytics Masterclass curriculum:

| File | Curriculum Day | Expected Content |
|------|---------------|------------------|
| Journals_Instrumentation_Plan.md | Day 3 | Instrumentation spec with events, success metrics, guardrails |
| Pre_Mortem_Memo.md | Day 7 | Risk analysis memo with 3 plausible risks and detection plans |
| Journals_Launch_Monitoring_Dashboard.md | Day 6 | Dashboard spec with KPIs, visualizations, and SQL queries |
| Week1_Launch_Summary.md | Day 12 | Structured memo with TL;DR, wins, challenges, insights, recommendations |
| ab_test_analysis.md | Days 4, 13 | A/B test design and preliminary analysis |
| AB_Test_Final_Readout.md | Day 15 | Complete A/B test analysis with statistical results |
| DiD_Critical_Assessment.md | Day 16 | Difference-in-Differences analysis and comparison with A/B test |
| qbr_presentation.md | Days 27-30 | Quarterly Business Review presentation (5-slide deck) |

### Impact

1. **Incomplete Documentation**: Users following the course have no example reports
2. **Build Output**: Generated book contains empty or placeholder pages
3. **Learning Gap**: Students can't see what a "good" report looks like
4. **Confusion**: Unclear if these are work-in-progress or intentionally blank

### Recommended Solutions

#### Option 1: Create Template/Example Content (RECOMMENDED)
Create realistic example content for each report based on the curriculum requirements.

**Pros:**
- Provides learning value
- Demonstrates best practices
- Makes the book complete and professional

**Cons:**
- Significant time investment (8-12 hours)
- Requires domain expertise
- Needs to align with fictional "Journals" feature scenario

**Priority Order for Content Creation:**
1. **High Priority** (Core learning deliverables):
   - Journals_Instrumentation_Plan.md
   - AB_Test_Final_Readout.md
   - Week1_Launch_Summary.md
   
2. **Medium Priority** (Important examples):
   - Pre_Mortem_Memo.md
   - Journals_Launch_Monitoring_Dashboard.md
   - DiD_Critical_Assessment.md

3. **Lower Priority** (Can be combined with others):
   - ab_test_analysis.md (interim/preliminary version)
   - qbr_presentation.md (capstone - can reference other reports)

#### Option 2: Remove from Build Scripts
Remove empty/placeholder files from the build process until content is ready.

**Pros:**
- Clean user experience
- No broken promises
- Quick fix

**Cons:**
- Reduces completeness of course materials
- Loses structure/scaffolding for future content

**Action Items:**
- Update build scripts to skip empty files
- Update SUMMARY.md to not list missing reports
- Add TODO comments for future content

#### Option 3: Convert to "Student Exercise" Placeholders
Explicitly frame these as templates for students to fill in.

**Pros:**
- Turns weakness into pedagogical feature
- Students learn by doing
- Clear expectations

**Cons:**
- Still incomplete as reference material
- May frustrate self-learners

**Action Items:**
- Add clear headers: "Student Exercise: [Report Name]"
- Include rubric/requirements
- Provide structure/outline to fill in

#### Option 4: Link to External Examples
Instead of creating content, link to high-quality examples from other sources.

**Pros:**
- Leverages existing resources
- Low effort
- Shows real-world variety

**Cons:**
- Examples may not align with "Journals" scenario
- External links can break
- Less cohesive learning experience

### Content Creation Guidelines (if Option 1 chosen)

Each report should:
1. **Be realistic**: Use plausible numbers and insights for the "Journals" feature
2. **Demonstrate best practices**: Show proper formatting, structure, communication
3. **Align with curriculum**: Match the requirements from the corresponding Day
4. **Be internally consistent**: Numbers should make sense across all reports
5. **Include visuals**: Charts, tables, code blocks where appropriate
6. **Show progression**: Early reports show uncertainty, later ones show learnings

### Sample Data for Consistency

To maintain consistency across reports, use these fictional parameters:
- **Test Duration**: 28 days
- **Sample Size**: 100,000 users (50k control, 50k treatment)
- **Baseline Retention (Day 28)**: 20%
- **Treatment Lift**: +2.5% (50 basis points absolute)
- **Statistical Significance**: p-value = 0.012 (significant)
- **Feature Adoption**: 15% of treatment group
- **Guardrail Metrics**: All neutral or positive

### Files to Update

- [ ] reports/ab_test_analysis.md
- [ ] reports/qbr_presentation.md
- [ ] reports/did_analysis.md
- [ ] reports/AB_Test_Final_Readout.md
- [ ] reports/DiD_Critical_Assessment.md
- [ ] reports/Journals_Instrumentation_Plan.md
- [ ] reports/Week1_Launch_Summary.md
- [ ] reports/Pre_Mortem_Memo.md
- [ ] reports/Journals_Launch_Monitoring_Dashboard.md
- [ ] scripts/bash/build_book.sh (if removing files)
- [ ] book-src/src/SUMMARY.md (if removing files)

### Definition of Done

**If Creating Content:**
- [ ] All report files have realistic, complete content
- [ ] Content aligns with curriculum day requirements
- [ ] Numbers are internally consistent across reports
- [ ] Reports demonstrate professional communication
- [ ] Build scripts successfully include all reports
- [ ] Generated mdBook is complete and professional

**If Removing:**
- [ ] Empty files removed from build scripts
- [ ] SUMMARY.md updated to not reference missing reports
- [ ] Documentation explains what's intentionally excluded
- [ ] Future content creation tracked in separate issues

### Related Issues
- Issue #1 (Build script consolidation)
- Issue #6 (SUMMARY.md generation)

---

## Issue #5: Review and update documentation files for consistency

**Labels:** `documentation`, `cleanup`, `consistency`  
**Priority:** Medium  
**Effort:** Medium (3-4 hours)

### Problem Description

Several documentation files in the repository may contain outdated references, broken links, or inconsistent information following recent structural changes (deletion of week directories, consolidation of build scripts, etc.). These files need to be reviewed and updated to reflect the current state of the repository.

### Files to Review

#### 1. README.md (Root)
**Current Issues to Check:**
- [ ] Does it reference the correct build script location?
- [ ] Are setup instructions current and accurate?
- [ ] Do links to course content work?
- [ ] Is the project structure description accurate?
- [ ] Are contribution guidelines referenced correctly?

**Specific Items:**
- Build script references (should point to working script)
- Directory structure documentation
- Prerequisites and setup
- Links to external resources
- Table of contents accuracy

#### 2. CONTRIBUTING.md
**Current Issues to Check:**
- [ ] Build/test instructions accurate?
- [ ] Are script paths correct?
- [ ] Is the development workflow documented?
- [ ] Are coding standards defined?
- [ ] Pull request guidelines current?

**Specific Items:**
- How to run build scripts
- How to test changes
- Code formatting standards
- Documentation standards
- Review process

#### 3. CODE_OF_CONDUCT.md
**Current Issues to Check:**
- [ ] Is this a standard template or custom?
- [ ] Are contact methods current?
- [ ] Does it need updates?

**Likely Status:** Probably fine, these are usually static

#### 4. book.toml (mdBook Configuration)
**Current Issues to Check:**
- [ ] Book title and author correct?
- [ ] Build configuration appropriate?
- [ ] Output directory settings?
- [ ] Theme and styling settings?
- [ ] Preprocessor configurations?

**Specific Items:**
```toml
[book]
title = "..."  # Verify accuracy
authors = ["..."]  # Verify accuracy
language = "en"
multilingual = false
src = "book-src/src"  # Verify path is correct
```

#### 5. docker-compose.yml & Dockerfile
**Current Issues to Check:**
- [ ] Are these used for development environment?
- [ ] Do they reference correct paths?
- [ ] Are dependencies current?
- [ ] Volume mounts accurate?
- [ ] Port mappings documented?

**Specific Items:**
- Working directory paths
- Volume mount points
- Environment variables
- Exposed ports
- Dependencies list

#### 6. environment.yml (Conda Environment)
**Current Issues to Check:**
- [ ] Python version appropriate?
- [ ] All required packages listed?
- [ ] Versions specified where needed?
- [ ] Compatible with curriculum requirements?

**Specific Items:**
```yaml
dependencies:
  - python=3.x
  - duckdb
  - pandas
  - jupyter
  - matplotlib
  # etc.
```

#### 7. .gitignore
**Current Issues to Check:**
- [ ] Build artifacts ignored?
- [ ] mdBook output ignored?
- [ ] Python cache ignored?
- [ ] Jupyter checkpoints ignored?
- [ ] IDE files ignored?

**Specific Items:**
```
book-src/book/  # mdBook output
__pycache__/
*.pyc
.ipynb_checkpoints/
.DS_Store
```

#### 8. .github/workflows/* (if exists)
**Current Issues to Check:**
- [ ] CI/CD pipelines exist?
- [ ] Build script references correct?
- [ ] Test commands accurate?
- [ ] Deploy processes working?

### Common Issues to Look For

1. **Broken Internal Links**
   - Links to deleted week directories
   - Links to moved files
   - Anchors to removed sections

2. **Outdated Script References**
   - References to old build_book.sh locations
   - Deprecated command examples
   - Wrong script paths in examples

3. **Structural Assumptions**
   - Descriptions of deleted week-based structure
   - References to Content folder without explaining purpose
   - Assumptions about file organization that changed

4. **Installation Instructions**
   - Missing dependencies
   - Outdated version requirements
   - Incorrect setup steps

5. **Build Instructions**
   - Wrong script paths
   - Missing environment setup
   - Incorrect command syntax

### Recommended Approach

#### Phase 1: Audit (1 hour)
1. Read each documentation file completely
2. Make notes of specific issues found
3. Check all internal and external links
4. Verify all code examples and commands
5. Test setup instructions in clean environment

#### Phase 2: Update (2 hours)
1. Fix broken links and references
2. Update script paths and examples
3. Correct structural descriptions
4. Update installation instructions if needed
5. Refresh any outdated information

#### Phase 3: Validate (1 hour)
1. Follow README setup instructions from scratch
2. Run all documented commands
3. Click all documentation links
4. Verify consistency across files
5. Test build process end-to-end

### Specific Updates Needed

Based on recent changes:

#### Update Build Script References
**Old:** `./scripts/build_book.sh`
**New:** `./scripts/bash/build_book.sh` (or consolidated location per Issue #1)

**Files to check:**
- README.md
- CONTRIBUTING.md
- .github/workflows/* (if exists)

#### Update Structure Documentation
**Old:** References to week-1/, week-2/, etc. in book-src/src/
**New:** Flat structure with introduction.md + reports

**Files to check:**
- README.md (project structure section)
- CONTRIBUTING.md (file organization section)

#### Document Content Folder
**Missing:** Explanation of Content/Day_XX_Topic/ purpose
**Needed:** Clear statement of what this folder is for

**Files to check:**
- README.md (should explain folder purpose)
- CONTRIBUTING.md (should explain when to edit these files)

### Documentation Quality Checklist

For each documentation file:
- [ ] No broken internal links
- [ ] No broken external links
- [ ] All code examples are valid
- [ ] All paths reference existing files
- [ ] Consistent terminology throughout
- [ ] Clear and concise language
- [ ] Proper markdown formatting
- [ ] Table of contents (if long)
- [ ] Last updated date/version

### Definition of Done

- [ ] All documentation files reviewed
- [ ] All broken links fixed
- [ ] All script references corrected
- [ ] All structural descriptions accurate
- [ ] Setup instructions tested in clean environment
- [ ] Build process documented accurately
- [ ] Consistency verified across all docs
- [ ] No references to deleted/moved content

### Related Issues
- Issue #1 (Build script paths may change)
- Issue #2 (Content folder needs documentation)
- Issue #3 (Structure changed with week deletion)

---

## Issue #6: Improve SUMMARY.md generation and book navigation

**Labels:** `enhancement`, `user-experience`, `mdbook`  
**Priority:** High  
**Effort:** Small-Medium (2-3 hours)

### Problem Description

The current `book-src/src/SUMMARY.md` file is minimal and doesn't provide comprehensive navigation for the course content. It only lists the introduction and two reports, missing the opportunity to create a rich, navigable learning experience.

### Current State

#### Current SUMMARY.md (164 bytes)
```markdown
# Summary

[Introduction](./introduction.md)

---

# Key Analyses

- [A/B Test Analysis](./ab_test_analysis.md)
- [QBR Presentation Outline](./qbr_presentation.md)
```

**Issues:**
- Only 3 items listed (intro + 2 reports)
- Missing 6 other report files that are copied to book-src/src/
- No day-by-day or week-by-week structure
- No clear learning progression
- Doesn't reflect the 30-day curriculum organization

#### Files Available in book-src/src/ (after build)
- introduction.md (49KB - entire curriculum)
- ab_test_analysis.md (empty)
- qbr_presentation.md (empty)
- AB_Test_Final_Readout.md (placeholder)
- DiD_Critical_Assessment.md (placeholder)
- Journals_Instrumentation_Plan.md (placeholder)
- Week1_Launch_Summary.md (placeholder)
- Pre_Mortem_Memo.md (placeholder)
- Journals_Launch_Monitoring_Dashboard.md (placeholder)

#### Current Generation Logic (in scripts/bash/build_book.sh)
```bash
cat > "${BOOK_SRC_DIR}/SUMMARY.md" << EOT
# Summary

[Introduction](./introduction.md)

---

# Key Analyses

- [A/B Test Analysis](./ab_test_analysis.md)
- [QBR Presentation Outline](./qbr_presentation.md)
EOT
```

**Issues with Generation:**
- Hardcoded content only
- No dynamic discovery of files
- Doesn't include all reports
- No hierarchical structure

### Impact

1. **Poor Navigation**: Users can't easily navigate to specific days or topics
2. **Incomplete**: Missing content that exists in book-src/src/
3. **Not Pedagogical**: Doesn't reflect the week-by-week learning structure
4. **Confusing**: Introduction.md contains all 30 days but no way to jump to specific days

### Curriculum Structure (from main file)

The 30-day curriculum is organized as:
- **Week 1 (Days 1-7)**: Foundations & Framing
- **Week 2 (Days 8-14)**: The Crucible - Monitoring & Triage
- **Week 3 (Days 15-21)**: The Deep Dive - Causal Impact
- **Week 4 (Days 22-30)**: The Strategy - From Analyst to Influencer

Each day has:
- Title
- Objective
- Why This Matters
- Tasks
- Deliverable

### Recommended Solutions

#### Option 1: Enhanced Flat Structure (Quick Win)
Keep single introduction.md but add all reports and better organization.

```markdown
# Summary

[Introduction: The 30-Day Product Analytics Masterclass](./introduction.md)

---

# Week 1 Deliverables: Foundations & Framing

- [Day 3: Instrumentation Plan](./Journals_Instrumentation_Plan.md)
- [Day 6: Dashboard Specification](./Journals_Launch_Monitoring_Dashboard.md)
- [Day 7: Pre-Mortem Memo](./Pre_Mortem_Memo.md)

# Week 2 Deliverables: Launch & Monitoring

- [Day 12: Week 1 Launch Summary](./Week1_Launch_Summary.md)

# Week 3 Deliverables: Causal Impact Analysis

- [Day 13: A/B Test Preliminary Analysis](./ab_test_analysis.md)
- [Day 15: A/B Test Final Readout](./AB_Test_Final_Readout.md)
- [Day 16: Difference-in-Differences Assessment](./DiD_Critical_Assessment.md)

# Week 4 Deliverables: Strategic Review

- [Day 27-30: Quarterly Business Review](./qbr_presentation.md)

---

# Reference Materials

- [Course Overview](./introduction.md#course-overview)
- [Glossary](./introduction.md#glossary) *(if exists)*
```

**Pros:**
- Quick to implement
- Includes all reports
- Organizes by week
- Better than current

**Cons:**
- Still single-file for curriculum
- Can't navigate to specific days easily

#### Option 2: Week-Based Chapters (Requires Content Split)
Split introduction.md into week files or link to Content/Day_XX files.

```markdown
# Summary

[Course Overview](./introduction.md)

---

# Week 1: Foundations & Framing

- [Day 1: Data Warehouse & Opportunity Discovery](./week-1/day-01.md)
- [Day 2: Opportunity Sizing & Business Case](./week-1/day-02.md)
- [Day 3: Instrumentation Plan](./week-1/day-03.md)
- [Day 4: A/B Test Design](./week-1/day-04.md)
- [Day 5: Difference-in-Differences Design](./week-1/day-05.md)
- [Day 6: BI Dashboard Specification](./week-1/day-06.md)
- [Day 7: Pre-Mortem Memo](./week-1/day-07.md)

# Week 2: Launch & Monitoring

- [Day 8: Launch Day Command Center](./week-2/day-08.md)
...

# Deliverables & Reports

- [Instrumentation Plan](./Journals_Instrumentation_Plan.md)
- [Pre-Mortem Memo](./Pre_Mortem_Memo.md)
- [A/B Test Final Readout](./AB_Test_Final_Readout.md)
...
```

**Pros:**
- Clear day-by-day navigation
- Aligns with pedagogical structure
- Easy to jump to specific content

**Cons:**
- Requires splitting or copying Content/ files
- More complex build process
- Depends on Issue #2 and #3 resolution

#### Option 3: Hybrid with Anchor Links
Use anchor links to navigate within introduction.md.

```markdown
# Summary

[Course Overview](./introduction.md)

---

# Week 1: Foundations & Framing

- [Day 1: Data Warehouse & Opportunity Discovery](./introduction.md#day-01-the-data-warehouse--opportunity-discovery)
- [Day 2: Opportunity Sizing](./introduction.md#day-02-opportunity-sizing--the-business-case)
...
```

**Pros:**
- Works with current single-file structure
- Easy to implement
- Good navigation experience

**Cons:**
- Requires consistent anchor IDs in introduction.md
- Long page load for introduction.md
- May not work well with search

#### Option 4: Dynamic Generation from Content/
Generate SUMMARY.md automatically from Content/Day_XX_Topic folders.

```bash
#!/bin/bash
# Generate SUMMARY.md dynamically

echo "# Summary" > SUMMARY.md
echo "" >> SUMMARY.md
echo "[Course Overview](./introduction.md)" >> SUMMARY.md
echo "" >> SUMMARY.md

for week in 1 2 3 4; do
  echo "# Week $week" >> SUMMARY.md
  # Logic to extract week title from curriculum
  
  for day in ...; do
    # Extract day title from Content/Day_XX/README.md
    # Add line to SUMMARY.md
  done
done
```

**Pros:**
- Automated and maintainable
- Always in sync with Content/
- Reduces manual work

**Cons:**
- Complex script logic
- Requires Content/ to be authoritative source
- Depends on Issue #2 resolution

### Recommended Approach

**Phase 1 (Immediate - Option 1):**
1. Update SUMMARY.md generation to include ALL report files
2. Organize by week-based sections
3. Add better section headers
4. Quick win for users

**Phase 2 (After Issue #2 & #3 resolution):**
1. Decide on content structure (flat vs. week-based)
2. Implement Option 2 or 3 based on that decision
3. Consider dynamic generation (Option 4) for maintainability

### Script Changes Needed

Update `scripts/bash/build_book.sh`:

```bash
# Before SUMMARY.md generation, extract week titles from curriculum
WEEK1_TITLE="Foundations & Framing"
WEEK2_TITLE="The Crucible - Monitoring & Triage"
WEEK3_TITLE="The Deep Dive - Causal Impact"
WEEK4_TITLE="The Strategy - From Analyst to Influencer"

# Generate enhanced SUMMARY.md
cat > "${BOOK_SRC_DIR}/SUMMARY.md" << 'EOT'
# Summary

[Introduction: The 30-Day Product Analytics Masterclass](./introduction.md)

---

# Week 1 Deliverables: Foundations & Framing

- [Day 3: Instrumentation Plan](./Journals_Instrumentation_Plan.md)
- [Day 6: Dashboard Specification](./Journals_Launch_Monitoring_Dashboard.md)
- [Day 7: Pre-Mortem Memo](./Pre_Mortem_Memo.md)

# Week 2 Deliverables: Launch & Monitoring

- [Day 12: Week 1 Launch Summary](./Week1_Launch_Summary.md)

# Week 3 Deliverables: Causal Impact Analysis

- [Day 13: A/B Test Preliminary Analysis](./ab_test_analysis.md)
- [Day 15: A/B Test Final Readout](./AB_Test_Final_Readout.md)
- [Day 16: Difference-in-Differences Assessment](./DiD_Critical_Assessment.md)

# Week 4 Deliverables: Strategic Review

- [Day 27-30: Quarterly Business Review](./qbr_presentation.md)
EOT
```

### Testing Checklist

- [ ] All listed files exist in book-src/src/
- [ ] All links work when mdBook is built
- [ ] Section headers render correctly
- [ ] Navigation is logical and clear
- [ ] No broken links
- [ ] Mobile navigation works (mdBook responsive)

### mdBook Features to Leverage

- **Search**: Works better with smaller files (favors Option 2)
- **Printing**: Single file easier (favors current structure)
- **Progress Tracking**: Week-based better (favors Option 2)
- **Loading Speed**: Smaller files better (favors Option 2)

### Definition of Done

**Phase 1 (Immediate):**
- [ ] SUMMARY.md includes all report files
- [ ] Content organized by week sections
- [ ] Clear, descriptive link text
- [ ] All links functional after build
- [ ] Script updated and tested

**Phase 2 (Future):**
- [ ] Navigation structure aligns with final content organization
- [ ] Consider dynamic generation if maintainability becomes issue
- [ ] User testing of navigation experience

### Related Issues
- Issue #2 (Content folder - source of truth decision)
- Issue #3 (Week directory structure decision)
- Issue #4 (Empty report files - affects what to list)

---

## Issue #7: Comprehensive codebase audit and cleanup roadmap

**Labels:** `epic`, `cleanup`, `planning`  
**Priority:** High  
**Effort:** Medium (4-6 hours for audit, varies for cleanup)

### Problem Description

This is a meta-issue to track the comprehensive cleanup of the Product Analytics MasterClass repository. It consolidates findings from Issues #1-6 and identifies any additional files, directories, or configurations that may be unnecessary or need attention.

### Scope of Audit

#### 1. File System Analysis
- [ ] Identify duplicate files across different directories
- [ ] Find orphaned files (not referenced by any build process or documentation)
- [ ] Locate deprecated or outdated scripts
- [ ] Identify large files that could be optimized or removed
- [ ] Find configuration files that may be unused

#### 2. Code Analysis
- [ ] Identify unused Python scripts in `/scripts/python/`
- [ ] Check for unused SQL scripts in `/scripts/sql/`
- [ ] Review shell scripts for redundancy
- [ ] Check notebooks for obsolete or duplicate content

#### 3. Dependency Analysis
- [ ] Review `environment.yml` for unused packages
- [ ] Check `requirements.txt` (if exists) for consistency
- [ ] Verify Docker dependencies are necessary
- [ ] Check for version conflicts

#### 4. Build System Analysis
- [ ] Verify all build outputs are in `.gitignore`
- [ ] Check for unused build configurations
- [ ] Identify intermediate build artifacts
- [ ] Review CI/CD efficiency

### Directories to Audit

#### /Content/ (368 KB)
**Questions:**
- Is this actively used or a legacy structure?
- Does it duplicate information in other locations?
- Should it be the source of truth or consolidated?
- Related: **Issue #2**

#### /book-src/ (92 KB)
**Questions:**
- Is the current flat structure optimal?
- Should week directories be restored?
- What belongs in book-src vs. Content?
- Related: **Issue #3**

#### /reports/ (32 KB)
**Questions:**
- Which reports are complete vs. placeholders?
- Should empty reports be removed or filled?
- Is the subdirectory `dashboards/` structure needed?
- Related: **Issue #4**

#### /notebooks/ (124 KB)
**Questions:**
- Are all notebooks referenced in the curriculum?
- Are there duplicate or obsolete notebooks?
- Is the organization optimal for learners?
- Do notebooks follow naming conventions?

#### /scripts/ (36 KB)
**Questions:**
- Why both `/scripts/` and `/scripts/bash/`?
- Which scripts are actively used?
- Are there redundant scripts?
- Related: **Issue #1**

#### /src/ (if exists)
**Questions:**
- What is this directory for?
- Does it overlap with other directories?
- Is it needed or legacy?

#### /solutions/ (if exists)
**Questions:**
- Are these example solutions for exercises?
- Should they be in a separate branch?
- Are they documented?

### Files to Review

#### Configuration Files
- [ ] `.gitignore` - Complete and accurate?
- [ ] `.dockerignore` - Optimized for build?
- [ ] `book.toml` - Settings appropriate?
- [ ] `docker-compose.yml` - All services needed?
- [ ] `Dockerfile` - Optimized and current?
- [ ] `environment.yml` - Dependencies minimal and current?

#### Documentation Files
- [ ] `README.md` - Comprehensive and current?
- [ ] `CONTRIBUTING.md` - Clear and accurate?
- [ ] `CODE_OF_CONDUCT.md` - Standard and appropriate?
- [ ] `LICENSE` - Correct and clear?
- Related: **Issue #5**

#### Script Files
- [ ] `generate_skeleton.sh` - What does this do? Still needed?
- [ ] All files in `/scripts/bash/`, `/scripts/python/`, `/scripts/sql/`

### Audit Methodology

#### Step 1: Inventory (1-2 hours)
```bash
# Generate comprehensive file listing
find . -type f -not -path './.git/*' > /tmp/all_files.txt

# Categorize by type
find . -name "*.md" | sort > /tmp/markdown_files.txt
find . -name "*.sh" | sort > /tmp/shell_scripts.txt
find . -name "*.py" | sort > /tmp/python_files.txt
find . -name "*.ipynb" | sort > /tmp/notebooks.txt
find . -name "*.sql" | sort > /tmp/sql_files.txt
find . -name "*.yml" -or -name "*.yaml" | sort > /tmp/config_files.txt

# Size analysis
du -sh */ | sort -hr > /tmp/directory_sizes.txt
find . -type f -size +100k -not -path './.git/*' > /tmp/large_files.txt
```

#### Step 2: Reference Analysis (2 hours)
For each file, check if it's referenced by:
- [ ] Build scripts
- [ ] Documentation
- [ ] Other code files
- [ ] Git history (recent commits)
- [ ] Configuration files

Create categories:
1. **Active**: Recently used and referenced
2. **Orphaned**: Exists but not referenced anywhere
3. **Deprecated**: Old version of something newer
4. **Unclear**: Purpose uncertain, needs investigation

#### Step 3: Dependency Graph (1 hour)
Create a visual or textual map of file dependencies:
```
README.md
  ├─> scripts/bash/build_book.sh
  ├─> CONTRIBUTING.md
  └─> book.toml

build_book.sh
  ├─> 30-Day Product Analytics Masterclass.md
  ├─> reports/*.md
  └─> book-src/src/SUMMARY.md
```

#### Step 4: Cleanup Recommendations (1-2 hours)
For each file/directory, recommend:
- **Keep**: Essential, actively used
- **Update**: Keep but needs changes
- **Archive**: Move to separate branch or tag
- **Delete**: No longer needed
- **Investigate**: Unclear, need more info

### Common Issues to Look For

1. **Naming Inconsistencies**
   - Mixed case conventions (CamelCase vs. snake_case)
   - Inconsistent prefixes/suffixes
   - Ambiguous names

2. **Organizational Issues**
   - Files in wrong directories
   - Flat structure where hierarchy would help
   - Too deep nesting where flat would work

3. **Duplication**
   - Same content in multiple files
   - Redundant scripts
   - Duplicate configurations

4. **Obsolete Content**
   - References to deleted features
   - Old version artifacts
   - Deprecated approaches

5. **Missing Documentation**
   - Scripts without comments
   - Directories without README
   - Unclear file purposes

### Cleanup Priorities

#### P0 - Critical (Do First)
- Remove duplicate build scripts (Issue #1)
- Fix broken references in documentation (Issue #5)
- Decide on Content/ folder purpose (Issue #2)

#### P1 - High (Do Soon)
- Improve SUMMARY.md (Issue #6)
- Address empty report files (Issue #4)
- Resolve week directory question (Issue #3)

#### P2 - Medium (Do When Possible)
- Optimize notebook organization
- Standardize naming conventions
- Clean up unused dependencies

#### P3 - Low (Nice to Have)
- Improve directory structure
- Add more comprehensive .gitignore
- Create developer documentation

### Deliverables

1. **Audit Report** (Markdown document)
   - Complete inventory of files
   - Reference analysis for each file
   - Dependency graph
   - Size analysis
   - Recommendations with justifications

2. **Cleanup Roadmap** (GitHub Project or Markdown)
   - Prioritized list of cleanup tasks
   - Estimated effort for each
   - Dependencies between tasks
   - Risk assessment

3. **Decision Log** (Markdown document)
   - Key decisions made during audit
   - Rationale for each decision
   - Trade-offs considered
   - Stakeholders consulted

4. **Updated Issues**
   - Create specific issues for each cleanup task
   - Link related issues
   - Assign priorities and labels

### Example Audit Report Structure

```markdown
# Codebase Audit Report

## Executive Summary
- Total files: XXX
- Directories audited: XX
- Issues identified: XX
- Recommendations: XX

## Directory Analysis

### /Content/ (368 KB)
**Status:** Under review
**References:** None found in build scripts
**Recommendation:** Decision needed (Issue #2)
**Rationale:** ...

### /scripts/ (36 KB)
**Status:** Has duplicates
**References:** README.md, build process
**Recommendation:** Consolidate (Issue #1)
**Rationale:** ...

## File Categories

### Active Files (Keep)
1. 30-Day Product Analytics Masterclass.md - Main curriculum
2. scripts/bash/build_book.sh - Primary build script
...

### Orphaned Files (Investigate)
1. scripts/old_backup.sh - No references, old date
2. data/test_data.csv - Not in .gitignore, unclear purpose
...

### Deprecated Files (Remove)
1. scripts/build_book.sh - Superseded by bash version
...

## Recommendations Summary

### Immediate Actions
- [ ] Delete: scripts/build_book.sh
- [ ] Update: README.md
- [ ] Decide: Content/ folder purpose

### Short-term Actions
- [ ] Consolidate: Report files
- [ ] Enhance: SUMMARY.md
...

## Dependencies Graph
[Visual or text representation]

## Risk Assessment
- Low risk: Documentation updates
- Medium risk: Script consolidation
- High risk: Directory restructuring
```

### Definition of Done

- [ ] Complete inventory of all files and directories
- [ ] Reference analysis completed for all files
- [ ] Recommendations provided for each item
- [ ] Cleanup roadmap created and prioritized
- [ ] Decision log documenting key choices
- [ ] Related issues updated with specific tasks
- [ ] Audit report reviewed and approved

### Related Issues
- Issue #1: Consolidate duplicate build scripts
- Issue #2: Evaluate Content folder
- Issue #3: Review week directory structure
- Issue #4: Populate or remove empty reports
- Issue #5: Update documentation
- Issue #6: Improve SUMMARY.md generation

---

## Summary: Issues Creation Roadmap

All issues above should be created on GitHub one at a time in the following order:

1. **Issue #1**: Consolidate duplicate build scripts (Quick win, unblocks others)
2. **Issue #2**: Evaluate Content folder usage (Strategic decision needed)
3. **Issue #3**: Week directory structure (Depends on #2)
4. **Issue #4**: Empty report files (Can be done in parallel)
5. **Issue #5**: Documentation updates (Do after #1-3 are decided)
6. **Issue #6**: SUMMARY.md generation (Depends on #2 and #3)
7. **Issue #7**: Comprehensive audit (Meta-issue to track overall progress)

Each issue should be created with:
- Appropriate labels
- Clear title
- Complete description from this document
- Related issues linked
- Priority and effort estimates

