#include "y.tab.h"
#include <stdio.h>

extern int yyparse();

// The rules will check whether the test file is syntactically correct or not.

int main()
{
    yyparse();
    return 0;
}