#!/bin/bash

    item_id=0
    while IFS= read item; do
        ((item_id++))
        parsing=${item%%:*}
        echo $parsing
        
    done
