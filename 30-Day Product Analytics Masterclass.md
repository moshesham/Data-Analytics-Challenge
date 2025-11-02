# The 30-Day Product Analytics Masterclass: The 'Journals' Sprint

This document outlines the full 30-day curriculum. Each day presents a new challenge that builds upon the last, simulating the real-world experience of a Product Analyst owning a major feature launch from ideation to strategic review.

---
## Week 1: Foundations & Framing – From Idea to Plan

**Goal:** Transform a vague product idea into a concrete, data-backed, and measurable plan.

### Day 01: The Data Warehouse & Opportunity Discovery

*   **Objective:** To validate the need for a new feature by performing proactive discovery on raw, qualitative user data.
*   **Why This Matters:** Great analysis starts with curiosity. Before complex modeling, you must be able to explore raw data to find signals of unmet user needs.
*   **Tasks:**
    1.  **Environment Setup:** Familiarize yourself with the Docker environment. Create a new notebook `01_opportunity_validation.ipynb`. Write a Python script using the `duckdb` library to load the provided `.parquet` files (`events`, `users`) and `.csv` file (`app_store_reviews`) into DuckDB tables.
    2.  **Schema Exploration:** Write SQL queries to explore the schema and first 10 rows of each table. Understand their columns and relationships.
    3.  **Qualitative Signal Mining:** Write a SQL query using `LOWER()` and `LIKE` to search for keywords like `%diary%`, `%journal%`, `%private%`, `%thoughts%`, and `%notes%` within the `review_text` column.
    4.  **Initial Quantification:** Use a CTE to first identify reviews with these keywords, then calculate the total count of these reviews and their average star `rating`. Compare this average rating to the overall average rating for all reviews.
*   **Deliverable:** A notebook containing the setup script and SQL queries, with a markdown cell summarizing your findings: "We found X reviews mentioning journaling themes, with an average rating of Y, which is Z points lower/higher than the platform average. This suggests a passionate, potentially underserved user group."

### Day 02: Opportunity Sizing & The Business Case

*   **Objective:** To translate a qualitative signal into a quantitative business case to justify engineering resources.
*   **Why This Matters:** A good idea is not enough. You must be able to quantify the potential impact on core business metrics to get buy-in for your project.
*   **Tasks:**
    1.  **Identify User Segment:** Write a SQL query to extract the unique `user_id`s for users who left the keyword-positive reviews identified on Day 1.
    2.  **Analyze Segment Behavior:** Join this list of `user_id`s with the `users` and `events` tables. Calculate this segment's key metrics: number of users, average 90-day retention, and average number of sessions per week.
    3.  **Build Forecast Model:** In a Pandas notebook, build a simple forecast. **Assumption:** The 'Journals' feature will increase this specific segment's 90-day retention by a relative 15%. Project the *net new* Weekly Active Users (WAU) this would add to the platform after one year.
    4.  **Write Recommendation:** Write a one-paragraph summary titled "Business Case for 'Journals' Feature." Use your forecast as the core evidence to argue for or against prioritizing this feature.
*   **Deliverable:** A notebook with the segment analysis and forecast, concluding with the clear, data-backed recommendation.

### Day 03: The Instrumentation Plan & Success Metrics

*   **Objective:** To define exactly what user actions need to be tracked and what metrics will define success, before any code is written.
*   **Why This Matters:** If you can't measure it, you can't improve it. An instrumentation plan is the contract between Product, Engineering, and Analytics that ensures you have the data you need to make decisions.
*   **Tasks:**
    1.  **Create Spec Document:** In a markdown file named `Journals_Instrumentation_Plan.md`, create a spec for the engineering team.
    2.  **Define Events:** List the new events that need to be tracked. Be precise. Example:
        *   `event_name: view_journals_page`, `properties: {source: 'main_feed_icon'}`
        *   `event_name: create_journal_entry`, `properties: {has_photo: true, template_used: 'gratitude_template'}`
    3.  **Define Success Metrics:** Formally define the Primary and Secondary metrics.
        *   **Primary Metric:** Day-28 User Retention. (Justify why this reflects long-term habit formation).
        *   **Secondary Metrics:** Journal Entries per User per Week, % of WAU using Journals.
    4.  **Define Guardrail Metrics:** Define at least three critical **Guardrail (or Counter) Metrics** (e.g., Time Spent on Main Feed, Direct Messages Sent, App Uninstalls). For each, explain what negative outcome it is designed to detect (e.g., cannibalization, user frustration).
*   **Deliverable:** The completed `Journals_Instrumentation_Plan.md` file.

### Day 04: The Gold-Standard A/B Test Design

