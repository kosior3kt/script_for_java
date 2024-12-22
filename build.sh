#!/bin/bash

cwd_files=$(ls | grep "java_root")

[[ ${cwd_files} == "" ]] && echo "I haven't found file: java_root. 
This is safety mechanism. This script will recursively 
search for java files from current location. This can be messy if
you invoke it in place that is not java project root.
If you haven't read README, do so now." && exit 1;

java_files=$(find . -iname \*.java)

javac ${java_files}

verbose=false

for file in ${java_files}
do
	[ ${verbose} == true ] && echo "$file"
	[ ${verbose} == true ] && echo "==============================START============================="
	where_to_copy=$(awk ' /package/ {print $2}' $file)
	[ ${verbose} == true ] && echo "where_to_copy: ${where_to_copy}"

	where_to_copy=$(echo "${where_to_copy}" | head -1)
	[ ${verbose} == true ] && echo "where_to_copy | head -1: ${where_to_copy}"

	where_to_copy_processed=$(echo ${where_to_copy} | sed 's/\./\//g')
	[ ${verbose} == true ] && echo "where_to_copy_processed: ${where_to_copy_processed}"

	where_to_copy_processed=$(echo ${where_to_copy_processed} | sed 's/;//')
	[ ${verbose} == true ] && echo "where_to_copy_processed (trimmed): ${where_to_copy_processed}"

	current_loc_class=$(echo $file | sed 's/\.java/\.class/')
	[ ${verbose} == true ] && echo "current_loc_class: ${current_loc_class}"

	
	# FUCK JAVA
	# # find all files that start with <FileName>$<className>.class
	# # and move them somewhere as well
	# # this is needed cause java is an absolute garbage language 
	directory_with_file="${current_loc_class%/*}"

	file_name=$(echo ${file##*/} | sed 's/\.java//')

	#find ${directory_with_file} -name "${file_name}*.class" -print


	# mkdir command if the directories dont exist yet
	mkdir -p ${where_to_copy_processed}
	[ ${verbose} == true ] && echo "mkdir command: mkdir -p ${where_to_copy_processed}"
	
	# move these suckers in there!
	# this one is just for normal files
	mv ${current_loc_class} ${where_to_copy_processed} 
	# and this one is all the files that contain $
	find ${directory_with_file} -name "${file_name}*.class" -exec mv {} "${where_to_copy_processed}" \;
	[ ${verbose} == true ] && echo "mv command: mv ${current_loc_class} ${where_to_copy_processed}"
	[ ${verbose} == true ] && echo "==============================STOP=============================="
done


[[ "${1}" == "-r" ]] && java dupa.Main && exit 0
[[ "$#" == 0 ]] && exit 0

echo "unknown flag ${1}"


