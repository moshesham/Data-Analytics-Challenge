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
cp "${MAIN_CURRICULUM_FILE}" "${BOOK_SRC_DIR}/introduction.md"

# Copy key reports into the book
cp "${REPORTS_DIR}/ab_test_analysis.md" "${BOOK_SRC_DIR}/ab_test_analysis.md"
cp "${REPORTS_DIR}/qbr_presentation.md" "${BOOK_SRC_DIR}/qbr_presentation.md"
cp "${REPORTS_DIR}/Journals_Instrumentation_Plan.md" "${BOOK_SRC_DIR}/Journals_Instrumentation_Plan.md"
cp "${REPORTS_DIR}/Week1_Launch_Summary.md" "${BOOK_SRC_DIR}/Week1_Launch_Summary.md"
cp "${REPORTS_DIR}/AB_Test_Final_Readout.md" "${BOOK_SRC_DIR}/AB_Test_Final_Readout.md"
cp "${REPORTS_DIR}/Pre_Mortem_Memo.md" "${BOOK_SRC_DIR}/Pre_Mortem_Memo.md"
cp "${REPORTS_DIR}/Journals_Launch_Monitoring_Dashboard.md" "${BOOK_SRC_DIR}/Journals_Launch_Monitoring_Dashboard.md"
cp "${REPORTS_DIR}/DiD_Critical_Assessment.md" "${BOOK_SRC_DIR}/DiD_Critical_Assessment.md"

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
