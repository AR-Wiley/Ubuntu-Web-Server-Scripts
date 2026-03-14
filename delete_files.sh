#!/bin/bash

set -euo pipefail

if [[ $EUID -ne 0 ]]; then
        echo "You must be root to run this script..."
        exit 1
fi

TARGET="/home/user/Documents"


function Delete_Files {

        local target=$1

        declare -a files

        files+=("$target"/*)

        for i in "${files[@]}"; do
                rm  -r -f -v "$i"
        done

}

Delete_Files "$TARGET"
