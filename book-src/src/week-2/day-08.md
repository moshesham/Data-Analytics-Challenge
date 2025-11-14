# Day 08: Launch Day! The Command Center

## Overview

**Objective:** To establish and run the "command center," actively assessing product and system health to provide the team with the first all-clear signal.

**Why This Matters:** Before asking "Are they using it?", you must confidently answer "Is it working?". As the analyst, you are the first line of defense, responsible for building trust in the data and the product's stability from the very first hour.

## The Launch Day Mindset

Launch day transforms you from a planner into a guardian. Your role is critical:

- **System Integrity First:** No adoption analysis matters if the feature is broken or degrading the user experience
- **Trust Builder:** Your sign-off gives the team confidence to focus on growth, not firefighting
- **Early Warning System:** You detect issues before they become crises
- **Data Quality Guardian:** You ensure the instrumentation you designed is actually firing correctly

## Task 1: Establish Monitoring Dashboards

Create notebook `08_launch_monitoring.ipynb` with two critical monitoring systems that run every 15 minutes.

### System Health Dashboard

Track core infrastructure stability to detect catastrophic failures immediately.

**Key Metrics:**

```sql
-- Total Events Per Minute (Baseline Detection)
SELECT 
    DATE_TRUNC('minute', event_timestamp) AS minute_bucket,
    COUNT(*) AS total_events,
    COUNT(DISTINCT user_id) AS unique_users,
    COUNT(DISTINCT session_id) AS unique_sessions
FROM events
WHERE event_timestamp >= NOW() - INTERVAL '1 hour'
GROUP BY minute_bucket
ORDER BY minute_bucket DESC;

-- App Crash Event Rate (Critical Health Indicator)
SELECT 
    DATE_TRUNC('hour', event_timestamp) AS hour_bucket,
    COUNT(*) FILTER (WHERE event_name = 'app_crash') AS crash_events,
    COUNT(*) AS total_events,
    ROUND(
        100.0 * COUNT(*) FILTER (WHERE event_name = 'app_crash') / NULLIF(COUNT(*), 0), 
        2
    ) AS crash_rate_pct
FROM events
WHERE event_timestamp >= NOW() - INTERVAL '24 hours'
GROUP BY hour_bucket
ORDER BY hour_bucket DESC;

-- Server Latency Monitoring (Performance Guardian)
SELECT 
    DATE_TRUNC('minute', event_timestamp) AS minute_bucket,
    AVG(server_latency_ms) AS avg_latency_ms,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY server_latency_ms) AS p50_latency_ms,
    PERCENTILE_CONT(0.95) WITHIN GROUP (ORDER BY server_latency_ms) AS p95_latency_ms,
    PERCENTILE_CONT(0.99) WITHIN GROUP (ORDER BY server_latency_ms) AS p99_latency_ms,
    MAX(server_latency_ms) AS max_latency_ms
FROM events
WHERE event_timestamp >= NOW() - INTERVAL '1 hour'
  AND server_latency_ms IS NOT NULL
GROUP BY minute_bucket
ORDER BY minute_bucket DESC
LIMIT 60;
```

### Product Adoption Dashboard

Track the earliest signs of user engagement with the new feature.

**Key Metrics:**

