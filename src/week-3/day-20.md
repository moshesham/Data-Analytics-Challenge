# Day 20: Predictive Modeling for Proactive Engagement

## Objective
Build a simple, interpretable model that identifies users most likely to become highly engaged with 'Journals', enabling proactive product interventions.

---

## Step-by-Step Guide

### 1. Define Target Variable
- `is_champion`: 1 if user created 5+ journal entries in first 28 days, else 0

### 2. Engineer Features
- Use only first-week data (e.g., `num_sessions_week1`, `did_use_photo_feature`, `signup_channel`)

### 3. Train Model
- Use logistic regression for interpretability
- Split data into train/test sets

### 4. Identify Key Predictors
- Extract and visualize model coefficients
- List top 3 predictive features
- Discuss what they mean for product strategy

### 5. Checklist for Reporting
- [ ] Target and features clearly defined
- [ ] Model training process described
- [ ] Feature importance visualized
- [ ] Strategic implications discussed

### 6. Example Modeling Code (Python/sklearn)
```python
from sklearn.linear_model import LogisticRegression
from sklearn.model_selection import train_test_split
import pandas as pd
# Assume df is your DataFrame
X = df[['num_sessions_week1', 'did_use_photo_feature', 'signup_channel']]
y = df['is_champion']
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.2)
model = LogisticRegression()
model.fit(X_train, y_train)
print(model.coef_)
```

---

## Deliverable
A notebook with:
- Model training process
- Top 3 predictive features
- Strategic summary
