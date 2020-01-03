#include "myl.h"

int main()
{
    // Checking the printing of the string
    char *str = "Enter an integer: ";
    printStr(str);
    
    int n;
    if(readInt(&n)) // If a vaild integer is entered
    {
        char *str1 = "You have entered: ";
        printStr(str1);
        printInt(n); // Print int
    }
    else // Else print error message
    {
        char *str1 = "ERROR: Not an integer";
        printStr(str1);
    }
    
    char *str2 = "\nEnter a floating point number: ";
    printStr(str2);
    
    float f=0.211;
    if(readFlt(&f)) // If a valid float is entered
    {
        char *str1 = "You have entered: ";
        printStr(str1);
        printFlt(f); // Print FLoat
    }
    else // Else print error message
    {
        char *str1 = "ERROR: Not a floating point number";
        printStr(str1);
    }        

}