#!/bin/bash

    item_id=0
    while IFS= read -r item; do
        ((item_id++))
        array_line+=(
            "$item"
        )
    done < <( echo "$1" | tr ';' '\n' )

    matrix_tasks=()
    for line in "${array_line[@]}";
    do
        while IFS= read -r item; do
            parsing_1=${item%%:*}
            matrix_tasks+=("$parsing_1;")

            parsing_1=${parsing_1#*$line/}
            parsing_1="#include \"$parsing_1\""
            matrix_tasks+=("$parsing_1;")

            parsing_2=${item#*PTR_TASK_OF_}
            parsing_2="PTR_TASK_OF_$parsing_2"
            parsing_2=${parsing_2%% *}
            matrix_tasks+=("$parsing_2;")

            parsing_3=${item##* }
            matrix_tasks+=("$parsing_3;")

        ## done < <( grep -rn "$line" -e 'PTR_TASK_OF_krThread_' )
        done < <( grep -rn "$line" -e "PTR_TASK_OF_$2_" )
    done

    echo "${matrix_tasks[@]}"
