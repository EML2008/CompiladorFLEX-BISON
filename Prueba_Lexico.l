%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <string.h>
#include "y.tab.h"
#include "funciones/funciones.h"
FILE  *yyin;

%}
%option noyywrap  
%option yylineno

DIGITO		[0-9]
LETRA		[a-zA-Z]
CTE         {DIGITO}+
CARACTER    [a-z,A-Z,0-9,=,>,<,!,:,+,-,*,/]
CTE_S       \"({CARACTER}|" ")+\"
ID			{LETRA}({LETRA}|{DIGITO})*

%%
"="		    { return asigna; }
"("			{ return para; }
")"			{ return parc; }
"["			{ return ca; }
"]"			{ return cc; }
";"			{ return pyc; }
","			{ return coma; }
"WRITE"     { return write; }
"READ"      { return read; }
"CONTAR"    { return contar; }

{ID} { 
    yylval.str_val = strdup(yytext); 
    printf("TOKEN ID ---> %s (%s)\n", yytext, yylval.str_val);
    return id; 
}

{CTE} {
    yylval.str_val = strdup(yytext);
    printf("TOKEN CTE ---> %s (%s)\n", yytext, yylval.str_val);
    return cte;
}

{CTE_S}	{ 
    yylval.str_val = strdup(yytext); 
    printf("TOKEN CTE_S ---> %s (%s)\n", yytext, yylval.str_val);
    return cte_s;
}

" "
"\n"  		
"\t"
%%