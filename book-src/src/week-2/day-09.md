# Day 09: The Fire Drill – Precision Bug Triage

## Overview

**Objective:** To move from a vague bug report to a precise, actionable diagnosis that empowers the engineering team to resolve the issue quickly.

**Why This Matters:** A great analyst is an engineer's best friend during a crisis. By isolating the "blast radius" of a bug, you save countless hours of guesswork and turn a panic-inducing problem into a solvable one.

## The Art of Precision Triage

When a bug report arrives, chaos wants to take over. Your role is to bring:

- **Precision:** Isolate exactly which users are affected
- **Quantification:** Measure the severity with data
- **Context:** Provide actionable dimensions for debugging
- **Clarity:** Communicate findings in a way engineers can immediately act on

**Bad Triage:** "Android users are crashing"
**Good Triage:** "Users on App v3.4.1 + Android OS 12 + Samsung Galaxy S21 are experiencing a 15% crash rate per session vs. 0.1% baseline"

The difference? The good triage gives engineers a specific starting point and justifies the urgency.

## The Scenario

**The Report:** A Jira ticket is filed at 10:15 AM:
```
Title: Android users reporting crashes after update
Description: Support team has received 15 complaints this morning about 
app crashes on Android devices. Users report the app freezes and force 
closes when they try to use the new Journals feature.

Priority: High
Reporter: CustomerSupport_TeamLead
```

Your job: Turn this vague report into a precise, data-driven diagnosis.

## Task 1: Quantify and Isolate the Issue

### The Investigation Framework

**Step 1: Confirm the Signal**

First, validate that there IS a statistically meaningful spike.

```sql
-- Crash Rate Comparison: Today vs. Last 7 Days
WITH daily_crashes AS (
    SELECT 
        DATE(event_timestamp) AS event_date,
        COUNT(*) FILTER (WHERE event_name = 'app_crash') AS crash_count,
        COUNT(DISTINCT user_id) FILTER (WHERE event_name = 'app_crash') AS users_with_crash,
        COUNT(DISTINCT session_id) AS total_sessions,
        ROUND(
            100.0 * COUNT(*) FILTER (WHERE event_name = 'app_crash') / 
            NULLIF(COUNT(DISTINCT session_id), 0), 
            3
        ) AS crash_rate_per_session_pct
    FROM events
    WHERE event_timestamp >= CURRENT_DATE - INTERVAL '7 days'
    GROUP BY event_date
)
SELECT 
    event_date,
    crash_count,
    users_with_crash,
    total_sessions,
    crash_rate_per_session_pct,
    CASE 
        WHEN event_date = CURRENT_DATE THEN 'TODAY'
        ELSE 'BASELINE'
    END AS period_label
FROM daily_crashes
ORDER BY event_date DESC;
```

**Step 2: Isolate by Platform**

Narrow down which platform is actually affected.

```sql
-- Platform-Specific Crash Analysis
WITH platform_crashes AS (
    SELECT 
        u.platform,
        COUNT(*) FILTER (WHERE e.event_name = 'app_crash') AS crash_events,
        COUNT(DISTINCT e.session_id) AS total_sessions,
        ROUND(
            100.0 * COUNT(*) FILTER (WHERE e.event_name = 'app_crash') / 
            NULLIF(COUNT(DISTINCT e.session_id), 0), 
            3
        ) AS crash_rate_pct
    FROM events e
    JOIN users u ON e.user_id = u.user_id
    WHERE e.event_timestamp >= CURRENT_DATE
    GROUP BY u.platform
)
SELECT 
    platform,
    crash_events,
    total_sessions,
    crash_rate_pct,
    CASE 
        WHEN crash_rate_pct > 1.0 THEN 'CRITICAL'
        WHEN crash_rate_pct > 0.5 THEN 'HIGH'
        WHEN crash_rate_pct > 0.2 THEN 'MODERATE'
        ELSE 'NORMAL'
    END AS severity_level
FROM platform_crashes
ORDER BY crash_rate_pct DESC;
```

