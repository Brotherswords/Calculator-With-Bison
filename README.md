# README

## Question Answer:

    1) The YACC(bison) tool generates C code for a syntax analyzer, or parser. Yacc then uses  defined grammar rules that to analyze tokens from lex and create a syntax tree. They can also generate parser tables.

## calc.y

The YACC(Bison) file calc.y is where it has BNF defined grammar rules that take in the tokens from the Flex file (calc.l) and computes a variety of statements. It does this by first declaring a set of functions notably YYfunctons and a set of flags used later in the program for error checking.

It defines a set of operators their precedence and associativity including the unary operators. Then the grammar rules are applied, all of which are fairly standard mathematical operations and assignment operations. The only notable difference in the impmemention is the choice of using a set of flags (declFlag, zeroFlag and validFlag) to check for edge cases that slip through the cracks of bison.

## calc.l

The Flex file calc.l is incredibly simple but very important, it defines a set of regular expressions and tokens that are associated with those regular expressions. Then it feeds them into Bison to be evaluated by the set of grammar rules provided there.
