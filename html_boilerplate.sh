#!/bin/bash

set -euo pipefail

while true; do
        read -r -p "Name HTML file: " html_file

        if [[ -n "$html_file" ]]; then
                break
        fi

        echo "Please provide HTML file name"

done
