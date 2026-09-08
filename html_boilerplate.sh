#!/bin/bash

set -euo pipefail

echo "This script will create an standard HTML, CSS, and JS boilerplate."
echo "Input in what you want to name the file and directory"

while true; do
        read -r -p "Name HTML file: " html_file

        if [[ -n "$html_file" ]]; then
                break
        fi

        echo "Please provide HTML file name"

done

while true; do
        read -r -p "Name of Directory: " html_dir

        if [[ -n "$html_dir" ]]; then
                break
        fi

        "Please provide Directory name for files"
done

