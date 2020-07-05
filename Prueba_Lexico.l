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
    insertarTablaSimbolos(yylval.str_val, T_ID, "?", 0);
    return id; 
}

{CTE} {
    yylval.str_val = strdup(yytext);
    printf("TOKEN CTE ---> %s (%s)\n", yytext, yylval.str_val);
    insertarTablaSimbolos(indicarNombreConstante(yylval.str_val), T_CTE_INTEGER, yylval.str_val, 0);
    return cte;
}

{CTE_S}	{ 
    int length = strlen(yytext) - 2;
	char * tmp = (char *) malloc(length + 1);
	strncpy(tmp, yytext + 1, length);
	tmp[length] = '\0';

	char carecteresInvalidos[] = { ';', ' ', ':', '=', ',', '(', ')', '[', ']' };
	int i = 0;
	char * caracter;
	for(i = 0; i < strlen(carecteresInvalidos); i++) {
		caracter = strchr(tmp, carecteresInvalidos[i]);
		while (caracter != NULL) {
			*caracter = '_';
			caracter = strchr(tmp, carecteresInvalidos[i]);
		}
	}
    
    yylval.str_val = strdup(tmp); 
    printf("TOKEN CTE_S ---> %s (%s)\n", yytext, yylval.str_val);
    insertarTablaSimbolos(indicarNombreConstante(yylval.str_val), T_CTE_STRING, strdup(yytext), strlen(yytext));
    return cte_s;
}

" "
"\n"  		
"\t"
%%