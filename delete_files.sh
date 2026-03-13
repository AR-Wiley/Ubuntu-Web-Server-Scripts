#!/bin/bash

if [[ $EUID -ne 0 ]]; then
        echo "You must be root to run this script..."
        exit 1
fi

TARGET="/home/user/Documents"


function Delete_Files {

        local target=$1

        declare -a files

        Files+=("$target"/*)

        for i in "${Files[@]}"; do
                rm  -r -f -v "$i"
        done

}

Delete_Files "$TARGET"
