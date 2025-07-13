# The 30-Day Product Analytics Masterclass: The 'Journals' Sprint

This document outlines the full 30-day curriculum. Each day presents a new challenge that builds upon the last, simulating the real-world experience of a Product Analyst owning a major feature launch from ideation to strategic review.

---

## Week 1: Pre-Launch – The Opportunity and The Plan

### Day 01: The Data Warehouse & The Spark of an Idea

**Objective:** To validate the need for a new feature by performing proactive discovery on raw, qualitative user data.

**Tasks:**

* **Environment Setup:** Set up a local DuckDB environment. Write a script to load the provided `.parquet` files (events, users) and `.csv` file (app_store_reviews) into DuckDB tables.
* **Schema Exploration:** Write a SQL query to explore the schema of the `app_store_reviews` table. Understand its columns, especially `review_text` and `rating`.
* **Keyword Search:** Write SQL queries using `LIKE` or regular expressions to search for keywords like "diary," "journal," "private," "thoughts," and "notes" within the review text.
* **Initial Summary:** In a markdown cell, summarize your findings. How many unique reviews mention these themes? What is the average rating for these reviews compared to the overall average?

### Day 02: Opportunity Sizing & The Business Case

**Objective:** To translate a qualitative signal into a quantitative business case to justify engineering resources.

**Tasks:**

* **Identify User Segment:** Write a SQL query to extract the `user_ids` for users who left the reviews identified on Day 1.
* **Analyze Segment Behavior:** Join this list with the `users` and `events` tables. Calculate this segment's key metrics: number of users, average 90-day retention, and weekly activity level.
* **Build Forecast Model:** In a Pandas notebook, build a simple forecast model. Assume the 'Journals' feature increases this segment's 90-day retention by a relative 15%. Project the total increase in the platform's overall Weekly Active Users (WAU) after one year.
* **Write Recommendation:** Write a one-paragraph summary arguing for or against prioritizing this feature, using your forecast as the core evidence.

### Day 03: The Gold-Standard A/B Test Design

**Objective:** To design a rigorous, trustworthy experiment to measure the causal impact of the 'Journals' feature.

**Tasks:**

* **Define Primary Metric:** In a markdown document, formally define the **Primary Metric**. A good choice is "User Day-28 Retention." Justify why this metric (and not something shorter-term) is the best measure of the feature creating a lasting habit.
* **Define Guardrail Metrics:** Define at least three critical **Guardrail (or Counter) Metrics** (e.g., Time Spent on Main Feed, Direct Messages Sent, Number of App Uninstalls). For each, explain what negative outcome it is designed to detect (e.g., cannibalization, user frustration).
* **Perform Power Analysis:** Using a provided formula or online calculator, perform a power analysis. Calculate the required sample size per group to detect a 2% relative lift in your primary metric, assuming a baseline retention of 20%, a significance level (alpha) of 0.05, and a statistical power of 80%.

### Day 04: The Quasi-Experiment Backup Plan: Difference-in-Differences

**Objective:** To understand and prepare an alternative causal inference method for situations where a perfect A/B test is not feasible.

**Tasks:**

* **Theory Review:** Read a provided article explaining the theory and assumptions of the Difference-in-Differences (DiD) method.
* **Outline Strategy:** In a notebook, outline your DiD strategy for the planned Canada-only MVP launch.
* **Select Groups:** Write a SQL query to select your "Treatment Group" (all users in Canada). Write another query to select a comparable "Control Group" (e.g., users in Australia and New Zealand), justifying your choice with data on similar demographics and baseline engagement trends.
* **Define Periods & Pseudo-Code:** Define the "Pre-Period" (e.g., 30 days before launch) and "Post-Period" (30 days after launch). Write the pseudo-code for the final DiD calculation: $(Treat_{Post\_Avg} - Treat_{Pre\_Avg}) - (Control_{Post\_Avg} - Control_{Pre\_Avg})$.

### Day 05: The BI Dashboard Simulation

**Objective:** To practice defining clear, actionable requirements for monitoring tools, a key collaborative skill for any PA.

**Tasks:**

