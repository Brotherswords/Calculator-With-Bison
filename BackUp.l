    /* calculator #1 */
%{
    #include "calc.tab.h" 
    #include <stdlib.h>
    #include <string>
    void yyerror(char *);
%}

%%

[a-zA-Z]*       {
                yylval.name = yytext;
                return VARIABLE;
                }

[-]?[1-9]+|([0-9]*)"."([0-9]+)     { 
                yylval.dub = atof(yytext); 
                return DOUBLE;
            }

[-+()=/*\n]     { return *yytext; }

[ \t]   ;       /* skip whitespace */

.               yyerror("Unknown character");

%%

int yywrap(void) {
    return 1;
}
