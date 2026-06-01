#!/bin/bash


## cat krThreadTbl_template.cpp | create_tbl_cpp.sh "lista include" "lista task pointer define"

## // #include modules here ...
## // list of pointer function here ...

    ref_include="->> #include modules here ... <<-"
    ref_pointer="->> list of pointer function here ... <<-"
    item_id=0
    while IFS= read item; do
        ((item_id++))
        
        echo "$item"
        check_pars=${item#*$ref_include}
        if [ "$item" != "$check_pars" ]; then
            break;
        fi
    done

    while IFS= read -r item; do
        echo "$item"
    done < <( echo "$1" | sed  "s|;|\n|g" )

    while IFS= read item; do
        ((item_id++))
        
        echo "$item"
        check_pars=${item#*$ref_pointer}
        if [ "$item" != "$check_pars" ]; then
            break;
        fi
    done

    while IFS= read -r item; do
        [ -n "$item" ] && {
            echo "        $item,"
        } || true
        
    done < <( echo "$2" | sed  "s|;|\n|g" )

    while IFS= read item; do
        echo "$item"
    done
