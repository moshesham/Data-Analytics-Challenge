# Day 01: The Spark of an Idea

Welcome to Day 1 of the Product Analytics Masterclass! Today, we’re not starting with complex dashboards or A/B tests. We're starting with the most fundamental skill of a great product analyst: **curiosity**. We're going on an expedition into the raw, unstructured world of user feedback to find the spark of our next big feature.

Our scenario for this week is the **"Journals Sprint."** The product team has a hunch that users want a way to journal or log their activities within our app. Is this a real need, or just a guess? Our job is to find the data to support or challenge this idea.

### Objective
- To validate the need for a new feature by performing proactive discovery on raw, qualitative user data.

### Why This Matters
Great analysis isn't just about answering questions that are handed to you; it's about asking the *right* questions in the first place. Too often, analytics is purely **reactive**—measuring the performance of features that already exist. Today, we're flipping the script.

We will practice **proactive discovery**: the art of sifting through raw data to uncover hidden opportunities and unmet user needs. By analyzing qualitative data like user reviews *before* a single line of code is written for a new feature, you can:
- **De-risk product decisions:** Provide evidence that a real user problem exists.
- **Influence the roadmap:** Champion features that are backed by user-driven data.
- **Build empathy:** Gain a deep, unfiltered understanding of what your users are actually saying and feeling.

This skill—finding signals in the noise—is what separates a good analyst from a great one.

### Key Concepts
Before we dive into the code, let's familiarize ourselves with the tools and concepts we'll be using today.

1.  **DuckDB:** Think of DuckDB as "SQLite for analytics." It's an in-process analytical database management system.
    -   **In-process:** It runs inside our Python notebook. No complex server setup, no database administrators, no network connections. It's just a library you import.
    -   **Analytical:** It's blazing fast for the types of queries we'll be doing (aggregations, filtering, etc.) because of its columnar-vectorized query engine.
    -   **Perfect for us:** We can query our data files directly, making it incredibly easy to get started.

2.  **Parquet Files:** The data we're using today (`app_reviews.parquet`) is stored in the Parquet format.
    -   **Columnar:** Unlike row-based formats like CSV, Parquet stores data by column. When you query `AVG(rating)`, it only reads the `rating` column, ignoring all others. This makes analytical queries significantly faster.
    -   **Compressed:** Parquet files are highly compressed, saving disk space and speeding up data reads. It's the go-to format for analytical datasets in the modern data stack.

3.  **Exploratory SQL:** Before you can perform complex analysis, you must first understand your dataset's basic shape and content. We call this exploratory analysis, and we'll use a few fundamental SQL commands:
    -   `DESCRIBE`: Shows the schema of the table—the column names and their data types (`VARCHAR`, `INTEGER`, `TIMESTAMP`, etc.).
    -   `SELECT * LIMIT 10`: Fetches the first 10 rows of the table. This is a quick and safe way to peek at the actual data without trying to load the entire (potentially huge) dataset.
    -   `COUNT(*)`: Counts the total number of rows in a table.
    -   `AVG()`: Calculates the average value of a numeric column.

4.  **Keyword Searching with `LIKE`:** This is our primary tool for discovery today. The `LIKE` operator in SQL is used for simple pattern matching in text data.
    -   It's often paired with the `%` wildcard, which matches any sequence of characters (including zero characters).
    -   For example, `WHERE content LIKE '%journal%'` will find any review that contains the word "journal" anywhere within its text. We'll use the case-insensitive version, `ILIKE`, to make our search more robust.

### Today's Challenge: A Step-by-Step Guide
It's time to get our hands dirty. Open the `Day_01_Challenge.ipynb` notebook and follow along with this guide. Our mission is to find evidence for or against the "Journals" feature idea within our app reviews.

**Step 1: Set Up the Environment**
The first few cells in the notebook will install and import the necessary libraries (`duckdb`) and then establish a connection to our Parquet file. This simple command tells DuckDB to treat our file as a SQL table.

**Step 2: Initial Data Exploration**
Now that we're connected, we need to get acquainted with the data.
1.  Run the `DESCRIBE` query to understand the columns we have to work with. What are their names? What are their data types?
2.  Use `SELECT * LIMIT 10` to see some sample reviews. Get a feel for the language users are using. What do the `content` and `rating` columns look like?
3.  Calculate the total number of reviews with `COUNT(*)` and the overall average rating with `AVG(rating)`. This gives us a baseline to compare our findings against later.

**Step 3: Formulate the Keyword Query**
Our hunch is about journaling. Let's translate that into keywords. We're looking for reviews that mention terms like `journal`, `diary`, `log`, or `track`.

We will build a query to find all reviews matching these keywords. To keep our logic clean and readable, we'll use a Common Table Expression (CTE) with the `WITH` clause.

The logic will be:
1.  **CTE (`Journal_Reviews`):** Create a temporary table that selects all columns from reviews `WHERE` the `content` column (using `ILIKE` for case-insensitivity) contains our keywords. We'll link them with `OR`.
2.  **Final Query:** Select the `COUNT(*)` and `AVG(rating)` from our `Journal_Reviews` CTE.

This query will tell us exactly how many people are talking about journaling and what their average sentiment (as measured by rating) is.

**Step 4: Analyze and Summarize Your Findings**
The final, and most important, step is to interpret your results. The query gives you numbers; your job is to turn them into an insight.

In the final markdown cell of the notebook, write a short summary answering these questions:
- How many reviews mentioned your keywords?
- What was the average rating for these specific reviews?
- How does this count and average rating compare to the overall dataset?
- **Conclusion:** Based on this initial analysis, is there evidence to support prioritizing a journaling feature? Why or why not?

This summary is your deliverable. It's where you practice the crucial skill of communicating your findings to stakeholders.

### Deliverable Checklist
- [ ] DuckDB environment is set up and data is loaded.
- [ ] SQL queries for schema exploration are complete.
- [ ] SQL query for keyword search is written and executed.
- [ ] A summary of findings is written in the notebook's markdown cell.