#!/bin/bash

echo "🚀 Generating HYBRID Product Analytics Masterclass skeleton (Code + Book)..."

# --- Configuration ---
PROJECT_NAME="Data-Analytics-Challenge"
PYTHON_VERSION="3.9"
MDBOOK_VERSION=0.4.36 # This MUST match the version in the deploy-mdbook.yml workflow


# --- Root Project Directory ---
# mkdir -p "$PROJECT_NAME"
# cd "$PROJECT_NAME"

# === 1. Create ALL Core Project Directories ===
echo "-> Creating directories for both code-centric work and mdBook output..."
# Code-centric directories
mkdir -p src scripts data/{raw,processed} notebooks solutions reports/dashboards
# mdBook directories
mkdir -p book-src/src/week-1 # The book's markdown source
# GitHub Actions directory
mkdir -p .github/workflows

# === 2. Generate Core Project & Environment Files ===
echo "-> Generating root configuration, Docker, and mdBook files..."

# .gitignore
cat > .gitignore << EOL
# mdBook build output directory
/book-src/book/

# Python & Docker
.venv/
venv/
__pycache__/
.ipynb_checkpoints/
docker-compose.override.yml

# Data & System
.DS_Store
*.duckdb
data/
EOL

# .dockerignore
cat > .dockerignore << EOL
**
!environment.yml
EOL

# Main Project README.md
cat > README.md << EOL
# The 30-Day Product Analytics Masterclass (Hybrid Project)

Welcome! This repository contains all materials for the "30-Day Product Analytics Masterclass." This project has two primary components:

1.  **An Interactive Coding Environment:** For completing the daily hands-on challenges.
2.  **A Polished Web Book:** A readable, searchable version of the curriculum and key findings, deployed as a website.

## 1. Interactive Coding Environment (Your Workspace)

This is where you will do your daily work.

