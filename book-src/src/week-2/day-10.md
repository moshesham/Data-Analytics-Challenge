# Day 10: The Adoption Funnel – Diagnosing User Friction

## Overview

**Objective:** To visualize the user journey into the feature and pinpoint the exact step where most users are dropping off.

**Why This Matters:** A feature's failure is often not due to a lack of value, but to friction. The funnel is your x-ray for seeing exactly where that friction occurs in the user experience.

## The Funnel Mindset

Every feature has a journey. Users don't instantly adopt; they progress through stages:

1. **Awareness:** They encounter the feature's entry point
2. **Discovery:** They interact with it
3. **Understanding:** They comprehend its value
4. **Action:** They complete a meaningful interaction
5. **Return:** They come back (the ultimate validation)

Your job is to:
- **Identify where users leak** from this journey
- **Quantify the magnitude** of each drop-off
- **Form hypotheses** about why users leave at each step
- **Recommend interventions** based on data, not hunches

## The Critical Constraint: Session-Based Funnel

**Why session-based matters:**
- Users who complete the funnel in one session are experiencing your optimal happy path
- Multi-session funnels can hide critical friction points
- Session completion correlates strongly with feature retention

**The Rule:** A user must complete all funnel steps **within a single session** to count as a successful conversion.

## Task 1: Define a Time-Bound Funnel

### The Journals Feature Funnel

```
Step 1: app_open
   ↓
Step 2: view_main_feed
   ↓
Step 3: tap_journals_icon
   ↓
Step 4: create_first_journal_entry
```

Each step must occur within the same `session_id` and be sequenced in chronological order.

## Task 2: Write the Funnel Query

Create notebook `10_adoption_funnel.ipynb` with the robust funnel analysis.

### Approach 1: CTE-Based Funnel (Recommended)

```sql
-- Session-Based Adoption Funnel with Sequential Step Validation
WITH session_events AS (
    -- Get all relevant events with session context
    SELECT 
        user_id,
        session_id,
        event_name,
        event_timestamp,
        ROW_NUMBER() OVER (
            PARTITION BY session_id 
            ORDER BY event_timestamp
        ) AS event_sequence
    FROM events
    WHERE event_timestamp >= CURRENT_DATE - INTERVAL '7 days'  -- Launch week
      AND event_name IN (
          'app_open',
          'view_main_feed', 
          'tap_journals_icon', 
          'create_journal_entry'
      )
),
step_1_app_open AS (
    SELECT DISTINCT 
        session_id,
        user_id
    FROM session_events
    WHERE event_name = 'app_open'
),
step_2_view_feed AS (
    SELECT DISTINCT 
        se.session_id,
        se.user_id
    FROM session_events se
    INNER JOIN step_1_app_open s1 ON se.session_id = s1.session_id
    WHERE se.event_name = 'view_main_feed'
      AND se.event_timestamp > (
          SELECT MIN(event_timestamp)
          FROM session_events
          WHERE session_id = se.session_id
            AND event_name = 'app_open'
      )
),
step_3_tap_icon AS (
    SELECT DISTINCT 
        se.session_id,
        se.user_id
    FROM session_events se
    INNER JOIN step_2_view_feed s2 ON se.session_id = s2.session_id
    WHERE se.event_name = 'tap_journals_icon'
      AND se.event_timestamp > (
          SELECT MIN(event_timestamp)
          FROM session_events
          WHERE session_id = se.session_id
            AND event_name = 'view_main_feed'
      )
),
step_4_create_entry AS (
    SELECT DISTINCT 
        se.session_id,
        se.user_id
    FROM session_events se
    INNER JOIN step_3_tap_icon s3 ON se.session_id = s3.session_id
    WHERE se.event_name = 'create_journal_entry'
      AND se.event_timestamp > (
          SELECT MIN(event_timestamp)
          FROM session_events
          WHERE session_id = se.session_id
            AND event_name = 'tap_journals_icon'
      )
),
funnel_summary AS (
    SELECT 
        'Step 1: App Open' AS funnel_step,
        1 AS step_number,
        COUNT(DISTINCT user_id) AS users,
        COUNT(DISTINCT session_id) AS sessions
    FROM step_1_app_open
    
    UNION ALL
    
    SELECT 
        'Step 2: View Main Feed' AS funnel_step,
        2 AS step_number,
        COUNT(DISTINCT user_id) AS users,
        COUNT(DISTINCT session_id) AS sessions
    FROM step_2_view_feed
    
    UNION ALL
    
    SELECT 
        'Step 3: Tap Journals Icon' AS funnel_step,
        3 AS step_number,
        COUNT(DISTINCT user_id) AS users,
        COUNT(DISTINCT session_id) AS sessions
    FROM step_3_tap_icon
    
    UNION ALL
    
    SELECT 
        'Step 4: Create First Entry' AS funnel_step,
        4 AS step_number,
        COUNT(DISTINCT user_id) AS users,
        COUNT(DISTINCT session_id) AS sessions
    FROM step_4_create_entry
)
SELECT 
    funnel_step,
    step_number,
    users,
    sessions,
    ROUND(100.0 * users / FIRST_VALUE(users) OVER (ORDER BY step_number), 2) AS pct_of_step_1,
    ROUND(
        100.0 * users / LAG(users) OVER (ORDER BY step_number), 
        2
    ) AS step_conversion_rate,
    users - LAG(users) OVER (ORDER BY step_number) AS user_dropoff,
    ROUND(
        100.0 * (users - LAG(users) OVER (ORDER BY step_number)) / 
        NULLIF(LAG(users) OVER (ORDER BY step_number), 0), 
        2
    ) AS step_dropoff_rate
FROM funnel_summary
ORDER BY step_number;
```

