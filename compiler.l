%option noyywrap
%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "SymbolTable.h"
#define YYSTYPE SymbolInfo
#include "compiler.tab.h"

void yyerror(const char* msg);

%}
DIGITS  [0-9]+
NUM	{DIGITS}
ID	[a-zA-Z_]
%%

[ \t]+ 	 { }

"int"      {  return INT;}
"main"     {  return MAIN;}
{NUM} {     
			SymbolInfo ob(string(yytext), "NUM");
			//strcpy(yylval.cvar,yytext);
			yylval = (YYSTYPE) ob;
			return NUM;
		 }
"="       {   return  ASSOP;}
"&&"      {   return  LAND;}
"||"      {   return  LOR ;}
"!"       {   return  LNOT;}
"*"       {   return  MULOP;}
"/"       {   return DIVOP;}
"+"       {   return  ADDOP;}
"-"       {   return  SUBOP;}

"(" 	 {
			return LPARAN;
		 }
")" 	 {
			return RPARAN;
		 }
"{" 	 {
			return *yytext;
		 }
"}" 	 {
			return *yytext;
		 }		 
";"      {return SEMICOLON;}
{ID} 	 {  
			SymbolInfo ob(string(yytext), "ID");
			//strcpy(yylval.cvar,yytext); // if use union
			yylval = (YYSTYPE) ob;
			return ID;
		 }
\n 	     {
			return NEWLINE;
		 }	 

exit     {
			return 0;
		 }

.        {
			char msg[25];
			sprintf(msg," <%s>","invalid character",yytext);
			yyerror(msg);
		 }
%%