*   **Objective:** To design a rigorous, trustworthy experiment to measure the causal impact of the 'Journals' feature.
*   **Why This Matters:** Correlation is not causation. A well-designed A/B test is the most reliable way to prove that your feature *caused* an outcome, eliminating guesswork.
*   **Tasks:**
    1.  **Define Hypothesis:** In a markdown document, state a clear, falsifiable hypothesis: "We hypothesize that providing users with the 'Journals' feature will lead to a statistically significant increase in Day-28 User Retention."
    2.  **Define Experiment Parameters:** Define the population (e.g., All iOS users in US, UK, CA), the allocation (50/50 split), and the duration (28 days + time to mature).
    3.  **Perform Power Analysis:** Using the `statsmodels.stats.power` library in Python, perform a power analysis. Calculate the required sample size per group to detect a 2% relative lift in your primary metric (Day-28 Retention), assuming a baseline retention of 20%, a significance level (alpha) of 0.05, and statistical power of 80%.
    4.  **Write Summary:** Conclude with a sentence: "We require a minimum of N users per group and estimate the experiment will need to run for X days to reach this sample size."
*   **Deliverable:** A notebook containing the power analysis code and a markdown summary of the complete A/B test design.

### Day 05: The Quasi-Experiment Backup Plan: Difference-in-Differences

*   **Objective:** To design an alternative causal inference method for situations where a perfect A/B test is not feasible (e.g., a phased rollout).
*   **Why This Matters:** A/B tests are not always possible. Knowing quasi-experimental methods like DiD allows you to estimate causal impact in complex, real-world scenarios.
*   **Tasks:**
    1.  **Theory Review:** Read a provided article explaining the theory and crucial "parallel trends" assumption of the Difference-in-Differences (DiD) method.
    2.  **Outline Strategy:** The team plans a Canada-only MVP launch first. Outline your DiD strategy in a notebook.
    3.  **Select Groups & Validate Assumption:** Write SQL queries to select your "Treatment Group" (users in Canada) and a "Control Group" (e.g., users in Australia & New Zealand). **Critically, plot the weekly retention trends for both groups over the 3 months *prior* to the hypothetical launch to visually check the parallel trends assumption.**
    4.  **Define Periods & Pseudo-Code:** Define the "Pre-Period" (4 weeks before launch) and "Post-Period" (4 weeks after launch). Write the pseudo-code for the final DiD calculation: `(Treat_Post_Avg - Treat_Pre_Avg) - (Control_Post_Avg - Control_Pre_Avg)`.
*   **Deliverable:** A notebook containing the SQL for group selection, the parallel trends plot, and the DiD pseudo-code.

### Day 06: The BI Dashboard Specification

*   **Objective:** To practice defining clear, actionable requirements for monitoring tools, a key collaborative skill for any Product Analyst.
*   **Why This Matters:** You are the domain expert. A BI developer builds what you tell them to build. A precise spec ensures the final dashboard is useful and answers the most important business questions.
*   **Tasks:**
    1.  **Create Spec Document:** In a markdown file, create a specification document titled "Journals Launch Monitoring Dashboard."
    2.  **Define Core KPIs:** List the 3-5 headline KPIs that should be at the top (e.g., Total Journal Adopters, Adoption Rate %, Entries Created Today).
    3.  **Define Visualizations:** Define 5-7 key charts. For each, specify: Title, Chart Type, X-axis, Y-axis, and required filters (e.g., Date Range, Country).
        *   Example: *Chart 1: Daily 'Journals' Adopters (New Users Creating First Entry) | Type: Line Chart | X-Axis: Day | Y-Axis: Count of Unique Users.*
    4.  **Write Production SQL:** For at least three of the charts, write the precise, production-ready SQL query that would generate the data. Include comments explaining the logic.
*   **Deliverable:** The completed dashboard specification document.

### Day 07: The Pre-Mortem: A Memo on What Could Go Wrong

*   **Objective:** To develop strategic foresight by anticipating and planning for potential negative outcomes before they happen.
*   **Why This Matters:** A good analyst doesn't just report on what happened; they anticipate what *could* happen. This builds trust and helps the team avoid preventable failures.
*   **Tasks:**
    1.  **Draft Memo:** In a markdown document, write a "Pre-Mortem Memo" addressed to the 'Journals' feature team.
    2.  **Outline Risks:** Outline the top 3 plausible risks of the launch. Be specific and tie them to metrics.
        *   *Risk 1: Cannibalization.* "The feature could divert engagement from our core feed, leading to a drop in total session time and ad revenue."
        *   *Risk 2: Privacy Backlash.* "Users may not trust our data privacy, leading to negative App Store reviews and a spike in account deletions."
        *   *Risk 3: Failed Adoption.* "The feature's UI could be confusing, leading to a near-zero adoption rate and wasted engineering effort."
    3.  **Define Detection Plan:** For each risk, specify the guardrail metric (from Day 3) that will be your early warning system and the threshold that would trigger an alert (e.g., "If `avg_main_feed_time_spent` drops by a statistically significant 5% in the first week, we will escalate").
*   **Deliverable:** The completed pre-mortem memo.

