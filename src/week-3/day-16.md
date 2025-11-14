# Day 16: The Quasi-Experiment Post-Mortem

## Objective
Execute the Difference-in-Differences (DiD) analysis and critically compare its results to the "ground truth" of the A/B test, understanding its limitations.

---

## Step-by-Step Guide

### 1. Execute DiD Analysis
- Define treatment and control groups
- Define pre- and post-periods
- Calculate group averages for each period
- Compute DiD estimate: (Treat_Post - Treat_Pre) - (Control_Post - Control_Pre)

### 2. Check Parallel Trends Assumption
- Plot pre-period trends for both groups
- Comment on validity of the assumption

### 3. Compare DiD and A/B Test Results
- Create a table comparing effect sizes and confidence intervals
- Discuss similarities and differences

### 4. Critical Assessment Template
> **Why DiD Deviated from the A/B Test:**
> - List potential confounders (e.g., seasonality, external events, demographic differences)
> - Discuss limitations of observational methods
> - Suggest improvements for future analyses

### 5. Checklist for Reporting
- [ ] Parallel trends plot included
- [ ] DiD calculation and interpretation
- [ ] Comparison table with A/B test
- [ ] Critical assessment paragraph

### 6. Example DiD Calculation (Python/Pandas)
```python
import pandas as pd
# Assume df has columns: group, period, metric
pre = df[df['period'] == 'pre'].groupby('group')['metric'].mean()
post = df[df['period'] == 'post'].groupby('group')['metric'].mean()
did = (post['treatment'] - pre['treatment']) - (post['control'] - pre['control'])
print(f"DiD Estimate: {did}")
```

---

## Deliverable
A notebook containing:
- DiD calculation
- Parallel trends plot
- Comparison table
- Critical assessment paragraph
