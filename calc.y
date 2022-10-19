/* Reverse polish notation calculator. */

%{
#include <math.h>
#include <stdio.h>
#include <iostream>

using namespace std;

extern int yylex();
extern int yyparse();
extern void yyerror(const char* s);
%}

%start stmt_list

%union {
    double numVal; 
}

%token<numVal> NUMBER
%token EOL
%type<numVal> exp

%right '='
%left '+' '-'
%left '*' '/'
%right '^'
%left '(' ')'

%% /* Grammar rules and actions follow */
stmt_list:  stmt
        | stmt_list stmt
;

stmt:   EOL
        | exp EOL { 
          cout << "= " << $1 << endl;
          cout << ">> ";
        }
        | error EOL 
;

exp:    NUMBER            { $$ = $1;         }
        | exp '+' exp     { $$ = $1 + $3;    }
        | exp '-' exp     { $$ = $1 - $3;    }
        | exp '*' exp     { $$ = $1 * $3;    }
        | exp '/' exp     { $$ = $1 / $3;    }
      /* Exponentiation */
        | exp '^' exp     { $$ = pow ($1, $3); }
      /* Unary minus    */
        | '~' exp         { $$ = -$2;        }
        |'(' exp ')'       { $$ = $2; }
;
%%


/* function invoked after finishing an input file */
int main ()
{
  cout << ">> ";
  yyparse ();
  return 0;
}

void yyerror (const char *s)  /* Called by yyparse() on error */
{
  cout << s << endl;
  cout << ">> ";
}