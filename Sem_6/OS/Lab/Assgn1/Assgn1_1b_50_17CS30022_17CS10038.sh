# Print the headers
echo "Serial Random string" > 1b_output.txt

# Attach each line with line numbers
nl 1b_input.txt >> 1b_output.txt

# Print it out to the file 1b_output.txt
echo "Output in file '1b_output.txt'"
