%{
#include <stdio.h>
#include <string.h>
#include "translator.h"
#include "parser.tab.h"
%}

/* Regular Expression Definitions */
/*COMMENTS*/
singleLineComment			\/\/.*
multiLineComment			"/"\*([^*]|[\r\n]|(\*+([^*/]|[\r\n])))*\*+"/"
Comment					{singleLineComment}|{multiLineComment}


/*KEYWORDS*/
Keyword					"auto"|"break"|"case"|"char"|"const"|"continue"|"default"|"do"|"double"|"else"|"enum"|"extern"|"float"|"for"|"goto"|"if"|"inline"|"int"|"long"|"register"|"restrict"|"return"|"short"|"signed"|"sizeof"|"static"|"struct"|"switch"|"typedef"|"union"|"unsigned"|"void"|"volatile"|"while"|"_Bool"|"_Complex"|"_Imaginary"
	

/*IDENTIFIERS*/
DIGIT						[0-9]
IdentifierNonDigit 		[a-zA-Z]|"_"
IDENTIFIER 					{IdentifierNonDigit}({IdentifierNonDigit}|{DIGIT})*
 

/*CONSTANTS*/

NONZERO_DIGIT				[1-9]
NONZERO_INTEGER_CONSTANT	{NONZERO_DIGIT}({NONZERO_DIGIT}|{DIGIT})*
integerConstant			{NONZERO_INTEGER_CONSTANT}|"0"

DIGIT_SEQUENCE				{DIGIT}+
SIGN 						"+"|"-"
EXPONENT_PART				("e"{SIGN}?{DIGIT_SEQUENCE})|("E"{SIGN}?{DIGIT_SEQUENCE})
FRACTIONAL_CONSTANT			(({DIGIT_SEQUENCE}?\.{DIGIT_SEQUENCE})|({DIGIT_SEQUENCE}\.))
floatingConstant			({FRACTIONAL_CONSTANT}{EXPONENT_PART}?)|({DIGIT_SEQUENCE}{EXPONENT_PART})

ENUMERATION_CONSTANT		{IDENTIFIER}

ESCAPE_SEQUENCE				"\'"|"\""|"\?"|"\\"|"\a"|"\b"|"\f"|"\n"|"\r"|"\t"|"\v"
C_CHAR 						{ESCAPE_SEQUENCE}|[^("\'"|"\\"|"\n")]
C_CHAR_SEQUENCE				{C_CHAR}+
CHARACTER_CONSTANT			'{C_CHAR_SEQUENCE}'


/*STRING_LITERALS*/
S_CHAR  					{ESCAPE_SEQUENCE}|[^("\""|"\\"|"\n")]
S_CHAR_SEQUENCE				{S_CHAR}+
STRING_LITERAL 				\"({S_CHAR_SEQUENCE}?)\"


/*PUNCTUATORS*/
PUNCTUATOR					"["|"]"|"("|")"|"{"|"}"|"."|"->"|"++"|"--"|"&"|"*"|"+"|"-"|"~"|"!"|"/"|"%"|"<<"|">>"|"<"|">"|"<="|">="|"=="|"!="|"^"|"|"|"&&"|"||"|"?"|":"|";"|"..."|","|"#"|"="|"*="|"/="|"%="|"+="|"-="|"<<="|">>="|"&="|"^="|"|="

%%
{Keyword}		{
if(strcmp(yytext,"auto")==0)			{ return AUTO; }
if(strcmp(yytext,"enum")==0)			{ return ENUM; }
if(strcmp(yytext,"restrict")==0)		{ return RESTRICT; } 
if(strcmp(yytext,"unsigned")==0)		{ return UNSIGNED; }
if(strcmp(yytext,"break")==0)			{ return BREAK; }
if(strcmp(yytext,"extern")==0)			{ return EXTERN; }
if(strcmp(yytext,"return")==0)			{ return RETURN; }
if(strcmp(yytext,"void")==0)			{ return VOID; }
if(strcmp(yytext,"case")==0)			{ return CASE; }
if(strcmp(yytext,"float")==0)			{ return FLOAT; }
if(strcmp(yytext,"short")==0)			{ return SHORT; }
if(strcmp(yytext,"volatile")==0)		{ return VOLATILE; }
if(strcmp(yytext,"char")==0)		  	{ return CHAR; }
if(strcmp(yytext,"for")==0)				{ return FOR; }
if(strcmp(yytext,"signed")==0)		  	{ return SIGNED; }
if(strcmp(yytext,"while")==0)			{ return WHILE; }
if(strcmp(yytext,"const")==0)			{ return CONST; }
if(strcmp(yytext,"goto")==0)			{ return GOTO; }
if(strcmp(yytext,"sizeof")==0)			{ return SIZEOF; }
if(strcmp(yytext,"_Bool")==0)			{ return BOOL; }
if(strcmp(yytext,"continue")==0)		{ return CONTINUE; }
if(strcmp(yytext,"if")==0)				{ return IF; }
if(strcmp(yytext,"static")==0)			{ return STATIC; }
if(strcmp(yytext,"_Complex")==0)		{ return COMPLEX; }
if(strcmp(yytext,"default")==0)			{ return DEFAULT; }
if(strcmp(yytext,"inline")==0)			{ return INLINE; }
if(strcmp(yytext,"struct")==0)			{ return STRUCT; }
if(strcmp(yytext,"_Imaginary")==0)		{ return IMAGINARY; }
if(strcmp(yytext,"do")==0)				{ return DO; }
if(strcmp(yytext,"int")==0)				{ return INT; }
if(strcmp(yytext,"switch")==0)			{ return SWITCH; }
if(strcmp(yytext,"double")==0)			{ return DOUBLE; }
if(strcmp(yytext,"long")==0)			{ return LONG; }
if(strcmp(yytext,"typedef")==0)			{ return TYPEDEF; }
if(strcmp(yytext,"else")==0)			{ return ELSE; }
if(strcmp(yytext,"register")==0)		{ return REGISTER; }
if(strcmp(yytext,"union")==0)			{ return UNION; }
}

