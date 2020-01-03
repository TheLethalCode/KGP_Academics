%{ 
	#include <string.h>
	#include <stdio.h>
	extern int yylex();
	void yyerror(char *errorS);
%}

%union {
int value;
}

// Comments
%token SINGLE_LINE_COMMENT
%token MULTI_LINE_COMMENT

// Keywords
%token AUTO
%token BREAK
%token CASE
%token CHAR
%token CONST
%token CONTINUE
%token DEFAULT
%token DO
%token DOUBLE
%token ELSE
%token ENUM
%token EXTERN
%token REGISTER
%token FLOAT
%token FOR
%token GOTO
%token IF
%token INLINE
%token INT
%token LONG
%token RESTRICT
%token RETURN
%token SHORT
%token SIGNED
%token SIZEOF
%token STATIC
%token STRUCT
%token SWITCH
%token TYPEDEF
%token UNION
%token UNSIGNED
%token VOID
%token VOLATILE
%token WHILE
%token BOOL
%token COMPLEX
%token IMAGINARY

// Punctuators and operators
%token OPENSQUAREB
%token CLOSESQUAREB
%token OPENROUNDB
%token CLOSEROUNDB
%token OPENCURLYB
%token CLOSECURLYB
%token DOT
%token ARROW
%token INCREMENT
%token DECREMENT
%token BITWISEAND
%token STAR
%token PLUS
%token MINUS
%token NOT
%token EXCLAMATION
%token DIVIDE
%token PERCENTAGE
%token LEFTSHIFT
%token RIGHTSHIFT
%token LESSTHAN
%token GREATERTHAN
%token LESSEQUAL
%token GREATEREQUAL
%token EQUAL
%token NOTEQUAL
%token XOR
%token BITWISEOR
%token AND
%token OR
%token QUESTIONMARK
%token COLON
%token SEMICOLON
%token ELLIPSIS
%token ASSIGN
%token MULTIPLYEQUAL
%token DIVIDEEQUAL
%token MODULOEQUAL
%token PLUSEQUAL
%token MINUSEQUAL
%token SHIFTLEFTEQUAL
%token SHIFTRIGHTEQUAL
%token ANDEQUAL
%token XOREQUAL
%token OREQUAL
%token COMMA
%token HASH

// Identifier
%token IDENTIFIER

// Constants
%token INTEGER_CONSTANT
%token FLOATING_CONSTANT
%token CHARACTER_CONSTANT
%token STRING_LITERAL

%start translation_unit

%%

// 1.EXPRESSIONS

// Primary Expression
constant : INTEGER_CONSTANT | FLOATING_CONSTANT | CHARACTER_CONSTANT ;
primary_expression : IDENTIFIER | constant | STRING_LITERAL | OPENROUNDB expression CLOSEROUNDB { printf("PRIMARY_EXPRESSION\n");};

// Postfix Expression
postfix_expression : primary_expression | postfix_expression OPENSQUAREB expression CLOSESQUAREB | postfix_expression OPENROUNDB CLOSEROUNDB | postfix_expression OPENROUNDB argument_expression_list CLOSEROUNDB | postfix_expression DOT IDENTIFIER | postfix_expression ARROW IDENTIFIER | postfix_expression INCREMENT | postfix_expression DECREMENT | OPENROUNDB type_name CLOSEROUNDB OPENCURLYB initializer_list CLOSECURLYB |  OPENROUNDB type_name CLOSEROUNDB OPENCURLYB initializer_list COMMA CLOSECURLYB {printf("POSTFIX_EXPRESSION\n");};

// Argument Expression List
argument_expression_list : assignment_expression | argument_expression_list COMMA assignment_expression { printf("ARGUMENT_EXPRESSION_LIST\n");};

// Unary Expression
unary_expression : postfix_expression | INCREMENT unary_expression | DECREMENT unary_expression | unary_operator cast_expression | SIZEOF unary_expression | SIZEOF OPENROUNDB type_name CLOSEROUNDB {printf("UNARY_EXPRESSION\n");};

// Unary Operator
unary_operator: BITWISEAND | STAR | PLUS | MINUS | NOT | EXCLAMATION {printf("UNARY_OPERATOR\n");};

// Cast expression
cast_expression : unary_expression | OPENROUNDB type_name CLOSEROUNDB cast_expression {printf("CAST_EXPRESSION\n");};

// Multiplicative expression
multiplicative_expression : cast_expression | multiplicative_expression STAR cast_expression | multiplicative_expression DIVIDE cast_expression | multiplicative_expression PERCENTAGE cast_expression {printf("MULTIPLICATIVE_EXPRESSION\n");};

// Additive Expression
additive_expression : multiplicative_expression | additive_expression PLUS multiplicative_expression | additive_expression MINUS multiplicative_expression {printf("ADDITIVE_EXPRESSION\n");};

// Shift Expression
shift_expression : additive_expression | shift_expression LEFTSHIFT additive_expression | shift_expression RIGHTSHIFT additive_expression {printf("SHIFT_EXPRESSION\n");};

