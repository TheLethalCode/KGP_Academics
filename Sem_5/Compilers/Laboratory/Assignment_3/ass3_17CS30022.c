#include <stdio.h>

extern char* yytext;

// Main function
int main() {

  int token_val;
  while (token_val = yylex()) {

    switch (token_val) {

    	// Comments
    	case SINGLE_LINE_COMMENT:
    		printf("<SINGLE_LINE_COMMENT, %d, %s>\n",token_val, yytext);
  			break;

        case MULTI_LINE_COMMENT:
            printf("<MULTI_LINE_COMMENT, %d, %s>\n",token_val, yytext);
            break;

  		// Keywords
  		case KEYWORD:
  			printf("<KEYWORD, %d, %s>\n",token_val, yytext);
  			break;

    	// Identifiers
		case IDENTIFIER: 
			printf("<IDENTIFIER, %d, %s>\n",token_val, yytext); 
			break;

		// Constants
		case INTEGER_CONSTANT: 
			printf("<INTEGER CONSTANT, %d, %s>\n",token_val, yytext); 
			break;

		case FLOATING_CONSTANT: 
			printf("<FLOAT CONSTANT, %d, %s>\n",token_val, yytext); 
			break;

		case CHARACTER_CONSTANT: 
			printf("<CHARACTER CONSTANT, %d, %s>\n",token_val, yytext); 
			break;

		case STRING_LITERAL: 
			printf("<STRING LITERAL, %d, %s>\n",token_val, yytext); 
			break;

		// Punctuators
		case PUNCTUATOR: 
			printf("<PUNCTUATOR, %d, %s>\n",token_val, yytext); 
			break;

		default: 
			printf("Not a valid C literal\n"); 
			break;
    }
  }
}