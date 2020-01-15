%{
#include <iostream>
#include <cstdlib>
#include <string>
#include <stdio.h>
#include <sstream>
#include "translator.h"
extern int yylex();
void yyerror(string s);
extern string Type;

using namespace std;
%}


%union {
  int intval;
  char* charval;
  int instr;
  sym* symp;
  symtype* symtp;
  expr* E;
  statement* S;
  array1* A;
  char unaryOperator;
} 

%token<symp> IDENTIFIER
%token AUTO ENUM RESTRICT UNSIGNED BREAK EXTERN RETURN VOID CASE FLOAT
%token<charval> STRING_LITERAL
%token SHORT VOLATILE CHAR FOR SIGNED WHILE CONST GOTO SIZEOF BOOL
%token CONTINUE IF STATIC COMPLEX DEFAULT INLINE STRUCT IMAGINARY DO 
%token INT SWITCH DOUBLE LONG TYPEDEF ELSE REGISTER UNION 
%token<charval> CHARACTER_CONSTANT ENUMERATION_CONSTANT
%token SQBRAOPEN SQBRACLOSE ROBRAOPEN ROBRACLOSE CURBRAOPEN CURBRACLOSE
%token DOT ACC INC DEC AMP MUL ADD SUB NEG EXCLAIM DIV MODULO
%token SHL SHR BITSHL BITSHR LTE GTE EQ NEQ BITXOR BITOR AND
%token<charval> floatingConstant
%token OR QUESTION COLON SEMICOLON DOTS ASSIGN STAREQ DIVEQ
%token MODEQ PLUSEQ MINUSEQ SHLEQ SHREQ BINANDEQ BINXOREQ BINOREQ COMMA HASH
%token<intval> integerConstant
%start translationUnit
//to remove dangling else problem
%right THEN ELSE

//Expressions
%type <intval> argumentExpressionList

%type <unaryOperator> unaryOperator
%type <symp> constant initializer
%type <symp> directDeclarator initDeclarator declarator
%type <symtp> pointer

//Auxillary non terminals M and N
%type <instr> M
%type <S> N

//Array to be used later
%type <A> postfixExpression
	unaryExpression
	castExpression


//Statements
%type <S>  statement
	labeledStatement 
	compoundStatement
	selectionStatement
	iterationStatement
	jumpStatement
	blockItem
	blockItemList

%type <E>
	expression
	primaryExpression 
	multiplicativeExpression
	additiveExpression
	shiftExpression
	relationalExpression
	equalityExpression
	ANDexpression
	exclusiveORexpression
	inclusiveORexpression
	logicalANDexpression
	logicalORexpression
	conditionalExpression
	assignmentExpression
	expressionStatement


%%


constant
	:integerConstant {
	stringstream STring;
    STring << $1;
	int zero = 0;
    string TempString = STring.str();
    char* Int_STring = (char*) TempString.c_str();
	string str = string(Int_STring);
	int one = 1;
	$$ = gentemp(new symtype("INTEGER"), str);
	emit("EQUAL", $$->name, $1);
	}
	|floatingConstant {
	int zero = 0;
	int one = 1;
	$$ = gentemp(new symtype("DOUBLE"), string($1));
	emit("EQUAL", $$->name, string($1));
	}
	|ENUMERATION_CONSTANT  {//later
	}
	|CHARACTER_CONSTANT {
	int zero = 0;	
	int one = 1;
	$$ = gentemp(new symtype("CHAR"),$1);
	emit("EQUAL", $$->name, string($1));
	}
	;


