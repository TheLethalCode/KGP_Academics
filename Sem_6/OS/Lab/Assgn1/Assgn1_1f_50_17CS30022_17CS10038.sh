input="1f.graph.edgelist" # Input file
output="1f_output_graph.edgelist" # Output file

printf "Cleaning the graph...\n"

# Listing the file contents
# Removing parallel edges and organizing the edges
# Sorting the edges
# Group the sorted edges

cat "$input" \
| awk '{if( $2 < $1 ) print $2,$1; else if( $1 < $2) print $1, $2}' \
| sort -n -k1,1 -k2,2 \
| uniq > "$output"

printf "Graph cleaned.\n\nFinding the highest 5 degrees...\n\n"

# List the contents of the file
# Break the line into separate lines
# Sort the numbers
# Count their frequency
# Sort them based on frequency
# List the top 5
# Swap the order

cat "$output" \
| awk '{printf "%s\n%s\n",$1,$2}' \
| sort -n \
| uniq -c \
| sort -k1,1 -nr \
| head -5 \
| awk '{print $2,$1}' 