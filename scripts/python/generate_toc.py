import os

def generate_toc():
    """Generates a markdown table of contents for the challenge notebooks."""
    toc_lines = []
    notebooks_dir = 'notebooks'
    
    # Sort files naturally (Day_01, Day_02, ..., Day_10)
    files = sorted(os.listdir(notebooks_dir), key=lambda x: int(x.split('_')[1]))

    for filename in files:
        if filename.endswith('.ipynb'):
            day_num = filename.split('_')[1]
            title = f"Day {day_num}: Challenge" # Placeholder, could read from notebook
            link = os.path.join(notebooks_dir, filename)
            toc_lines.append(f"* [**{title}**]({link})")
    
    toc_str = "\n".join(toc_lines)
    
    # Update the main README
    with open('README.md', 'r') as f:
        content = f.read()
    
    start_marker = "<!-- TOC-START -->"
    end_marker = "<!-- TOC-END -->"
    
    start_index = content.find(start_marker)
    end_index = content.find(end_marker)
    
    if start_index != -1 and end_index != -1:
        new_content = (content[:start_index + len(start_marker)] + 
                       "\n" + toc_str + "\n" + 
                       content[end_index:])
        with open('README.md', 'w') as f:
            f.write(new_content)
        print("✅ README.md Table of Contents updated successfully.")
    else:
        print("⚠️ TOC markers not found in README.md.")

if __name__ == "__main__":
    generate_toc()
