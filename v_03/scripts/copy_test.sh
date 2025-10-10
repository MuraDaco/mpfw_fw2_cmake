#!/bin/bash

echo "PWD test 1: $PWD"
echo "PWD test 2: `pwd`"
echo "$2" | cut -d';' -f1-4

while IFS= read item; do
    echo "$item"
done

cp ../../../../../../../../main/app20240619/layer/mpfw_fw2_main_app20240619_5main/common/src/tb/kr/krInit/v_01/main/krInitStaticTbl.cpp $1


