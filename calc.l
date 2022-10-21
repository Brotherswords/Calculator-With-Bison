/* Auxiliary declaration section */
%{
#include <string.h>
#include <math.h>
#include <stdlib.h>
#include <iostream>
#include "calc.tab.h"

using namespace std;

%}


/* Regular declarations section */
var [_[:alpha:]][_[:alnum:]]* 
num [-]?[[:digit:]]+|[-+]?[[:digit:]]*\.[[:digit:]]+([eE][-+]?[[:digit:]]+)?
valid [*+-/^=()~]  
eol [\n]
whitespace [ |\t]*


/* Rules section */
%%
{valid} {return yytext[0]; /* pass them to be consumed by bison */}
{eol} {return EOL;}
{var} {yylval.var = new std::string(yytext); return VARIABLE;}
{num} {yylval.numVal = atof(yytext); return NUMBER;}
{whitespace} {};

. {; /* sink all extra characters */}  
%%

/* Display 'bye' msg when the program terminates */
int yywrap()
{
    std::cout << "Done!!\n" << std::endl;
    return 1;
}