#!/bin/bash

file_path="~/.config/code-server/config.yaml"  # Specify the path to your file

# Function to wait for the file to become available
wait_for_file() {
  while [ ! -f "$1" ]; do
    echo "Waiting for file: $1"
    sleep 1
  done
  # Read the contents of the file
  file_contents=$(cat "$file_path")
  echo "File contents:"
  echo "$file_contents"
}

# Wait for the file to become available
wait_for_file "$file_path" &


