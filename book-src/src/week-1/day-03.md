# Day 03: If You Can't Measure It, You Can't Improve It

So far, we've found a signal in the noise and sized the potential business impact. We've answered the "what" and the "why." Today, we tackle the "how"—specifically, how will we measure success? We're going to create an **Instrumentation Plan**.

This is one of the most critical, high-leverage activities an analyst can perform. We are defining, *before a single line of code is written*, exactly what data we need to collect to determine if our "Journals" feature is a success or a failure.

### Objective
- To define exactly what user actions need to be tracked (events) and what metrics will define success, *before* any code is written.

### Why This Matters
Think of an instrumentation plan as the foundational contract between Product, Engineering, and Analytics.
- **For Product,** it forces clarity on what "success" actually means.
- **For Engineering,** it provides a clear, unambiguous list of tracking requirements.
- **For Analytics,** it ensures that the data you need to do your job will actually exist post-launch.

Without this plan, you're flying blind. You launch a feature and then ask, "Did it work?" only to realize you don't have the data to answer the question. This leads to opinions, not data-driven decisions. The old adage holds true: **"Bad data in, bad decisions out."** A thoughtful instrumentation plan is your quality control for future decisions.

### Key Concepts
Let's define the core components of our plan.

1.  **Events and Properties:** This is the vocabulary we use to describe user behavior.
    -   An **Event** is a user action. It's the *verb*. Examples: `click_button`, `view_screen`, `save_entry`.
    -   **Properties** are the context for that action. They are the *adverbs* or *nouns* that describe the verb. They answer questions like who, what, where, when, and how.
    -   **Analogy:** If the event is `play_song` (the verb), the properties would be a dictionary of context like `{genre: 'rock', artist_name: 'Queen', duration_ms: 210000, source: 'playlist'}`.

2.  **Primary vs. Secondary Metrics:** Not all metrics are created equal. You need a hierarchy to avoid confusion.
    -   The **Primary Metric** (also called the North Star Metric for the project) is the single, undisputed measure of success. If this metric goes up, the project is a success. If it doesn't, it's a failure. It must be directly related to the business case we built yesterday.
    -   **Secondary Metrics** add color, context, and diagnostic power. They help explain *why* the primary metric moved. If retention is our primary metric, a secondary metric might be "average number of journal entries per week," which could be a leading indicator of retention.

3.  **Guardrail Metrics:** This is a concept that separates good analysts from great ones. Guardrail metrics are the metrics you hope *don't* change. They are your early warning system for unintended negative consequences.
    -   **Purpose:** Their job is to protect the overall health of the product. When you launch a new feature, you might accidentally hurt another part of the app.
    -   **Example:** For our Journals feature, we want to increase engagement. But what if it's so engaging that users stop using our app's main social feed? A good guardrail metric would be `time_spent_on_main_feed`. If that metric plummets for users of the journal, we know we've created a cannibalization problem. Other examples include app performance (crash rate) or uninstalls.

### Today's Challenge: A Step-by-Step Guide
Your task is to create a simple instrumentation plan for the "Journals" feature. Think logically through the user journey and define the data you would need to collect. We'll outline the key components in your notebook, `Day_03_Challenge.md`.

**Step 1: Map the User Journey & Define Events**
First, imagine you are a user. What are the key actions you would take within this new feature? List them out as events.
- What happens when the user sees the feature for the first time? (`view_journal_promo`)
- What is the first click? (`click_journal_tab`)
- What actions can they take on the page? (`start_journal_entry`, `save_journal_entry`, `set_reminder`)

**Step 2: Add Context with Properties**
Now, for each event, what additional information would be useful for deeper analysis later?
- For `save_journal_entry`, you'd want to know the `character_count` to see if longer entries correlate with retention. You might also want a `template_used` property if you offer different journaling formats (e.g., 'gratitude', 'freeform').
- For `start_journal_entry`, an `entry_point` property (`'from_prompt'`, `'from_blank_canvas'`) would be incredibly valuable.

**Step 3: Define Your Metrics**
This is where you formalize your success criteria.
- **Choose a Primary Metric:** The goal of a journal is to build a long-term habit. Therefore, a short-term metric like "number of entries on Day 1" is misleading. A better primary metric is **28-day retention for users who create their first entry**. This directly measures if the feature creates lasting value.
- **List Secondary Metrics:** What would support this primary metric? Consider `Adoption Rate` (% of users who try the feature), `Engagement Rate` (average entries per user per week), and `Funnel Conversion` (the % of users who start an entry and then save it).
- **Set Your Guardrails:** What could go wrong? The biggest risk is cannibalization. A key guardrail would be `sessions_per_week_on_core_feature_X`. You could also add `app_uninstall_rate` for the week after a user's first journal entry.

By completing this plan, you're not just preparing to analyze a feature; you are actively shaping its success.