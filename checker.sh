#!/bin/bash

# check if TEST_SET_DIR is set in the environment
if [ -z "$TEST_SET_DIR" ]; then
    echo "TEST_SET_DIR is not set. Please set TEST_SET_DIR to the directory containing the test set."
    exit 1
fi


# loop of input until user enters "exit" or "q"
while true; do
    read -p "Enter phrase to search for (or 'exit' to quit): " phrase
    if [ "$phrase" == "exit" ] || [ "$phrase" == "q" ]; then
        break
    fi

    # grep through all files in TEST_SET_DIR for the phrase and cat the whole file
    grep -r "$phrase" "$TEST_SET_DIR" | while read -r line; do
        # split the line into an array
        IFS=':' read -ra ADDR <<< "$line"
        # print the file name
        echo "File: ${ADDR[0]}"
        cat "${ADDR[0]}"
        echo ""
        echo ""
    done
done
