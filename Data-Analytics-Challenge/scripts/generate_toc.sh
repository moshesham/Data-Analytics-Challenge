#!/bin/bash

# This script generates a hyperlinked Table of Contents for the 30-Day Challenge
# and inserts it into the main README.md file.

# --- Configuration ---
README_FILE="README.md"
TOC_START_MARKER="<!-- TOC-START -->"
TOC_END_MARKER="<!-- TOC-END -->"
TEMP_FILE=$(mktemp)

echo "🚀 Starting Table of Contents generation for $README_FILE..."

# --- Find and Format Challenge Directories ---
TOC_CONTENT=""
# Find directories matching the pattern, sort them naturally, and loop through
for day_dir in $(find . -maxdepth 1 -type d -name "Day_[0-9][0-9]_*" | sort); do
    # Clean up the directory name to be './Day_XX_Topic'
    dir_name=$(basename "$day_dir")
    
    # Extract Day Number (e.g., "01")
    day_num=$(echo "$dir_name" | cut -d'_' -f2)
    
    # Extract Topic Name and replace underscores with spaces
    topic_name=$(echo "$dir_name" | cut -d'_' -f3- | tr '_' ' ')
    
    # Create the markdown-formatted link
    TOC_CONTENT="${TOC_CONTENT}* **Day ${day_num}:** [${topic_name}](${day_dir}/)\n"
    echo "  -> Found: ${dir_name}"
done

if [ -z "$TOC_CONTENT" ]; then
    echo "⚠️ No 'Day_XX' directories found. Exiting."
    exit 1
fi

# --- Check if README.md and markers exist ---
if [ ! -f "$README_FILE" ]; then
    echo "❌ ERROR: $README_FILE not found. Please create it first."
    exit 1
fi

if ! grep -q "$TOC_START_MARKER" "$README_FILE" || ! grep -q "$TOC_END_MARKER" "$README_FILE"; then
    echo "❌ ERROR: TOC markers not found in $README_FILE."
    echo "Please add the following lines to your README.md:"
    echo "$TOC_START_MARKER"
    echo "..."
    echo "$TOC_END_MARKER"
    exit 1
fi

# --- Rebuild the README with the new TOC ---
# Use awk to replace the content between the markers
awk -v toc_content="$TOC_CONTENT" '
  BEGIN { p = 1 }
  $0 ~ /<!-- TOC-START -->/ { print; print toc_content; p = 0 }
  $0 ~ /<!-- TOC-END -->/   { p = 1 }
  p { print }
' "$README_FILE" > "$TEMP_FILE"

# --- Finalize ---
# Replace the old README with the updated one
mv "$TEMP_FILE" "$README_FILE"

echo "✅ Table of Contents successfully updated in $README_FILE."