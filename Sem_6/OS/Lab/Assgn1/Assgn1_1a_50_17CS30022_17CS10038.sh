# Usage instructions
func()
{
	printf "USAGE INSTRUCTIONS\n"
	printf "==================\n"
	printf "Assgn1_1a_50_17CS30022_17CS10038.sh <int> <op> <int>\n"
	printf "op:- +, -, '*', /\n"
}

# Check for non - integer arguments
if [[ $1 =~ [^-0-9] || $3 =~ [^-0-9] ]]
then
	func

# Addition
elif [ "$2" == '+' ]
then
	echo "$(($1 + $3))"

# Subtraction
elif [ "$2" == '-' ]
then
	echo "$(($1 - $3))"

# Multiplication
elif [ "$2" == '*' ]
then
	echo "$(($1 * $3))"

# Divison
elif [ "$2" == '/' ]
then
	echo "$(($1 / $3))"

# Modulo
elif [ "$2" == '%' ]
then
	echo "$(($1 % $3))"

else
	func
fi 
