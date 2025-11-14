# Day 18: Retention Curves & The Lift Over Time

## Objective
Visualize and quantify the feature's impact on user retention over the entire 28-day user lifecycle, not just on a single day.

---

## Step-by-Step Guide

### 1. Create Cohorts
- Use A/B test data to create "Control Group Users" and "Treatment Group Users" cohorts based on join date.

### 2. Calculate Retention Curves
- For each cohort, calculate daily retention rates from Day 1 to Day 28.

### 3. Visualize the Curves
- Plot both retention curves on the same line chart.
- Annotate the chart to highlight the average daily lift.
- Title example: "'Journals' Feature Sustains an Average +2.5% Retention Lift Over 28 Days."

### 4. Checklist for Reporting
- [ ] Cohorts are clearly defined
- [ ] Retention rates calculated for all days
- [ ] Visualization includes both curves and annotations
- [ ] Title tells the story

### 5. Example Visualization Code (Python/Matplotlib)
```python
import matplotlib.pyplot as plt
import numpy as np
x = np.arange(1, 29)
control = np.random.uniform(0.15, 0.20, size=28)
treatment = control + 0.025
plt.plot(x, control, label='Control')
plt.plot(x, treatment, label='Treatment')
plt.xlabel('Day')
plt.ylabel('Retention Rate')
plt.title("'Journals' Feature Sustains an Average +2.5% Retention Lift Over 28 Days")
plt.legend()
plt.show()
```

---

## Deliverable
A notebook with:
- SQL/Python code to generate retention data
- Clearly titled line chart
- Short summary of findings