* **Create Spec Document:** In a markdown file, create a specification document titled "Journals Launch Monitoring Dashboard."
* **Define Visualizations:** Define 5-7 key charts needed. For each, give it a clear title and specify the chart type (e.g., Chart 1: Daily 'Journals' Adopters [Line Chart]; Chart 2: Adoption Funnel [Funnel Chart]).
* **Write Production SQL:** For each defined chart, write the precise, production-ready SQL query that would generate the data for that visualization. Include comments in your SQL to explain the logic.

### Day 06: Proactive Discovery: The Adjacent User

**Objective:** To practice proactive, open-ended data exploration to identify unforeseen opportunities.

**Tasks:**

* **Formulate Hypothesis:** The PM gives you an ambiguous task: "Find a user segment that would love 'Journals' but doesn't know it yet." Formulate a testable hypothesis. Example: "Users who frequently use the 'save post' feature but rarely share content publicly are likely seeking a private way to curate content."
* **Identify Segment:** Write SQL/Pandas code to identify this user segment based on their event behavior over the last 90 days.
* **Analyze and Profile:** Analyze the size, demographics, and overall engagement of this segment.
* **Present Findings:** Create a short profile of this "adjacent user" segment, supported by 2-3 key data points and one compelling visualization.

### Day 07: The Pre-Mortem: A Memo on What Could Go Wrong

**Objective:** To develop strategic foresight by anticipating and planning for potential negative outcomes.

**Tasks:**

* **Draft Memo:** In a markdown document, write a "Pre-Mortem" memo addressed to the 'Journals' feature team.
* **Outline Risks:** Outline the top 3 plausible risks of the launch. Be specific. (e.g., Risk 1: Cannibalization of core feed engagement; Risk 2: Privacy concerns leading to user distrust and negative App Store reviews; Risk 3: The feature is too hidden and adoption is near zero).
* **Define Detection Plan:** For each risk, specify the guardrail metric you defined on Day 3 that will be your early warning system and the threshold that would trigger an alert.

---

## Week 2: The Launch – Monitoring, Triage, and First Signals

**Objective:** Survive the chaos of launch week. You will monitor the data firehose, quickly diagnose problems, and provide clear, real-time updates to your team.

### Day 08: Launch Day! The Real-Time Health Check

**Objective:** To monitor key product and system metrics for immediate, catastrophic anomalies upon feature release.

**Tasks:**

* **Set up Monitoring Queries:** You are given a stream of new `events` data. Write a set of SQL queries that refresh every 5 minutes to track key system health metrics: total events per minute, error event rate, and server latency.
* **Monitor Guardrails:** Track your key guardrail metrics from Day 3 at an hourly grain. Are uninstalls or bug reports spiking?
* **End-of-Day Report:** At the end of the day, create a single visualization plotting the key health metrics throughout the day and add a one-sentence summary: "Launch stable" or "Investigating anomaly in [metric]."

### Day 09: The Fire Drill: Diagnosing a Bug

**Objective:** To isolate the source of a reported user-facing issue with speed and precision to aid engineering.

**Tasks:**

* **Receive Report:** The support team reports a spike in crashes specifically for Android users after updating to the latest app version.
* **Isolate Impact:** Write a SQL query to join `events` (filtering for `event_name = 'app_crash'`) with the `users` table.
* **Segment and Pinpoint:** Group the crash data by `app_version`, `os_version`, and `device_model`. Identify the exact combination that has the highest crash rate.
* **Communicate Findings:** Write a short, clear message as if for a company Slack channel: "@Eng-Team: The Android crash spike is isolated to users on App Version 3.4.1 running Android OS 12, primarily on Samsung Galaxy S21 devices. Crash rate for this segment is 15% vs. 0.1% baseline."

### Day 10: The Adoption Funnel: Are Users Finding It?

**Objective:** To understand and visualize the user path to discovering and using the new feature for the first time.

**Tasks:**

* **Define Funnel Steps:** Define the key steps in the adoption funnel: `app_open` -> `view_main_feed` -> `tap_journals_icon` -> `create_first_journal_entry`.
* **Calculate Conversion:** Write a single, complex SQL query using CTEs or subqueries to calculate the number of unique users who completed each step of the funnel within 24 hours of the feature being available to them.
* **Visualize Funnel:** Use a plotting library to create a classic funnel chart showing the conversion rate between each step.
* **Identify Leakage:** Add an annotation to the chart highlighting the biggest drop-off point.

### Day 11: The "Aha!" Moment: Early Engagement Patterns

