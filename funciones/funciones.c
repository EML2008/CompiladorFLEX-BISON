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

char etiqueta[20];
int numeroEtiqueta = 1;

int esPosicion = 0;
int posicion = -1;

int esEscritura = 0;
int esLectura = 0;
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
    int i;
    for (i = 0; i < getPosActualPolaca(); i++) {
        if (i == posicion) {
            fprintf(fp, "%s:\n", etiqueta);
        }

        char * dato = polaca[i].dato;
        if (strcmp(dato, MAS) == 0) {
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
            pedirEtiqueta();
            fprintf(fp, "JNE %s\n", etiqueta);
            esPosicion = 1;
        } else if (strcmp(dato, LEER) == 0) {
            esLectura = 1;
        } else if (strcmp(dato, ESCRIBIR) == 0) {
            esEscritura = 1;
        } else {
            if(esPosicion) {
                esPosicion = 0;
                posicion = atoi(dato);
            } else if(esEscritura) {
                esEscritura = 0;
                fprintf(fp, "DisplayInteger %s", dato);
                fprintf(fp, "newLine 1\n");
            } else if(esLectura) {
                esLectura = 0;
                fprintf(fp, "GetInteger %s\n", dato);
            }
            apilarOperador(dato);
        }
    }
}

void pedirAux(char * aux) {
    sprintf(aux, "@aux%d", numeroAuxiliar++);
    insertarTablaSimbolos(aux, T_INTEGER, "", "");
}

void pedirEtiqueta() {
    sprintf(etiqueta, "etiqueta%d", numeroEtiqueta++);
}

