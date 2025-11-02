# Day 04: Architecting Trust – The A/B Test Blueprint

We've identified an opportunity, built a business case, and designed a measurement plan. So far, all of our analysis has been based on *correlation* and *forecasting*. We observed that users asking for a journal feature have lower retention. We forecast that building it might help. But how do we *prove* it? How do we establish **causation**?

This is where we move from analyst to scientist. An A/B test (or randomized controlled experiment) is the gold standard for proving that a product change *caused* a change in user behavior. A well-designed test is the difference between guessing and knowing, and it's the foundation of a data-driven culture. Today, we design the blueprint for that test.

### The Central Analogy: Focusing a Camera

Designing an experiment before you run it is called **Power Analysis**. The goal is to figure out how many users you need and how long you need to run the test to get a trustworthy result. Let's think of it like setting up a camera to take a very important photograph.

**Power analysis is like focusing the lens of your camera.** You need to make sure your settings are right *before* you press the shutter.

-   **Sample Size (N) is the amount of light you let in.** If you want to take a picture of a huge, obvious object like a car, you don't need much light. But if you want to capture a clear photo of a tiny, distant insect, you need to let in a lot more light (i.e., have more users in your test). More users give you more statistical "light" to see smaller effects.

-   **Minimum Detectable Effect (MDE) is the size of the object you're trying to see.** Before you take the picture, you must decide: am I trying to photograph the car or the insect? The MDE is the smallest change you care about detecting. A 10% lift in retention is a much bigger "object" than a 1% lift. Trying to detect a tiny effect (a small MDE) requires a much sharper focus and a lot more light (a larger sample size). This is the most important business decision in your test design.

-   **Statistical Power (1-β) is the probability your camera works.** It's the probability that you will actually capture a clear photo *if the insect is truly there*. The industry standard is 80% power. This means we accept a 20% chance of a "false negative"—our camera fails to capture the photo even though the insect was right in front of us. In other words, we have an 80% chance of detecting a real effect if it exists.

### Key Concepts Explained

With our camera focused, there's one more setting to check:

-   **Significance Level (alpha / α):** This is your risk of a "false positive." In our analogy, it's the chance that a random speck of dust on your camera lens looks exactly like the insect you were searching for. You see the "insect" in your photo, but it was never really there. We want to keep this risk low, so the standard is 5% (or 0.05). This means we're willing to accept a 5% chance of celebrating a win that was actually just random noise.

### The Critical Thinking Corner: Beyond the Calculator

A power calculator will give you a number, but a great analyst knows the pitfalls that the math doesn't account for.

1.  **The Novelty Effect:** Beware the siren song of early results! When you launch a new feature, some users will click on it simply because it's new and shiny. This can create a temporary lift in engagement that has nothing to do with the feature's true, long-term value. If you run your test for only a few days, you're likely measuring novelty, not a sustained change in behavior. This is why for a habit-forming feature like a journal, running the test for a full habit loop (e.g., 28 days) is essential to measure its real impact.

2.  **The Sin of "Peeking":** It is statistically invalid to check your experiment results every day and stop the test as soon as it hits statistical significance (p-value < 0.05). This is called "peeking," and it dramatically increases your risk of a false positive. Why? Because data is naturally noisy. If you check 20 times, you're giving random chance 20 opportunities to produce a "significant" result.

    **Analogy:** It's like pulling a cake out of the oven early just because the top looks brown. The statistical guarantees of your test are only valid if you let it run for its pre-determined duration or sample size. The inside is still uncooked. Commit to your test plan.

### Today's Challenge: A Step-by-Step Guide
Open `Day_04_Challenge.ipynb`. We will now use our camera settings to calculate the required sample size for our "Journals" feature A/B test.

**Step 1: Define the Inputs for the Power Calculator**
We need to tell our calculator what we're looking for. We will link each parameter directly to our camera analogy and our previous work.
-   **Baseline Rate (p1):** This is our starting point. From Day 2, what is the 28-day retention rate for our target user segment?
-   **Minimum Detectable Effect (MDE):** What is the "insect" we're trying to see? We'll use the 15% *relative lift* from our business case on Day 2. You'll need to convert this to an absolute value for the calculator (e.g., if the baseline is 20%, a 15% relative lift makes the target rate 23%).
-   **Alpha (α):** Our tolerance for a false positive. We'll use the standard 0.05.
-   **Power (1-β):** Our desired chance of detecting a real effect. We'll use the standard 0.80.

**Step 2: Calculate the Sample Size**
Using the `statsmodels` library in Python, you will plug these four inputs into the power analysis function. The output will be the number of users required *per group* (i.e., for the control group and for the treatment group).

**Step 3: Calculate the Test Duration**
A sample size is not an actionable plan. We need to translate it into time. Based on the number of eligible new users who sign up for our product each week, how many weeks will it take to get enough users into our experiment? This final calculation—"We need to run this experiment for X weeks"—is the clear, actionable deliverable for your product and engineering team.