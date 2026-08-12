#!/bin/bash

if [[ $EUID -ne 0 ]]; then
        echo "You must be root to run this script" >&2
        exit 1
fi

path="/etc/default/useradd"
values=('HOME' 'INACTIVE' 'EXPIRE' 'SKEL' 'CREATE_MAIL_SPOOL')

declare -A configs=(
        [HOME]="/home"
        [INACTIVE]=14
        [EXPIRE]=-1
        [SKEL]="/etc/skel"
        [CREATE_MAIL_SPOOL]="yes"
)

function update_user_configs {
       
        for i in "${values[@]}"; do

                if grep -q "^${i}" "$path"; then
                        sed -i "s/^\(${i}[[:space:]]*\).*/\1 ${configs[$i]}/" "$path"
                else
                        echo "${i} ${configs[$i]}" >> "$path"
                fi
        done
}

update_user_configs