```sql
-- Journals Icon Tap Tracking (Discovery Signal)
SELECT 
    DATE_TRUNC('hour', event_timestamp) AS hour_bucket,
    COUNT(DISTINCT user_id) AS unique_users_tapping_icon,
    COUNT(*) AS total_taps
FROM events
WHERE event_name = 'tap_journals_icon'
  AND event_timestamp >= NOW() - INTERVAL '24 hours'
GROUP BY hour_bucket
ORDER BY hour_bucket DESC;

-- First Journal Entry Creation (Conversion Signal)
WITH first_entries AS (
    SELECT 
        user_id,
        MIN(event_timestamp) AS first_entry_time
    FROM events
    WHERE event_name = 'create_journal_entry'
    GROUP BY user_id
)
SELECT 
    DATE_TRUNC('hour', first_entry_time) AS hour_bucket,
    COUNT(DISTINCT user_id) AS new_journal_adopters,
    COUNT(*) AS total_first_entries
FROM first_entries
WHERE first_entry_time >= NOW() - INTERVAL '24 hours'
GROUP BY hour_bucket
ORDER BY hour_bucket DESC;

-- Cumulative Adoption Tracking
SELECT 
    DATE_TRUNC('hour', event_timestamp) AS hour_bucket,
    COUNT(DISTINCT user_id) AS hourly_creators,
    SUM(COUNT(DISTINCT user_id)) OVER (ORDER BY DATE_TRUNC('hour', event_timestamp)) AS cumulative_adopters
FROM events
WHERE event_name = 'create_journal_entry'
  AND event_timestamp >= DATE_TRUNC('day', NOW())
GROUP BY hour_bucket
ORDER BY hour_bucket;
```

## Task 2: Set Alert Thresholds

Define clear, actionable thresholds for your guardrail metrics. Document these in your notebook.

### Critical Thresholds Framework

```python
# Define baseline metrics from pre-launch period (calculate from historical data)
BASELINE_METRICS = {
    'crash_rate_pct': 0.1,  # 0.1% baseline crash rate
    'avg_latency_ms': 250,   # 250ms average latency
    'app_uninstalls_per_hour': 12,  # 12 uninstalls per hour on average
    'negative_reviews_per_hour': 3   # 3 negative reviews per hour
}

# Define alert thresholds (% deviation from baseline)
ALERT_THRESHOLDS = {
    'crash_rate_pct': 0.2,  # Alert if crashes exceed 0.2% (2x baseline)
    'avg_latency_ms': 375,   # Alert if latency exceeds 375ms (1.5x baseline)
    'app_uninstalls_per_hour': 18,  # Alert if uninstalls exceed 18/hour (1.5x baseline)
    'negative_reviews_per_hour': 6   # Alert if negative reviews exceed 6/hour (2x baseline)
}

def check_metric_threshold(metric_name, current_value, threshold_value):
    """
    Check if a metric exceeds its threshold and return alert status
    """
    if current_value > threshold_value:
        deviation_pct = ((current_value - threshold_value) / threshold_value) * 100
        return {
            'alert': True,
            'metric': metric_name,
            'current': current_value,
            'threshold': threshold_value,
            'deviation_pct': round(deviation_pct, 2),
            'message': f"🚨 ALERT: {metric_name} is {deviation_pct:.1f}% above threshold"
        }
    return {'alert': False, 'metric': metric_name}
```

### Guardrail Monitoring Query

```sql
-- Comprehensive Guardrail Check
WITH hourly_metrics AS (
    SELECT 
        DATE_TRUNC('hour', event_timestamp) AS hour_bucket,
        COUNT(*) FILTER (WHERE event_name = 'app_uninstall') AS uninstalls,
        COUNT(*) FILTER (WHERE event_name = 'app_crash') AS crashes,
        COUNT(*) AS total_events,
        AVG(server_latency_ms) AS avg_latency
    FROM events
    WHERE event_timestamp >= NOW() - INTERVAL '24 hours'
    GROUP BY hour_bucket
),
metrics_with_status AS (
    SELECT 
        hour_bucket,
        uninstalls,
        crashes,
        total_events,
        ROUND(100.0 * crashes / NULLIF(total_events, 0), 4) AS crash_rate_pct,
        ROUND(avg_latency, 2) AS avg_latency_ms,
        CASE 
            WHEN uninstalls > 18 THEN 'ALERT: High Uninstalls'
            WHEN ROUND(100.0 * crashes / NULLIF(total_events, 0), 4) > 0.2 THEN 'ALERT: High Crash Rate'
            WHEN avg_latency > 375 THEN 'ALERT: High Latency'
            ELSE 'Normal'
        END AS status
    FROM hourly_metrics
)
SELECT * 
FROM metrics_with_status
ORDER BY hour_bucket DESC;
```

