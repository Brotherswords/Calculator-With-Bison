/* Auxiliary declaration section */
%{
#include <string.h>
#include <math.h>
#include <stdlib.h>
#include <iostream>
#include "calc.tab.h"
%}


/* Regular declarations section */
num [-]?[[:digit:]]+|[-+]?[[:digit:]]*\.[[:digit:]]+([eE][-+]?[[:digit:]]+)?
valid [*+-/^=()~]
eol [\n]


/* Rules section */
%%
{num} {yylval.numVal = atof(yytext); return NUMBER;}

{valid} {return yytext[0]; /* pass them to be consumed by bison */}
{eol} {return EOL;}

. {; /* sink all extra characters */}  
%%

/* Display 'bye' msg when the program terminates */
int yywrap()
{
    std::cout << "Done!!\n" << std::endl;
    return 1;
}