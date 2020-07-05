tasm assembler/numbers.asm
tasm assembler/Final.asm
tlink /3 assembler/Final.obj assembler/numbers.obj /v /s /m
pause
Final.exe
pause
del Final.obj
del numbers.obj
