# README

## Question Answer:

1. In completion of the tiny calculator, list the things that you could not do with the flex() tool in Homework 2 that can be done using the bison tool. Please write down your explanation on why they could not be done by the flex() tool alone.

- One notable useful feature of the Bison tool that is not inherently or easily capable of flex is actually getting pieces of information in the order you want them in. Whether that be precedence or just making sure that for some command, you get all the parameters in order. BNF really helps a lot with this, and is simply not supported by FLEX. The only way to do this in FLEX would be to implement complex and convoluted logic.

2. Write BNF grammar rules to implement the tiny calculator behaviors listed below. You should list the grammar with some descriptions in a comment section at the beginning of your code file, or in a separate Markdown file.
   statement_list (list of binary expression statements)
   statement (assignment or expression)
   expression 5 arithmetic operations (+, -, \*, /,^)
   (expression) # parenthesis for setting user's precedence
   variables (C-like identifiers)
   numbers (C-like integers or floats)
   Supporting signs (+, -) e.g. 2 - -3 + 2 -7 --2 (output: 2)

- Answer in comments of calc.y

## calc.y

The YACC(Bison) file calc.y is where it has BNF defined grammar rules that take in the tokens from the Flex file (calc.l) and computes a variety of statements. It does this by first declaring a set of functions notably YYfunctons and a set of flags used later in the program for error checking.

It defines a set of operators their precedence and associativity including the unary operators. Then the grammar rules are applied, all of which are fairly standard mathematical operations and assignment operations. The only notable difference in the impmemention is the choice of using a set of flags (declFlag, zeroFlag and validFlag) to check for edge cases that slip through the cracks of bison.

## calc.l

The Flex file calc.l is incredibly simple but very important, it defines a set of regular expressions and tokens that are associated with those regular expressions. Then it feeds them into Bison to be evaluated by the set of grammar rules provided there.
