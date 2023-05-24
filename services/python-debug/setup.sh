#!/bin/bash

function insert_lines_with_cursor() {
    file_path=$1
    lines_to_insert=("${@:2}")

    content=$(cat "$file_path")
    echo "Content of $file_path:"
    echo "$content"

    echo -e "\nSelect the line number where you want to insert the lines:"
    read -r line_number

    lines_to_insert=$(printf "%s\n" "${lines_to_insert[@]}")
    sed -i "${line_number}i$lines_to_insert" "$file_path"

    echo -e "\nLines inserted successfully into $file_path!"
}

# Get a list of all Python files in the current directory and its subdirectories
python_files=()
while IFS= read -r -d '' file; do
    python_files+=("$file")
done < <(find . -type f -name "*.py" -print0)

num_files=${#python_files[@]}

# Display the available Python files with numbering
echo "Available Python files:"
for ((i=0; i<num_files; i++)); do
    echo "$((i+1)). ${python_files[i]}"
done

# Prompt the user to select a file by number or path
echo -e "\nEnter the number or path of the file where you want to insert lines:"
read -r selection

if [[ "$selection" =~ ^[0-9]+$ ]]; then
    index=$((selection - 1))
    if (( index >= 0 && index < num_files )); then
        selected_file=${python_files[index]}
    else
        echo "Invalid selection!"
        exit 1
    fi
else
    selected_file=$selection
    if [[ ! -f "$selected_file" ]]; then
        echo "File not found!"
        exit 1
    fi
fi

# Prompt the user for the lines to be inserted
lines_to_insert=()
echo -e "\nEnter the lines to be inserted (press Enter on a blank line to finish):"
while IFS= read -r line; do
    if [[ -z "$line" ]]; then
        break
    fi
    lines_to_insert+=("$line")
done

# Call the function to insert the lines
insert_lines_with_cursor "$selected_file" "${lines_to_insert[@]}"