**Objective:** To identify the key set of early actions that correlates with a user becoming retained on the new feature.

**Tasks:**

* **Define Cohorts:** Create two user cohorts: "One-Time Users" (created one journal entry in their first 7 days) and "Engaged Users" (created 3+ journal entries in their first 7 days).
* **Explore Early Actions:** For both cohorts, analyze their behavior within their **first session** using 'Journals'. Did they use a specific sub-feature (e.g., add a photo, use a template)? How long did they spend?
* **Find the Correlate:** Identify the single action that has the biggest difference in completion rate between the "Engaged" and "One-Time" cohorts.
* **Formulate Hypothesis:** State your finding as a hypothesis: "We believe that users who add a photo to their first journal entry are 3x more likely to become engaged users. This is our 'Aha!' Moment."

### Day 12: Stakeholder Communication: The 3 Talking Points

**Objective:** To practice distilling complex, nuanced data into a concise, memorable summary for an executive audience.

**Tasks:**

* **Review the Week's Data:** Look at everything you've learned from Day 8 to Day 11.
* **Synthesize:** Draft three clear, data-backed talking points. Each should be a single sentence.
    * Example 1 (The Good): "Early adoption is tracking 15% ahead of our initial forecast, with over 50,000 users creating a journal entry in the first week."
    * Example 2 (The Bad): "However, our adoption funnel shows significant user drop-off before the first entry is created, suggesting a discoverability issue we need to address."
    * Example 3 (The Interesting): "Our most engaged new users are those who add a photo to their first entry, pointing to a potential 'Aha!' moment we can encourage in the onboarding flow."
* **Refine:** Edit your talking points for clarity, impact, and brevity.

### Day 13: The First A/B Test Readout (Week 1 Data)

**Objective:** To conduct a preliminary experiment analysis while responsibly communicating the risks and uncertainties of early results.

**Tasks:**

* **Pull Data:** You are given the first 7 days of A/B test data.
* **Run Analysis:** Calculate the primary metric (Day-7 Retention, in this case) for the control and treatment groups. Calculate the p-value and confidence interval for the difference.
* **Check Guardrails:** Briefly check the key guardrail metrics. Are there any alarming early signals?
* **Draft Update:** Write a short update memo. Start by clearly stating the preliminary result (e.g., "Treatment group shows a +1.5% relative lift in D7 retention"). Immediately follow this with a strong caveat about statistical noise, the novelty effect, and why this result is not final.

### Day 14: Analyzing Qualitative Feedback

**Objective:** To integrate unstructured, qualitative text data into your quantitative analysis to get a complete picture of user sentiment.

**Tasks:**

* **Load Data:** You are given a `feedback.csv` file with 500 user comments about the new 'Journals' feature. Load it into Pandas.
* **Basic NLP:** Write a simple Python function that categorizes each comment based on keywords. Categories should be "Bug Report," "Feature Request," "General Praise," and "Privacy Concern."
* **Quantify Themes:** Create a bar chart showing the count of comments in each category.
* **Synthesize:** Write a summary paragraph that combines a quantitative insight with a qualitative one. Example: "While our metrics show strong initial adoption, the qualitative feedback reveals that 'Privacy Concerns' are the second-largest category of comments, suggesting we need to improve our user-facing communication about data security."

---

## Week 3: The Deep Dive – Causal Impact and Long-Term Value

**Objective:** Go beyond surface-level metrics to understand the feature's true, causal impact on user behavior and its long-term value to the business.

### Day 15: The Definitive A/B Test Analysis

**Objective:** To determine the feature's final, causal impact with full statistical rigor after the experiment has concluded.

**Tasks:**

* **Receive Final Data:** You are given the full 28-day A/B test dataset.
* **Calculate Final Results:** Re-run your analysis on the primary metric (Day-28 Retention). Calculate the final p-value and the 95% confidence interval for the lift.
* **Analyze Guardrail Metrics:** Perform a full statistical analysis on your key guardrail metrics. Did the feature cause a significant drop in feed engagement?
* **Write Conclusion:** Write a clear, unambiguous conclusion statement: "The 'Journals' feature caused a statistically significant X% relative increase in Day-28 retention (95% CI: \[Y%, Z%\], p < 0.001) with no significant negative impact on core engagement metrics."

### Day 16: The Difference-in-Differences Analysis in Practice

