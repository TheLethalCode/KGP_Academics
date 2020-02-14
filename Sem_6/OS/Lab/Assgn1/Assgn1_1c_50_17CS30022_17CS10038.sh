# Usage instruncions
func()
{
	printf "USAGE INSTRUCTIONS\n"
	printf "==================\n"
	printf "Assgn1_1c_50_17CS30022_17CS10038.sh <int> <int> ... <int>\n"
	printf "NUMBER OF ARGUMENTS:- Atleast 2, Atmost 10\n"
}

# GCD Function
gcd() {

	# Base condition
	if [[ $1 == 0 ]]; then
		return $2
	fi
	
	# Recursion
	gcd $(( $2 % $1)) $1
	return $?
}

# If more than 9 arguments
if [ "$#" -gt 10 ]; then
	func
	exit
fi

# If 2 arguments not given
if [ "$#" -lt 2 ]; then
	func
	exit
fi

temp="$1"

# Appending each variable in the GCD
for var in "$@"; do

	# Check for non-integer args
	if [[ $var =~ [^0-9] ]]; then
		func
		exit
	fi

	# Calling the GCD function
	gcd $temp $var
	temp="$?"
done

# Print the val
echo "$temp"
