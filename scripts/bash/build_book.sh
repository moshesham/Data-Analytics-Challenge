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