### Approach 2: Window Function Funnel (Alternative)

```sql
-- Alternative: Using Window Functions for Funnel Analysis
WITH user_session_steps AS (
    SELECT 
        user_id,
        session_id,
        MAX(CASE WHEN event_name = 'app_open' THEN 1 ELSE 0 END) AS completed_step_1,
        MAX(CASE WHEN event_name = 'view_main_feed' THEN 1 ELSE 0 END) AS completed_step_2,
        MAX(CASE WHEN event_name = 'tap_journals_icon' THEN 1 ELSE 0 END) AS completed_step_3,
        MAX(CASE WHEN event_name = 'create_journal_entry' THEN 1 ELSE 0 END) AS completed_step_4,
        -- Ensure proper sequence
        MIN(CASE WHEN event_name = 'app_open' THEN event_timestamp END) AS step_1_time,
        MIN(CASE WHEN event_name = 'view_main_feed' THEN event_timestamp END) AS step_2_time,
        MIN(CASE WHEN event_name = 'tap_journals_icon' THEN event_timestamp END) AS step_3_time,
        MIN(CASE WHEN event_name = 'create_journal_entry' THEN event_timestamp END) AS step_4_time
    FROM events
    WHERE event_timestamp >= CURRENT_DATE - INTERVAL '7 days'
      AND event_name IN ('app_open', 'view_main_feed', 'tap_journals_icon', 'create_journal_entry')
    GROUP BY user_id, session_id
),
validated_funnel AS (
    SELECT 
        user_id,
        session_id,
        completed_step_1,
        CASE 
            WHEN completed_step_2 = 1 AND step_2_time > step_1_time THEN 1 
            ELSE 0 
        END AS completed_step_2,
        CASE 
            WHEN completed_step_3 = 1 AND step_3_time > step_2_time THEN 1 
            ELSE 0 
        END AS completed_step_3,
        CASE 
            WHEN completed_step_4 = 1 AND step_4_time > step_3_time THEN 1 
            ELSE 0 
        END AS completed_step_4
    FROM user_session_steps
    WHERE completed_step_1 = 1  -- Must have started the funnel
)
SELECT 
    'Step 1: App Open' AS step,
    SUM(completed_step_1) AS users,
    ROUND(100.0 * SUM(completed_step_1) / SUM(completed_step_1), 2) AS conversion_rate
FROM validated_funnel
UNION ALL
SELECT 
    'Step 2: View Main Feed',
    SUM(completed_step_2),
    ROUND(100.0 * SUM(completed_step_2) / SUM(completed_step_1), 2)
FROM validated_funnel
UNION ALL
SELECT 
    'Step 3: Tap Journals Icon',
    SUM(completed_step_3),
    ROUND(100.0 * SUM(completed_step_3) / SUM(completed_step_1), 2)
FROM validated_funnel
UNION ALL
SELECT 
    'Step 4: Create First Entry',
    SUM(completed_step_4),
    ROUND(100.0 * SUM(completed_step_4) / SUM(completed_step_1), 2)
FROM validated_funnel;
```

