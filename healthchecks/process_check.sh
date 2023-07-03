#!/bin/bash

if ps aux | grep '[p]ython /path/to/your/script.py' > /dev/null; then
    exit 0
else
    exit 1
fi