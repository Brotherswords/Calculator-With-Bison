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
int errFlag = 0;
int statementNum = 1;

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
          statementNum+=1;
          
          if (errFlag == 0){
            cout << "= " << $1 << endl;
            cout << "[" << statementNum << "] ";
          }
          errFlag = 0;
        }
        | VARIABLE '=' exp { cout << *($1) << " = "<<  $3 << endl; vars[*$1] = $3; cout << "[" << statementNum << "] ";}
        | error EOL 
;

exp:    NUMBER            { $$ = $1;         }
        | VARIABLE        
        { 
          if(vars.contains(*$1)){
            $$ = vars[*$1];
          }else{
            errFlag = 1;
            yyerror((*$1 + " not declared.").c_str());} 
        }
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
  cout << "[" << statementNum << "] ";
  yyparse ();
  return 0;
}

void yyerror (const char *s)  /* Called by yyparse() on error */
{
  statementNum+=1;
  cout << "Error: " << s << " at statement: " << statementNum << endl;
  cout << "[" << statementNum << "] ";
}