## Task 3: Create the End-of-Day Sign-Off

At the end of launch day, produce a concise summary report with visualization and structured assessment.

### Visualization: Key Health Metrics Timeline

```python
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
from datetime import datetime, timedelta

# Sample code structure for visualization
def create_launch_day_health_chart(health_data):
    """
    Create a multi-panel health metrics visualization
    """
    fig, axes = plt.subplots(3, 1, figsize=(14, 10))
    fig.suptitle('Journals Feature Launch - Day 1 Health Dashboard', 
                 fontsize=16, fontweight='bold')
    
    # Panel 1: Event Volume
    axes[0].plot(health_data['hour'], health_data['total_events'], 
                marker='o', linewidth=2, color='#2E86AB')
    axes[0].set_title('Total Events Per Hour', fontsize=12, fontweight='bold')
    axes[0].set_ylabel('Event Count')
    axes[0].grid(True, alpha=0.3)
    
    # Panel 2: Crash Rate
    axes[1].plot(health_data['hour'], health_data['crash_rate_pct'], 
                marker='o', linewidth=2, color='#A23B72')
    axes[1].axhline(y=0.2, color='red', linestyle='--', label='Alert Threshold')
    axes[1].set_title('Crash Rate (%)', fontsize=12, fontweight='bold')
    axes[1].set_ylabel('Crash Rate %')
    axes[1].legend()
    axes[1].grid(True, alpha=0.3)
    
    # Panel 3: New Adopters
    axes[2].plot(health_data['hour'], health_data['new_adopters'], 
                marker='o', linewidth=2, color='#F18F01')
    axes[2].set_title('New Journal Adopters Per Hour', fontsize=12, fontweight='bold')
    axes[2].set_ylabel('New Users')
    axes[2].set_xlabel('Hour of Day')
    axes[2].grid(True, alpha=0.3)
    
    plt.tight_layout()
    plt.savefig('launch_day_health_dashboard.png', dpi=300, bbox_inches='tight')
    return fig
```

### The Three-Point Sign-Off Structure

**End-of-Day Launch Assessment Template:**

```markdown
# Journals Feature Launch - Day 1 Sign-Off Report
**Date:** [Launch Date]  
**Analyst:** [Your Name]  
**Report Time:** [Time, e.g., 11:00 PM PT]

---

## Executive Summary

### ✅ System Status: STABLE
- **Crash Rates:** Remained within acceptable thresholds throughout the day
  - Average: 0.08% (baseline: 0.1%, threshold: 0.2%)
  - Peak: 0.12% at 3:00 PM (within normal variance)
- **Server Latency:** Performed within expected parameters
  - Average: 245ms (baseline: 250ms)
  - P95: 380ms (threshold: 500ms)
- **Critical Issues:** Zero critical system failures detected

### 📈 Initial Adoption Signal: POSITIVE
- **Total New Adopters:** 1,247 users created their first journal entry
- **Adoption Trajectory:** Steady stream of new adopters throughout the day
  - Peak hour: 2:00 PM with 156 new adopters
  - Minimum hour: 4:00 AM with 23 new adopters (expected low)
- **Engagement Depth:** 34% of adopters created multiple entries on Day 1

### 🎯 Overall Assessment: ALL CLEAR TO PROCEED
**Recommendation:** Continue with standard monitoring cadence. No immediate intervention required. Launch is stable and showing promising early adoption signals.

---

## Supporting Data

[Insert visualization here]

### Key Metrics Summary
| Metric | Target | Actual | Status |
|--------|--------|--------|--------|
| Crash Rate | < 0.2% | 0.08% | ✅ Pass |
| Avg Latency | < 375ms | 245ms | ✅ Pass |
| New Adopters | > 800 | 1,247 | ✅ Exceeded |
| App Uninstalls | < 18/hour | 11/hour | ✅ Pass |

### Next Steps
1. Continue hourly monitoring for next 48 hours
2. Prepare Day 2 adoption funnel analysis
3. Monitor qualitative feedback channels for user sentiment
```

