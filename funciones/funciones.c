#include "funciones.h"

t_polaca polaca[100];
t_simbolo tablaSimbolos[100];

int pilaPosiciones[100];
int posActualPilaPosiciones = 0;

char * pilaOperandos[100];
int posActualPilaOperandos = 0;

int posActualPolaca = 0;
int posActualTablaSimbolos = 0;

int numeroAuxiliar = 0;

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
    fp = fopen("instrucciones.asm", "w");
    if (fp == NULL) {
        exit(1);
    }
    generarInstrucciones(fp);
    fclose(fp);   
}

void generarInstrucciones(FILE * fp) {
    char * op1;
    char * op2;
    printf("Llegue a generarInstrucciones\n");
    int i;
    for (i = 0; i < getPosActualPolaca(); i++) {
        char * dato = polaca[i].dato;
        printf("El tipo de dato es %s\n", dato);
        if (strcmp(dato, MAS) == 0) {
            printf("Entre por +\n");
            op1 = desapilarOperador();
            op2 = desapilarOperador();
            fprintf(fp, "fld %s\n", op1);
            fprintf(fp, "fld %s\n", op2);
            fprintf(fp, "fadd\n");
            char aux[20];
            pedirAux(aux);
            fprintf(fp, "fstp %s\n", aux);
            apilarOperador(aux);
        } else if (strcmp(dato, IGUAL) == 0) {
            op1 = desapilarOperador();
            op2 = desapilarOperador();
            fprintf(fp, "fld %s\n", op2);
            fprintf(fp, "fstp %s\n", op1);
        } else if (strcmp(dato, CMP) == 0) {
            op1 = desapilarOperador();
            op2 = desapilarOperador();
            fprintf(fp, "fld %s\n", op1);
            fprintf(fp, "fld %s\n", op2);   
            fprintf(fp, "fcom\n");
            fprintf(fp, "fstsw ax\n");
            fprintf(fp, "sahf\n");
        } else if (strcmp(dato, SALTO_POR_DISTINTO) == 0) {
            
        } else if (strcmp(dato, LEER) == 0) {
        } else if (strcmp(dato, ESCRIBIR) == 0) {
        } else {
            printf("Apilo operador!\n");
            apilarOperador(dato);
        }
    }
}

void pedirAux(char * aux) {
    sprintf(aux, "@aux%d", numeroAuxiliar++);
    insertarTablaSimbolos(aux, T_INTEGER, "", "");
}