// Relational Expression
relational_expression : shift_expression | relational_expression LESSTHAN shift_expression | relational_expression GREATERTHAN shift_expression | relational_expression LESSEQUAL shift_expression | relational_expression GREATEREQUAL shift_expression {printf("RELATIONAL_EXPRESSION\n");};

// Equality Expression
equality_expression : relational_expression | equality_expression EQUAL relational_expression | equality_expression NOTEQUAL relational_expression {printf("EQUALITY_EXPRESSION\n");};

// And Expression
and_expression : equality_expression | and_expression BITWISEAND equality_expression {printf("AND_EXPRESSION\n");};

// Xor Expression
exclusive_or_expression : and_expression | exclusive_or_expression XOR and_expression {printf("EXCLUSIVE_OR_EXPRESSION \n");}; 

// Or expression
inclusive_or_expression : exclusive_or_expression | inclusive_or_expression BITWISEOR exclusive_or_expression {printf("INCLUSIVE_OR_EXPRESSION\n");};

// Logical AND expression
logical_and_expression : inclusive_or_expression | logical_and_expression AND inclusive_or_expression {printf("LOGICAL_AND_EXPRESSION\n");};

// Logical OR expression
logical_or_expression : logical_and_expression | logical_or_expression OR logical_and_expression {printf("LOGICAL_OR_EXPRESSION \n");};

// Conditional expression
conditional_expression : logical_or_expression | logical_or_expression QUESTIONMARK expression COLON conditional_expression {printf("CONDITIONAL_EXPRESSION\n");};

// Assignment expression
assignment_expression : conditional_expression | unary_expression assignment_operator assignment_expression {printf("ASSIGNMENT_EXPRESSION\n");};

// Assignment operator
assignment_operator : ASSIGN | MULTIPLYEQUAL | DIVIDEEQUAL | MODULOEQUAL | PLUSEQUAL | MINUSEQUAL | SHIFTLEFTEQUAL | SHIFTRIGHTEQUAL | ANDEQUAL | XOREQUAL | OREQUAL {printf("ASSIGNMENT_OPERATOR\n");};

// Expression
expression : assignment_expression | expression COMMA assignment_expression {printf("EXPRESSION\n");};

// Constant Expression
constant_expression : conditional_expression {printf("CONSTANT_EXPRESSION\n");};

// 2.DECLARATIONS


// declaration
declaration : declaration_specifiers SEMICOLON | declaration_specifiers init_declarator_list SEMICOLON {printf("DECLARATION\n");};

// Declaration Specifiers
declaration_specifiers : storage_class_specifier | storage_class_specifier declaration_specifiers | type_specifier | type_specifier declaration_specifiers | type_qualifier | type_qualifier declaration_specifiers | function_specifier  | function_specifier declaration_specifiers {printf("DECLARATION_SPECIFIERS\n");};

// Init declarator list
init_declarator_list : init_declarator | init_declarator_list COMMA init_declarator {printf("INIT_DECLARATOR_LIST\n");};

// Init Declarator
init_declarator : declarator | declarator ASSIGN initializer {printf("INIT_DECLARATOR\n");};

// Storage Class Specifier
storage_class_specifier : EXTERN | STATIC | AUTO | REGISTER {printf("STORAGE_CLASS_SPECIFIER\n");};

// Type Specifier
type_specifier : VOID | CHAR | SHORT | INT | LONG | FLOAT | DOUBLE | SIGNED | UNSIGNED | BOOL | COMPLEX | IMAGINARY | enum_specifier {printf("TYPE_SPECIFIER\n");};

// Specifier Qualifier List
specifier_qualifier_list : type_specifier specifier_qualifier_list | type_specifier | type_qualifier specifier_qualifier_list | type_qualifier {printf("SPECIFIER_QUALIFIER_LIST\n");};

// Enum Specifier
enum_specifier : ENUM OPENCURLYB enumerator_list CLOSECURLYB | ENUM IDENTIFIER OPENCURLYB enumerator_list CLOSECURLYB | ENUM OPENCURLYB enumerator_list COMMA CLOSECURLYB | ENUM IDENTIFIER OPENCURLYB enumerator_list COMMA CLOSECURLYB | ENUM IDENTIFIER {printf("ENUM_SPECIFIER\n");};

// Enumerator List
enumerator_list : enumerator | enumerator_list COMMA enumerator {printf("ENUMERATOR_LIST\n");};

// Enumerator
enumerator : IDENTIFIER | IDENTIFIER ASSIGN constant_expression {printf("ENUMERATOR\n");};

// Type Qualifier
type_qualifier : CONST | VOLATILE | RESTRICT {printf("TYPE_QUAIFIER \n");};

// Function Specifier
function_specifier : INLINE {printf("FUNCTION_SPECIFIER\n");};

// Declarator
declarator : pointer direct_declarator | direct_declarator {printf("DECLARATOR\n");};

