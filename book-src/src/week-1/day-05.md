# Day 05: The Analytical Detective – Finding Causation Without an A/B Test

Welcome to Day 5. So far, we've treated A/B tests as the only way to establish causation. But the real world is messy. Products don't always launch to everyone at once. Sometimes a feature is rolled out to one country (e.g., Canada) before it's launched globally. Sometimes a new marketing campaign is only run in specific cities. In these scenarios, a clean A/B test is impossible.

Does that mean we have to give up on finding the true cause of a change? Absolutely not. It means we have to become detectives. Today, we learn one of the most powerful techniques in the observational analysis toolkit: **Difference-in-Differences (DiD)**. This is how you find the truth in the mess.

### Objective & Why This Matters
- To estimate the causal impact of a feature when a true A/B test is not available.

This is a critical, real-world skill. Very few analysts outside of top tech companies are proficient in quasi-experimental methods like DiD. Mastering this technique will allow you to provide causal insights in situations where others can only point to correlations. You'll be able to confidently answer "What was the true impact of our Canada-only launch?" while others are still guessing.

### The Central Analogy: The Twin Runners

To understand DiD, let's forget about data for a moment and think about two identical twin runners, Alex and Ben.

-   **The Setup:** Alex and Ben are perfectly matched athletes. For years, every time they've run a 5k, their race times have been identical. If Alex gets a little faster one month (due to better training), Ben gets faster by the same amount. Their performance trends are perfectly **parallel**.

-   **The Intervention:** One day, we give Alex a new, expensive pair of running shoes (our "feature"). Ben keeps his old shoes (he's our "control group").

-   **The Result:** After a month, we check their race times again. We see that Ben's time has improved by 10 seconds (maybe the weather got better for everyone). But Alex's time has improved by *15 seconds*.

-   **The Conclusion:** The "Difference-in-Differences" is the difference between their improvements: `15 seconds - 10 seconds = 5 seconds`. Because we know they were identical twins whose performance always moved in parallel, we can confidently conclude that the new shoes *caused* a 5-second improvement in Alex's race time. The extra 5-second gain Alex saw, above and beyond the trend Ben also experienced, is the causal effect.

### The Bedrock of DiD: The Parallel Trends Assumption

The twin analogy works for one reason only: Alex and Ben were identical to begin with. This is the **Parallel Trends Assumption**, and it is the non-negotiable foundation of any DiD analysis.

It states: **In the absence of the treatment, the treatment group would have followed the same trend as the control group.**

If this assumption is violated, your entire analysis is invalid. You cannot be sure if the change you see is from your feature or from a pre-existing difference between the groups. This is why the first step of any DiD analysis is always to check this assumption visually.

Here is what you should look for when plotting your metric over time for both groups *before* the intervention:

#### **GOOD: Parallel Trends Hold**
```
      Metric ^
             |
             |       /-------- (Treatment)
             |      /
             | ----/---------- (Control)
             |    /
       -----/----
      /
     /
    ----------------------> Time
             ^
         Intervention
```
*Description: The Treatment and Control lines move in lockstep before the intervention. They might be at different absolute levels, but their slopes are the same. After the intervention, the Treatment group's line diverges upwards, indicating a positive effect.*

#### **BAD: Parallel Trends Violated**
```
      Metric ^
             |
             |           /---- (Treatment)
             |          /
             |         /
             |        /
             | ------/---------- (Control)
             |      /
       -----/
      /
     /
    ----------------------> Time
             ^
         Intervention
```
*Description: The Treatment and Control groups were already on different trajectories *before* the intervention. The Treatment group was already growing faster. Because of this, it's impossible to know if the post-intervention change is due to the feature or just a continuation of the old trend. The analysis is unreliable.*

### The Critical Thinking Corner: When DiD Fails

The primary risk in a DiD analysis is a **confounding event**. What if, on the exact day Alex got his new shoes, he *also* secretly hired a new running coach, but Ben didn't? Now we have two things that could explain his extra 5-second improvement. The effect of the shoes is confounded by the effect of the coach.

In product analytics, this happens all the time. Imagine we launch our feature in Canada, and on the same day, a major Canadian competitor goes out of business. Our metrics in Canada might shoot up, but we can't isolate the effect of our feature from the effect of the competitor disappearing. As the analytical detective, you must always be asking: "What else happened at the same time that could explain this change?"

### Today's Challenge: A Step-by-Step Guide
In `Day_05_Challenge.ipynb`, we will simulate a scenario where the "Journals" feature was launched only to users in Canada. We will use DiD to measure its causal impact on 28-day retention.

**Step 1: Check the Parallel Trends Assumption (CRITICAL FIRST STEP!)**
Before you calculate a single number, you must plot the historical 28-day retention trend for Canadian users (our treatment group) and users from a comparable country, like the UK (our control group). Do this for the 3-4 months *before* the launch. If the lines are reasonably parallel, you can proceed. If not, you must stop and declare the method invalid for this control group.

**Step 2: Define the Four Key Numbers**
Once you've validated the assumption, you'll need to calculate four values using SQL or Pandas:
1.  **Treatment Group, After:** Average 28d retention for Canadian users who signed up *after* the launch.
2.  **Treatment Group, Before:** Average 28d retention for Canadian users who signed up *before* the launch.
3.  **Control Group, After:** Average 28d retention for UK users who signed up *after* the launch.
4.  **Control Group, Before:** Average 28d retention for UK users who signed up *before* the launch.

**Step 3: Calculate the "Difference-in-Differences"**
The final calculation is straightforward:
-   `diff_treatment = (Treatment_After - Treatment_Before)`
-   `diff_control = (Control_After - Control_Before)`
-   `causal_effect = diff_treatment - diff_control`

This final number is your estimate of the causal impact of the feature on retention. It isolates the feature's effect from any general, market-wide trends that affected both countries. You've just become an analytical detective.