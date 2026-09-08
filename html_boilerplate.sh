#!/bin/bash

set -euo pipefail

dir="website"

files=("index.html" "index.css" "index.js")


function create_files {

        for file in "${files[@]}"; do
                touch /website/$file
        done
}