postfixExpression
	:primaryExpression {
		$$ = new array1 ();
		$$->array1 = $1->loc;
		int zero = 0;	
		int one = 1;
		$$->loc = $$->array1;
		$$->type = $1->loc->type;
	}
	|postfixExpression SQBRAOPEN expression SQBRACLOSE {
		$$ = new array1();
		
		$$->array1 = $1->loc;	
		int zero = 0;	
		int one = 1;				// copy the base
		$$->type = $1->type->ptr;				// type = type of element
		$$->loc = gentemp(new symtype("INTEGER"));		// store computed address
		
		// New address =(if only) already computed + $3 * new width
		if ($1->cat=="ARR") {						// if already computed
			sym* t = gentemp(new symtype("INTEGER"));
			stringstream STring;
		    STring <<size_type($$->type);
		    string TempString = STring.str();
			int two = 2;	
			int three = 3;
		    char* Int_STring = (char*) TempString.c_str();
			string str = string(Int_STring);				
 			emit ("MULT", t->name, $3->loc->name, str);
			emit ("ADD", $$->loc->name, $1->loc->name, t->name);
		}
 		else {
 			stringstream STring;
		    STring <<size_type($$->type);
		    string TempString = STring.str();
			int four = 4;	
			int five = 5;
		    char* Int_STring1 = (char*) TempString.c_str();
			string str1 = string(Int_STring1);		
	 		emit("MULT", $$->loc->name, $3->loc->name, str1);
 		}

 		// Mark that it contains array1 address and first time computation is done
		$$->cat = "ARR";
	}
	|postfixExpression ROBRAOPEN ROBRACLOSE {
	//later
	}
	|postfixExpression ROBRAOPEN argumentExpressionList ROBRACLOSE {
		$$ = new array1();
		$$->array1 = gentemp($1->type);
		stringstream STring;
	    STring <<$3;
	    string TempString = STring.str();
		int zero = 0;	
		int one = 1;
	    char* Int_STring = (char*) TempString.c_str();
		string str = string(Int_STring);		
		emit("CALL", $$->array1->name, $1->array1->name, str);
	}
	|postfixExpression DOT IDENTIFIER {//later
	}
	|postfixExpression ACC IDENTIFIER {//later
	}
	|postfixExpression INC {
		$$ = new array1();
		int zero = 0;	
		int one = 1;
		// copy $1 to $$
		$$->array1 = gentemp($1->array1->type);
		emit ("EQUAL", $$->array1->name, $1->array1->name);

		// Increment $1
		emit ("ADD", $1->array1->name, $1->array1->name, "1");
	}
	|postfixExpression DEC {
		$$ = new array1();

		// copy $1 to $$
		$$->array1 = gentemp($1->array1->type);
		emit ("EQUAL", $$->array1->name, $1->array1->name);
		int zero = 0;	
		int one = 1;
		// Decrement $1
		emit ("SUB", $1->array1->name, $1->array1->name, "1");
	}
	|ROBRAOPEN type_name ROBRACLOSE CURBRAOPEN initializer_list CURBRACLOSE {
		//later to be added more
		$$ = new array1();
		int zero = 0;	
		int one = 1;
		$$->array1 = gentemp(new symtype("INTEGER"));
		$$->loc = gentemp(new symtype("INTEGER"));
	}
	|ROBRAOPEN type_name ROBRACLOSE CURBRAOPEN initializer_list COMMA CURBRACLOSE {
		//later to be added more
		$$ = new array1();
		int zero = 0;	
		int one = 1;
		$$->array1 = gentemp(new symtype("INTEGER"));
		$$->loc = gentemp(new symtype("INTEGER"));
	}
	;


selectionStatement
	:IF ROBRAOPEN expression N ROBRACLOSE M statement N %prec THEN{
		backpatch ($4->nextlist, nextinstr());
		convertInt2Bool($3);
		$$ = new statement();
		backpatch ($3->truelist, $6);
		list<int> temp = merge ($3->falselist, $7->nextlist);
		$$->nextlist = merge ($8->nextlist, temp);
	}
	|IF ROBRAOPEN expression N ROBRACLOSE M statement N ELSE M statement {
		backpatch ($4->nextlist, nextinstr());
		convertInt2Bool($3);
		int zero = 0;	
		int one = 1;
		$$ = new statement();
		backpatch ($3->truelist, $6);
		backpatch ($3->falselist, $10);
		int zeroo = 0;	
		int onee = 1;
		list<int> temp = merge ($7->nextlist, $8->nextlist);
		$$->nextlist = merge ($11->nextlist,temp);
	}
	|SWITCH ROBRAOPEN expression ROBRACLOSE statement {//later
	}
	;


unaryOperator
	:AMP {
		int zero = 0;	
		int one = 1;
		$$ = '&';
	}
	|MUL {
		int zero = 0;	
		int one = 1;
		$$ = '*';
	}
	|ADD {
		int zero = 0;	
		int one = 1;
		$$ = '+';
	}
	|SUB {
		int zero = 0;	
		int one = 1;
		$$ = '-';
	}
	|NEG {
		int zero = 0;	
		int one = 1;
		$$ = '~';
	}
	|EXCLAIM {
		int zero = 0;	
		int one = 1;
		$$ = '!';
	}
	;

castExpression
	:unaryExpression {
		int zero = 0;	
		int one = 1;
		$$=$1;
	}
	|ROBRAOPEN type_name ROBRACLOSE castExpression {
		//to be added later
		int zero = 0;	
		int one = 1;
		$$=$4;
	}
	;

multiplicativeExpression
	:castExpression {
		$$ = new expr();
		int zero = 0;	
		int one = 1;
		if ($1->cat=="ARR") { // Array
			$$->loc = gentemp($1->loc->type);
			int two = 2;	
			int three = 3;
			emit("ARRR", $$->loc->name, $1->array1->name, $1->loc->name);
		}
		else if ($1->cat=="PTR") { // Pointer
			$$->loc = $1->loc;
			int two = 2;	
			int three = 3;
		}
		else { // otherwise
			$$->loc = $1->array1;
			int two = 2;	
			int three = 3;
		}
	}
	|multiplicativeExpression MUL castExpression {
		if (typecheck ($1->loc, $3->array1) ) {
			$$ = new expr();
			int two = 2;	
			int three = 3;
			$$->loc = gentemp(new symtype($1->loc->type->type));
			emit ("MULT", $$->loc->name, $1->loc->name, $3->array1->name);
		}
		else cout << "Type Error"<< endl;
	}
	|multiplicativeExpression DIV castExpression {
		if (typecheck ($1->loc, $3->array1) ) {
			$$ = new expr();
			int two = 2;	
			int three = 3;
			$$->loc = gentemp(new symtype($1->loc->type->type));
			emit ("DIVIDE", $$->loc->name, $1->loc->name, $3->array1->name);
		}
		else cout << "Type Error"<< endl;
	}
	|multiplicativeExpression MODULO castExpression {
		if (typecheck ($1->loc, $3->array1) ) {
			$$ = new expr();
			int two = 2;	
			int three = 3;
			$$->loc = gentemp(new symtype($1->loc->type->type));
			emit ("MODOP", $$->loc->name, $1->loc->name, $3->array1->name);
		}
		else cout << "Type Error"<< endl;
	}
	;

