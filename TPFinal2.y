%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <string.h>
#include "y.tab.h"
#include "funciones/funciones.h"

int yystopparser=0;
FILE  *yyin;

%}

%union {
	int intval;
	double val;
	char *str_val;
}

%token <str_val>id
%token <str_val>cte
%token <str_val>cte_s
%token asigna
%token para
%token parc
%token ca
%token cc
%token pyc
%token coma
%token write
%token read
%token contar

%start S

%%

S : 
	PROG { 
		generarIntermedia();
		generarAssembler();
		printf("COMPILACION OK!\n"); 
	};
PROG:
	SENT { printf("PROG -> SENT\n"); } | 
	PROG SENT { printf("PROG -> PROG SENT\n"); };
SENT:
	READ  { printf("SENT -> READ\n"); } |
	WRITE  { printf("SENT -> WRITE\n"); } |
	ASIG { printf("SENT -> ASIG\n"); };
READ: 
	read id { 
		insertarPolaca("READ", T_NONE);
		insertarPolaca($2, T_NONE);
		printf("READ -> read id\n"); 
	};
ASIG:
	id asigna CONTAR {
			insertarPolaca("@CANTREP", T_INTEGER);
			insertarPolaca($1, T_INTEGER);
			insertarPolaca("=", T_NONE);

			printf("ASIG -> id asigna CONTAR\n"); 
		};
CONTAR:

	contar para cte { 
		insertarTablaSimbolos("@PIVOT", T_INTEGER, "", "");
		insertarPolaca($3, T_INTEGER);
		insertarPolaca("@PIVOT", T_INTEGER);
		insertarPolaca("=", T_NONE);
	} pyc ca LISTA cc parc { printf("CONTAR -> contar para cte pyc ca LISTA cc parc\n"); };
LISTA:
	cte	{ 
			insertarTablaSimbolos("@CANTREP", T_INTEGER, "0", "");

			insertarPolaca("0", T_INTEGER);
			insertarPolaca("@CANTREP", T_INTEGER);
			insertarPolaca("=", T_NONE);

			insertarPolaca($1, T_INTEGER);
			insertarPolaca("@PIVOT", T_INTEGER);
			insertarPolaca("CMP", T_NONE);
			insertarPolaca("JNE", T_NONE);
			apilarPosicion(adelantarPosicionEnPolaca());
			insertarPolaca("@CANTREP", T_INTEGER);
			insertarPolaca("1", T_INTEGER);
			insertarPolaca("+", T_NONE);
			insertarPolaca("@CANTREP", T_INTEGER);
			insertarPolaca("=", T_NONE);
			char temp[10];
			insertarPolacaEnPosicion(itoa(getPosActualPolaca(), temp, 10), T_INTEGER, desapilarPosicion());
			
			printf("LISTA -> cte\n"); 
		};
LISTA:
	LISTA coma cte	{ 
						insertarPolaca($3, T_INTEGER);
						insertarPolaca("@PIVOT", T_INTEGER);
						insertarPolaca("CMP", T_NONE);
						insertarPolaca("JNE", T_NONE);
						apilarPosicion(adelantarPosicionEnPolaca());
						insertarPolaca("@CANTREP", T_INTEGER);
						insertarPolaca("1", T_INTEGER);
						insertarPolaca("+", T_NONE);
						insertarPolaca("@CANTREP", T_INTEGER);
						insertarPolaca("=", T_NONE);
						char temp[10];
						insertarPolacaEnPosicion(itoa(getPosActualPolaca(), temp, 10), T_INTEGER, desapilarPosicion());

						printf("LISTA -> LISTA coma cte\n");
					};
WRITE:
	write cte_s { 
		insertarPolaca("WRITE", T_NONE);
		insertarPolaca($2, T_STRING);
		printf("WRITE -> write cte_s\n"); 
	};
WRITE:
	write id {
		insertarPolaca("WRITE", T_NONE);
		insertarPolaca($2, T_NONE);
		printf("WRITE -> write id\n"); 
	};

%%
int main(int argc, char *argv[]) {
	if ((yyin = fopen(argv[1], "rt")) == NULL) {
		printf("\nNo se puede abrir el archivo: %s\n", argv[1]);
	}
	else {
		yyparse();
	}
  	fclose(yyin);
  	return 0;
}

int yyerror(void) {
	printf("Syntax Error\n");
	system ("Pause");
	exit (1);
}