## Task 3: Visualize and Annotate

### Creating the Funnel Chart

```python
import pandas as pd
import matplotlib.pyplot as plt
import numpy as np

def create_funnel_visualization(funnel_data):
    """
    Create a professional funnel chart with annotations
    
    Parameters:
    funnel_data: DataFrame with columns ['funnel_step', 'users', 'step_conversion_rate']
    """
    fig, ax = plt.subplots(figsize=(12, 8))
    
    # Extract data
    steps = funnel_data['funnel_step'].values
    users = funnel_data['users'].values
    conversion_rates = funnel_data['step_conversion_rate'].values
    
    # Calculate funnel widths (normalized)
    max_users = users[0]
    widths = users / max_users
    
    # Create funnel shape
    y_positions = np.arange(len(steps))
    colors = plt.cm.Blues(np.linspace(0.4, 0.8, len(steps)))
    
    # Draw funnel bars
    for i, (step, width, user_count, conv_rate) in enumerate(zip(steps, widths, users, conversion_rates)):
        # Draw bar
        ax.barh(i, width, height=0.8, color=colors[i], 
                edgecolor='white', linewidth=2)
        
        # Add user count
        ax.text(width/2, i, f'{user_count:,} users', 
                ha='center', va='center', fontsize=11, fontweight='bold', color='white')
        
        # Add conversion rate (skip first step)
        if i > 0 and not np.isnan(conv_rate):
            # Calculate dropoff
            dropoff = users[i-1] - users[i]
            dropoff_pct = 100 - conv_rate
            
            # Annotate dropoff on the right
            ax.text(1.05, i - 0.4, 
                   f'↓ {dropoff:,} users dropped\n({dropoff_pct:.1f}% loss)', 
                   ha='left', va='center', fontsize=9, 
                   color='#D32F2F', style='italic')
    
    # Formatting
    ax.set_yticks(y_positions)
    ax.set_yticklabels(steps, fontsize=11)
    ax.set_xlim(0, 1.3)
    ax.set_xlabel('Relative Volume', fontsize=12, fontweight='bold')
    ax.set_title('Journals Adoption Funnel (Within First Session)\nWeek 1 Launch Data', 
                fontsize=14, fontweight='bold', pad=20)
    
    # Remove spines
    ax.spines['top'].set_visible(False)
    ax.spines['right'].set_visible(False)
    ax.spines['bottom'].set_visible(False)
    ax.get_xaxis().set_visible(False)
    
    # Add overall conversion rate
    overall_conversion = (users[-1] / users[0]) * 100
    fig.text(0.5, 0.02, 
            f'Overall Conversion Rate: {overall_conversion:.1f}% | {users[-1]:,} / {users[0]:,} users completed the full funnel',
            ha='center', fontsize=11, style='italic', color='#555555')
    
    plt.tight_layout()
    plt.savefig('adoption_funnel.png', dpi=300, bbox_inches='tight')
    return fig

# Usage example with sample data
# funnel_df = pd.DataFrame({
#     'funnel_step': ['App Open', 'View Feed', 'Tap Icon', 'Create Entry'],
#     'users': [50000, 45000, 18000, 12000],
#     'step_conversion_rate': [100, 90, 40, 66.7]
# })
# create_funnel_visualization(funnel_df)
```

