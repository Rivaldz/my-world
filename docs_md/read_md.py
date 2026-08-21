import os
import glob

def main():
    # Directory mapping from docker-compose.yml
    search_dir = "/app/data"
    
    print(f"Searching for .md files in {search_dir}...")
    
    # Recursively find all .md files
    md_files = glob.glob(os.path.join(search_dir, "**/*.md"), recursive=True)
    
    if not md_files:
        print("No .md files found.")
        return

    print(f"Found {len(md_files)} .md files. Reading contents:\n")
    
    for filepath in md_files:
        print(f"--- File: {filepath} ---")
        try:
            with open(filepath, 'r', encoding='utf-8') as f:
                content = f.read()
                # Print the first few lines to give a preview
                lines = content.splitlines()
                for line in lines[:10]:
                    print(line)
                if len(lines) > 10:
                    print("... (content truncated)")
        except Exception as e:
            print(f"Error reading {filepath}: {e}")
        print("\n")

if __name__ == "__main__":
    main()
