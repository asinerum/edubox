@echo Make the file %1
@echo off
if not exist %1.asm goto end
tasm %1,%1;
if errorlevel 1 goto end
tlink %1,%1,nul;
if not exist %1.exe goto end
if not 'A%2'=='A' goto run
exe2bin %1.exe %1.com;
if not exist %1.com goto end
erase %1.exe
erase %1.obj
:run
@echo Press Ctrl-Break to stop or
pause
%1
:end
