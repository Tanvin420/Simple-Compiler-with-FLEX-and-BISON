Commands for compiling a.exe which will be our Compiler for C language:

flex compiler.l
bison -d compiler.y
g++ lex.yy.c compiler.tab.c

Input:
input.txt contains the input of the compiler

Language:
You should consider the following subset of C language which has the following characteristics:
→ There can be only one function named main without any parameter and return type.
→ Statements can be either declarations of a single variable of basic data type or arithmetic expressions
ending with semicolons.
→ Arithmetic expression can be any assignment that uses all types of operators for arithmetic expressions
you have seen so far. Precedence and associativity rules should be maintained as per standard.
Note:
→ There will be no pre-processing directives like #include or #define.
→ No need to handle the initialization of variables in the declaration statement.
→ No return, break statement, switch-case statement, loop, or conditional statement will be used


Partial Grammar:
prog → MAIN(){ stmt }
stmt → stmt unit | unit
unit → var_decl NEWLINE
| expr_decl NEWLINE
var_decl → type_spec decl_list SEMICOLON
type_spec→ INT
decl_list→ term
expr→ NUM
| expr ADDOP expr
| expr MULOP expr
| <add other grammar for other arithmetic and logical operators>
| <add grammar rule for expression with parentheses>
|term
term→ ID
expr_decl-> term ASSOP expr SEMICOLON

Outputs:

→ For each production of the grammar directly print in the output file “code.ir” as soon as three
address code needs to be generated.

→ When the parser reduces to the start symbol, it will print in the output file
“code.asm”

→ To check the generated “code.asm” file add the initialization part in the assembly program like initializing
the data segment register in the main procedure of the generated assembly code. Some instructions may not be the same for all processors.
