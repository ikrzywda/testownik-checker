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

# Check the exit status of the script
  if [ $? -eq 1 ]; then
      cat "$filename"
      echo
      echo "**********"
      echo "An error occurred while executing pretty_print.py."
      echo "Displayed file contents using 'cat' command:"
      echo "**********"
  fi
  echo
  echo "----------------------------------------"
}

# Function to search for files with matching content
search_files() {
  local search_phrase="$1"
  local root_dir="$2"

  # Find files with matching content using grep
  files=$(grep -rli --include "*.txt" "$search_phrase" "$root_dir")

  if [ -z "$files" ]; then
    echo "No files found with matching content."
    return 1
  fi

  # Pretty print each file
  for file in $files; do
    pretty_print_file "$file" "$search_phrase"
  done
}

if [ $# -eq 0 ]; then
    echo "Error: Root directory argument is missing."
    echo "Usage: $0 <root_directory>"
    exit 1
fi

# Assign the root directory argument to a variable
root_dir="$1"

# Check if the root directory exists
if [ ! -e "$root_dir" ]; then
    echo "The specified directory does not exist."
    exit 1
fi

# Check if the root directory is a directory
if [ ! -d "$root_dir" ]; then
    echo "The specified path is not a directory."
    exit 1
fi

# Continue with further processing if the checks pass
echo "Root directory: $root_dir"

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
