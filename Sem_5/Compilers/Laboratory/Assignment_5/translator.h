#ifndef TRANSLATE
#define TRANSLATE
#include <bits/stdc++.h>

using namespace std;

#define CHAR_BYTE_SIZE 		    1
#define INT_BYTE_SIZE  		    4
#define DOUBLE_BYTE_SIZE		8
#define POINTER_BYTE_SIZE		4

extern  char* yytext;
extern  int yyparse();

// Declaring the classes
class symtype;					// Symbol type class
class sym;						// Element of symbol table
class symtable;					// Symbol Table
class quad;						// Element of quad array
class quadArray;				// QuadArray

// Variables to be exported to the cxx file
extern symtable* currTable;						// Current Symbbol Table
extern symtable* globalTable;				// Global Symbbol Table
extern quadArray qArr;							// Quadarray object
extern sym* currSymbol;					// A pointer pointing to the symbol read just now


// Class definitions

// Symbol type class
class symtype {
public:
	symtype(string name, symtype* ptr = NULL, int width = 1); // Initialiser for the class
	string type;				// Type of symbol in the table
	symtype* ptr;				// For arrays
	int width;					// Size of array (in case of arrays)
};

// Quad Class - Element of quadArray
class quad {
public:
	string operator1;					// Operator of the expression
	string answer;						// Result of the expression
	string argument1;					// Argument 1 of the expression
	string argument2;					// Argument 2 of the expression

	// Print Quad Function
	void print ();

	// COnstructors with default operation
	quad (string res, string argA, string operation = "EQUAL", string argB = "");			
	quad (string res, int argA, string operation = "EQUAL", string argB = "");				
	quad (string res, float argA, string operation = "EQUAL", string argB = "");			
};

// Array of Quads
class quadArray {
public:
	vector <quad> qArray;		                // Vector of quads

	// Print all the Quads
	void print ();								// Print the quadArray
};

// Element of the symbol table - symbols
class sym {
public:
	string name;				// Name of the symbol
	symtype *type;				// Type of the Symbol - Pointer
	string initial_value;		// Symbol initial valus (if any)
	int size;					// Size of the symbol
	int offset;					// Offset of symbol
	symtable* nested;				// Pointer to nested symbol table

	sym (string name, string t="INTEGER", symtype* ptr = NULL, int width = 0); //constructor declaration
	sym* update(symtype * t); 	// A method to update different fields of an existing entry.
	sym* link_to_symbolTable(symtable* t);
};

// Symbol Table Class
class symtable {
public:
	string name;				// Name of the symbol table
	int count;					// Count of temporary variables
	list<sym> currTable; 			// The table of symbols
	symtable* parent;				// Immediate parent of the symbol table

	symtable (string name="NULL");							// Constructor
	sym* lookup (string name);								// Lookup for a symbol in symbol table
	void print();					            			// Print the symbol table
	void update();						        			// Update offset of the complete symbol table
};


//Attributes and their explanation for different non terminal type

//Attributes for statements
struct statement {
	list<int> nextlist;				// Nextlist for statement
};

//Attributes for array
struct array1 {
	string cat;
	sym* loc;					// Temporary used for computing array address
	sym* array1;					// Pointer to symbol table
	symtype* type;				// type of the subarray generated
};


//Attributes for expressions
struct expr {
	string type; 							//to store whether the expression is of type int or bool

	// Valid for non-bool type
	sym* loc;								// Pointer to the symbol table entry

	// Valid for bool type
	list<int> truelist;						// Truelist valid for boolean
	list<int> falselist;					// Falselist valid for boolean expressions

	// Valid for statement expression
	list<int> nextlist;
};

//////////////////////////////////////////Global functions required for the translator
void emit(string op, string answer, string argA="", string argB = "");    //emits for adding quads to quadArray
void emit(string op, string answer, int argA, string argB = "");		  //emits for adding quads to quadArray (argA is int)
void emit(string op, string answer, float argA, string argB = "");        //emits for adding quads to quadArray (argA is float)


sym* conv (sym*, string);							// TAC for Type conversion in program
bool typecheck(sym* &s1, sym* &s2);					// Checks if two symbols have same type
bool typecheck(symtype* t1, symtype* t2);			//checks if two symtype objects have same type


void backpatch (list <int> lst, int i);
list<int> makelist (int i);							        // Make a new list contaninig an integer
list<int> merge (list<int> &lst1, list <int> &lst2);		// Merge two lists into a single list

expr* convertInt2Bool (expr*);				// convert any expression (int) to bool
expr* convertBool2Int (expr*);				// convert bool to expression (int)

void changeTable (symtable* newtable);               //for changing the current sybol table
int nextinstr();									// Returns the next instruction number

sym* gentemp (symtype* t, string init = "");		// Generate a temporary variable and insert it in current symbol table

int size_type (symtype*);							// Calculate size of any symbol type 
string print_type(symtype*);						// For printing type of symbol recursive printing of type

#endif