## Week 2: The Crucible – Monitoring, Triage, and First Signals

**Goal:** This week simulates the chaos and opportunity of a real feature launch. Your role will evolve from a reactive monitor to a proactive diagnostician and trusted communicator. You will learn to find the signal in the noise, provide clarity when there is ambiguity, and lay the groundwork for the strategic deep dives in Week 3. By the end of this week, you will have moved from simply reporting numbers to interpreting their meaning and recommending action.

### Day 08: Launch Day! The Command Center

*   **Objective:** To establish and run the "command center," actively assessing product and system health to provide the team with the first all-clear signal.
*   **Why This Matters:** Before asking "Are they using it?", you must confidently answer "Is it working?". As the analyst, you are the first line of defense, responsible for building trust in the data and the product's stability from the very first hour.
*   **Tasks:**
    1.  **Establish Monitoring Dashboards:** In notebook `08_launch_monitoring.ipynb`, write two sets of SQL queries intended to be run every 15 minutes:
        *   **System Health Dashboard:** Tracks core infrastructure stability. Metrics: `total_events_per_minute`, `app_crash_event_rate`, `avg_server_latency_ms`.
        *   **Product Adoption Dashboard:** Tracks the earliest signs of user engagement. Metrics: `count_unique_users_tapping_icon`, `count_first_journal_entries_created`.
    2.  **Set Alert Thresholds:** Define and document simple thresholds for your guardrail metrics (e.g., "Alert if `app_uninstalls_per_hour` exceeds the pre-launch average by 20%"). Monitor these throughout the day.
    3.  **Create the End-of-Day Sign-Off:** At the end of the launch day, produce a concise summary report. It should include a single visualization plotting the key health metrics and a three-point conclusion:
        *   **System Status:** Stable. Crash rates and latency remained within acceptable thresholds.
        *   **Initial Adoption Signal:** Positive. Over 1,200 users created a first entry, with a steady stream of new adopters.
        *   **Overall Assessment:** Launch is stable. All clear to proceed with monitoring.
*   **Deliverable:** The `08_launch_monitoring.ipynb` notebook containing the monitoring queries, the end-of-day visualization, and the structured sign-off report.

### Day 09: The Fire Drill – Precision Bug Triage

*   **Objective:** To move from a vague bug report to a precise, actionable diagnosis that empowers the engineering team to resolve the issue quickly.
*   **Why This Matters:** A great analyst is an engineer's best friend during a crisis. By isolating the "blast radius" of a bug, you save countless hours of guesswork and turn a panic-inducing problem into a solvable one.
*   **Tasks:**
    1.  **The Report:** A Jira ticket is filed: "Android users are complaining about crashes since the update."
    2.  **Quantify and Isolate:** Write a SQL query that joins `events` (filtering for `event_name = 'app_crash'`) with the `users` table. The goal is to find the combination of dimensions (`app_version`, `os_version`, `device_model`) with the highest crash rate.
    3.  **Calculate Severity:** Don't just count crashes. Calculate the *crash rate per user* for the affected segment and compare it to the baseline rate for all other Android users. This quantifies the severity.
    4.  **Write the Triage Report:** In notebook `09_bug_triage.ipynb`, draft a formal triage report in a markdown cell, formatted for clarity:
        *   **Subject:** Confirmed & Isolated: Android Crash Spike on App v3.4.1
        *   **Summary:** The reported crash spike is confirmed and isolated to a specific user segment.
        *   **Impacted Segment:** Users on `App Version 3.4.1` running `Android OS 12`, primarily on `Samsung Galaxy S21` devices.
        *   **Severity:** This segment is experiencing a **15% crash rate per session**, compared to a **0.1% baseline** for the rest of the Android user base.
        *   **Recommendation:** High-priority ticket for the Android engineering team. Data query available for further debugging.
*   **Deliverable:** A notebook containing the diagnostic query and the professionally formatted Bug Triage Report.

### Day 10: The Adoption Funnel – Diagnosing User Friction

*   **Objective:** To visualize the user journey into the feature and pinpoint the exact step where most users are dropping off.
*   **Why This Matters:** A feature's failure is often not due to a lack of value, but to friction. The funnel is your x-ray for seeing exactly where that friction occurs in the user experience.
*   **Tasks:**
    1.  **Define a Time-Bound Funnel:** Define the key steps: `app_open` -> `view_main_feed` -> `tap_journals_icon` -> `create_first_journal_entry`. **Crucially, a user must complete all steps within a single session to count.**
    2.  **Write the Funnel Query:** In `10_adoption_funnel.ipynb`, write a single, robust SQL query using Common Table Expressions (CTEs) or `LEFT JOIN`s to calculate the number of unique users who completed each step *within the same session*.
    3.  **Visualize and Annotate:** Use a plotting library to create a funnel chart. The title must be clear: "Journals Adoption Funnel (Within First Session)."
    4.  **Identify Leakage & Formulate a Product Hypothesis:** Annotate the chart to highlight the biggest drop-off point. Below the chart, write a specific, testable product hypothesis to address it. Example: "The 60% drop-off between viewing the feed and tapping the icon suggests low discoverability. **We hypothesize that changing the icon color and adding a 'New' badge will increase the tap-through rate by 20%.**"