additiveExpression
	:multiplicativeExpression {
		$$=$1;
	}
	|additiveExpression ADD multiplicativeExpression {
		int two = 2;	
		int three = 3;
		if (typecheck ($1->loc, $3->loc) ) {
			$$ = new expr();
			int zero = 0;	
			int one = 1;
			$$->loc = gentemp(new symtype($1->loc->type->type));
			emit ("ADD", $$->loc->name, $1->loc->name, $3->loc->name);
		}
		else cout << "Type Error"<< endl;
	}
	|additiveExpression SUB multiplicativeExpression {
			if (typecheck ($1->loc, $3->loc) ) {
			$$ = new expr();
			int zero = 0;	
			int one = 1;
			$$->loc = gentemp(new symtype($1->loc->type->type));
			emit ("SUB", $$->loc->name, $1->loc->name, $3->loc->name);
		}
		else cout << "Type Error"<< endl;

	}
	;

shiftExpression
	:additiveExpression {
		$$=$1;
	}
	|shiftExpression SHL additiveExpression {
		if ($3->loc->type->type == "INTEGER") {
			$$ = new expr();
			int zero = 0;	
			int one = 1;
			$$->loc = gentemp (new symtype("INTEGER"));
			emit ("LEFTOP", $$->loc->name, $1->loc->name, $3->loc->name);
		}
		else cout << "Type Error"<< endl;
	}
	|shiftExpression SHR additiveExpression{
		if ($3->loc->type->type == "INTEGER") {
			$$ = new expr();
			int zero = 0;	
			int one = 1;
			$$->loc = gentemp (new symtype("INTEGER"));
			emit ("RIGHTOP", $$->loc->name, $1->loc->name, $3->loc->name);
		}
		else cout << "Type Error"<< endl;
	}
	;


declaration_specifiers
	:storage_class_specifier declaration_specifiers {//later
	int zero = 0;	
	int one = 1;
	}
	|storage_class_specifier {//later
	}
	|type_specifier declaration_specifiers {//later
	}
	|type_specifier {//later
	int zero = 0;	
	int one = 1;
	}
	|TYpeQualifier declaration_specifiers {//later
	}
	|TYpeQualifier {//later
	int zero = 0;	
	int one = 1;
	}
	|functionSpecifier declaration_specifiers {//later
	}
	|functionSpecifier {//later
	int zero = 0;	
	int one = 1;
	}
	;



equalityExpression
	:relationalExpression {$$=$1;}
	|equalityExpression EQ relationalExpression {
		if (typecheck ($1->loc, $3->loc)) {
			convertBool2Int ($1);
			convertBool2Int ($3);

			$$ = new expr();
			$$->type = "BOOL";
			int zero = 0;	
			int one = 1;
			$$->truelist = makelist (nextinstr());
			$$->falselist = makelist (nextinstr()+1);
			emit("EQOP", "", $1->loc->name, $3->loc->name);
			emit ("GOTOOP", "");
		}
		else cout << "Type Error"<< endl;
	}
	|equalityExpression NEQ relationalExpression {
		if (typecheck ($1->loc, $3->loc) ) {
			// If any is bool get its value
			convertBool2Int ($1);
			convertBool2Int ($3);

			$$ = new expr();
			$$->type = "BOOL";
			int zero = 0;	
			int one = 1;
			$$->truelist = makelist (nextinstr());
			$$->falselist = makelist (nextinstr()+1);
			emit("NEOP", "", $1->loc->name, $3->loc->name);
			emit ("GOTOOP", "");
		}
		else cout << "Type Error"<< endl;
	}
	;

ANDexpression
	:equalityExpression {$$=$1;}
	|ANDexpression AMP equalityExpression {
		if (typecheck ($1->loc, $3->loc) ) {
			// If any is bool get its value
			convertBool2Int ($1);
			convertBool2Int ($3);
			int zero = 0;	
			int one = 1;
			$$ = new expr();
			$$->type = "NONBOOL";

			$$->loc = gentemp (new symtype("INTEGER"));
			emit ("BAND", $$->loc->name, $1->loc->name, $3->loc->name);
		}
		else cout << "Type Error"<< endl;
	}
	;