## Best Practices for Launch Day Monitoring

### The Command Center Checklist

- [ ] **Pre-Launch (T-1 hour)**
  - [ ] Verify all monitoring queries are running
  - [ ] Test alert notification system
  - [ ] Confirm baseline metrics are calculated
  - [ ] Set up communication channels with engineering team

- [ ] **Launch Hour (T-0)**
  - [ ] Monitor system health dashboard every 5 minutes
  - [ ] Check instrumentation is firing correctly
  - [ ] Verify event data is flowing into tables
  - [ ] Confirm no immediate spikes in error rates

- [ ] **First 4 Hours (T+0 to T+4)**
  - [ ] Monitor every 15 minutes
  - [ ] Document any anomalies immediately
  - [ ] Communicate status updates every hour
  - [ ] Start tracking early adoption patterns

- [ ] **Rest of Day (T+4 to T+24)**
  - [ ] Monitor every 30 minutes
  - [ ] Compile hourly summary statistics
  - [ ] Begin analyzing user journey data
  - [ ] Prepare end-of-day sign-off

- [ ] **End of Day (T+24)**
  - [ ] Generate health visualization
  - [ ] Complete three-point assessment
  - [ ] Send sign-off to stakeholders
  - [ ] Plan next day's analysis priorities

### Communication Protocol

**When to Alert vs. When to Watch:**

**Immediate Alert (< 5 minutes):**
- Crash rate exceeds 0.5% (5x baseline)
- Complete loss of event data
- Widespread user-facing errors
- Security breach indicators

**Escalate Within 1 Hour:**
- Crash rate exceeds threshold (0.2%)
- Latency degradation > 50% above baseline
- Uninstall rate spike > 2x threshold
- Negative review spike

**Monitor and Document:**
- Metrics approaching thresholds
- Unexpected usage patterns
- Minor anomalies in specific segments
- Positive surprises exceeding expectations

## Common Launch Day Scenarios

### Scenario 1: The Ghost Launch
**Symptom:** System is healthy, but adoption is near zero.

**Diagnosis Approach:**
1. Verify feature is actually live (check feature flags)
2. Confirm instrumentation is working (check test events)
3. Validate user eligibility logic
4. Check if UI entry point is visible

### Scenario 2: The Adoption Spike
**Symptom:** Adoption far exceeds forecasts.

**What to Do:**
1. Celebrate briefly, then investigate
2. Check for bot traffic or data quality issues
3. Monitor system capacity and performance
4. Verify user segment distribution is expected
5. Document for Week 1 memo

### Scenario 3: The Latency Creep
**Symptom:** Average latency slowly increasing throughout the day.

**What to Do:**
1. Segment latency by geography, device, OS
2. Check database query performance
3. Alert engineering if approaching threshold
4. Document impact on user experience metrics

## Deliverable Checklist

- [ ] `08_launch_monitoring.ipynb` notebook created
- [ ] System health monitoring queries implemented
- [ ] Product adoption monitoring queries implemented
- [ ] Alert thresholds defined and documented
- [ ] Monitoring automation set up (15-minute intervals)
- [ ] End-of-day visualization created
- [ ] Three-point sign-off report completed
- [ ] All critical metrics tracked and documented
- [ ] Next-day priorities identified

## Key Takeaways

1. **Trust is earned through rigor:** Your sign-off means something only if your monitoring was comprehensive
2. **Health before growth:** Never analyze adoption before confirming system stability
3. **Document everything:** Your notes from today become the baseline for tomorrow's analysis
4. **Communicate clearly:** Engineers and executives need different levels of detail; provide both
5. **Stay calm under pressure:** Launch day is chaotic; your methodical approach brings clarity

---

**Remember:** You are not just monitoring a feature launch. You are the guardian of data integrity, the early warning system for the team, and the foundation of trust that enables confident decision-making. Your work today sets the tone for the entire launch cycle.

Launch day is your moment to demonstrate that analytics is not just about insights—it's about ensuring the business can operate with confidence.
