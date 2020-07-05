tasm assembler/numbers.asm
tasm assembler/macros.asm
tasm assembler/Final.asm
tlink /3 assembler/Final.obj assembler/numbers.obj assembler/macros.obj /v /s /m
pause
Final.exe
pause
del Final.obj
del numbers.obj