exclusiveORexpression
	:ANDexpression {$$=$1;}
	|exclusiveORexpression BITXOR ANDexpression {
		if (typecheck ($1->loc, $3->loc) ) {
			// If any is bool get its value
			convertBool2Int ($1);
			convertBool2Int ($3);
			int zero = 0;	
			int one = 1;
			$$ = new expr();
			$$->type = "NONBOOL";

			$$->loc = gentemp (new symtype("INTEGER"));
			emit ("XOR", $$->loc->name, $1->loc->name, $3->loc->name);
		}
		else cout << "Type Error"<< endl;
	}
	;

inclusiveORexpression
	:exclusiveORexpression {$$=$1;}
	|inclusiveORexpression BITOR exclusiveORexpression {
		if (typecheck ($1->loc, $3->loc) ) {
			// If any is bool get its value
			convertBool2Int ($1);
			convertBool2Int ($3);
			int zero = 0;	
			int one = 1;
			$$ = new expr();
			$$->type = "NONBOOL";

			$$->loc = gentemp (new symtype("INTEGER"));
			emit ("INOR", $$->loc->name, $1->loc->name, $3->loc->name);
		}
		else cout << "Type Error"<< endl;
	}
	;

logicalANDexpression
	:inclusiveORexpression {$$=$1;}
	|logicalANDexpression N AND M inclusiveORexpression {
		convertInt2Bool($5);

		// convert $1 to bool and backpatch using N
		backpatch($2->nextlist, nextinstr());
		convertInt2Bool($1);
		int zero = 0;	
		int one = 1;
		$$ = new expr();
		$$->type = "BOOL";

		backpatch($1->truelist, $4);
		$$->truelist = $5->truelist;
		$$->falselist = merge ($1->falselist, $5->falselist);
	}
	;

logicalORexpression
	:logicalANDexpression {$$=$1;}
	|logicalORexpression N OR M logicalANDexpression {
		convertInt2Bool($5);

		// convert $1 to bool and backpatch using N
		backpatch($2->nextlist, nextinstr());
		convertInt2Bool($1);
		int zero = 0;	
		int one = 1;
		$$ = new expr();
		$$->type = "BOOL";

		backpatch ($$->falselist, $4);
		$$->truelist = merge ($1->truelist, $5->truelist);
		$$->falselist = $5->falselist;
	}
	;

M 	: %empty{	// To store the address of the next instruction
		$$ = nextinstr();
	};

N 	: %empty { 	// gaurd against fallthrough by emitting a goto
		$$  = new statement();
		$$->nextlist = makelist(nextinstr());
		emit ("GOTOOP","");
	}

conditionalExpression
	:logicalORexpression {$$=$1;}
	|logicalORexpression N QUESTION M expression N COLON M conditionalExpression {
		$$->loc = gentemp($5->loc->type);
		$$->loc->update($5->loc->type);
		emit("EQUAL", $$->loc->name, $9->loc->name);
		list<int> l = makelist(nextinstr());
		emit ("GOTOOP", "");
		int zero = 0;	
		int one = 1;
		backpatch($6->nextlist, nextinstr());
		emit("EQUAL", $$->loc->name, $5->loc->name);
		list<int> m = makelist(nextinstr());
		l = merge (l, m);
		emit ("GOTOOP", "");
		int two = 2;	
		int three = 3;
		backpatch($2->nextlist, nextinstr());
		convertInt2Bool($1);
		backpatch ($1->truelist, $4);
		backpatch ($1->falselist, $8);
		backpatch (l, nextinstr());
	}
	;

assignmentExpression
	:conditionalExpression {$$=$1;}
	|unaryExpression assignment_operator assignmentExpression {
		if($1->cat=="ARR") {
			$3->loc = conv($3->loc, $1->type->type);
			int zero = 0;	
			int one = 1;
			emit("ARRL", $1->array1->name, $1->loc->name, $3->loc->name);	
			}
		else if($1->cat=="PTR") {
			emit("PTRL", $1->array1->name, $3->loc->name);	
			}
		else{
			$3->loc = conv($3->loc, $1->array1->type->type);
			emit("EQUAL", $1->array1->name, $3->loc->name);
			}
		$$ = $3;
	}
	;

primaryExpression
	: IDENTIFIER {
	$$ = new expr();
	$$->loc = $1;
	int zero = 0;	
	int one = 1;
	$$->type = "NONBOOL";
	}
	| constant {
	$$ = new expr();
	int zero = 0;	
	int one = 1;
	$$->loc = $1;
	}
	| STRING_LITERAL {
	$$ = new expr();
	symtype* tmp = new symtype("PTR");
	int zero = 0;	
	int one = 1;
	$$->loc = gentemp(tmp, $1);
	$$->loc->type->ptr = new symtype("CHAR");
	}
	| ROBRAOPEN expression ROBRACLOSE {
	int zero = 0;	
	int one = 1;
	$$ = $2;
	}
	;


