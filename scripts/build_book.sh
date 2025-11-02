#!/bin/bash

# --- Variables ---
MAIN_CURRICULUM_FILE="30-Day Product Analytics Masterclass.md"
C:\Users\Moshe\Analytical_Guide\Data-Analytics-Challenge\30-Day Product Analytics Masterclass.md
BOOK_SRC_DIR="book-src/src"
REPORTS_DIR="reports"

# --- Copy Core Content ---
echo "-> Copying main curriculum and reports..."
# Copy the main curriculum as introduction
cp "${MAIN_CURRICULUM_FILE}" "${BOOK_SRC_DIR}/introduction.md"

# Copy all week/day markdown files
for week in week-1 week-2 week-3 week-4; do
  if [ -d "${BOOK_SRC_DIR}/$week" ]; then
    cp -r "${BOOK_SRC_DIR}/$week" "${BOOK_SRC_DIR}/$week"
  fi
done

# Copy key reports into the book
cp "${REPORTS_DIR}/ab_test_analysis.md" "${BOOK_SRC_DIR}/ab_test_analysis.md"
cp "${REPORTS_DIR}/qbr_presentation.md" "${BOOK_SRC_DIR}/qbr_presentation.md"
cp "${REPORTS_DIR}/Journals_Instrumentation_Plan.md" "${BOOK_SRC_DIR}/Journals_Instrumentation_Plan.md"
cp "${REPORTS_DIR}/Week1_Launch_Summary.md" "${BOOK_SRC_DIR}/Week1_Launch_Summary.md"
cp "${REPORTS_DIR}/AB_Test_Final_Readout.md" "${BOOK_SRC_DIR}/AB_Test_Final_Readout.md"
cp "${REPORTS_DIR}/Pre_Mortem_Memo.md" "${BOOK_SRC_DIR}/Pre_Mortem_Memo.md"
cp "${REPORTS_DIR}/Journals_Launch_Monitoring_Dashboard.md" "${BOOK_SRC_DIR}/Journals_Launch_Monitoring_Dashboard.md"
cp "${REPORTS_DIR}/DiD_Critical_Assessment.md" "${BOOK_SRC_DIR}/DiD_Critical_Assessment.md"