### Step 3: Pinpoint the Combination

This is the critical query that isolates the exact "blast radius."

```sql
-- Precision Isolation: Find the Highest-Risk Segment
WITH crash_segments AS (
    SELECT 
        u.platform,
        u.app_version,
        u.os_version,
        u.device_model,
        COUNT(DISTINCT e.user_id) AS affected_users,
        COUNT(DISTINCT e.session_id) AS total_sessions,
        COUNT(*) FILTER (WHERE e.event_name = 'app_crash') AS crash_events,
        ROUND(
            100.0 * COUNT(*) FILTER (WHERE e.event_name = 'app_crash') / 
            NULLIF(COUNT(DISTINCT e.session_id), 0), 
            2
        ) AS crash_rate_per_session_pct
    FROM events e
    JOIN users u ON e.user_id = u.user_id
    WHERE e.event_timestamp >= CURRENT_DATE
      AND u.platform = 'Android'  -- Filter to Android based on Step 2
    GROUP BY u.platform, u.app_version, u.os_version, u.device_model
    HAVING COUNT(DISTINCT e.session_id) >= 10  -- Minimum sample size filter
),
ranked_segments AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (ORDER BY crash_rate_per_session_pct DESC) AS severity_rank
    FROM crash_segments
    WHERE crash_rate_per_session_pct > 0.5  -- Only include elevated crash rates
)
SELECT 
    platform,
    app_version,
    os_version,
    device_model,
    affected_users,
    total_sessions,
    crash_events,
    crash_rate_per_session_pct,
    severity_rank
FROM ranked_segments
ORDER BY crash_rate_per_session_pct DESC
LIMIT 10;
```

## Task 2: Calculate Severity

Don't just count crashes—contextualize them.

### Severity Calculation Query

```sql
-- Comparative Severity Analysis
WITH problematic_segment AS (
    -- The specific segment identified above
    SELECT 
        e.user_id,
        e.session_id,
        e.event_name
    FROM events e
    JOIN users u ON e.user_id = u.user_id
    WHERE e.event_timestamp >= CURRENT_DATE
      AND u.app_version = '3.4.1'
      AND u.os_version = 'Android 12'
      AND u.device_model LIKE '%Samsung Galaxy S21%'
),
baseline_segment AS (
    -- All other Android users
    SELECT 
        e.user_id,
        e.session_id,
        e.event_name
    FROM events e
    JOIN users u ON e.user_id = u.user_id
    WHERE e.event_timestamp >= CURRENT_DATE
      AND u.platform = 'Android'
      AND NOT (
          u.app_version = '3.4.1' 
          AND u.os_version = 'Android 12' 
          AND u.device_model LIKE '%Samsung Galaxy S21%'
      )
),
severity_comparison AS (
    SELECT 
        'Affected Segment' AS segment_type,
        COUNT(DISTINCT session_id) AS total_sessions,
        COUNT(*) FILTER (WHERE event_name = 'app_crash') AS crash_events,
        ROUND(
            100.0 * COUNT(*) FILTER (WHERE event_name = 'app_crash') / 
            NULLIF(COUNT(DISTINCT session_id), 0), 
            2
        ) AS crash_rate_pct
    FROM problematic_segment
    
    UNION ALL
    
    SELECT 
        'Baseline (Other Android)' AS segment_type,
        COUNT(DISTINCT session_id) AS total_sessions,
        COUNT(*) FILTER (WHERE event_name = 'app_crash') AS crash_events,
        ROUND(
            100.0 * COUNT(*) FILTER (WHERE event_name = 'app_crash') / 
            NULLIF(COUNT(DISTINCT session_id), 0), 
            2
        ) AS crash_rate_pct
    FROM baseline_segment
)
SELECT 
    segment_type,
    total_sessions,
    crash_events,
    crash_rate_pct,
    CASE 
        WHEN segment_type = 'Affected Segment' THEN 
            crash_rate_pct - (
                SELECT crash_rate_pct 
                FROM severity_comparison 
                WHERE segment_type = 'Baseline (Other Android)'
            )
        ELSE NULL
    END AS excess_crash_rate
FROM severity_comparison;
```