*   **Deliverable:** A notebook with the time-bound funnel query, the annotated chart, and a clear, testable product hypothesis.

### Day 11: The "Aha!" Moment – Finding the Magic Action

*   **Objective:** To find the early user action that most strongly correlates with long-term feature retention, while understanding the limits of correlation.
*   **Why This Matters:** The "Aha!" moment is where a user internalizes a product's value. Identifying it gives the product team a powerful lever to improve user onboarding and drive habit formation.
*   **Critical Thinking Check:** This analysis reveals **correlation, not causation**. A user who adds a photo might be more motivated to begin with. Your job is to find the signal and frame it correctly as a hypothesis to be tested later.
*   **Tasks:**
    1.  **Define User Cohorts:** Based on the first 7 days of feature usage, create two distinct groups:
        *   **"Engaged & Retained":** Users who created ≥ 3 journal entries.
        *   **"Churned Adopters":** Users who created only 1 journal entry and never returned to the feature.
    2.  **Analyze First-Session Behavior:** For both cohorts, calculate the percentage of users who performed key actions (`used_template`, `added_photo`, `wrote_over_100_chars`) during their **very first session**.
    3.  **Isolate the Strongest Signal:** Find the action with the largest *relative difference* in completion rates between the "Engaged" and "Churned" cohorts.
    4.  **Formulate a Careful Hypothesis:** In notebook `11_aha_moment_analysis.ipynb`, state your finding with analytical precision. Example: "We've identified a strong correlation: Users who add a photo to their first journal entry are 3x more likely to become retained on the feature. **We hypothesize that this action represents the 'Aha!' moment. To test this, we should build an A/B test that encourages photo uploads during onboarding.**"
*   **Deliverable:** The notebook containing the cohort analysis and the carefully worded, actionable hypothesis.

### Day 12: The Weekly Launch Memo – Communicating with Clarity

*   **Objective:** To synthesize a week of complex findings into a clear, concise, and persuasive memo for leadership and the broader team.
*   **Why This Matters:** Data only drives decisions when it is communicated effectively. This memo is your chance to shape the narrative, manage expectations, and guide the team's focus for the upcoming week.
*   **Tasks:**
    1.  **Review the Week's Learnings:** Re-read your findings from Days 8-11.
    2.  **Draft the Memo:** In a new file `Week1_Launch_Summary.md`, draft a memo using a structured format that executives appreciate.
        *   **Subject:** 'Journals' Launch: Week 1 Data Summary & Recommendations
        *   **TL;DR:** One sentence summarizing the state of the launch. (e.g., "Launch is stable with promising early adoption, but a clear discoverability issue is limiting its reach.")
        *   **The Good (Wins):** "Adoption is tracking 15% ahead of forecasts..."
        *   **The Bad (Challenges):** "A significant 60% of users drop off before finding the feature..."
        *   **The Insights (Learnings):** "We've found a powerful correlation between adding a photo and long-term retention..."
        *   **Actionable Recommendations:** "Based on this data, our priorities for Week 2 are: 1. Design an A/B test for a more prominent entry point. 2. Scope a 'photo suggestion' feature for onboarding."
*   **Deliverable:** The completed, professionally structured `Week1_Launch_Summary.md` memo.

### Day 13: The Early A/B Test Readout – Resisting Pressure

*   **Objective:** To analyze preliminary A/B test data while masterfully managing stakeholder expectations and preventing premature decision-making.
*   **Why This Matters:** The single fastest way to lose credibility as an analyst is to endorse a decision based on noisy, statistically insignificant early data. Your role is to be the voice of statistical integrity.
*   **Tasks:**
    1.  **The Ask:** A Product Manager asks, "It's been 7 days, how is the A/B test looking? Are we winning?"
    2.  **Run the Analysis:** Using the first 7 days of data, calculate the primary metric (Day-7 Retention as a proxy) for control and treatment. Calculate the p-value and 95% confidence interval.
    3.  **Draft the Update Memo:** Write a `AB_Test_Week1_Update.md` memo that provides the data while heavily reinforcing correct statistical practice.
        *   **Headline:** State the raw numbers. (e.g., "Preliminary D7 retention shows a +1.5% relative lift for treatment.")
        *   **Statistical Readout:** Provide the figures. (e.g., "95% CI: [-0.5%, +3.5%], p-value: 0.25").
        *   **Mandatory Analyst Caveats:** This section is non-negotiable.
            *   **Statistical Significance:** "This result is **not statistically significant**. The p-value indicates this could easily be due to random chance."
            *   **Novelty Effect:** "Early lift is often inflated by user curiosity and should not be considered indicative of long-term behavior."
            *   **Conclusion:** "Per our experimental design, we will not make a decision until the full 28-day data is available. This preliminary result is for monitoring purposes only."
