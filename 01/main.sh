#!/bin/bash

reg_express_numb="^[a-zA-Zа-яА-Я]+$"

if [[ $# -eq 1 ]]; then
    if [[ $1 =~ $reg_express_numb ]]; then
        echo $1
    else
        echo "Incorrenct input (argument is number)"
    fi
else
    echo "Incorrect input (empty arguments)"
fi
