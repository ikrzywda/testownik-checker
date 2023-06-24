#!/bin/bash

# Function to pretty print a file
pretty_print_file() {
  local filename="$1"
  local phrase="$2"

  # Highlight the searched phrase using grep
  highlighted_content=$(grep -i "$phrase" "$filename" | grep --color=always -i "$phrase")


  # Print the pretty-printed file
  echo -e "File: $filename"
  echo "$highlighted_content"
  ./pretty_print.py "$filename"
  echo
  echo "----------------------------------------"
}

# Function to search for files with matching content
search_files() {
  local search_phrase="$1"
  local root_dir="$2"

  # Find files with matching content using grep
  files=$(grep -rl --include "*.txt" "$search_phrase" "$root_dir")

  if [ -z "$files" ]; then
    echo "No files found with matching content."
    return 1
  fi

  # Pretty print each file
  for file in $files; do
    pretty_print_file "$file" "$search_phrase"
  done
}

# Read the root directory from user
echo "Enter the root directory:"
read root_dir
echo $root_dir
# Loop until "quit" is entered
while true; do
  # Read input from user
  echo "Enter a search phrase (or 'quit' to exit):"
  read input_phrase

  # Check if user wants to quit
  if [ "$input_phrase" == "quit" ]; then
    echo "Exiting the program."
    break
  fi

  # Perform the search
  search_files "$input_phrase" "$root_dir"
done