### Enhanced Visualization with Segment Comparison

```python
def create_segmented_funnel(funnel_data_dict):
    """
    Create side-by-side funnel comparison (e.g., iOS vs Android)
    
    Parameters:
    funnel_data_dict: Dictionary with segment names as keys and DataFrames as values
    """
    fig, axes = plt.subplots(1, len(funnel_data_dict), 
                             figsize=(7*len(funnel_data_dict), 8))
    
    if len(funnel_data_dict) == 1:
        axes = [axes]
    
    for idx, (segment_name, funnel_df) in enumerate(funnel_data_dict.items()):
        ax = axes[idx]
        
        steps = funnel_df['funnel_step'].values
        users = funnel_df['users'].values
        max_users = users[0]
        widths = users / max_users
        
        y_positions = np.arange(len(steps))
        colors = plt.cm.Oranges(np.linspace(0.4, 0.8, len(steps))) if idx == 0 else plt.cm.Blues(np.linspace(0.4, 0.8, len(steps)))
        
        for i, (step, width, user_count) in enumerate(zip(steps, widths, users)):
            ax.barh(i, width, height=0.8, color=colors[i], 
                   edgecolor='white', linewidth=2)
            ax.text(width/2, i, f'{user_count:,}', 
                   ha='center', va='center', fontsize=10, 
                   fontweight='bold', color='white')
        
        ax.set_yticks(y_positions)
        ax.set_yticklabels(steps, fontsize=10)
        ax.set_xlim(0, 1.1)
        ax.set_title(f'{segment_name}\nConversion: {(users[-1]/users[0]*100):.1f}%', 
                    fontsize=12, fontweight='bold')
        ax.spines['top'].set_visible(False)
        ax.spines['right'].set_visible(False)
        ax.get_xaxis().set_visible(False)
    
    plt.tight_layout()
    plt.savefig('segmented_funnel_comparison.png', dpi=300, bbox_inches='tight')
    return fig
```

## Task 4: Identify Leakage & Formulate a Product Hypothesis

### Leakage Analysis Framework

Annotate your funnel chart to highlight the biggest drop-off point. Below the chart, write a specific, testable product hypothesis.

#### Example Analysis

**Sample Funnel Results:**
```
Step 1: App Open           → 50,000 users (100%)
Step 2: View Main Feed     → 45,000 users (90%) | -5,000 users (-10%)
Step 3: Tap Journals Icon  → 18,000 users (36%) | -27,000 users (-60%)  ⚠️ CRITICAL LEAKAGE
Step 4: Create First Entry → 12,000 users (24%) | -6,000 users (-33%)
```

**Insight:** The 60% drop-off between viewing the feed and tapping the icon is the critical friction point.

### The Product Hypothesis Template

