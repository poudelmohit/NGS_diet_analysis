#!/bin/bash

## Set the directories:
data_dir="raw_reads"
temp_dir="temp"

# Create the temp directory if it doesn't exist
mkdir -p "$temp_dir"

# Read the sequences file line by line:
while IFS=$'\t' read -r id tag1 tag2; do
    # Search for the tags in the corresponding file:
    echo "Searching for pattern '$tag1+$tag2' in file starting with '$id'.."

    # Combine tag1 and tag2 with + sign:
    combined_pattern="${tag1}+${tag2}"

    # Get the list of files matching the pattern:
    matching_files="$data_dir/${id}_*.fastq"
    
    # Check for matching files:
    for file in $matching_files; do
        if [[ -e $file ]]; then
            echo "Searching in file: $file"
            # Use sed to process the file and save the output in the temp directory
            sed "/$combined_pattern/{n;s/^/$tag1/g;s/$/$tag2/;}" "$file" > "$temp_dir/$(basename "$file")"
        else
            echo "No files found matching pattern $matching_files"
        fi
    done

done < tags_list.txt

echo "Finished !!"
