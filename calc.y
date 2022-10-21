/* Reverse polish notation calculator. */

%{
#include <math.h>
#include <stdio.h>
#include <iostream>
#include <map>

using namespace std;

extern int yylex();
extern int yyparse();
extern void yyerror(const char* s);

map<string, double> vars;
%}

%start stmt_list

%union {
    double numVal;
    std::string *var;

}


%token<numVal> NUMBER
%token EOL
%token<var> VARIABLE
%type<numVal> exp

%right '='
%left '+' '-'
%left '*' '/'
%right '^'
%left '(' ')'
%right UMINUS
%right UPLUS

%% /* Grammar rules and actions follow */
stmt_list:  stmt
        | stmt_list stmt
;

stmt:   EOL
        | exp EOL { 
          cout << "=" << $1 << endl;
          cout << ">> ";
        }
        | VARIABLE '=' exp { cout << *($1) << "="<<  $3 << endl; vars[*$1] = $3; cout  << ">>";}
        | error EOL 
;

exp:    NUMBER            { $$ = $1;         }
        | VARIABLE        { $$ = vars[*$1]; }
        | exp '+' exp     { $$ = $1 + $3;    }
        | exp '-' exp     { $$ = $1 - $3;    }
        | exp '*' exp     { $$ = $1 * $3;    }
        | exp '/' exp     { $$ = $1 / $3;    }
      /* Exponentiation */
        | exp '^' exp     { $$ = pow ($1, $3); }
      /* Unary minus    */
        | '-' exp %prec UMINUS   { $$ = -$2; }
        | '+' exp %prec UPLUS   { $$ = $2;}
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