// Direct Declarator
direct_declarator : IDENTIFIER | OPENROUNDB declarator CLOSEROUNDB | direct_declarator OPENSQUAREB  type_qualifier_list_opt assignment_expression_opt CLOSESQUAREB | direct_declarator OPENSQUAREB STATIC type_qualifier_list_opt assignment_expression CLOSESQUAREB | direct_declarator OPENSQUAREB type_qualifier_list_opt STAR CLOSESQUAREB | direct_declarator OPENROUNDB parameter_type_list CLOSEROUNDB | direct_declarator OPENROUNDB identifier_list_opt CLOSEROUNDB | direct_declarator OPENSQUAREB type_qualifier_list STATIC assignment_expression CLOSESQUAREB {printf("DIRECT_DECLARATOR\n");};
type_qualifier_list_opt : %empty | type_qualifier_list
assignment_expression_opt : %empty | assignment_expression
identifier_list_opt : %empty | identifier_list

// Pointer
pointer : STAR type_qualifier_list_opt | STAR type_qualifier_list_opt pointer {printf("POINTER\n");};

// Type Qualifier List
type_qualifier_list : type_qualifier | type_qualifier_list type_qualifier {printf("TYPE_QUALIFIER_LIST\n");};

// Parameter Type List
parameter_type_list : parameter_list | parameter_list COMMA ELLIPSIS {printf("PARAMETER_TYPE_LIST\n");};

// Parameter List
parameter_list : parameter_declaration | parameter_list COMMA parameter_declaration {printf("PARAMETER_LIST\n");};

// Parameter Declaration
parameter_declaration : declaration_specifiers declarator | declaration_specifiers {printf("PARAMETER_DECLARATION\n");};

// Identifier List
identifier_list: IDENTIFIER | identifier_list COMMA IDENTIFIER {printf("IDENTIFIER_LIST\n");};

// Type Name
type_name : specifier_qualifier_list {printf("TYPE_NAME\n");};

// Initializer
initializer : assignment_expression | OPENCURLYB initializer_list CLOSECURLYB | OPENCURLYB initializer_list COMMA CLOSECURLYB {printf("INITIALIZER\n");};

// Initializer List
initializer_list : designation_opt initializer | initializer_list COMMA designation_opt initializer {printf("INITIALIZER_LIST\n");};
designation_opt : %empty | designation

// Designation
designation : designator_list ASSIGN {printf("DESIGNATION\n");};

// Designator List
designator_list : designator | designator_list designator {printf("DESIGNATOR_LIST\n");};

// Designator
designator : OPENSQUAREB constant_expression CLOSESQUAREB | DOT IDENTIFIER {printf("DESIGNATOR\n");};


// 3.STATEMENTS

// Statement
statement : labeled_statement | compound_statement | expression_statement | selection_statement | iteration_statement | jump_statement {printf("STATEMENT\n");} ;

// Labeled Statement
labeled_statement : IDENTIFIER COLON statement | CASE constant_expression COLON statement | DEFAULT COLON statement {printf("LABELED_STATMENT\n");};

// Compound Statement
compound_statement : OPENCURLYB CLOSECURLYB | OPENCURLYB block_item_list CLOSECURLYB {printf("COMPOUND_STATEMENT\n");};

// Block Item List
block_item_list : block_item | block_item_list block_item {printf("BLOCK_ITEM_LIST\n");};

// Block Item
block_item : declaration | statement {printf("BLOCK_ITEM\n");};

// Expression Statemt
expression_statement : SEMICOLON | expression SEMICOLON {printf("EXPRESSION_STATEMENT\n");};

// Selection Statement
selection_statement : IF OPENROUNDB expression CLOSEROUNDB statement | IF OPENROUNDB expression CLOSEROUNDB statement ELSE statement | SWITCH OPENROUNDB expression CLOSEROUNDB statement {printf("SELECTION_STATEMENT\n");};

// Looping Statements
iteration_statement : WHILE OPENROUNDB expression CLOSEROUNDB statement | DO statement WHILE OPENROUNDB expression CLOSEROUNDB SEMICOLON | FOR OPENROUNDB expression_opt SEMICOLON expression_opt SEMICOLON expression_opt CLOSEROUNDB statement {printf("ITERATION_STATEMENT\n");};
expression_opt : %empty | expression

// Jump Statements
jump_statement : GOTO IDENTIFIER SEMICOLON | CONTINUE SEMICOLON | BREAK SEMICOLON | RETURN SEMICOLON | RETURN expression SEMICOLON {printf("JUMP_STATEMENT\n");} ;


// 4.EXTERNAL DEFINITIONS

// Translation Unit
translation_unit : external_declaration | translation_unit external_declaration {printf("TRANSLATION_UNIT\n");};

// External Declaration
external_declaration : function_definition | declaration {printf("EXTERNAL_DECLARATION\n");};

// Function Definition
function_definition : declaration_specifiers declarator declaration_list compound_statement | declaration_specifiers declarator compound_statement {printf("FUNCTION DEFINITION\n");};

// Declartation List
declaration_list : declaration | declaration_list declaration {printf("DECLARATION LIST\n");};
%%

void yyerror(char *errorS) {
	printf ("ERROR :- %s",errorS);
}