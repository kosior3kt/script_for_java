#!/bin/bash

cwd_files=$(ls | grep "java_root")

[[ ${cwd_files} == "" ]] && echo "I haven't found file: java_root. 
This is safety mechanism. This script will recursively 
search for java files from current location. This can be messy if
you invoke it in place that is not java project root.
If you haven't read README, do so now." && exit 1;

java_files=$(find . -iname \*.java)

javac ${java_files}

for file in ${java_files}
do
	where_to_copy=$(awk ' /package/ {print $2}' $file)

	where_to_copy=$(echo "${where_to_copy}" | head -1)

	where_to_copy_processed=$(echo ${where_to_copy} | sed 's/\./\//g')
	where_to_copy_processed=$(echo ${where_to_copy_processed} | sed 's/;//')

	current_loc_class=$(echo $file | sed 's/\.java/\.class/')

	mkdir -p ${where_to_copy_processed}

	mv ${current_loc_class} ${where_to_copy_processed} 
done

[[ "${1}" == "-r" ]] && java dupa.Main && exit 0
[[ "$#" == 0 ]] && exit 0

echo "unknown flag ${1}"