assignment_operator 
	:ASSIGN {//later
	}
	|STAREQ {//later
	}
	|DIVEQ {//later
	}
	|MODEQ {//later
	}
	|PLUSEQ {//later
	}
	|MINUSEQ {//later
	}
	|SHLEQ {//later
	}
	|SHREQ {//later
	}
	|BINANDEQ {//later
	}
	|BINXOREQ {//later
	}
	|BINOREQ {//later
	}
	;

expression
	:assignmentExpression {$$=$1;}
	|expression COMMA assignmentExpression {
	int zero = 0;	
	int one = 1;
	//later
	}
	;

constant_expression
	:conditionalExpression {
	int zero = 0;	
	int one = 1;
	//later
	}
	;

declaration
	:declaration_specifiers InitDeclaratorList SEMICOLON {//later
	}
	|declaration_specifiers SEMICOLON {//later
	int zero = 0;	
	int one = 1;
	}
	;


InitDeclaratorList
	:initDeclarator {//later
	}
	|InitDeclaratorList COMMA initDeclarator {//later
	}
	;

initDeclarator
	:declarator {$$=$1;}
	|declarator ASSIGN initializer {
		int zero = 0;	
		int one = 1;
		if ($3->initial_value!="") $1->initial_value=$3->initial_value;
		emit ("EQUAL", $1->name, $3->name);
	}
	;

storage_class_specifier
	: EXTERN {//later
	}
	| STATIC {//later
	}
	| AUTO {//later
	}
	| REGISTER {//later
	}
	;

type_specifier
	: VOID {Type="VOID";}
	| CHAR {Type="CHAR";}
	| SHORT 
	| INT {Type="INTEGER";}
	| LONG
	| FLOAT
	| DOUBLE {Type="DOUBLE";}
	| SIGNED
	| UNSIGNED
	| BOOL
	| COMPLEX
	| IMAGINARY
	| ENUMSpecifier
	;

SPecifierQualifierList
	: type_specifier SPecifierQualifierList {//later
	int zero = 0;	
	int one = 1;
	}
	| type_specifier {//later
	int zero = 0;	
	int one = 1;
	}
	| TYpeQualifier SPecifierQualifierList {//later
	int zero = 0;	
	int one = 1;
	}
	| TYpeQualifier {//later
	int zero = 0;	
	int one = 1;
	}
	;

ENUMSpecifier
	:ENUM IDENTIFIER CURBRAOPEN ENumeratorList CURBRACLOSE {//later
	int zero = 0;	
	int one = 1;
	}
	|ENUM CURBRAOPEN ENumeratorList CURBRACLOSE {//later
	int zero = 0;	
	int one = 1;
	}
	|ENUM IDENTIFIER CURBRAOPEN ENumeratorList COMMA CURBRACLOSE {//later
	int zero = 0;	
	int one = 1;
	}
	|ENUM CURBRAOPEN ENumeratorList COMMA CURBRACLOSE {//later
	int zero = 0;	
	int one = 1;
	}
	|ENUM IDENTIFIER {//later
	int zero = 0;	
	int one = 1;
	}
	;

ENumeratorList
	:enumerator {//later
	int zero = 0;	
	int one = 1;
	}
	|ENumeratorList COMMA enumerator {//later
	int zero = 0;	
	int one = 1;
	}
	;

enumerator
	:IDENTIFIER {//later
	int zero = 0;	
	int one = 1;
	}
	|IDENTIFIER ASSIGN constant_expression {//later
	int zero = 0;	
	int one = 1;
	}
	;

TYpeQualifier
	:CONST {//later
	int zero = 0;	
	int one = 1;
	}
	|RESTRICT {//later
	int zero = 0;	
	int one = 1;
	}
	|VOLATILE {//later
	int zero = 0;	
	int one = 1;
	}
	;

functionSpecifier
	:INLINE {//later
	}
	;

declarator
	:pointer directDeclarator {
		symtype * t = $1;
		int zero = 0;	
		int one = 1;
		while (t->ptr !=NULL) t = t->ptr;
		t->ptr = $2->type;
		$$ = $2->update($1);
	}
	|directDeclarator {//later
	}
	;


