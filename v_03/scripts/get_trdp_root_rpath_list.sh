#!/bin/bash

    [ -d "$1" ] || {
        echo "error!! - get_trdp_root_rpath_list.sh - directory is not defined"
        exit 1
    }
    item_id=0
    trdp_fnct_list=()
    while IFS= read -r item; do
        ((item_id++))
        array_line+=(
            "$item"
        )

        trdp_dir=$(find $1 -type d -name "$item" | sort | head -1)
        [ -d "$trdp_dir" ] && {

            trdp_rpath=${trdp_dir#$1/}
            trdp_fnct_list+=("$trdp_rpath;")

        }
    done < <( echo "$2" | sed  "s|;|\n|g" )

    echo "${trdp_fnct_list[@]}"

