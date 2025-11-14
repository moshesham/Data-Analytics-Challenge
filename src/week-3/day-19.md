# Day 19: Validating the Engagement Loop

## Objective
Use data to prove whether the feature created a new, repeatable, habit-forming loop that brings users back to the product.

---

## Step-by-Step Guide

### 1. Hypothesize the Loop
- Diagram: Trigger (Push Notification) → Action (App Open) → Reward (Reading Past Entries) → Investment (Writing a New Entry)
- State which part you are testing (Trigger → Action)

### 2. Measure Trigger Efficacy
- Create two groups: users who received a `journal_reminder_notification` and those who did not
- For both, calculate next-day app open rate (next-day retention)

### 3. Statistical Test
- Use a significance test (e.g., chi-square or z-test for proportions) to compare return rates

### 4. Checklist for Reporting
- [ ] Loop hypothesis diagrammed and explained
- [ ] Groups and metrics clearly defined
- [ ] Statistical test performed
- [ ] Conclusion states whether loop is validated

### 5. Example Analysis Code (Python/Scipy)
```python
from scipy.stats import chi2_contingency
import numpy as np
# Example counts
notified = np.array([200, 800])  # [returned, not returned]
not_notified = np.array([150, 850])
table = np.array([notified, not_notified])
chi2, p, _, _ = chi2_contingency(table)
print(f"p-value: {p}")
```

---

## Deliverable
A notebook with:
- Analysis comparing groups
- Statistical test
- Conclusion on engagement loop
