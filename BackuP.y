%{
    #include <stdio.h>
    #include <string>
    void yyerror(char *);
    int yylex(void);

    std::map<std::string, double> vars;
    using namespace std;
%}

%union {
    string name; 
    double dub;             /* Constant integer value */
};


%token <name> VARIABLE
%token <dub> DOUBLE
%left '+' '-'
%left '*' '/'

%type<dub> expression 


%%

program:
        program statement '\n'
        | /* NULL */
        ;

statement:
        expression                      { printf("%d\n", $1); }
        | VARIABLE '=' expression       { sym[$1] = $3; }
        ;

expression:
        DOUBLE
        | VARIABLE                      { $$ = sym[$1]; }
        | expression '+' expression     { $$ = $1 + $3; }
        | expression '-' expression     { $$ = $1 - $3; }
        | expression '*' expression     { $$ = $1 * $3; }
        | expression '/' expression     { $$ = $1 / $3; }
        | '(' expression ')'            { $$ = $2; }
        ;

%%

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}

int main(void) {
    yyparse();
}
