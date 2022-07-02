%{
#include<bits/stdc++.h>
#include <fstream>
#include <sstream>	
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "SymbolTable.h"
#define YYSTYPE SymbolInfo
 
using namespace std;

int yylex(void);
int t_count = 1;
char * str;

ofstream  fout,lout,TAC,ASM;
ostringstream ss;

SymbolTable Table;


int line=1;

void yyerror(const char *s)
{
	fprintf(stderr,"%s\n",s);
	return;
}

char* getTemp(int i)
{
    char *ret = (char*) malloc(15);
    sprintf(ret, "t%d", i);
	return ret;
}



%}

%error-verbose
%token INT NUM ID MAIN SEMICOLON 
%token NEWLINE


%right ASSOP NOT
%left ADDOP SUBOP 
%left LAND LOR 
%left MULOP 
%left DIVOP
%right LNOT
%left LPARAN RPARAN '{' '}'  


%%

prog :
		 MAIN LPARAN RPARAN '{' stmt '}'  {	
			                           												
									SymbolInfo obj1("", "");					
									$$=obj1;
									$$.code=$5.code;									
									ASM<<$$.code<<endl;									
									TAC<<endl; 									 										 
										}
	;


stmt : stmt unit            { 
								SymbolInfo obj1("", "");					
								$$=obj1;
								$$.Code($2.code);
								}
     | unit                 {   SymbolInfo obj1("", "");					
								$$=obj1;
								$$.Code($1.code);
								}						
	| NEWLINE stmt          {   line++;
		                        SymbolInfo obj1("", "");					
								$$=obj1;
                                $$.code=$2.code;
								} 
	| stmt NEWLINE           {   line++; 
                                SymbolInfo obj1("", "");					
								$$=obj1;
								$$.code=$1.code;
								}                     
	;
unit : var_decl NEWLINE     { 
							    
                            }
     | expr_decl NEWLINE  { 
							    line++;TAC<<endl; 
								SymbolInfo obj1("", "");					
								$$=obj1;
								$$.code=$1.code;								
						   }
	;
var_decl : type_spec decl_list SEMICOLON {  	extern SymbolTable Table;
	        							        Table.INSERT($2.getSymbol(),"ID");  }

type_spec : INT                   {   }
	;
decl_list : term                  {   }
	;
