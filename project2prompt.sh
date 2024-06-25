#!/bin/bash

# Default directory (current directory)
target_dir="."
output_dir=""
scrub_comments=false

# Default ignore patterns
ignore_patterns=("LICENSE" "LICENSE.md" ".gitignore")
ignore_hidden=true

# Function to display usage information
usage() {
    echo "Usage: $0 [OPTIONS] [DIRECTORY]"
    echo "Options:"
    echo "  -i, --ignore PATTERN   Ignore files matching PATTERN (can be used multiple times)"
    echo "  -a, --all              Include hidden files (starting with .)"
    echo "  -o, --output FILE      Specify output file name (without .md extension)"
    echo "  -d, --output-dir DIR   Specify output directory (default: same as input directory)"
    echo "  -s, --scrub-comments   Remove comments from the output file"
    echo "  -h, --help             Display this help message"
    echo "DIRECTORY                Path to the directory to process (default: current directory)"
}

# Parse command-line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -i|--ignore)
            ignore_patterns+=("$2")
            shift 2
            ;;
        -a|--all)
            ignore_hidden=false
            shift
            ;;
        -o|--output)
            output_file="$2"
            shift 2
            ;;
        -d|--output-dir)
            output_dir="$2"
            shift 2
            ;;
        -s|--scrub-comments)
            scrub_comments=true
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        -*)
            echo "Unknown option: $1"
            usage
            exit 1
            ;;
        *)
            target_dir="$1"
            shift
            ;;
    esac
done

# Check if the target directory exists
if [ ! -d "$target_dir" ]; then
    echo "Error: Directory '$target_dir' does not exist."
    exit 1
fi

# Set output file name if not provided
if [ -z "$output_file" ]; then
    dir_name=$(basename "$target_dir")
    output_file="${dir_name}_project"
fi

# Set output directory if not provided
if [ -z "$output_dir" ]; then
    output_dir="$target_dir"
fi

# Construct full output path
full_output_path="$output_dir/${output_file}.md"

# Remove the output file if it already exists
rm -f "$full_output_path"

# Function to process each file
process_file() {
    local file="$1"
    echo "Path: $file" >> "$full_output_path"
    echo "" >> "$full_output_path"

    # Determine the file extension
    extension="${file##*.}"

    echo "\`\`\`$extension" >> "$full_output_path"
    if $scrub_comments; then
        # Generic comment removal
        sed '
            # Remove single-line comments starting with #, //, --, ;, or %
            s/^\s*\(#\|\/\/\|--\|;\|%\).*$//g
            
            # Remove multi-line comments for C-style languages
            /\/\*/,/\*\//d
            
            # Remove multi-line comments for HTML/XML
            /<!--/,/-->/d
            
            # Remove multi-line comments for Lua
            /--\[\[/,/\]\]/d
            
            # Remove blank lines
            /^\s*$/d
        ' "$file" >> "$full_output_path"
    else
        cat "$file" >> "$full_output_path"
    fi
    echo "\`\`\`" >> "$full_output_path"
    echo "" >> "$full_output_path"
    echo "-----------" >> "$full_output_path"
    echo "" >> "$full_output_path"
}

# Generate tree view
echo "Project Structure:" >> "$full_output_path"
echo "\`\`\`" >> "$full_output_path"
tree -L 3 --charset=ascii "$target_dir" >> "$full_output_path"
echo "\`\`\`" >> "$full_output_path"
echo "" >> "$full_output_path"
echo "-----------" >> "$full_output_path"
echo "" >> "$full_output_path"

# Construct find command
find_cmd="find '$target_dir'"

# Add ignore patterns
for pattern in "${ignore_patterns[@]}"; do
    find_cmd+=" -not -name '$pattern'"
done

# Ignore hidden files if specified
if $ignore_hidden; then
    find_cmd+=" -not -path '*/.*'"
fi

# Find and process files
eval "$find_cmd -type f" | sort | while read -r file; do
    process_file "$file"
done

echo "Files have been combined into $full_output_path"