*   **Deliverable:** The update memo that perfectly balances transparency with statistical responsibility.

### Day 14: Weaving the Narrative – Quant + Qual

*   **Objective:** To combine quantitative metrics with qualitative user feedback to create a holistic and deeply empathetic understanding of the user experience.
*   **Why This Matters:** Numbers tell you *what* users do; words tell you *how they feel*. The most powerful insights lie at the intersection of both. This skill separates a data reporter from a true product strategist.
*   **Tasks:**
    1.  **Load and Categorize:** Load the `feedback.csv` file. Use simple regex or keyword matching in Python to categorize feedback into themes like "Bug Report," "Feature Request," "Praise," and "Privacy Concern." Create a bar chart of the themes.
    2.  **Find the Story:** Look for a connection. Does the qualitative data explain, contradict, or add nuance to a quantitative finding from earlier in the week?
    3.  **Write the Synthesized Insight:** In `14_qualitative_analysis.ipynb`, write a paragraph that weaves the two data sources together into a single, powerful narrative.
        *   **Example:** "While our quantitative funnel analysis (Day 10) pointed to a major discoverability problem, our qualitative feedback provides the 'why'. Of the 50 comments categorized as 'Praise', over 80% include phrases like 'I finally found this' or 'I wish I knew about this sooner'. This strongly supports our hypothesis that the feature's value proposition is strong, but its current placement is failing our users."
*   **Deliverable:** A notebook containing the theme analysis and a paragraph demonstrating a masterful synthesis of quantitative and qualitative data.

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

Of course. This is the crucial part of the masterclass where the analyst transitions from reporting on the "what" to explaining the "why" and influencing the "what's next."

I have performed a thorough review of the original Week 3 and 4 content, improving it to align with the rigor and strategic focus of the revised Weeks 1 and 2. My goal was to deepen the analytical concepts, introduce more real-world complexities, and transform the final week into a true capstone strategy project.

Here is the fully revised and improved curriculum for Week 3 and Week 4 in Markdown format.

---

## Week 3: The Deep Dive – Causal Impact and Strategic Value

**Goal:** Move beyond surface-level metrics to answer the two most critical questions about your feature: "Did it actually *cause* the changes we see?" and "What is its true, long-term value to the business?" This week, you will deploy your most rigorous analytical skills to build an unshakeable, data-driven case for the feature's impact.

### Day 15: The Definitive A/B Test Readout

*   **Objective:** To determine the feature's final, causal impact with full statistical rigor and to communicate the results in a formal, shareable experiment readout document.
*   **Why This Matters:** This is the moment of truth. A definitive A/B test analysis is the gold standard for data-driven decision-making. The clarity and integrity of your final report will determine the entire team's confidence in the results.
*   **Tasks:**
    1.  **Receive Final Data:** You are given the full 28-day A/B test dataset.
    2.  **Analyze Primary Metric:** Calculate the final lift, 95% confidence interval, and p-value for your primary metric (Day-28 Retention).
    3.  **Analyze Guardrail & Secondary Metrics:** Perform a full statistical analysis on your key guardrail metrics (e.g., Time on Feed, App Uninstalls) and secondary success metrics (e.g., Journals entries per user). Did the feature cause any significant negative (or positive) side effects?
    4.  **Segment Analysis:** Does the feature's impact differ across key user segments (e.g., New vs. Existing Users, iOS vs. Android)? Conduct a segmented analysis on the primary metric.
*   **Deliverable:** A formal `AB_Test_Final_Readout.md` memo. It must include:
    *   An executive summary with the main conclusion.
    *   A table showing the results for the primary, secondary, and guardrail metrics (including CIs and p-values).
    *   A visualization of the key results.
    *   A clear, final recommendation: "Declare a winning or losing variant."

### Day 16: The Quasi-Experiment Post-Mortem

*   **Objective:** To execute the Difference-in-Differences (DiD) analysis and critically compare its results to the "ground truth" of the A/B test, understanding its limitations.
*   **Why This Matters:** You won't always have an A/B test. This exercise teaches you to critically evaluate the results of quasi-experiments by comparing them to a known truth, building your intuition for when these methods are reliable and when they are not.
*   **Tasks:**
    1.  **Execute DiD Analysis:** Using your plan from Day 5, execute the DiD analysis on the Canada (treatment) vs. Australia/NZ (control) launch data.
    2.  **Calculate DiD Estimate:** Calculate the final DiD estimate for the lift in the primary metric.
    3.  **Create a Comparison Report:** In a notebook `16_did_vs_ab_test.ipynb`, create a clear table comparing the results:
        *   Row 1: A/B Test Result (Lift %, 95% CI)
        *   Row 2: DiD Result (Lift %, No CI needed for this exercise)
    4.  **Write a Critical Assessment:** Write a paragraph titled "Why DiD Deviated from the A/B Test." Discuss potential confounding factors you couldn't control for (e.g., a national holiday in Canada, a marketing campaign in Australia, underlying demographic differences not visible in the data).
