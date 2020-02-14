# Usage Instrunctions
func()
{
    printf "USAGE INSTRUCTIONS\n"
    printf "==================\n"
    printf "Assgn1_1e_50_17CS30022_17CS10038.sh <file_name> <col_no>\n"
    printf "col_no:- 1 to 4\n"
}

# If there are not 2 arguments or the column number isnt from 1 to 4
if [[ "$#" -ne 2 || ! $2 =~ [1-4] ]]
then
    func
    exit
fi

# If the file doesnt exist
if [ ! -f "$1" ]
then
    printf "File not found\n"
    exit
fi


# Display the file
# Read only the required column
# Sort the column ignoring case
# Merge repeated lines and append frequency at the start
# Sort based on the first word numerically
# Exchange the first and second word and convert string to lower case
# Output it into a file

cat "$1" | awk -v var="$2" '{print $var}' \
    | sort -f | uniq -ic | sort -nr -k1,1 \
        | awk '{print tolower($2),$1}' >> "1e_output_${2}_column.freq" 
