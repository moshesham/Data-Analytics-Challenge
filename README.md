# The 30-Day Product Analytics Masterclass

Welcome to a 30-day, project-based sprint designed to simulate the complete lifecycle of a Product Analyst. You won't just learn isolated skills; you'll own a feature, from initial discovery in raw data to a final strategic recommendation in a Quarterly Business Review (QBR).

> This is not a tutorial. It's a simulator. By the end, you will have a portfolio-ready project that demonstrates technical depth, business acumen, and strategic thinking.

---

### What You Will Learn & Accomplish

Over 30 days, you will build a robust, end-to-end analytical skillset:

*   **Technical Foundations:** Master advanced SQL for user behavior analysis, funnel creation, and cohort analysis in a realistic data environment (DuckDB).
*   **Experimentation & Causal Inference:** Design a rigorous A/B test, perform power analysis, and implement a quasi-experimental backup (Difference-in-Differences) to measure true causal impact.
*   **Diagnostic & Monitoring:** Learn to monitor a feature launch, diagnose bugs with precision, and communicate findings effectively under pressure.
*   **Predictive Analytics:** Build a simple, interpretable machine learning model to identify high-value users and inform product strategy.
*   **Stakeholder Communication & Strategy:** Practice distilling complex data into concise memos, compelling visualizations, and an executive-level presentation.
*   **Product & Business Acumen:** Develop a deep understanding of metrics like LTV, cannibalization, and engagement loops, and use them to make data-driven product decisions.

### The Scenario: The 'Journals' Feature

You are a Product Analyst at a fast-growing social media company. The product team has a hunch that users want a private space to jot down thoughts, inspired by qualitative feedback. Your mission is to use data to validate this idea, measure its impact, and determine its future.

### How to Use This Repository

This project is split into two key parts: your local coding environment and the online curriculum.

#### 1. Your Workspace: The Interactive Coding Environment

This is where you will complete your daily challenges.

**Setup (Required):**
1.  **Install [Docker Desktop](https://www.docker.com/products/docker-desktop/)**. This is the standard for creating reproducible data science environments.
2.  Clone this repository.
3.  From the project's root directory, run the command:
    ```bash
    docker-compose up --build
    ```
4.  Open your web browser and navigate to **http://localhost:8888**. You will see the JupyterLab interface.

**Directory Structure:**
*   `/notebooks`: Contains the Jupyter notebooks for each day's challenge. **This is where you'll work.**
*   `/data`: Holds all raw datasets (`.parquet`, `.csv`).
*   `/src`: A place for any reusable Python functions you write.
*   `/solutions`: Contains the completed solution notebooks for your reference.

#### 2. The Curriculum: A Polished Web Book

The full 30-day syllabus, with detailed explanations and context, is deployed as a searchable website using mdBook. This is your primary reference.

**➡️ [Access the Live Masterclass Curriculum Here](https://moshesham.github.io/Data-Analytics-Challenge/)**
*(Note: You must update this link after deploying your own version via GitHub Pages.)*

**Building the Book Locally:**
The book is generated from the project's markdown files. To build and preview it locally:

1.  **Run the build script.** This prepares the content for the book.
    ```bash
    ./scripts/build_book.sh
    ```
2.  **Serve the book.**
    ```bash
    mdbook serve book-src
    ```
3.  Open your browser to `http://localhost:3000`.

**Deployment:**
The included GitHub Actions workflow will automatically build and deploy the book to GitHub Pages on every push to the `main` branch.

---