*   **Deliverable:** The notebook containing the DiD calculation, the comparison table, and the critical assessment paragraph.

### Day 17: Cannibalization vs. Creation – The Engagement Portfolio

*   **Objective:** To answer the critical strategic question: did the feature generate *net new* engagement, or did it just shift existing behavior from one part of the app to another?
*   **Why This Matters:** A feature that simply shuffles engagement around doesn't grow the business. It might still be valuable for retention, but leadership needs to know if it's a true expansion of the user experience or just a substitution.
*   **Tasks:**
    1.  **Define the "Engagement Portfolio":** The key metric is "Total Daily Time Spent in App per User." Break this down into its components: `time_on_feed`, `time_in_dms`, `time_in_journals`, etc.
    2.  **Analyze A/B Test Data:** Using the full A/B test dataset, calculate the average of `total_time_spent` for both control and treatment groups. Is the difference statistically significant?
    3.  **Visualize the Shift:** Create a stacked bar chart comparing the control and treatment groups. Each bar represents 100% of the `total_time_spent`, with segments showing the proportion of time spent in each part of the app. This will visually demonstrate the "portfolio shift."
    4.  **Interpret the Result:** Write a clear conclusion. Example: "The feature did not cause a statistically significant increase in total time in app. Instead, it successfully captured an average of 2 minutes of daily time that, for the control group, was spent on the main feed. This indicates the feature is currently a substitute for, not an expansion of, user engagement."
*   **Deliverable:** A notebook containing the statistical tests and the stacked bar chart visualization, along with a clear, concise interpretation.

### Day 18: Retention Curves & The Lift Over Time

*   **Objective:** To visualize and quantify the feature's impact on user retention over the entire 28-day user lifecycle, not just on a single day.
*   **Why This Matters:** A feature's true value is in its ability to create a lasting habit. By plotting retention curves, you can see if the feature's impact is a short-term novelty effect or if it creates a sustained, long-term lift.
*   **Tasks:**
    1.  **Create Cohorts:** Using the A/B test data, create two cohorts based on their join date during the experiment: "Control Group Users" and "Treatment Group Users."
    2.  **Calculate Retention Curves:** For both cohorts, calculate their retention rates for each day from Day 1 to Day 28.
    3.  **Visualize the Curves:** Plot both retention curves on the same line chart. The vertical distance between the two lines represents the daily retention lift.
    4.  **State the Finding in the Title:** Don't just label the chart "Retention Curve." Give it a title that tells the story. Example: "'Journals' Feature Sustains an Average +2.5% Retention Lift Over 28 Days."
*   **Deliverable:** A notebook with the SQL/Python code to generate the retention data and the clearly titled line chart.

### Day 19: Validating the Engagement Loop

*   **Objective:** To use data to prove whether the feature created a new, repeatable, habit-forming loop that brings users back to the product.
*   **Why This Matters:** The best features create their own gravity. They have triggers (like notifications) that lead to actions (writing an entry), which in turn creates future triggers. Proving this loop exists demonstrates that the feature can be a self-sustaining driver of engagement.
*   **Tasks:**
    1.  **Hypothesize the Loop:** Propose a testable loop: "Trigger (Push Notification) -> Action (App Open) -> Reward (Reading Past Entries) -> Investment (Writing a New Entry)." We will test the first part: Trigger -> Action.
    2.  **Measure Trigger Efficacy:** From the `events` data, create two groups of 'Journals' users: those who received a `journal_reminder_notification` and those who did not on a given day.
    3.  **Measure Next-Day Return Rate:** For both groups, calculate the percentage who opened the app the following day (Next-Day Retention).
    4.  **Validate the Loop's Start:** Compare the retention rates with a significance test. A significantly higher return rate for the notified group provides strong evidence that your notification is an effective trigger for re-engagement.
*   **Deliverable:** A notebook with the analysis comparing the two groups and a conclusion stating whether you have validated the first step of a new engagement loop.

### Day 20: Predictive Modeling for Proactive Engagement

