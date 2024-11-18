#!/bin/bash

# Process command line arguments
SOURCE_DIR="${1:-.}"  # Default to current directory if not provided
OUTPUT_DIR="${2:-.}"  # Default to current directory if not provided

# Constants
MAX_FILE_SIZE=$((25 * 1024 * 1024))  # 25MB in bytes
MAX_TOKENS=32000  # Standard token limit for most LLMs

# Get project information
PROJECT_NAME=$(basename "$(cd "${SOURCE_DIR}" && pwd)")
TIMESTAMP=$(date "+%y%m%d_%H%M")

# Function to generate output filename
get_output_filename() {
    local index=$1
    echo "${OUTPUT_DIR}/${PROJECT_NAME}_$(printf "%03d" $index)_${TIMESTAMP}.md"
}

# Function to write header to file
write_header() {
    local file=$1
    local part=$2
    local total_files=$3
    
    echo "# Source Code Review and Analysis Report" > "$file"
    echo "Project: ${PROJECT_NAME}" >> "$file"
    echo "Part: ${part}/${total_files}" >> "$file"
    echo "Generated: $(date "+%Y-%m-%d %H:%M:%S")" >> "$file"
    echo "Repository Path: ${SOURCE_DIR}" >> "$file"
    echo "" >> "$file"
    echo "## Project Structure" >> "$file"
    echo "\`\`\`" >> "$file"
    tree "${SOURCE_DIR}" -L 2 -I "__pycache__|*.pyc|*.pyo|*.pyd|.git|.env|venv" >> "$file"
    echo "\`\`\`" >> "$file"
    echo "" >> "$file"
    echo "## Files in this Analysis" >> "$file"
    echo "" >> "$file"
}

# Function to add file content
write_file_content() {
    local output_file=$1
    local source_file=$2
    local relative_path=$3
    
    {
        echo "### ${relative_path}"
        
        # Add file statistics
        if [ -f "$source_file" ]; then
            local file_size=$(stat -f%z "$source_file" 2>/dev/null || stat -c%s "$source_file")
            local line_count=$(wc -l < "$source_file")
            echo "- Size: $(numfmt --to=iec --suffix=B ${file_size})"
            echo "- Lines: ${line_count}"
            echo -e "- Path: \`${relative_path}\`\n"
        fi
        
        # Add code block
        echo '```python'
        cat "$source_file"
        echo -e '\n```\n'
    } >> "$output_file"
}

# Initialize variables
current_file_num=1
current_size=0
current_output_file=$(get_output_filename $current_file_num)

# Collect all Python files
mapfile -t file_list < <(find "${SOURCE_DIR}" -name "*.py" -type f | sort)
total_files=${#file_list[@]}
estimated_parts=$(( (total_files + 9) / 10 ))  # Rough estimate of needed parts

# Create first file
write_header "$current_output_file" 1 "$estimated_parts"

# Process each Python file
for filepath in "${file_list[@]}"; do
    relative_path=$(realpath --relative-to="${SOURCE_DIR}" "${filepath}")
    file_size=$(stat -f%z "$filepath" 2>/dev/null || stat -c%s "$filepath")
    
    # Check if we need to create a new file
    if [ $((current_size + file_size + 2000)) -gt $MAX_FILE_SIZE ]; then
        # Create new file
        current_file_num=$((current_file_num + 1))
        current_output_file=$(get_output_filename $current_file_num)
        current_size=0
        write_header "$current_output_file" "$current_file_num" "$estimated_parts"
    fi
    
    # Add file content
    write_file_content "$current_output_file" "$filepath" "$relative_path"
    current_size=$((current_size + file_size + 2000))  # Include formatting overhead
done

# Print summary
echo -e "\nProcessing complete. Generated analysis files:"
for ((i=1; i<=current_file_num; i++)); do
    output_file=$(get_output_filename $i)
    if [ -f "$output_file" ]; then
        size=$(wc -c < "$output_file")
        echo "$(basename "${output_file}"): $(numfmt --to=iec --suffix=B ${size})"
    fi
done

echo -e "\nFiles are ready for code analysis and review"