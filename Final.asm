INCLUDE macros2.asm
INCLUDE number.asm
.MODEL LARGE
.386
.STACK 200h
	.DATA
	TRUE equ 1
	FALSE equ 0
	MAXTEXTSIZE equ 200
"Ingrese un valor: "            	db	"Ingrese un valor: ",'$', 20 dup (?)
pivot                           	dd	?
resul                           	dd	?
2                               	dd	2
@PIVOT                          	dd	?
1                               	dd	1
@CANTREP                        	dd	0
2                               	dd	2
3                               	dd	3
4                               	dd	4
"La cantidad es: "              	db	"La cantidad es: ",'$', 18 dup (?)
resul                           	dd	?
@aux0                           	dd	?
@aux1                           	dd	?
@aux2                           	dd	?
@aux3                           	dd	?

.CODE
DisplayInteger "Ingrese un valor: "
newLine 1
GetInteger pivot
fld 2
fstp @PIVOT
fld 0
fstp @CANTREP
fld @PIVOT
fld 1
fcom
fstsw ax
sahf
JNE etiqueta1
fld 1
fld @CANTREP
fadd
fstp @aux0
fld @aux0
fstp @CANTREP
etiqueta1:
fld @PIVOT
fld 2
fcom
fstsw ax
sahf
JNE etiqueta2
fld 1
fld @CANTREP
fadd
fstp @aux1
fld @aux1
fstp @CANTREP
etiqueta2:
fld @PIVOT
fld 3
fcom
fstsw ax
sahf
JNE etiqueta3
fld 1
fld @CANTREP
fadd
fstp @aux2
fld @aux2
fstp @CANTREP
etiqueta3:
fld @PIVOT
fld 4
fcom
fstsw ax
sahf
JNE etiqueta4
fld 1
fld @CANTREP
fadd
fstp @aux3
fld @aux3
fstp @CANTREP
etiqueta4:
fld @CANTREP
fstp resul
DisplayInteger "La cantidad es: "
newLine 1
DisplayInteger resul
newLine 1
	ffree
	mov ax, 4c00h
	int 21h
	End START