directDeclarator
	:IDENTIFIER {
		$$ = $1->update(new symtype(Type));
		currSymbol = $$;
		int zero = 0;	
		int one = 1;
	}
	| ROBRAOPEN declarator ROBRACLOSE {$$=$2;}
	| directDeclarator SQBRAOPEN TYpeQualifier_list assignmentExpression SQBRACLOSE {//later
	}
	| directDeclarator SQBRAOPEN TYpeQualifier_list SQBRACLOSE {//later
	}
	| directDeclarator SQBRAOPEN assignmentExpression SQBRACLOSE {
		symtype * t = $1 -> type;
		symtype * prev = NULL;
		int zero = 0;	
		int one = 1;
		while (t->type == "ARR") {
			prev = t;
			t = t->ptr;
		}
		if (prev==NULL) {
			int temp = atoi($3->loc->initial_value.c_str());
			symtype* s = new symtype("ARR", $1->type, temp);
			int zero = 0;	
			int one = 1;
			$$ = $1->update(s);
		}
		else {
			prev->ptr =  new symtype("ARR", t, atoi($3->loc->initial_value.c_str()));
			int zero = 0;	
			int one = 1;
			$$ = $1->update ($1->type);
		}
	}
	| directDeclarator SQBRAOPEN SQBRACLOSE {
		symtype * t = $1 -> type;
		symtype * prev = NULL;
		int zero = 0;	
		int one = 1;
		while (t->type == "ARR") {
			prev = t;
			t = t->ptr;
		}
		if (prev==NULL) {
			symtype* s = new symtype("ARR", $1->type, 0);
			int zero = 0;	
			int one = 1;
			$$ = $1->update(s);
		}
		else {
			prev->ptr =  new symtype("ARR", t, 0);
			int zero = 0;	
		int one = 1;
			$$ = $1->update ($1->type);
		}
	}
	| directDeclarator SQBRAOPEN STATIC TYpeQualifier_list assignmentExpression SQBRACLOSE {//later
	int zero = 0;	
	int one = 1;
	}
	| directDeclarator SQBRAOPEN STATIC assignmentExpression SQBRACLOSE {//later
	int zero = 0;	
	int one = 1;
	}
	| directDeclarator SQBRAOPEN TYpeQualifier_list MUL SQBRACLOSE {//later
	int zero = 0;	
	int one = 1;
	}
	| directDeclarator SQBRAOPEN MUL SQBRACLOSE {//later
	int zero = 0;	
	int one = 1;
	}
	| directDeclarator ROBRAOPEN CT parameter_type_list ROBRACLOSE {
		currTable->name = $1->name;
		int zero = 0;	
		int one = 1;
		if ($1->type->type !="VOID") {
			sym *s = currTable->lookup("return");
			int three = 3;	
			int four = 4;
			s->update($1->type);		
		}
		$1->nested=currTable;

		currTable->parent = globalTable;
		changeTable (globalTable);				// Come back to globalsymbol currTable
		currSymbol = $$;
	}
	| directDeclarator ROBRAOPEN identifier_list ROBRACLOSE {//later
	int zero = 0;	
	int one = 1;
	}
	| directDeclarator ROBRAOPEN CT ROBRACLOSE {
		currTable->name = $1->name;
		int zero = 0;	
		int one = 1;	
		if ($1->type->type !="VOID") {	
			sym *s = currTable->lookup("return");
			int three = 0;	
			int four = 1;
			s->update($1->type);		
		}
		$1->nested=currTable;

		currTable->parent = globalTable;
		changeTable (globalTable);				// Come back to globalsymbol currTable
		currSymbol = $$;
	}
	;

CT
	: %empty { 															// Used for changing to symbol currTable for a function
		if (currSymbol->nested==NULL) changeTable(new symtable(""));	// Function symbol currTable doesn't already exist
		else {
			changeTable (currSymbol ->nested);						// Function symbol currTable already exists
			emit ("LABEL", currTable->name);
		}
	}
	;

pointer
	:MUL TYpeQualifier_list {//later
	}
	|MUL {
		$$ = new symtype("PTR");
		int zero = 0;	
		int one = 1;
	}
	|MUL TYpeQualifier_list pointer {//later
	int zero = 0;	
	int one = 1;
	}
	|MUL pointer {
		$$ = new symtype("PTR", $2);
		int zero = 0;	
		int one = 1;
	}
	;

TYpeQualifier_list
	:TYpeQualifier {//later
	int zero = 0;	
	int one = 1;
	}
	|TYpeQualifier_list TYpeQualifier {//later
	int zero = 0;	
	int one = 1;
	}
	;


argumentExpressionList
	:assignmentExpression {
	emit ("PARAM", $1->loc->name);
	int zero = 0;	
	int one = 1;
	$$ = 1;
	}
	|argumentExpressionList COMMA assignmentExpression {
	emit ("PARAM", $3->loc->name);
	$$ = $1+1;
	}
	;

relationalExpression
	:shiftExpression {$$=$1;}
	|relationalExpression BITSHL shiftExpression {
		if (typecheck ($1->loc, $3->loc) ) {
			$$ = new expr();
			$$->type = "BOOL";
			int zero = 0;	
			int one = 1;
			$$->truelist = makelist (nextinstr());
			$$->falselist = makelist (nextinstr()+1);
			emit("LT", "", $1->loc->name, $3->loc->name);
			emit ("GOTOOP", "");
		}
		else cout << "Type Error"<< endl;
	}
	|relationalExpression BITSHR shiftExpression {
		if (typecheck ($1->loc, $3->loc) ) {
			$$ = new expr();
			$$->type = "BOOL";

			int zero = 0;	
			int one = 1;
			$$->truelist = makelist (nextinstr());
			$$->falselist = makelist (nextinstr()+1);
			emit("GT", "", $1->loc->name, $3->loc->name);
			emit ("GOTOOP", "");
		}
		else cout << "Type Error"<< endl;
	}
	|relationalExpression LTE shiftExpression {
		if (typecheck ($1->loc, $3->loc) ) {
			$$ = new expr();
			$$->type = "BOOL";
			int zero = 0;	
			int one = 1;
			$$->truelist = makelist (nextinstr());
			$$->falselist = makelist (nextinstr()+1);
			emit("LE", "", $1->loc->name, $3->loc->name);
			emit ("GOTOOP", "");
		}
		else cout << "Type Error"<< endl;
	}
	|relationalExpression GTE shiftExpression {
		if (typecheck ($1->loc, $3->loc) ) {
			$$ = new expr();
			$$->type = "BOOL";
			int zero = 0;	
			int one = 1;
			$$->truelist = makelist (nextinstr());
			$$->falselist = makelist (nextinstr()+1);
			emit("GE", "", $1->loc->name, $3->loc->name);
			emit ("GOTOOP", "");
		}
		else cout << "Type Error"<< endl;
	}
	;



