
input="1.d.files"           # Input directory
output="1.d.files.out"      # Output directory
total="1.d.out.txt"         # Combining all the files

# Create output directory
mkdir "$output"

# Create the final file
touch "$total"

# Iterate through all the files in the input directory
for files in "$input"/*
do
    sort -nr $files -o "$output"/"$(basename -- $files)" # Sort each file and store it in output directory
    echo "Sorted $(basename -- $files)"
done

sort -nmr "$output"/* -o "$total" # Merging all the files
echo "Merged all the files"