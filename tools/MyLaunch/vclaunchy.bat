@echo off 
SET PATH=C:\;C:\windows\system32;C:\windows;d:\Program Files\Microsoft Visual Studio 8\Common7\IDE\
CALL "d:\Program Files\Microsoft Visual Studio 8\VC\vcvarsall.bat" x86
SET PATH=%PATH%
SET INCLUDE=%INCLUDE%
SET LIB=%LIB% 