#!/bin/bash

    ##    for par_item
    ##    do
    ##        echo "par_item: $par_item"
    ##    done
    ##
    ##    echo "par 1:    $1"
    ##    echo "par 2:    $2"
    ##    echo "par 3:    $3"
    ##    echo "par 4:    $4"
    ##

    [ -d "$1" ] || {
        echo "error!! - get_cmake_files_list.sh - directory \"$1\" is not defined"
        exit 1
    }

    array_line=()
    while IFS= read -r item; do
        array_line+=(
            "$item"
        )
    done < <( echo "$4" | sed  "s|;|\n|g" )

    ## for trdp_fnct in ${array_line[@]}; do
    ##     echo "trdp_fnct: $trdp_fnct"
    ## done

    array_files=()
    while IFS= read -r item; do

        if [[ $item =~ "/trdp/" ]]; then
            for trdp_fnct in ${array_line[@]}; do

                if [[ $item =~ "/$trdp_fnct/" ]]; then
                    array_files+=("$item;")
                fi
            done
        else
            array_files+=("$item;")
        fi

    done < <( find $1 -type f -name "$2" | grep "/$3/" )

    echo "${array_files[@]}"

