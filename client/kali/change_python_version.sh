#!/bin/bash

# Iterate over each Python file in the directory
for file in ./; do
  if [[ -f "$file" ]]; then
    # Check if the file is a regular file
    if [[ -f "$file" ]]; then
      # Update the shebang line to point to the desired Python version
      sed -i '1s|^#!/usr/bin/env python$|#!/usr/bin/env python2.7|' "$file"
      echo "Modified: $file"
    fi
  fi
done