{STRING_LITERAL} {
	yylval.charval = yytext;
	return STRING_LITERAL;
}

{IDENTIFIER}	{
	yylval.symp = currTable->lookup(yytext);
	return IDENTIFIER;
}

{integerConstant}	{
	yylval.intval = atoi(yytext);
	return integerConstant;
}

{floatingConstant}	{
	yylval.charval = yytext;
	return floatingConstant;
}

{CHARACTER_CONSTANT} {
	yylval.charval = yytext;
	return CHARACTER_CONSTANT;
}


{PUNCTUATOR}	{
	if(strcmp(yytext,"[") == 0) return SQBRAOPEN;
	if(strcmp(yytext,"]") == 0) return SQBRACLOSE;
	if(strcmp(yytext,"(") == 0) return ROBRAOPEN;
	if(strcmp(yytext,")") == 0) return ROBRACLOSE;
	if(strcmp(yytext,"{") == 0) return CURBRAOPEN;
	if(strcmp(yytext,"}") == 0) return CURBRACLOSE;
	if(strcmp(yytext,".") == 0) return DOT;
	if(strcmp(yytext,"->") == 0) return ACC;

	if(strcmp(yytext,"++") == 0) return INC;
	if(strcmp(yytext,"--") == 0) return DEC;
	if(strcmp(yytext,"&") == 0) return AMP;
	if(strcmp(yytext,"*") == 0) return MUL;
	if(strcmp(yytext,"+") == 0) return ADD;
	if(strcmp(yytext,"-") == 0) return SUB;
	if(strcmp(yytext,"~") == 0) return NEG;
	if(strcmp(yytext,"!") == 0) return EXCLAIM;

	if(strcmp(yytext,"/") == 0) return DIV;
	if(strcmp(yytext,"%") == 0) return MODULO;
	if(strcmp(yytext,"<<") == 0) return SHL;
	if(strcmp(yytext,">>") == 0) return SHR;
	if(strcmp(yytext,"<") == 0) return BITSHL;
	if(strcmp(yytext,">") == 0) return BITSHR;
	if(strcmp(yytext,"<=") == 0) return LTE;
	if(strcmp(yytext,">=") == 0) return GTE;
	if(strcmp(yytext,"==") == 0) return EQ;
	if(strcmp(yytext,"!=") == 0) return NEQ;
	if(strcmp(yytext,"^") == 0) return BITXOR;
	if(strcmp(yytext,"|") == 0) return BITOR;
	if(strcmp(yytext,"&&") == 0) return AND;
	if(strcmp(yytext,"||") == 0) return OR;

	if(strcmp(yytext,"?") == 0) return QUESTION;
	if(strcmp(yytext,":") == 0) return COLON;
	if(strcmp(yytext,";") == 0) return SEMICOLON;
	if(strcmp(yytext,"...") == 0) return DOTS;
	if(strcmp(yytext,"=") == 0) return ASSIGN;
	if(strcmp(yytext,"*=") == 0) return STAREQ;
	if(strcmp(yytext,"/=") == 0) return DIVEQ;
	if(strcmp(yytext,"%=") == 0) return MODEQ;
	if(strcmp(yytext,"+=") == 0) return PLUSEQ;
	if(strcmp(yytext,"-=") == 0) return MINUSEQ;
	if(strcmp(yytext,"<<=") == 0) return SHLEQ;
	if(strcmp(yytext,">>=") == 0) return SHREQ;
	if(strcmp(yytext,"&=") == 0) return BINANDEQ;
	if(strcmp(yytext,"^=") == 0) return BINXOREQ;
	if(strcmp(yytext,"|=") == 0) return BINOREQ;
	if(strcmp(yytext,",") == 0) return COMMA;
	if(strcmp(yytext,"#") == 0) return HASH;
}
"\n"|" "|"\t"|{Comment}	{

}
%%