### Setup (Highly Recommended)
1.  **Install [Docker Desktop](https://www.docker.com/products/docker-desktop/)**.
2.  Run \`docker-compose up --build\` from the project root.
3.  Open your browser to **http://localhost:8888**.

### Structure
*   \`/notebooks\`: Contains the daily challenge Jupyter notebooks.
*   \`/data\`: Holds all datasets.
*   \`/src\`: For reusable Python functions.
*   \`/solutions\`: Contains the completed solution notebooks.

---

## 2. The Curriculum Website (mdBook)

The full curriculum is also available as a polished, searchable website, built with mdBook.

**➡️ [Access the live curriculum here](https://your-username.github.io/your-repo-name/)**
*(You must update this link after your first deployment.)*

### Building the Book Locally
The content for the book is generated from the project's markdown files. To build and preview it:

1.  **Run the build script:** This script copies and formats content into the \`book-src\` directory.
    \`\`\`bash
    ./scripts/build_book.sh
    \`\`\`
2.  **Serve the book:**
    \`\`\`bash
    mdbook serve book-src
    \`\`\`
3.  Open your browser to \`http://localhost:3000\`.

### Deployment
Any push to the \`main\` branch will trigger the GitHub Actions workflow, which runs \`./scripts/build_book.sh\` and then deploys the site to GitHub Pages.
EOL

# Docker, Conda, and other config files...
cp /path/to/environment.yml . # Assuming you provide these
cp /path/to/Dockerfile .
cp /path/to/docker-compose.yml .
touch LICENSE

# mdBook configuration
cat > book-src/book.toml << EOL
[book]
title = "The 30-Day Product Analytics Masterclass"
authors = ["Your Name"]
src = "src"

[output.html]
git-repository-url = "https://github.com/your-username/your-repo-name"
EOL

# === 3. Generate Placeholders for Daily Work ===
echo "-> Generating placeholder notebooks and scripts..."
for i in $(seq -w 1 30); do
    touch "notebooks/Day_${i}_Challenge.ipynb"
    touch "solutions/Day_${i}_Solution.ipynb"
done
touch scripts/load_data_duckdb.py scripts/keyword_search.sql
touch data/raw/.gitkeep data/processed/.gitkeep
touch reports/ab_test_analysis.md reports/qbr_presentation.md

# === 4. Generate the GitHub Actions Deployment Workflow ===
echo "-> Generating the GitHub Actions workflow for mdBook deployment..."
cat > .github/workflows/deploy-mdbook.yml << EOL
name: Deploy mdBook Site to Pages
on:
  push:
    branches: ["main"]
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

concurrency:
  group: "pages"
  cancel-in-progress: false

jobs:
  build:
    runs-on: ubuntu-latest
    env:
      MDBOOK_VERSION: "${MDBOOK_VERSION}"
    steps:
      - name: Checkout repository
        uses: actions/checkout@v4
      
      - name: Install mdBook
        uses: peaceiris/actions-mdbook@v2
        with:
          mdbook-version: \${{ env.MDBOOK_VERSION }}

      - name: Run the Book Build Script
        run: |
          chmod +x ./scripts/build_book.sh
          ./scripts/build_book.sh

      - name: Setup GitHub Pages
        uses: actions/configure-pages@v5

      - name: Build with mdBook
        run: mdbook build ./book-src

      - name: Upload artifact
        uses: actions/upload-pages-artifact@v3
        with:
          path: ./book-src/book

  deploy:
    environment:
      name: github-pages
      url: \${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    needs: build
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4
EOL

# === 5. Create the Bridge Script (build_book.sh) ===
echo "-> Generating the 'build_book.sh' script to bridge content to mdBook..."
cat > scripts/build_book.sh << 'EOL'
#!/bin/bash

# This script prepares the content for the mdBook build.
# It copies primary markdown files into the book's source directory (`book-src/src`).

echo "📚 Preparing content for mdBook build..."

# --- Configuration ---
BOOK_SRC_DIR="book-src/src"
MAIN_CURRICULUM_FILE="30-Day Product Analytics Masterclass.md"
REPORTS_DIR="reports"

# --- Clean slate ---
echo "-> Clearing old book content..."
rm -rf "${BOOK_SRC_DIR}"/*
mkdir -p "${BOOK_SRC_DIR}"

# --- Copy Core Content ---
echo "-> Copying main curriculum and reports..."
# We will just copy the main file as the introduction for this example.
# A more advanced script would parse this file into chapters.
cp "${MAIN_CURRICULUM_FILE}" "${BOOK_SRC_DIR}/introduction.md"

# Copy key reports into the book
cp "${REPORTS_DIR}/ab_test_analysis.md" "${BOOK_SRC_DIR}/ab_test_analysis.md"
cp "${REPORTS_DIR}/qbr_presentation.md" "${BOOK_SRC_DIR}/qbr_presentation.md"

# --- Generate SUMMARY.md ---
echo "-> Generating book table of contents (SUMMARY.md)..."
cat > "${BOOK_SRC_DIR}/SUMMARY.md" << EOT
# Summary

[Introduction](./introduction.md)

---

# Key Analyses

- [A/B Test Analysis](./ab_test_analysis.md)
- [QBR Presentation Outline](./qbr_presentation.md)
EOT

echo "✅ mdBook content preparation complete."
EOL
chmod +x scripts/build_book.sh

# === 6. Final Touches ===
echo "-> Creating placeholder curriculum file..."
touch "30-Day Product Analytics Masterclass.md"

echo ""
echo "✅ Hybrid project skeleton generation complete!"
echo "Project '$PROJECT_NAME' created successfully."
echo ""
echo "Next Steps:"
echo "1. 'cd $PROJECT_NAME'"
echo "2. Populate '30-Day Product Analytics Masterclass.md' with the full curriculum."
echo "3. Update URLs in 'README.md' and 'book-src/book.toml'."
echo "4. Run './scripts/build_book.sh' to test the book generation."
echo "5. Initialize git and push to GitHub."
cd ..