```markdown
## Funnel Leakage Analysis

### Critical Drop-Off Point Identified

**Location:** Step 2 → Step 3 (View Main Feed → Tap Journals Icon)

**Magnitude:** 
- **Absolute Loss:** 27,000 users (60% of Step 2 users)
- **Impact on Overall Conversion:** If fixed to 80% conversion, overall funnel conversion 
  would increase from 24% to 64% (+167% relative lift)

### Root Cause Hypothesis

**Primary Hypothesis:** Low discoverability of the Journals feature entry point

**Supporting Evidence:**
1. **High Feed Engagement:** 90% of users successfully reach the main feed, indicating 
   the app experience up to this point is working
2. **Massive Drop at Discovery:** The journal icon is not prominent enough to capture 
   user attention in the busy feed interface
3. **Good Post-Discovery Conversion:** Once users tap the icon, 67% create an entry, 
   suggesting the feature itself has strong value proposition

**Alternative Hypotheses to Rule Out:**
- ❌ "Users don't want the feature" → Contradicted by 67% conversion after discovery
- ❌ "The icon is confusing" → Would manifest as high bounce rate after tap
- ✅ "The icon is invisible/not prominent" → Matches the data pattern

### Testable Product Intervention

**Proposed Change:** Redesign the Journals entry point to increase visibility

**Specific Tactics:**
1. **Visual Prominence:** Change icon color from gray to brand purple
2. **Novelty Badge:** Add a "New" badge for first 14 days post-launch
3. **Positioning:** Move icon from bottom-right to top-right of feed
4. **Animation:** Add subtle pulse animation on first 3 app opens post-launch

**Success Metric:** Increase tap-through rate (Step 2 → Step 3) from 40% to 60%

**A/B Test Design:**
- **Control:** Current icon placement and styling
- **Treatment:** Enhanced visibility (all 4 tactics above)
- **Primary Metric:** Tap-through rate (View Feed → Tap Icon)
- **Sample Size:** 10,000 users per group
- **Duration:** 7 days
- **Decision Criteria:** Ship if treatment shows >15% relative lift with p < 0.05

### Expected Impact

If successful, this intervention would:
- **Increase overall funnel conversion** from 24% to ~40% (+67% relative)
- **Add ~8,000 new journal adopters** in the first week
- **Improve feature ROI** by reducing the cost-per-acquisition of engaged users
```

## Advanced Funnel Analysis Techniques

### Time-to-Convert Analysis

How long does it take users to complete the funnel?

```sql
-- Time Between Funnel Steps
WITH step_times AS (
    SELECT 
        session_id,
        user_id,
        MIN(CASE WHEN event_name = 'app_open' THEN event_timestamp END) AS step_1_time,
        MIN(CASE WHEN event_name = 'view_main_feed' THEN event_timestamp END) AS step_2_time,
        MIN(CASE WHEN event_name = 'tap_journals_icon' THEN event_timestamp END) AS step_3_time,
        MIN(CASE WHEN event_name = 'create_journal_entry' THEN event_timestamp END) AS step_4_time
    FROM events
    WHERE event_timestamp >= CURRENT_DATE - INTERVAL '7 days'
      AND event_name IN ('app_open', 'view_main_feed', 'tap_journals_icon', 'create_journal_entry')
    GROUP BY session_id, user_id
    HAVING MIN(CASE WHEN event_name = 'create_journal_entry' THEN event_timestamp END) IS NOT NULL
),
time_deltas AS (
    SELECT 
        EXTRACT(EPOCH FROM (step_2_time - step_1_time)) AS seconds_step_1_to_2,
        EXTRACT(EPOCH FROM (step_3_time - step_2_time)) AS seconds_step_2_to_3,
        EXTRACT(EPOCH FROM (step_4_time - step_3_time)) AS seconds_step_3_to_4,
        EXTRACT(EPOCH FROM (step_4_time - step_1_time)) AS total_funnel_seconds
    FROM step_times
    WHERE step_2_time > step_1_time
      AND step_3_time > step_2_time
      AND step_4_time > step_3_time
)
SELECT 
    ROUND(AVG(seconds_step_1_to_2), 1) AS avg_seconds_to_feed,
    ROUND(AVG(seconds_step_2_to_3), 1) AS avg_seconds_to_icon_tap,
    ROUND(AVG(seconds_step_3_to_4), 1) AS avg_seconds_to_entry,
    ROUND(AVG(total_funnel_seconds), 1) AS avg_total_funnel_time,
    ROUND(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY total_funnel_seconds), 1) AS median_funnel_time,
    ROUND(PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY total_funnel_seconds), 1) AS p90_funnel_time
FROM time_deltas;
```

### Funnel Segmentation

