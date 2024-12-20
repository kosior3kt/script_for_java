#!/bin/bash

java_files=$(find . -iname \*.java)

javac ${java_files}

for file in ${java_files}
do
	where_to_copy=$(awk ' /package/ {print $2}' $file)
	where_to_copy_processed=$(echo ${where_to_copy} | sed 's/\./\//g')
	where_to_copy_processed=$(echo ${where_to_copy_processed} | sed 's/;//')

	current_loc_class=$(echo $file | sed 's/\.java/\.class/')

	mkdir -p ${where_to_copy_processed}

	mv ${current_loc_class} ${where_to_copy_processed} 
done

[[ "${1}" == "-r" ]] && java dupa.Main && exit 0
[[ "$#" == 0 ]] && exit 0

echo "unknown flag ${1}"