### Impact Quantification

Calculate the business impact:

```sql
-- Estimated Impact Scope
WITH affected_population AS (
    SELECT 
        COUNT(DISTINCT u.user_id) AS total_affected_users,
        COUNT(DISTINCT u.user_id) * 1.0 / (
            SELECT COUNT(DISTINCT user_id) 
            FROM users 
            WHERE platform = 'Android'
        ) * 100 AS pct_of_android_base
    FROM users u
    WHERE u.app_version = '3.4.1'
      AND u.os_version = 'Android 12'
      AND u.device_model LIKE '%Samsung Galaxy S21%'
)
SELECT 
    total_affected_users,
    ROUND(pct_of_android_base, 2) AS pct_of_android_users,
    -- Estimate daily impacted sessions
    ROUND(total_affected_users * 3.5, 0) AS est_daily_impacted_sessions,
    -- Estimate potential uninstalls (assuming 20% of crash users uninstall)
    ROUND(total_affected_users * 0.20, 0) AS est_potential_uninstalls
FROM affected_population;
```

## Task 3: Write the Triage Report

In notebook `09_bug_triage.ipynb`, draft a formal triage report in a markdown cell.

### The Professional Triage Report Template

```markdown
# 🚨 Bug Triage Report: Android Crash Spike

**Report ID:** BTR-2024-001  
**Date:** [Current Date]  
**Time:** [Current Time]  
**Analyst:** [Your Name]  
**Severity:** HIGH  
**Status:** ISOLATED & QUANTIFIED

---

## Executive Summary

The reported Android crash spike has been **confirmed and isolated** to a specific 
user segment. Immediate engineering intervention is recommended.

---

## Impacted Segment

**Precise Configuration:**
- **App Version:** 3.4.1
- **Operating System:** Android OS 12
- **Device Model:** Samsung Galaxy S21 (all variants)
- **Feature Context:** Crashes occur when users interact with Journals feature

**Affected Population:**
- **Total Users:** 2,847 users
- **% of Android Base:** 3.2%
- **Est. Daily Sessions Impacted:** ~9,965 sessions

---

## Severity Analysis

| Metric | Affected Segment | Baseline (Other Android) | Delta |
|--------|------------------|-------------------------|-------|
| **Crash Rate per Session** | **15.3%** | 0.1% | **+15.2pp** |
| **Total Crash Events Today** | 487 | 143 | +240% |
| **Users Experiencing Crashes** | 1,243 (43.7% of segment) | - | - |

**Severity Classification:** 🔴 **CRITICAL**

The affected segment is experiencing a crash rate **153x higher** than the Android 
baseline. This represents a severe user experience degradation.

---

## Business Impact

**Estimated Daily Impact:**
- **Lost Sessions:** ~1,500 sessions/day
- **Potential Uninstalls:** ~570 users at risk (assuming 20% churn rate)
- **User Sentiment:** High negative impact on segment satisfaction

**Trend:** ⚠️ Crash rate has been increasing since 8:00 AM launch time

---

## Root Cause Hypotheses

Based on the isolated dimensions, potential causes include:

1. **Device-Specific Rendering Issue:** Samsung One UI 4.0 (Android 12) may have 
   incompatibility with journal entry input field
2. **Memory Leak:** App version 3.4.1 may have memory management issue specific to 
   Samsung devices
3. **Library Conflict:** Third-party library incompatibility with Samsung's Android 12 
   implementation

---

## Recommended Actions

**Priority 1 (Immediate - Next 2 Hours):**
- [ ] Engineering team to pull crash logs for affected segment
- [ ] QA to attempt reproduction on Samsung Galaxy S21 w/ Android 12
- [ ] Consider feature flag kill switch for affected segment if crash rate continues

**Priority 2 (Next 4 Hours):**
- [ ] Identify specific code path triggering crash
- [ ] Prepare hotfix build 3.4.2 with targeted fix
- [ ] Set up dedicated monitoring for this segment

**Priority 3 (Next 24 Hours):**
- [ ] Beta test fix with sample of affected users
- [ ] Prepare communication for impacted user segment
- [ ] Conduct post-mortem on QA process gap

---

## Data Query Access

All diagnostic queries are available in notebook: `09_bug_triage.ipynb`

**Key Queries:**
- Crash rate comparison (baseline vs. affected)
- Segment isolation by dimensions
- Impact quantification
- Hourly trend analysis

---

## Communication

**Stakeholders Notified:**
- [x] Engineering Lead (via Slack @eng-team)
- [x] Product Manager (via email)
- [ ] Customer Support (pending - will send template)
- [ ] Executive Team (on standby pending engineering assessment)

**Next Update:** In 2 hours or upon significant development

---

## Appendix: Technical Details

**Query Execution Time:** 3.2 seconds  
**Data Freshness:** Real-time (< 5 min lag)  
**Sample Size:** 10,234 total sessions analyzed  
**Statistical Confidence:** High (n > 100 for all segments)

**Analyst Notes:** 
The precision of this isolation (3 specific dimensions) and the magnitude of the 
difference (153x baseline) provides high confidence in the diagnosis. The engineering 
team can focus debugging efforts on this specific configuration, significantly 
reducing time-to-resolution.
```

