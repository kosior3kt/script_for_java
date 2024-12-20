#!/bin/bash

echo "this thing will DELETE DIRECTORY DUPA. are you sure you want to precees? y/[n]"
read choice

#echo ${choice}
([[ ${choice} == "y" ]] || [[ ${choice} == "Y" ]]) && rm -fr dupa && echo "seccess" && exit 0;

echo "aborted"



