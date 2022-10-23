/*
Standard Calculator wiht Bison

The stmt_list tokens are used to start the program.
stmt_list stmt allows for other statements to be elaborated.

stmt tokens are use to decipher EOL and VARIABLE tokens.
exp EOL handles the setting of new lines and resetitng of flags.
VARIABLE '=' exp handles the setting of variales.


The exp token handles most of the BNF cases.
exp '+' exp handles addiditon and allows for either a NUMBER or VARIABLE terminal to get used in its place
exp '-' exp handles subtraction and allows for either a NUMBER or VARIABLE terminal to get used in its place
exp '*' exp handles multiplication and allows for either a NUMBER or VARIABLE terminal to get used in its place
exp '/' exp handles division and allows for either a NUMBER or VARIABLE terminal to get used in its place. It also sets flags to indicate divide by zero issues. 
exp '^' exp handles power/exponentiation and allows for either a NUMBER or VARIABLE terminal to get used in its place. 
'-' exp %prec UMINUS sets the UNARY minus, and its associated precedence allowing for things like -3-3 and 3--3 to happen without error 
'+' exp %prec UPLUS sets the UNARY plus, and its associated precedence allowing for things like 3-+2 to happen without error.
*/

%{
#include <math.h>
#include <stdio.h>
#include <iostream>
#include <map>

using namespace std;

extern int yylex();
extern int yyparse();
extern void yyerror(const char* s);
int declFlag = 0;
int zeroFlag = 0;
int validFlag = 0;
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
%left UMINUS
%left UPLUS

%% /* Grammar rules and actions follow */
stmt_list:  stmt
        | stmt_list stmt
;

stmt:   EOL
        | exp EOL { 
          
          if (declFlag == 0 && zeroFlag == 0){
            statementNum+=1;
            cout << "= " << $1 << endl;
            cout << "[" << statementNum << "] ";
          }
          declFlag = 0;
          zeroFlag = 0;
        }
        | VARIABLE '=' exp { if(declFlag == 0 && validFlag == 0 && zeroFlag == 0) {
                                cout << "Variable "<< *($1) << " is assigned to "<<  $3 << "." << endl; vars[*$1] = $3; statementNum+=1; cout << "[" << statementNum << "] ";
                              }
                              declFlag = 0;
                              validFlag = 0;
                              zeroFlag = 0;
                            }
        | error EOL 
;

exp:    NUMBER            { $$ = $1;         }
        | VARIABLE        
        { 
          if(vars.contains(*$1)){
            $$ = vars[*$1];
          }else{
            declFlag = 1;
            yyerror((*$1 + " not declared").c_str());} 
        }
        | VARIABLE VARIABLE {validFlag = 1; yyerror(("Syntax Error"));}
        | exp '+' exp     { $$ = $1 + $3;    }
        | exp '-' exp     { $$ = $1 - $3;    }
        | exp '*' exp     { $$ = $1 * $3;    }
        | exp '/' exp     { if ($3 != 0){
                              $$ = $1 / $3;
                            }else{
                              zeroFlag = 1;
                              yyerror(("Divide by Zero"));
                            }    
                          }
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
  cout << "Error: " << s << " at statement: " << statementNum-1 << endl;
  cout << "[" << statementNum << "] ";
}