**Objective:** To apply and compare a quasi-experimental method to the A/B test results, understanding its strengths and limitations.

**Tasks:**

* **Execute DiD Analysis:** Using the plan from Day 4, execute the Difference-in-Differences analysis on the Canada (treatment) and Australia/NZ (control) launch data.
* **Calculate DiD Estimate:** Calculate the final DiD estimate for the lift in the primary metric.
* **Compare Results:** Create a table comparing the result from the A/B test (the "ground truth") with the result from the DiD analysis.
* **Critique the Method:** Write a paragraph discussing why the DiD result was or was not close to the A/B test result. Mention potential confounding factors (e.g., a national holiday in one country).

### Day 17: Cannibalization or Creation?

**Objective:** To answer the critical and ambiguous strategic question of whether the feature generated net new engagement.

**Tasks:**

* **Define Metric:** The key metric is "Total Daily Time Spent in App per User."
* **Analyze A/B Test Data:** Using the full A/B test dataset, calculate the average of this metric for both the control and treatment groups.
* **Run Significance Test:** Perform a t-test to determine if there is a statistically significant difference in total time spent.
* **Interpret the Result:** Write a clear conclusion. Example: "The feature did not significantly increase total time in app, but it shifted 2 minutes of daily time from the main feed into 'Journals'. This indicates the feature is currently a substitute for, not an expansion of, user engagement."

### Day 18: Impact on Long-Term Retention

**Objective:** To use cohort analysis to measure the feature's effect on user stickiness over a longer time horizon.

**Tasks:**

* **Create Cohorts:** Using the A/B test data, create two cohorts: "Control Group Users" and "Treatment Group Users" who signed up during the experiment window.
* **Calculate Retention Curves:** For both cohorts, calculate their retention curves for Day 1, Day 7, Day 14, Day 21, and Day 28.
* **Visualize the Curves:** Plot both retention curves on the same line chart.
* **State the Finding:** Add a title to the chart that clearly states the finding, e.g., "'Journals' Feature Lifted Long-Term Retention by an Average of 2.5% over 28 Days."

### Day 19: The Engagement Loop Deep Dive

**Objective:** To prove whether the feature created a new, valuable, habit-forming loop that brings users back to the product.

**Tasks:**

* **Hypothesize a Loop:** Propose a testable engagement loop. Example: "A user receives a push notification reminder about their journal -> The user opens the app within 24 hours."
* **Identify User Groups:** Using the `events` data, create two groups of users who have used 'Journals': those who received a reminder notification and those who did not.
* **Measure Return Rate:** For both groups, calculate their return rate on the following day (Next-Day Retention).
* **Validate the Loop:** Compare the retention rates. If the notified group has a significantly higher retention rate, you have evidence for a new engagement loop.

### Day 20: Predictive Modeling: 'Journal Champions'

**Objective:** To use a simple ML model to identify users who are most likely to become highly engaged with the new feature.

**Tasks:**

* **Define Target Variable:** Create a target variable `is_champion`, which is `1` for users who created 5+ journal entries in their first 28 days and `0` otherwise.
* **Engineer Features:** Create features from users' **first week** of data (e.g., `signup_channel`, `num_sessions_week1`, `used_photo_feature`).
* **Train Model:** Train a simple logistic regression model to predict `is_champion` based on the week 1 features.
* **Interpret Coefficients:** The goal is not accuracy, but interpretation. Identify the top 3 features with the most significant positive coefficients. These are the strongest early indicators of a future "Journal Champion."

### Day 21: The One-Slide Story

**Objective:** To master the art of telling a complete, compelling data story in a single, powerful visual.

**Tasks:**

* **Review the Week:** Review all your findings from Day 15-20.
* **Choose the Core Narrative:** Decide on the single most important message (e.g., "Journals successfully boosts retention but doesn't grow overall engagement.").
* **Design the Slide:** Design a single presentation slide. It should contain no more than 3 key charts/numbers and a single, clear takeaway sentence as the title.
* **Add Speaker Notes:** In the "speaker notes" section, write a brief script that explains the slide's content in under 60 seconds.

---

## Week 4: The Strategy – The Future of the 'Journals' Feature

**Objective:** You've analyzed the past; now you will shape the future. You will use your insights to build a strategic roadmap and justify the future investment in your feature.