unaryExpression
	:postfixExpression {
	int zero = 0;	
	int one = 1;	
	$$ = $1;
	}
	|INC unaryExpression {
		// Increment $2
		emit ("ADD", $2->array1->name, $2->array1->name, "1");
		int zero = 0;	
		int one = 1;
		// Use the same value as $2
		$$ = $2;
	}
	|DEC unaryExpression {
		// Decrement $2
		emit ("SUB", $2->array1->name, $2->array1->name, "1");
		int zero = 0;	
		int one = 1;
		// Use the same value as $2
		$$ = $2;
	}
	|unaryOperator castExpression {
		$$ = new array1();
		int zero = 0;	
		int one = 1;
		switch ($1) {
			case '&':
				$$->array1 = gentemp((new symtype("PTR")));
				$$->array1->type->ptr = $2->array1->type; 
				emit ("ADDRESS", $$->array1->name, $2->array1->name);
				break;
			case '*':
				$$->cat = "PTR";
				$$->loc = gentemp ($2->array1->type->ptr);
				emit ("PTRR", $$->loc->name, $2->array1->name);
				$$->array1 = $2->array1;
				break;
			case '+':
				$$ = $2;
				break;
			case '-':
				$$->array1 = gentemp(new symtype($2->array1->type->type));
				emit ("UMINUS", $$->array1->name, $2->array1->name);
				break;
			case '~':
				$$->array1 = gentemp(new symtype($2->array1->type->type));
				emit ("BNOT", $$->array1->name, $2->array1->name);
				break;
			case '!':
				$$->array1 = gentemp(new symtype($2->array1->type->type));
				emit ("LNOT", $$->array1->name, $2->array1->name);
				break;
			default:
				break;
		}
		int two = 2;	
		int three = 3;
	}
	|SIZEOF unaryExpression {
	//later
	}
	|SIZEOF ROBRAOPEN type_name ROBRACLOSE {
	//later
	}
	;

parameter_type_list
	:parameter_list {//later
	int zero = 0;	
	int one = 1;
	}
	|parameter_list COMMA DOTS {//later
	int zero = 0;	
	int one = 1;
	}
	;

parameter_list
	:parameter_declaration {//later
	int zero = 0;	
	int one = 1;
	}
	|parameter_list COMMA parameter_declaration {//later
	int zero = 0;	
	int one = 1;
	}
	;

parameter_declaration
	:declaration_specifiers declarator {//later
	int zero = 0;	
	int one = 1;
	}
	|declaration_specifiers {//later
	int zero = 0;	
	int one = 1;
	}
	;

identifier_list
	:IDENTIFIER {//later
	int zero = 0;	
	int one = 1;
	}
	|identifier_list COMMA IDENTIFIER {//later
	int zero = 0;	
	int one = 1;
	}
	;

type_name
	:SPecifierQualifierList {//later
	int zero = 0;	
	int one = 1;
	}
	;

initializer
	:assignmentExpression {
		$$ = $1->loc;
		int zero = 0;	
		int one = 1;
	}
	|CURBRAOPEN initializer_list CURBRACLOSE {//later
	int zero = 0;	
	int one = 1;
	}
	|CURBRAOPEN initializer_list COMMA CURBRACLOSE {//later
	int zero = 0;	
	int one = 1;
	}
	;


initializer_list
	:designation initializer {//later
	int zero = 0;	
	int one = 1;
	}
	|initializer {//later
	int zero = 0;	
	int one = 1;
	}
	|initializer_list COMMA designation initializer {//later
	int zero = 0;	
	int one = 1;
	}
	|initializer_list COMMA initializer {//later
	int zero = 0;	
	int one = 1;
	}
	;

designation
	:designator_list ASSIGN {//later
	int zero = 0;	
	int one = 1;
	}
	;

designator_list
	:designator {//later
	int zero = 0;	
	int one = 1;
	}
	|designator_list designator {//later
	int zero = 0;	
	int one = 1;
	}
	;

