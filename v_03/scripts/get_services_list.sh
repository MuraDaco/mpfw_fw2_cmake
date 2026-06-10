#!/bin/bash

    item_id=0
    matrix_services=()
    while IFS= read -r item; do
        ((item_id++))
        array_line+=(
            "$item"
        )
        ## find $item -name "/[^/]*Tbl.h"
        tblTemplaFile=$(find $item -name "*Tbl_template.cpp")
        [ -f "$tblTemplaFile" ] && {
            ## echo "$tblTemplaFile"

            serviceName=$(basename "$tblTemplaFile")
            serviceName=${serviceName%Tbl_template.cpp*}
            matrix_services+=("$serviceName;")
            matrix_services+=("$tblTemplaFile;")

            rpath=${item##*/src/}
            matrix_services+=("$rpath;")
            ## matrix_services+=("$rpath/${serviceName}Tbl.cpp;")

        }
    done < <( echo "$1" | tr ';' '\n' )

    echo "${matrix_services[@]}"

