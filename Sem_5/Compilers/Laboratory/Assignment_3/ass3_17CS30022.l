%{
	#define SINGLE_LINE_COMMENT 1
	#define MULTI_LINE_COMMENT 2
	#define KEYWORD 3
    #define IDENTIFIER 4
	#define INTEGER_CONSTANT 5
	#define FLOATING_CONSTANT 6
    #define CHARACTER_CONSTANT 7
    #define STRING_LITERAL 8
    #define PUNCTUATOR 9
%}

/* Regular Expression Definitions */
/*COMMENTS*/
SINGLE_LINE_COMMENT			"//"[^("\n")]*
MULTI_LINE_COMMENT			"/*"[^"*"]*"*"("*"|([^"/*"]*[^"*"]*"*"))*"/"


/*KEYWORDS*/
/* Separated into separate lines for readability */
KEYWORD1					"auto"|"break"|"case"|"char"|"const"|"continue"
KEYWORD2                    "default"|"do"|"double"|"else"|"enum"|"extern"
KEYWORD3				    "register"|"float"|"for"|"goto"|"if"|"inline"
KEYWORD4					"int"|"long"|"restrict"|"return"|"short"|"signed"
KEYWORD5                    "sizeof"|"static"|"struct"|"switch"|"typedef"|"union"
KEYWORD6 					"unsigned"|"void"|"volatile"|"while"|"_Bool"|"_Complex"|"_Imaginary"
KEYWORD 					{KEYWORD1}|{KEYWORD2}|{KEYWORD3}|{KEYWORD4}|{KEYWORD5}|{KEYWORD6}
	

/*IDENTIFIERS*/
DIGIT						[0-9]
ALPHABET 		            [a-zA-Z]|"_"
IDENTIFIER 					{ALPHABET}({ALPHABET}|{DIGIT})*
 

/*CONSTANTS*/
NONZERO_DIGIT				[1-9]
NONZERO_INTEGER_CONSTANT	{NONZERO_DIGIT}({NONZERO_DIGIT}|{DIGIT})*
INTEGER_CONSTANT			{NONZERO_INTEGER_CONSTANT}|"0"

DIGIT_SEQUENCE				[0-9]{DIGIT}
SIGN 						"+"|"-"
EXPONENT_PART				("e"{SIGN}?{DIGIT_SEQUENCE})|("E"{SIGN}?{DIGIT_SEQUENCE})
FRACTIONAL_CONSTANT			({DIGIT_SEQUENCE}?"."{DIGIT_SEQUENCE})|({DIGIT_SEQUENCE}".")
FLOATING_CONSTANT			({FRACTIONAL_CONSTANT}{EXPONENT_PART}?)|({DIGIT_SEQUENCE}{EXPONENT_PART})

ENUMERATION_CONSTANT		{IDENTIFIER}

ESCAPE_SEQUENCE				\\['"?\\abfnrtv]
C_CHAR 						{ESCAPE_SEQUENCE}|[^("\'"|"\\"|"\n")]
C_CHAR_SEQUENCE				{C_CHAR}+
CHARACTER_CONSTANT			"\'"{C_CHAR_SEQUENCE}"\'"

CONSTANT					{INTEGER_CONSTANT}|{FLOATING_CONSTANT}|{ENUMERATION_CONSTANT}|{CHARACTER_CONSTANT}

/*STRING_LITERALS*/
S_CHAR  					{ESCAPE_SEQUENCE}|[^("\""|"\\"|"\n")]
S_CHAR_SEQUENCE				{S_CHAR}+
STRING_LITERAL 				"\""{S_CHAR_SEQUENCE}?"\""


/*PUNCTUATORS*/
/* Separated into separate lines for readability */
PUNCTUATOR1					"["|"]"|"("|")"|"{"|"}"|"."|"->"
PUNCTUATOR2					"++"|"--"|"&"|"*"|"+"|"-"|"~"|"!"
PUNCTUATOR3					"/"|"%"|"<<"|">>"|"<"|">"|"<="|">=" 
PUNCTUATOR4                 "=="|"!="|"^"|"|"|"&&"|"||"|"?"|":"
PUNCTUATOR5					 ";"|"..."|"="|"*="|"/="|"%="|"+="|"-="
PUNCTUATOR6					"<<="|">>="|"&="|"^="|"|="|","|"#" 
PUNCTUATOR 					{PUNCTUATOR1}|{PUNCTUATOR2}|{PUNCTUATOR3}|{PUNCTUATOR4}|{PUNCTUATOR5}|{PUNCTUATOR6}

/* WHITESPACE */
OTHER                       [\t\v\n\f]

%%
{SINGLE_LINE_COMMENT}					{ return SINGLE_LINE_COMMENT;}
{MULTI_LINE_COMMENT} 					{ return MULTI_LINE_COMMENT;}

{KEYWORD}                       		{ return KEYWORD; }

{IDENTIFIER}	                        { return IDENTIFIER; }

{INTEGER_CONSTANT}	                    { return INTEGER_CONSTANT; }
{FLOATING_CONSTANT}	                    { return FLOATING_CONSTANT; }
{CHARACTER_CONSTANT}                    { return CHARACTER_CONSTANT; }

{STRING_LITERAL}                        { return STRING_LITERAL; }

{PUNCTUATOR}	                        { return PUNCTUATOR; }

{OTHER}                                 {}
%%