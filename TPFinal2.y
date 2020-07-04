%{
#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <string.h>
#include "y.tab.h"

#define T_NONE 0
#define T_INTEGER 1
#define T_FLOAT 2
#define T_STRING 3

int yystopparser=0;
FILE  *yyin;

typedef struct {
	int tipoDato;
	char dato[100];
}t_polaca;

typedef struct {
	char nombre[100];
	int tipo;
	char dato[100];
	char longitud[10];
}t_simbolo;

t_polaca polaca[100];
t_simbolo tablaSimbolos[100];

int pilaPosiciones[100];
int posActualPila = 0;

int verTopeDePilaPosiciones();
void apilarPosicion(int);
int desapilarPosicion();

int adelantarPosicionEnPolaca();

int posActualPolaca = 0;
int posActualTablaSimbolos = 0;

void insertarPolaca(char *, int);
void insertarPolacaEnPosicion(char *, int , int); 
void mostrarPolaca();

void insertarTablaSimbolos(char *, int, char *, char *);
void mostrarTablaSimbolos();

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
	PROG { mostrarPolaca(); mostrarTablaSimbolos(); printf("COMPILACION OK!\n"); } ;
PROG:
	SENT { printf("PROG -> SENT\n"); } | 
	PROG SENT { printf("PROG -> PROG SENT\n"); };
SENT:
	READ  { printf("SENT -> READ\n"); } |
	WRITE  { printf("SENT -> WRITE\n"); } |
	ASIG { printf("SENT -> ASIG\n"); };
READ: 
	read id { printf("READ -> read id\n"); };
ASIG:
	id asigna CONTAR { 
			insertarPolaca($1, T_INTEGER);
			insertarPolaca("@CANTREP", T_INTEGER);
			insertarPolaca("=", T_NONE);
			
			printf("ASIG -> id asigna CONTAR\n"); 
		};
CONTAR:
	contar para cte { 
		insertarTablaSimbolos("@PIVOT", T_INTEGER, "", "");
		insertarPolaca("@PIVOT", T_INTEGER);
		insertarPolaca($3, T_INTEGER);
		insertarPolaca("=", T_NONE);
	} pyc ca LISTA cc parc { printf("CONTAR -> contar para cte pyc ca LISTA cc parc\n"); };
LISTA:
	cte	{ 
			insertarTablaSimbolos("@CANTREP", T_INTEGER, "0", "");

			insertarPolaca("@CANTREP", T_INTEGER);
			insertarPolaca("0", T_INTEGER);
			insertarPolaca("=", T_NONE);

			insertarPolaca($1, T_INTEGER);
			insertarPolaca("@PIVOT", T_INTEGER);
			insertarPolaca("CMP", T_NONE);
			insertarPolaca("JNE", T_NONE);
			apilarPosicion(adelantarPosicionEnPolaca());
			insertarPolaca("@CANTREP", T_INTEGER);
			insertarPolaca("@CANTREP", T_INTEGER);
			insertarPolaca("1", T_INTEGER);
			insertarPolaca("+", T_NONE);
			insertarPolaca("=", T_NONE);
			char temp[10];
			insertarPolacaEnPosicion(itoa(posActualPolaca, temp, 10), T_INTEGER, desapilarPosicion());
			
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
						insertarPolaca("@CANTREP", T_INTEGER);
						insertarPolaca("1", T_INTEGER);
						insertarPolaca("+", T_NONE);
						insertarPolaca("=", T_NONE);
						char temp[10];
						insertarPolacaEnPosicion(itoa(posActualPolaca, temp, 10), T_INTEGER, desapilarPosicion());

						printf("LISTA -> LISTA coma cte\n");
					};
WRITE:
	write cte_s { printf("WRITE -> write cte_s\n"); };
WRITE:
	write id { printf("WRITE -> write id\n"); };

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

void insertarPolaca(char * dato, int tipo) {
	t_polaca tmp;
	strcpy(tmp.dato, dato);
	tmp.tipoDato = tipo;
	polaca[posActualPolaca++] = tmp;
}

void insertarPolacaEnPosicion(char * dato, int tipo, int pos) {
	t_polaca tmp;
	strcpy(tmp.dato, dato);
	tmp.tipoDato = tipo;
	polaca[pos] = tmp;
}

void mostrarPolaca() {
	int i;	
	for(i = 0; i < posActualPolaca ; i++) {
		printf("POS. %d, DATO %s, TIPO %d\n", i, polaca[i].dato, polaca[i].tipoDato);
	}
}

void insertarTablaSimbolos(char * nombre, int tipo, char * dato, char * longitud) {
	t_simbolo tmp;
	strcpy(tmp.nombre, nombre);
	tmp.tipo = tipo;
	strcpy(tmp.dato, dato);
	strcpy(tmp.longitud, longitud);
	tablaSimbolos[posActualTablaSimbolos++] = tmp;
}

void mostrarTablaSimbolos() {
	int i;
	printf("Cantidad de simbolos en tabla: %d\n", posActualTablaSimbolos);
	for(i = 0; i < posActualTablaSimbolos ; i++) {
		printf("POS. %d, NOMBRE %s, TIPO %d, DATO %s, LONGITUD %s\n", i, tablaSimbolos[i].nombre, tablaSimbolos[i].tipo, tablaSimbolos[i].dato, tablaSimbolos[i].longitud);
	}
}

int verTopeDePilaPosiciones() {
	return posActualPila;
}

void apilarPosicion(int pos) {
	pilaPosiciones[posActualPila++] = pos;
} 

int desapilarPosicion() {
	return pilaPosiciones[--posActualPila];
}

int adelantarPosicionEnPolaca() {
	return posActualPolaca++;
}