*   **Objective:** To build a simple, interpretable model that identifies users who are most likely to become highly engaged with 'Journals', enabling proactive product interventions.
*   **Why This Matters:** Not all users are the same. By identifying future power users early, the product team can design targeted onboarding flows, promotions, or nudges to help them succeed, maximizing the feature's impact.
*   **Tasks:**
    1.  **Define Target Variable:** Create a binary target `is_champion`, which is `1` for users who created 5+ journal entries in their first 28 days and `0` otherwise.
    2.  **Engineer Features:** Create predictive features using only a user's **first-week** data (e.g., `num_sessions_week1`, `did_use_photo_feature`, `signup_channel`).
    3.  **Train Model:** Train a logistic regression model to predict `is_champion`. The goal is **not predictive accuracy, but interpretability.**
    4.  **Identify Key Predictors:** Extract and visualize the model's coefficients. Identify the top 3 features that are the strongest early indicators of a future "Journal Champion." These are your levers.
*   **Deliverable:** A notebook showing the model training process and a summary of the top 3 predictive features, explaining what they mean for product strategy.

### Day 21: The One-Slide Story

*   **Objective:** To master the art of telling a complete, compelling data story in a single, powerful visual designed for an executive audience.
*   **Why This Matters:** Senior leaders are time-poor. Your ability to synthesize a week of complex analysis into a single, understandable, and persuasive slide is a career-defining skill.
*   **Tasks:**
    1.  **Review the Week's Narrative:** Review all your findings from Day 15-20. What is the single most important message?
    2.  **Choose the Core Narrative:** Decide on the story (e.g., "Journals successfully boosts retention by creating a new habit, but does not yet grow overall engagement.").
    3.  **Design the Slide:** Design a single presentation slide. It should have a clear, assertive title (the main takeaway). It should contain no more than 3 key charts/numbers to support that title.
    4.  **Write Speaker Notes:** In the "speaker notes" section of your presentation software (or a markdown cell), write a script that explains the slide's content and its implications in under 60 seconds.
*   **Deliverable:** A single image file of your presentation slide (`.png` or `.jpg`) and the accompanying speaker notes.

---

## Week 4: The Strategy – From Analyst to Influencer

**Goal:** You have analyzed the past and understood the present. This final week is about shaping the future. You will use your deep insights to build a strategic roadmap, justify future investment, and present your findings in a high-stakes business review, demonstrating your ability to translate data into dollars and direction.

### Day 22: Quantifying the Business Impact (LTV)

*   **Objective:** To connect the feature's impact on user behavior (retention) directly to the company's bottom line (Lifetime Value).
*   **Why This Matters:** Product metrics are important, but financial metrics drive business decisions. Tying your work to LTV is how you prove to the C-suite that your feature isn't just a nice-to-have; it's a value creator.
*   **Tasks:**
    1.  **Build a Simple LTV Formula:** Use the formula: LTV = (Average Revenue Per User per Month) * (1 / Monthly Churn Rate).
    2.  **Calculate LTV for Control:** Using data from the control group, calculate their monthly churn rate (1 - monthly retention rate) and assume an ARPU of $1.00 to find their LTV.
    3.  **Calculate LTV for Treatment:** Do the same for the treatment group. Their lower churn rate (from your A/B test) should result in a higher LTV.
    4.  **Quantify Total Business Impact:** Calculate the LTV lift per user. Then, project the total increase in lifetime value for the entire user base over the next year if the feature is rolled out to everyone.
*   **Deliverable:** A notebook containing the LTV calculations and a concluding statement: "The 'Journals' feature is projected to increase LTV by $X per user, generating an estimated $Y in total value over the next year."

### Day 23: The "Iterate, Expand, or Kill" Decision Framework

*   **Objective:** To use a structured, data-driven framework to make a clear, defensible, and transparent product lifecycle recommendation.
*   **Why This Matters:** Gut feelings lead to bad product decisions. A structured framework removes emotion and bias, forcing a decision based on pre-defined criteria and ensuring everyone understands the "why" behind your recommendation.
*   **Tasks:**
    1.  **Create a Scorecard:** In a markdown file, create a table with columns: "Metric," "Result vs. Goal," and "Score (-1, 0, or 1)."
    2.  **Fill the Scorecard:** Populate the table with your key findings from the entire project.
        *   *Day-28 Retention Lift:* +2.5% (Goal: +2.0%) -> Score: +1
        *   *Net Engagement (Cannibalization):* Neutral (Goal: Positive) -> Score: 0
        *   *Adoption Rate (Wk 1):* 15% (Goal: 10%) -> Score: +1
        *   *Negative Guardrail Impact:* None (Goal: None) -> Score: +1
        *   *Projected LTV Impact:* +$0.50/user (Goal: Positive) -> Score: +1
    3.  **Make the Call:** Sum the scores. Based on the total, write a formal, one-paragraph recommendation. Example: "With a strongly positive data scorecard of +4, I recommend we **Expand** the 'Journals' feature to 100% of users and allocate resources for V2 development."
*   **Deliverable:** The completed decision framework scorecard and formal recommendation.

### Day 24: Building the Data-Driven V2 Roadmap