### Alternative: Slack Communication Format

For immediate team notification:

```
📊 **Bug Triage: Android Crash ISOLATED**

@eng-team - Confirmed crash spike is isolated to specific segment:

**🎯 Affected Configuration:**
• App Version: 3.4.1
• OS: Android 12
• Device: Samsung Galaxy S21

**📈 Severity:**
• Crash Rate: 15.3% (vs 0.1% baseline) - 153x higher
• Affected Users: ~2,850 users (3.2% of Android base)
• Status: CRITICAL

**💡 Impact:**
• 487 crashes today (vs ~3 expected)
• ~1,500 lost sessions/day
• ~570 users at uninstall risk

**🔧 Recommendation:**
High-priority ticket for Android team. Diagnostic queries available in 
`09_bug_triage.ipynb`. Standing by for engineering questions.

Full triage report: [Link to report]
```

## Best Practices for Bug Triage

### The RAPID Framework

**R - Reproduce the Pattern**
- Use data to identify the pattern, even if you can't reproduce manually
- Look for consistency across multiple users
- Document the frequency and timing

**A - Assess the Scope**
- How many users are affected?
- What percentage of the user base?
- Is it growing or stable?

**P - Pinpoint the Dimensions**
- Device model, OS version, app version
- Geographic location, network type
- User segment, feature flags, A/B test groups

**I - Isolate the Severity**
- Compare to baseline metrics
- Calculate the excess rate
- Estimate business impact

**D - Document for Action**
- Write clear, concise findings
- Provide specific debugging starting points
- Include all relevant queries and data

### Common Triage Mistakes to Avoid

❌ **"Android users are crashing"** → Too vague  
✅ **"Android 12 + Samsung S21 + App v3.4.1 users are crashing at 15.3% rate"**

❌ **"We have 487 crashes"** → No context  
✅ **"487 crashes vs. 3 expected (baseline rate) = 153x increase"**

❌ **"This is a big problem"** → Subjective  
✅ **"Affecting 3.2% of Android base, ~570 users at churn risk"**

❌ **Reporting raw counts only** → Doesn't account for traffic changes  
✅ **Use rates per session/user for true comparison**

### Advanced Triage Techniques

#### Time-Series Anomaly Detection

