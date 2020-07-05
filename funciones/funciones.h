#include <stdio.h>
#include <stdlib.h>
#include <conio.h>
#include <string.h>

#define T_NONE 0
#define T_INTEGER 1
#define T_FLOAT 2
#define T_STRING 3

#define MAS "+"
#define IGUAL "="
#define CMP "CMP"
#define SALTO_POR_DISTINTO "JNE"
#define LEER "READ"
#define ESCRIBIR "WRITE"

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

int verTopeDePilaPosiciones();
void apilarPosicion(int);
int desapilarPosicion();

void apilarOperador(char * );
char * desapilarOperador();

void insertarPolaca(char *, int);
void insertarPolacaEnPosicion(char *, int , int); 
int adelantarPosicionEnPolaca();
void mostrarPolaca();

void insertarTablaSimbolos(char *, int, char *, char *);
void mostrarTablaSimbolos();

void generarAssembler();
void generarInstrucciones(FILE *);

void pedirAux(char *);

void pedirEtiqueta();
