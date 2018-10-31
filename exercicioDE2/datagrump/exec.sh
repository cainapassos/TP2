#!/bin/bash

for((i=1; i<=29; i++))
do
    echo "==============================================="

    ./run-contest a
    echo "$i"
    sleep 2

done
