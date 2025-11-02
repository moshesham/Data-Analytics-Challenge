# Day 06: The Executive Dashboard – From Data to Decision

For the last five days, we've been deep in the trenches—finding signals, sizing opportunities, and designing experiments. We've been producing analytical artifacts for ourselves and our direct product teams. Today, we change our audience. We are no longer speaking to our peers; we are speaking to the C-suite. Our mission is to distill all of this complexity into a single screen that an executive can understand in 60 seconds.

This isn't about making charts. This is about synthesizing insight. A dashboard is not a report; it's a *product*, and the user is your CEO. Your goal is not to show data, but to guide a decision.

### Objective & Why This Matters
- To design a strategic dashboard that communicates the business impact of a feature to executive leadership, using the "KPI Pyramid" to ensure clarity and actionability.

As analysts, our influence is directly proportional to our ability to communicate clearly to leadership. Executives do not have time to wade through spreadsheets or interpret complex charts. They think in terms of outcomes: Are we winning or losing? Are we growing faster or slower? Should I invest more here or cut our losses?

A great executive dashboard ruthlessly prioritizes information to answer those questions. It respects the viewer's time and focuses their attention on what matters most. Getting this right is how you build trust and earn a seat at the table where strategic decisions are made.

### The KPI Pyramid: A Mental Model for Clarity

To avoid overwhelming our audience, we need a structure. The KPI Pyramid is a mental model for organizing metrics by audience and purpose, ensuring that information flows logically from a high-level summary down to the diagnostic details.

#### **Level 1 (Top): Executive KPIs (The "What")**
-   **Audience:** C-Suite, GM, Board of Directors.
-   **Purpose:** To give a 30-second snapshot of overall business health and trajectory. These are the "ship-steering" metrics.
-   **Characteristics:** There should be very few of them (3-5 max). They are almost always lagging indicators of success, like revenue, user growth, or long-term retention.
-   **Example:** For the entire company, this might be `WAU Growth (WoW)` and `Net Revenue`. For our feature, the top-line KPI might be **`Net New Retained Users (in the last 28 days)`**.

#### **Level 2 (Middle): Team Performance Metrics (The "Why")**
-   **Audience:** VPs, Directors of Product/Engineering/Marketing.
-   **Purpose:** To diagnose *why* the top-level KPIs are moving. If WAU is down, is it an acquisition problem or an engagement problem? These metrics provide a first layer of context.
-   **Characteristics:** These are a mix of leading and lagging indicators that are directly influenceable by specific teams.
-   **Example:** To explain the **`Net New Retained Users`** number, we would show `28d Retention Rate for Journal Users` and the `Adoption Rate of the Journal Feature`.

#### **Level 3 (Bottom): Diagnostic & Health Metrics (The "Where")**
-   **Audience:** Product Managers, Analysts, Engineering Leads.
-   **Purpose:** The ground-level, operational data used for deep dives and debugging. This is where the actual day-to-day analysis happens.
-   **Characteristics:** Highly granular, often leading indicators or guardrail metrics. They are rarely shown on the main executive view but are available via a "drill-down."
-   **Example:** To understand why the `Adoption Rate` is low, a PM would drill down to see the `Onboarding Funnel Conversion Rate` or the `Save Button Click-Through Rate`. To ensure the feature isn't hurting things, we'd monitor the `Time Spent on Core Feed (Guardrail)`.

The magic of this structure is the drill-down path. An executive sees **what** happened. Their VPs can immediately see **why**. And the PMs know **where** to go look for the root cause.

### Key Concepts in Visual Design

1.  **Visual Hierarchy:** The most important information should be the most visually prominent. Use size, color, and position to guide the user's eye. The top-left of a dashboard is the most valuable real estate; put your Level 1 KPI there in the largest font.
2.  **Data-Ink Ratio:** Coined by Edward Tufte, this principle demands that we remove every single pixel that isn't communicating data. No 3D effects, no distracting background images, no unnecessary gridlines. Maximize the signal, minimize the noise.
3.  **Context is King:** A number in isolation is meaningless. `28d Retention: 35%` tells me nothing. `28d Retention: 35% (vs. 20% Control, +5pts WoW)` tells a complete story. Every key metric MUST have a comparison (to a previous time period, a goal, or a control group) to be actionable.

### The Critical Thinking Corner: Art Gallery vs. Cockpit

As a Head of BI, I see two types of dashboards. Your career trajectory will depend on which one you build.

1.  **The Data Art Gallery:** This dashboard is designed to impress. It features visually complex charts (like Sankey diagrams or network graphs) and a kaleidoscope of colors. It's aesthetically pleasing and demonstrates the technical skill of the analyst. But it's ultimately useless. It's a gallery you walk through, say "huh, that's interesting," and then leave without knowing what to do. It answers "What happened?" but provides no path to "So what?" or "Now what?". It is a beautiful dead end.

2.  **The Decision-Making Cockpit:** This dashboard is designed to be acted upon. It might even look "boring." It uses simple bar and line charts, minimal color (leveraging red/green for alerts), and a rigid structure. Every single chart is tied to a decision someone needs to make. It's like a pilot's cockpit: the most critical gauges (altitude, speed) are front and center, while diagnostic information is on secondary screens. It doesn't just show data; it surfaces exceptions and guides the user toward the next question. It is the starting point of an action.

Your C-suite doesn't want art. They want a cockpit.

### Today's Challenge: A Step-by-Step Guide
Your task is not to write code. It is to **design**. In the `Day_06_Challenge.md` file, you will architect a dashboard for our "Journals" feature launch.

**Step 1: Define Your Pyramid**
Think like an executive. If you had 60 seconds to evaluate this feature's success, what would you need to know?
-   **Level 1:** What is the single most important metric that proves this feature is adding value to the business? (Hint: It should relate to your business case from Day 2).
-   **Level 2:** What are the 2-3 key performance metrics that explain the "why" behind the Level 1 metric? Think about adoption and engagement.
-   **Level 3:** What is the most important guardrail metric you need to monitor to ensure this feature isn't causing unintended harm?

**Step 2: Sketch the Cockpit**
On a piece of paper, a whiteboard, or a simple digital tool, sketch a wireframe of your dashboard. Don't worry about being precise. Focus on:
-   **Layout:** Where does the Level 1 metric go? How do you position the Level 2 metrics to support it?
-   **Hierarchy:** How will you use size to show which number is most important?
-   **Context:** For each metric, what comparison will you show? (e.g., vs. goal, vs. previous period).
-   **Chart Choice:** Should this be a big number (a KPI), a line chart showing a trend over time, or a bar chart comparing two groups?

Upload an image of your sketch to the notebook. This exercise—thinking about design and hierarchy *before* you open a BI tool—is one of the most valuable habits you can build as an analyst.