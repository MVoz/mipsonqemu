REM Start qemu on windows.
@ECHO OFF

START qemu.exe -L . -m 128 -hda disk.img  -user-net
CLS
EXIT
