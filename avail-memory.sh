#!/bin/bash

if [[ $EUID -ne 0 ]]; then
        echo "You must be root to run this script" >&2
        exit 1
fi


admin_log_path="/var/log/admin-logs/"
file_path="$admin_log_path/memory-usage.txt"

timestamp=$(date "+%Y-%m-%d")

function Validate_Log_Path {

        if [[ ! -d $admin_log_path ]]; then
                mkdir -p $admin_log_path
                echo "$admin_log_path has been created"
        fi
}

function Validate_File_Path {

        if [[ ! -f $file_path ]]; then
                touch $file_path
                echo "$file_path has been created"
        fi
}


function Avail_Memory {

        AVAIL=$(free -m | awk 'NR==2 {print $7}')
        MINIMIUM=1024

        if (( AVAIL < MINIMIUM )); then
                echo "ALERT. FREE AVAILABLE RAM SPACE: $AVIAL IS BELOW MINIMUM THRESHOLD: $MINIMIUM" >> "$file_path"
        fi

        free -m >> "$file_path"

        echo "$timestamp" >> "$file_path"
}

Validate_Log_Path
Validate_File_Path
Avail_Memory







