c:\GnuWin32\bin\flex EA3.l
pause
c:\GnuWin32\bin\bison -dyv EA3.y
pause
c:\MinGW\bin\gcc.exe lex.yy.c y.tab.c funciones/funciones.h funciones/funciones.c -o EA3.exe
pause
pause
EA3.exe testing.txt
del lex.yy.c
del y.tab.c
del y.output
del y.tab.h

pause