*   **Objective:** To use the insights you've gathered to propose the next set of feature improvements, ensuring the product roadmap is built on evidence, not opinions.
*   **Why This Matters:** This task separates a reactive analyst from a proactive product partner. You are not just reporting on the past; you are using your data to write the future of the product.
*   **Tasks:**
    1.  **Synthesize Your Key Insights:** Review your findings on the adoption funnel (Day 10), the 'Aha!' moment (Day 11), qualitative feedback (Day 14), and key predictors of champions (Day 20).
    2.  **Propose 3 Roadmap Items:** Based on this synthesis, propose the top 3 most impactful improvements or new features for "Journals V2."
    3.  **Justify Each Item with Data:** For each proposal, write one sentence justifying it with a specific data point.
        *   **1. Add Prominent Onboarding Card:** (Justification: To address the 60% drop-off in our adoption funnel.)
        *   **2. Prompt Users to Add a Photo:** (Justification: To intentionally guide users to the 'Aha!' moment that correlates with a 3x higher retention rate.)
        *   **3. Develop Sharable Templates:** (Justification: 'Feature Request' was the #1 theme in our qualitative feedback analysis.)
*   **Deliverable:** A short memo titled "Proposed Journals V2 Roadmap," listing the three initiatives and their data-driven justifications.

### Day 25: Extrapolating to Broader Product Strategy

*   **Objective:** To practice senior-level strategic thinking by extrapolating a core insight from your feature to influence the entire product ecosystem.
*   **Why This Matters:** The most impactful analysts see the forest, not just the trees. They connect learnings from a single feature to the company's grand strategy, identifying new opportunities and markets.
*   **Tasks:**
    1.  **Identify the Core User Need:** Look beyond the 'Journals' feature. What is the fundamental, underlying user need you have validated? (e.g., "Our users have a strong, unmet desire for private, self-expression features in a world of public performance.").
    2.  **Draft a Strategy Memo:** Write a short memo to the Head of Product.
    3.  **Connect Your Insight to Company Strategy:** In the memo, explain how this core insight should influence the company's 3-year plan. Propose that the company should explore a new "Privacy & Wellness" product pillar, with 'Journals' as the successful pilot. Suggest 1-2 other feature ideas that would fit into this pillar.
*   **Deliverable:** A concise, persuasive strategy memo that demonstrates thinking beyond your immediate project.

### Day 26: Preparing for the QBR – Behavioral Storytelling

*   **Objective:** To practice crafting compelling, concise narratives about your work to prepare for high-stakes presentations and behavioral job interviews.
*   **Why This Matters:** People don't remember data points; they remember stories. The STAR method is a framework for turning your analytical work into memorable narratives of impact.
*   **Tasks:**
    1.  **Reflect on Your Journey:** Review all the challenges from the past 25 days.
    2.  **Draft STAR Stories:** In a markdown file, write out three stories using the **STAR** method (Situation, Task, Action, Result).
        *   **A Time You Dealt with Ambiguity:** (Use the Day 6 open-ended discovery task or Day 17 Cannibalization analysis).
        *   **A Time You Used Data to Influence Decisions:** (Use the Day 23 decision framework or Day 24 roadmap).
        *   **A Time You Handled a Crisis or Technical Challenge:** (Use the Day 9 bug triage fire drill).
    3.  **Practice and Refine:** Read your stories aloud. Are they clear? Are they concise? Does the Result clearly link to your Action?
*   **Deliverable:** The document containing your three polished STAR stories.

### Day 27-30: Capstone: The Quarterly Business Review (QBR) Presentation

*   **Objective:** To synthesize the entire 30-day journey into a strategic, executive-level presentation that demonstrates business impact and successfully influences the company's future direction.
*   **Why This Matters:** This is the culmination of all your work. The QBR is where you stop being an analyst who *supports* the business and become a leader who *drives* the business.
*   **Tasks:**
    1.  **Outline the Narrative Arc:** Structure your presentation as a compelling story:
        *   Slide 1: **The Opportunity:** Why we built this in the first place.
        *   Slide 2: **The Results:** It worked. The feature causally improved retention (your Day 21 slide).
        *   Slide 3: **The Business Impact:** Here's what this means for our bottom line (your LTV analysis).
        *   Slide 4: **The Strategic Recommendation:** Based on the data, here is our decision (your Day 23 framework) and our V2 roadmap (Day 24).
        *   Slide 5: **The Bigger Picture:** How this learning shapes our company's future (your Day 25 memo).
    2.  **Create the Deck:** Create a polished 5-slide presentation.
    3.  **Create the Appendix:** Create a detailed supporting document (`QBR_Appendix.md`) that links to all your notebooks and provides the full methodology behind every number in your presentation. This is your defense.
    4.  **Record Your Presentation:** Practice and record yourself delivering the 5-minute presentation as if you were in a real QBR meeting. Focus on being clear, confident, and persuasive.
*   **Deliverable:** The final 5-slide presentation deck, the detailed appendix document, and a link to your recorded presentation.