Compare funnel performance across user segments:

```sql
-- Segmented Funnel Analysis (iOS vs Android)
WITH session_events AS (
    SELECT 
        e.user_id,
        e.session_id,
        e.event_name,
        e.event_timestamp,
        u.platform
    FROM events e
    JOIN users u ON e.user_id = u.user_id
    WHERE e.event_timestamp >= CURRENT_DATE - INTERVAL '7 days'
      AND e.event_name IN ('app_open', 'view_main_feed', 'tap_journals_icon', 'create_journal_entry')
),
-- Repeat the funnel logic for each segment
platform_funnels AS (
    SELECT 
        platform,
        COUNT(DISTINCT CASE WHEN event_name = 'app_open' THEN session_id END) AS step_1,
        COUNT(DISTINCT CASE WHEN event_name = 'view_main_feed' THEN session_id END) AS step_2,
        COUNT(DISTINCT CASE WHEN event_name = 'tap_journals_icon' THEN session_id END) AS step_3,
        COUNT(DISTINCT CASE WHEN event_name = 'create_journal_entry' THEN session_id END) AS step_4
    FROM session_events
    GROUP BY platform
)
SELECT 
    platform,
    step_1,
    step_2,
    step_3,
    step_4,
    ROUND(100.0 * step_2 / step_1, 2) AS conversion_1_to_2,
    ROUND(100.0 * step_3 / step_2, 2) AS conversion_2_to_3,
    ROUND(100.0 * step_4 / step_3, 2) AS conversion_3_to_4,
    ROUND(100.0 * step_4 / step_1, 2) AS overall_conversion
FROM platform_funnels
ORDER BY overall_conversion DESC;
```

## Common Funnel Analysis Pitfalls

### ❌ Mistake 1: Not Validating Sequential Order
**Problem:** Counting a user who did Step 3 before Step 2  
**Solution:** Always validate timestamp ordering in your query

### ❌ Mistake 2: Allowing Multi-Session Funnels
**Problem:** A user who takes 3 days to complete the funnel looks like a "success"  
**Solution:** Enforce same `session_id` constraint

### ❌ Mistake 3: Reporting Only Percentages
**Problem:** "60% drop-off" doesn't communicate absolute impact  
**Solution:** Always include both absolute (27,000 users) and relative (60%) numbers

### ❌ Mistake 4: Not Considering Sample Size
**Problem:** Drawing conclusions from a funnel with 50 users  
**Solution:** Report confidence intervals or flag small sample sizes

### ❌ Mistake 5: Analyzing Without Context
**Problem:** "40% conversion is bad"  
**Solution:** Compare to industry benchmarks, similar features, or A/B test variations

## Deliverable Checklist

- [ ] `10_adoption_funnel.ipynb` notebook created
- [ ] Session-based funnel query implemented with sequential validation
- [ ] Funnel visualization created with clear annotations
- [ ] Biggest drop-off point identified and highlighted
- [ ] Time-to-convert analysis completed
- [ ] Segmented funnel comparison (e.g., iOS vs Android) performed
- [ ] Root cause hypothesis formulated
- [ ] Product intervention designed with specific tactics
- [ ] A/B test plan drafted for proposed solution
- [ ] Expected impact quantified

## Key Takeaways

1. **The funnel reveals friction:** Where users drop off tells you where your UX is failing
2. **Session-based is critical:** Multi-session funnels hide true UX problems
3. **Absolute + relative matters:** "60% drop = 27K users" is more compelling than just percentages
4. **Hypotheses must be testable:** Vague ideas don't drive action; specific interventions do
5. **Segmentation reveals insights:** What works for iOS may not work for Android

---

**Remember:** The adoption funnel is not just a diagnostic tool—it's a strategic weapon. When you can pinpoint exactly where users are struggling and propose a data-backed solution, you transform from a reporter of problems into a driver of solutions. Your funnel analysis today becomes tomorrow's product roadmap.
