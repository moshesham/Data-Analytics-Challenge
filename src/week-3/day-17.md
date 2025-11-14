# Day 17: Cannibalization vs. Creation – The Engagement Portfolio

## Objective
Answer the critical strategic question: did the feature generate net new engagement, or did it just shift existing behavior from one part of the app to another?

---

## Step-by-Step Guide

### 1. Define Engagement Metrics
- Total daily time spent in app per user
- Breakdown: time_on_feed, time_in_dms, time_in_journals, etc.

### 2. Analyze Changes in Engagement
- Compare pre- and post-feature launch
- Use statistical tests to assess significance

### 3. Visualize Engagement Portfolio
- Stacked bar chart of time allocation by feature
- Highlight shifts between categories

### 4. Interpret Results
> **Interpretation Template:**
> - Did total engagement increase, decrease, or stay the same?
> - Was time simply reallocated, or did the feature create new value?
> - What are the business implications?

### 5. Checklist for Reporting
- [ ] Engagement metrics clearly defined
- [ ] Pre/post analysis performed
- [ ] Visualization included
- [ ] Interpretation addresses business impact

### 6. Example Visualization Code (Python/Matplotlib)
```python
import matplotlib.pyplot as plt
labels = ['Feed', 'DMs', 'Journals']
pre = [30, 10, 0]
post = [20, 8, 12]
plt.bar(labels, pre, label='Pre', alpha=0.6)
plt.bar(labels, post, label='Post', alpha=0.6)
plt.ylabel('Avg Minutes per User')
plt.title('Engagement Portfolio: Pre vs Post Feature Launch')
plt.legend()
plt.show()
```

---

## Deliverable
A notebook containing:
- Statistical tests
- Stacked bar chart
- Clear interpretation of results