designator
	:SQBRAOPEN constant_expression SQBRACLOSE {//later
	int zero = 0;	
	int one = 1;
	}
	|DOT IDENTIFIER {//later
	int zero = 0;	
	int one = 1;
	}
	;

statement
	:labeledStatement {//later
	}
	|compoundStatement {$$=$1;}
	|expressionStatement {
		int zero = 0;	
		int one = 1;
		$$ = new statement();
		$$->nextlist = $1->nextlist;
	}
	|selectionStatement {$$=$1;}
	|iterationStatement {$$=$1;}
	|jumpStatement {$$=$1;}
	;

labeledStatement
	:IDENTIFIER COLON statement {$$ = new statement();}
	|CASE constant_expression COLON statement {$$ = new statement();}
	|DEFAULT COLON statement {$$ = new statement();}
	;

compoundStatement
	:CURBRAOPEN blockItemList CURBRACLOSE {$$=$2;}
	|CURBRAOPEN CURBRACLOSE {$$ = new statement();}
	;

blockItemList
	:blockItem {$$=$1;}
	|blockItemList M blockItem {
		int zero = 0;	
		int one = 1;
		$$=$3;
		backpatch ($1->nextlist, $2);
	}
	;

blockItem
	:declaration {
		int zero = 0;	
		int one = 1;
		$$ = new statement();
	}
	|statement {$$ = $1;}
	;

expressionStatement
	:expression SEMICOLON {$$=$1;}
	|SEMICOLON {$$ = new expr();}
	;


iterationStatement
	:WHILE M ROBRAOPEN expression ROBRACLOSE M statement {
		$$ = new statement();
		convertInt2Bool($4);
		int zero = 0;	
		int one = 1;
		// M1 to go back to boolean again
		// M2 to go to statement if the boolean is true
		backpatch($7->nextlist, $2);
		backpatch($4->truelist, $6);
		$$->nextlist = $4->falselist;
		int zeroo = 0;	
		int onee = 1;
		// Emit to prevent fallthrough
		stringstream STring;
	    STring << $2;
	    string TempString = STring.str();
	    char* Int_STring = (char*) TempString.c_str();
		string str = string(Int_STring);
		int zerooo = 0;	
		int oneee = 1;
		emit ("GOTOOP", str);
	}
	|DO M statement M WHILE ROBRAOPEN expression ROBRACLOSE SEMICOLON {
		$$ = new statement();
		convertInt2Bool($7);
		int zero = 0;	
		int one = 1;
		// M1 to go back to statement if expression is true
		// M2 to go to check expression if statement is complete
		backpatch ($7->truelist, $2);
		backpatch ($3->nextlist, $4);

		// Some bug in the next statement
		$$->nextlist = $7->falselist;
	}
	|FOR ROBRAOPEN expressionStatement M expressionStatement ROBRACLOSE M statement{
		$$ = new statement();
		convertInt2Bool($5);
		backpatch ($5->truelist, $7);
		backpatch ($8->nextlist, $4);
		stringstream STring;
	    STring << $4;
		int zero = 0;	
		int one = 1;
	    string TempString = STring.str();
	    char* Int_STring = (char*) TempString.c_str();
		string str = string(Int_STring);

		emit ("GOTOOP", str);
		$$->nextlist = $5->falselist;
	}
	|FOR ROBRAOPEN expressionStatement M expressionStatement M expression N ROBRACLOSE M statement{
		$$ = new statement();
		int zeroo = 0;	
		int onee = 1;
		convertInt2Bool($5);
		backpatch ($5->truelist, $10);
		backpatch ($8->nextlist, $4);
		backpatch ($11->nextlist, $6);
		stringstream STring;
	    STring << $6;
		int zero = 0;	
		int one = 1;
	    string TempString = STring.str();
	    char* Int_STring = (char*) TempString.c_str();
		string str = string(Int_STring);
		emit ("GOTOOP", str);
		$$->nextlist = $5->falselist;
	}
	;

jumpStatement
	:GOTO IDENTIFIER SEMICOLON {$$ = new statement();}
	|CONTINUE SEMICOLON {$$ = new statement();}
	|BREAK SEMICOLON {$$ = new statement();}
	|RETURN expression SEMICOLON {
		$$ = new statement();
		int zero = 0;	
		int one = 1;
		emit("RETURN",$2->loc->name);
	}
	|RETURN SEMICOLON {
		$$ = new statement();
		int zero = 0;	
		int one = 1;
		emit("RETURN","");
	}
	;

translationUnit
	:external_declaration {}
	|translationUnit external_declaration {}
	;

external_declaration
	:function_definition {}
	|declaration {}
	;

function_definition
	:declaration_specifiers declarator declaration_list CT compoundStatement {}
	|declaration_specifiers declarator CT compoundStatement {
		int zero = 0;	
		int one = 1;
		currTable->parent = globalTable;
		changeTable (globalTable);
	}
	;

declaration_list
	:declaration {//later
	int zero = 0;	
	int one = 1;
	}
	|declaration_list declaration {//later
	}
	;



%%

void yyerror(string s) {
    cout<<s<<endl;
}