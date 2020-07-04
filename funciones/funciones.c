#include "funciones.h"

t_polaca polaca[100];
t_simbolo tablaSimbolos[100];

int pilaPosiciones[100];
int posActualPilaPosiciones = 0;

char * pilaOperandos[100];
int posActualPilaOperandos = 0;

int posActualPolaca = 0;
int posActualTablaSimbolos = 0;


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

int getPosActualPolaca() {
    return posActualPolaca;
}

void mostrarPolaca() {
	int i;	
	for(i = 0; i < posActualPolaca ; i++) {
		printf("POS. %d, DATO %s, TIPO %d\n", i, polaca[i].dato, polaca[i].tipoDato);
	}
}

int adelantarPosicionEnPolaca() {
	return posActualPolaca++;
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
	return posActualPilaPosiciones;
}

void apilarPosicion(int pos) {
	pilaPosiciones[posActualPilaPosiciones++] = pos;
} 

int desapilarPosicion() {
	return pilaPosiciones[--posActualPilaPosiciones];
}

void apilarOperador(char * op) {
	pilaOperandos[posActualPilaOperandos++] = op;
} 

char * desapilarOperador() {
	return pilaOperandos[--posActualPilaOperandos];
}

void generarAssembler() {
    FILE * fp;
    fp = fopen("Instrucciones.asm", "wt");
    if (fp == NULL) {
        exit(1);
    }
    generarInstrucciones(fp);
    fclose(fp);   
}

void generarInstrucciones(FILE * fp) {
    int i;
    for (i = 0; i < getPosActualPolaca(); i++) {
        char * dato = polaca[i].dato;
        
    }
}