expr : NUM                        {  
	                                 extern SymbolTable Table;
	                                 Table.INSERT($1.getSymbol(),"NUM"); 

								  }
	| expr ADDOP expr             {  
								str = getTemp(t_count);
								SymbolInfo obj1(string(str), "");				
								$$=obj1;
								TAC<<$$.getSymbol()<<" = "<<$1.getSymbol()<<" + "<<$3.getSymbol()<<endl;							

                                /*
								//asm code
								fprintf(ASM, "MOV ax, %s\n", $1.getSymbol().c_str()); 
								// check documentation for c_str() function
								fprintf(ASM, "MOV bx, %s\n", $3.getSymbol().c_str());
								 // c_str() used to have fprintf compatible string
								fprintf(ASM, "ADD ax, bx\n");
								fprintf(ASM, "MOV %s, ax\n", $$.getSymbol().c_str());
                                 */

								string result;
                                ss<<"MOV ax,"<<$1.getSymbol().c_str()<<endl;
                                ss<<"MOV bx,"<<$3.getSymbol().c_str()<<endl;
								ss<<"ADD ax, bx"<<endl;
								ss<<"MOV "<<$$.getSymbol().c_str()<<", ax"<<endl;

								result = ss.str();
								$$.Code(result);
                                

								t_count++;
								
	    							}	

	| expr MULOP expr             {  

								str = getTemp(t_count);
								SymbolInfo obj1(string(str), "");				
								$$=obj1;
								TAC<<$$.getSymbol()<<" = "<<$1.getSymbol()<<" * "<<$3.getSymbol()<<endl;

								// asm code
								string result;
                                ss<<"MOV ax,"<<$3.getSymbol().c_str()<<endl;
                                ss<<"MOV bx,"<<$1.getSymbol().c_str()<<endl;
								ss<<"MUL bx"<<endl;
								ss<<"MOV "<<$$.getSymbol().c_str()<<", ax"<<endl;

								result = ss.str();
								$$.Code(result);
								
								
								t_count++;
					   
									}

	| expr SUBOP expr           {	
								str = getTemp(t_count);
								SymbolInfo obj1(string(str), "");				
								$$=obj1;
								TAC<<$$.getSymbol()<<" = "<<$1.getSymbol()<<" - "<<$3.getSymbol()<<endl;


								// asm code
								string result;
                                ss<<"MOV ax,"<<$1.getSymbol().c_str()<<endl;
                                ss<<"MOV bx,"<<$3.getSymbol().c_str()<<endl;
								ss<<"SUB ax, bx"<<endl;
								ss<<"MOV "<<$$.getSymbol().c_str()<<", ax"<<endl;

								result = ss.str();
								$$.Code(result);
								
								
								t_count++;	 

									}

	| expr DIVOP expr             {	
									str = getTemp(t_count);
								SymbolInfo obj1(string(str), "");					
								$$=obj1;
								TAC<<$$.getSymbol()<<" = "<<$1.getSymbol()<<" / "<<$3.getSymbol()<<endl;

								// asm code
								string result;
                                ss<<"MOV ax,"<<$3.getSymbol().c_str()<<endl;
                                ss<<"MOV bx,"<<$1.getSymbol().c_str()<<endl;
								ss<<"MUL bx"<<endl;
								ss<<"MOV "<<$$.getSymbol().c_str()<<", ax"<<endl;

								result = ss.str();
								$$.Code(result);
								
								
								t_count++;	 

									}
	| expr LAND expr              {	
									str = getTemp(t_count);
								SymbolInfo obj1(string(str), "");					
								$$=obj1;
								TAC<<$$.getSymbol()<<" = "<<$1.getSymbol()<<" && "<<$3.getSymbol()<<endl;


								// asm code
								string result;
                                ss<<"MOV ax,"<<$1.getSymbol().c_str()<<endl;
                                ss<<"MOV bx,"<<$3.getSymbol().c_str()<<endl;
								ss<<"AND ax, bx"<<endl;
								ss<<"MOV "<<$$.getSymbol().c_str()<<", ax"<<endl;

								result = ss.str();
								$$.Code(result);
								
								
								t_count++;	 

									}

	| expr LOR expr               {	
		                        str = getTemp(t_count);
								SymbolInfo obj1(string(str), "");				
								$$=obj1;
								TAC<<$$.getSymbol()<<" = "<<$1.getSymbol()<<" || "<<$3.getSymbol()<<endl;


								// asm code
								string result;
                                ss<<"MOV ax,"<<$1.getSymbol().c_str()<<endl;
                                ss<<"MOV bx,"<<$3.getSymbol().c_str()<<endl;
								ss<<"OR ax, bx"<<endl;
								ss<<"MOV "<<$$.getSymbol().c_str()<<", ax"<<endl;

								result = ss.str();
								$$.Code(result);
		
								
								t_count++;	 

									}

	| LNOT expr           	    {	
								str = getTemp(t_count);
								SymbolInfo obj1(string(str), "");					
								$$=obj1;
								cout<<$$.getSymbol()<<" = "<<"!"<<$1.getSymbol()<<endl;

								// asm code
								string result;
                                ss<<"MOV ax,"<<$1.getSymbol().c_str()<<endl;                               
								ss<<"NEG ax"<<endl;
								ss<<"MOV "<<$$.getSymbol().c_str()<<", ax"<<endl;

								result = ss.str();

								$$.Code(result);
								
								
								t_count++;	 

									}

    | LPARAN expr RPARAN          {	 
		                              $$=$2;
		                             // $$.code=$2.code;

									}

	| '{' expr '}'             {	
								//$$.code=$2.code;	
								  $$=$2;
								}

	|term                         {  }

	;
term: ID                          {    }
	;
expr_decl: term ASSOP expr SEMICOLON    {
									 t_count-=1;
								     str = getTemp(t_count);
								     SymbolInfo obj1(string(str), "");					
								     $$=obj1;
								     TAC<<$1.getSymbol()<<" = "<<$3.getSymbol()<<endl; 

									 string result;                                   
								     ss<<"ST "<<$1.getSymbol().c_str()<<","<<$3.getSymbol()<<endl<<endl;
								     result = ss.str();

								     $$.Code(result);
									 
								     t_count=1;								
									}
         
;


%%


int main(void)
{  
	extern FILE *yyin, *yyout;
	yyin=fopen("input.txt", "r");

    ASM.open("code.asm");

	TAC.open("code.ir");

	fout.open("Table.txt");

	lout.open("log.txt");

	yyparse();
    
	Table.print();
	return 0;
}