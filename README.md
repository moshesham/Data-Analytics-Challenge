# The 30-Day Product Analytics Masterclass (Hybrid Project)

Welcome! This repository contains all materials for the "30-Day Product Analytics Masterclass." This project has two primary components:

1.  **An Interactive Coding Environment:** For completing the daily hands-on challenges.
2.  **A Polished Web Book:** A readable, searchable version of the curriculum and key findings, deployed as a website.

## 1. Interactive Coding Environment (Your Workspace)

This is where you will do your daily work.

### Setup (Highly Recommended)
1.  **Install [Docker Desktop](https://www.docker.com/products/docker-desktop/)**.
2.  Run `docker-compose up --build` from the project root.
3.  Open your browser to **http://localhost:8888**.

### Structure
*   `/notebooks`: Contains the daily challenge Jupyter notebooks.
*   `/data`: Holds all datasets.
*   `/src`: For reusable Python functions.
*   `/solutions`: Contains the completed solution notebooks.

---

## 2. The Curriculum Website (mdBook)

The full curriculum is also available as a polished, searchable website, built with mdBook.

**➡️ [Access the live curriculum here](https://your-username.github.io/your-repo-name/)**
*(You must update this link after your first deployment.)*

### Building the Book Locally
The content for the book is generated from the project's markdown files. To build and preview it:

1.  **Run the build script:** This script copies and formats content into the `book-src` directory.
    ```bash
    ./scripts/build_book.sh
    ```
2.  **Serve the book:**
    ```bash
    mdbook serve book-src
    ```
3.  Open your browser to `http://localhost:3000`.

### Deployment
Any push to the `main` branch will trigger the GitHub Actions workflow, which runs `./scripts/build_book.sh` and then deploys the site to GitHub Pages.
