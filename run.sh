#!/bin/bash

# Check if the transcript file exists
if [ ! -f transcript.txt ]; then
  echo "Error: transcript.txt file not found"
  exit 1
fi

# Create the output directory if it doesn't exist
mkdir -p output

# Generate a timestamp to use in the output filename
timestamp=$(date +%Y-%m-%d_%H-%M-%S)

# Use sed to replace lines matching the pattern with an empty string
# Then, use sed again to replace lines containing only numbers with an empty string
# Finally, use awk to concatenate lines without a period, exclamation mark, or question mark at the end with the next line
sed -e 's/^[0-9:,]\+ --> [0-9:,]\+$//g' -e '/^[0-9]*$/d' transcript.txt | awk '{if (substr($0,length($0)) == "." || substr($0,length($0)) == "!" || substr($0,length($0)) == "?") {if (NR!=1) print hold; print $0; hold=""} else {hold=hold" "$0}} END {if (hold!="") print hold}' > output/output_${timestamp}.txt

# Check if any modifications were made to the transcript file
if cmp -s transcript.txt output/output_${timestamp}.txt; then
  echo "Error: no modifications made to transcript file"
  exit 1
fi

# Display a success message with the full path of the output file on a new line
echo "Transcript cleaned up successfully."$'\n'"Output file: $(realpath output/output_${timestamp}.txt)"