### Day 22: Lifetime Value (LTV) Modeling

**Objective:** To quantify the feature's impact on the company's bottom line by modeling its effect on user lifetime value.

**Tasks:**

* **Build a Simple LTV Formula:** Use the formula: LTV = (Average Revenue Per User per Month) * (1 / Monthly Churn Rate).
* **Calculate LTV for Control:** Using data from the control group of your A/B test, calculate their monthly churn rate and assume an ARPU of $1.00 to find their LTV.
* **Calculate LTV for Treatment:** Do the same for the treatment group. Their lower churn rate (higher retention) should result in a higher LTV.
* **Quantify Business Impact:** Calculate the total projected LTV increase across all users who will receive the feature.

### Day 23: The "Iterate, Expand, or Kill" Framework

**Objective:** To use a structured, data-driven framework to make a clear and defensible product lifecycle decision.

**Tasks:**

* **Create Scorecard:** Create a markdown table with three columns: "Metric," "Result," and "Score (-1, 0, or 1)."
* **Fill the Scorecard:** Populate the table with your key findings.
    * Day-28 Retention Lift: +2.5% (Score: +1)
    * Net Engagement (Cannibalization): Neutral (Score: 0)
    * Adoption Rate: 15% (Score: +1)
    * Negative Guardrail Impact: None (Score: +1)
    * LTV Impact: +$0.50 per user (Score: +1)
* **Make Recommendation:** Sum the scores. Based on the total, write a formal recommendation: "Based on a strongly positive data scorecard, I recommend we fully expand the 'Journals' feature to all users."

### Day 24: Building the V2 Roadmap

**Objective:** To use data to inform and propose the next set of impactful feature improvements.

**Tasks:**

* **Synthesize Inputs:** Review your findings on the adoption funnel (Day 10), the 'Aha!' moment (Day 11), and qualitative feedback (Day 14).
* **Propose Improvements:** Based on this synthesis, propose the top 3 most impactful improvements for "Journals V2."
* **Justify with Data:** For each proposed improvement, write one sentence justifying it with data. Example: "1. Improve discoverability by adding an entry point on the main feed (to address the 50% drop-off in our adoption funnel). 2. Prompt users to add a photo during onboarding (to trigger our 'Aha!' moment)."

### Day 25: The Broader Product Strategy

**Objective:** To practice strategic thinking by extrapolating learnings from one feature to the entire product ecosystem.

**Tasks:**

* **Identify a Core Insight:** Choose the single most surprising or powerful insight you learned during the sprint (e.g., "Our users have a strong, unmet need for private, self-expression features.").
* **Draft a Strategy Memo:** Write a short memo to the Head of Product.
* **Connect to Strategy:** In the memo, explain how this core insight should influence the company's overall strategy. Propose that the company should explore a new "Privacy & Wellness" product pillar, with 'Journals' as the first step.

### Day 26: Preparing for the QBR (Behavioral Storytelling)

**Objective:** To practice crafting compelling, concise narratives about your work to prepare for behavioral interviews and presentations.

**Tasks:**

* **Reflect on the Journey:** Review all the challenges from the past 25 days.
* **Draft STAR Stories:** Write out three stories using the STAR method (Situation, Task, Action, Result).
    * One story about a technical challenge you overcame (e.g., the Day 9 fire drill).
    * One story about how you used data to influence a decision (e.g., the Day 23 framework).
    * One story about a time you dealt with ambiguity (e.g., the Day 6 open-ended discovery task).
* **Practice and Refine:** Read your stories aloud and refine them for clarity and impact.

### Day 27-30: Capstone: The Quarterly Business Review (QBR) Presentation

**Objective:** To synthesize the entire 30-day journey into a strategic, executive-level presentation that demonstrates impact and influences company direction.

**Tasks:**

* **Outline the Narrative:** Structure your presentation as a compelling story: The Opportunity, The Experiment, The Results, The Business Impact, and The Recommendation.
* **Create the Slides:** Create a polished 5-slide presentation. Use the "One-Slide Story" from Day 21 as your centerpiece.
* **Write the Supporting Doc:** Create a detailed supporting document that links to your notebooks and provides the full data and methodology behind every number in your presentation.
* **Record/Practice Presentation:** Practice delivering your 5-minute presentation as if you were in a real QBR meeting. The goal is to be clear, confident, and persuasive.