```sql
-- Detect When the Issue Started
WITH hourly_crash_rates AS (
    SELECT 
        DATE_TRUNC('hour', e.event_timestamp) AS hour_bucket,
        COUNT(*) FILTER (WHERE e.event_name = 'app_crash' AND u.app_version = '3.4.1') AS crashes,
        COUNT(DISTINCT e.session_id) AS sessions,
        ROUND(
            100.0 * COUNT(*) FILTER (WHERE e.event_name = 'app_crash' AND u.app_version = '3.4.1') / 
            NULLIF(COUNT(DISTINCT e.session_id), 0), 
            2
        ) AS crash_rate_pct
    FROM events e
    JOIN users u ON e.user_id = u.user_id
    WHERE e.event_timestamp >= CURRENT_DATE - INTERVAL '7 days'
      AND u.platform = 'Android'
    GROUP BY hour_bucket
)
SELECT 
    hour_bucket,
    crashes,
    sessions,
    crash_rate_pct,
    AVG(crash_rate_pct) OVER (
        ORDER BY hour_bucket 
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS moving_avg_7h,
    CASE 
        WHEN crash_rate_pct > 3 * AVG(crash_rate_pct) OVER (
            ORDER BY hour_bucket 
            ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
        ) THEN 'ANOMALY'
        ELSE 'NORMAL'
    END AS anomaly_flag
FROM hourly_crash_rates
ORDER BY hour_bucket DESC;
```

#### Cross-Dimensional Analysis

```sql
-- Find All Dimensions with Elevated Crash Rates
SELECT 
    'App Version' AS dimension_type,
    u.app_version AS dimension_value,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE e.event_name = 'app_crash') / 
        NULLIF(COUNT(DISTINCT e.session_id), 0), 
        2
    ) AS crash_rate_pct
FROM events e
JOIN users u ON e.user_id = u.user_id
WHERE e.event_timestamp >= CURRENT_DATE
  AND u.platform = 'Android'
GROUP BY u.app_version
HAVING COUNT(DISTINCT e.session_id) >= 50

UNION ALL

SELECT 
    'OS Version' AS dimension_type,
    u.os_version AS dimension_value,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE e.event_name = 'app_crash') / 
        NULLIF(COUNT(DISTINCT e.session_id), 0), 
        2
    ) AS crash_rate_pct
FROM events e
JOIN users u ON e.user_id = u.user_id
WHERE e.event_timestamp >= CURRENT_DATE
  AND u.platform = 'Android'
GROUP BY u.os_version
HAVING COUNT(DISTINCT e.session_id) >= 50

UNION ALL

SELECT 
    'Device Model' AS dimension_type,
    u.device_model AS dimension_value,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE e.event_name = 'app_crash') / 
        NULLIF(COUNT(DISTINCT e.session_id), 0), 
        2
    ) AS crash_rate_pct
FROM events e
JOIN users u ON e.user_id = u.user_id
WHERE e.event_timestamp >= CURRENT_DATE
  AND u.platform = 'Android'
GROUP BY u.device_model
HAVING COUNT(DISTINCT e.session_id) >= 50

ORDER BY crash_rate_pct DESC;
```

## Deliverable Checklist

- [ ] `09_bug_triage.ipynb` notebook created
- [ ] Crash spike confirmed with statistical evidence
- [ ] Platform isolation completed
- [ ] Precise segment dimensions identified (app version, OS, device)
- [ ] Severity calculated with baseline comparison
- [ ] Business impact quantified
- [ ] Formal triage report completed with all sections
- [ ] Engineering team notified via appropriate channel
- [ ] Follow-up cadence established

## Key Takeaways

1. **Precision saves time:** Vague reports lead to vague fixes. Specific isolation accelerates resolution
2. **Context matters:** Raw counts mean nothing without baselines and rates
3. **Think like an engineer:** Provide debugging starting points, not just problem descriptions
4. **Quantify impact:** Business metrics (users at risk, lost sessions) justify urgency
5. **Document everything:** Your triage report becomes the reference for the post-mortem

---

**Remember:** In a crisis, the team looks to you for clarity. Your ability to quickly isolate a problem and communicate it with precision can mean the difference between a 2-hour fix and a 2-day debugging nightmare. Be the analyst who turns chaos into actionable intelligence.
