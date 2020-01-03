%{

#include "y.tab.h"
extern void yyerror(const char *);

%}

					/* Regular Expression Definitions */

/*COMMENTS*/
SINGLE_LINE_COMMENT			"//"[^("\n")]*
MULTI_LINE_COMMENT			"/*"[^"*"]*"*"("*"|([^"/*"]*[^"*"]*"*"))*"/"

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

/*STRING_LITERALS*/
S_CHAR  					{ESCAPE_SEQUENCE}|[^("\""|"\\"|"\n")]
S_CHAR_SEQUENCE				{S_CHAR}+
STRING_LITERAL 				"\""{S_CHAR_SEQUENCE}?"\""

/* WHITESPACE */
OTHER                       [\t\v\n\f]

%%
{SINGLE_LINE_COMMENT}					{ }
{MULTI_LINE_COMMENT} 					{ }

"auto"				{return AUTO;}
"break"				{return BREAK;}
"case"				{return CASE;}
"char"				{return CHAR;}
"const"				{return CONST;}
"continue"			{return CONTINUE;}
"default"			{return DEFAULT;}
"do"				{return DO;}
"double"			{return DOUBLE;}
"else"				{return ELSE;}
"enum"				{return ENUM;}
"extern"			{return EXTERN;}
"register"			{return REGISTER;}
"float"				{return FLOAT;}
"for"				{return FOR;}
"goto"				{return GOTO;}
"if"				{return IF;}
"inline"			{return INLINE;}
"int"				{return INT;}
"long"				{return LONG;}
"restrict"			{return RESTRICT;}
"return"			{return RETURN;}
"short"				{return SHORT;}
"signed"			{return SIGNED;}
"sizeof"			{return SIZEOF;}
"static"			{return STATIC;}
"struct"			{return STRUCT;}
"switch"			{return SWITCH;}
"typedef"			{return TYPEDEF;}
"union"				{return UNION;}
"unsigned"			{return UNSIGNED;}
"void"				{return VOID;}
"volatile"			{return VOLATILE;}
"while"				{return WHILE;}
"_Bool"				{return BOOL;}
"_Complex"			{return COMPLEX;}
"_Imaginary"		{return IMAGINARY;}

{IDENTIFIER}	                        { return IDENTIFIER; }

{INTEGER_CONSTANT}	                    { return INTEGER_CONSTANT; }
{FLOATING_CONSTANT}	                    { return FLOATING_CONSTANT; }
{CHARACTER_CONSTANT}                    { return CHARACTER_CONSTANT; }

{STRING_LITERAL}                        { return STRING_LITERAL; }

"["					{return OPENSQUAREB;}
"]"					{return CLOSESQUAREB;}
"("					{return OPENROUNDB;}
")"					{return CLOSEROUNDB;}
"{"					{return OPENCURLYB;}
"}"					{return CLOSECURLYB;}
"."					{return DOT;}
"->"				{return ARROW;}
"++"				{return INCREMENT;}
"--"				{return DECREMENT;}
"&"					{return BITWISEAND;}
"*"					{return STAR;}
"+"					{return PLUS;}
"-"					{return MINUS;}
"~"					{return NOT;}
"!"					{return EXCLAMATION;}
"/"					{return DIVIDE;}
"%"					{return PERCENTAGE;}
"<<"				{return LEFTSHIFT;}
">>"				{return RIGHTSHIFT;}
"<"					{return LESSTHAN;}
">"					{return GREATERTHAN;}
"<="				{return LESSEQUAL;}
">=" 				{return GREATEREQUAL;}
"=="				{return EQUAL;}
"!="				{return NOTEQUAL;}
"^"					{return XOR;}
"|"					{return BITWISEOR;}
"&&"				{return AND;}
"||"				{return OR;}
"?"					{return QUESTIONMARK;}
":"					{return COLON;}
";"					{return SEMICOLON;}
"..."				{return ELLIPSIS;}
"="					{return ASSIGN;}
"*="				{return MULTIPLYEQUAL;}
"/="				{return DIVIDEEQUAL;}
"%="				{return MODULOEQUAL;}
"+="				{return PLUSEQUAL;}
"-="				{return MINUSEQUAL;}
"<<="				{return SHIFTLEFTEQUAL;}
">>="				{return SHIFTRIGHTEQUAL;}
"&="				{return ANDEQUAL;}
"^="				{return XOREQUAL;}
"|="				{return OREQUAL;}
","					{return COMMA;}
"#" 				{return HASH;}

{OTHER}             {}
%%