@echo off
set title=ÍÆ¼öµ½¶¬¹ÏÍø
set html=%USERPROFILE%\%title%.htm
set url=%USERPROFILE%\Favorites\%title%.url

del "%html%"
del "%url%"
copy "%CD%\dongua.htm" "%html%"
REM copy "%CD%\dongua.url" "%url%"

reg add "HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\MenuExt\%title%(&D)" /v "" /d "%html%" /f
reg add "HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\MenuExt\%title%(&D)" /v "Contexts" /t REG_DWORD /d 243 /f

if errorlevel 0 goto end
set reg=%CD%\dongua.reg

echo Windows Registry Editor Version 5.00 > "%reg%"
echo [HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\MenuExt\%title%(^&D)] >> "%reg%"
echo @="%html:\=\\%" >> "%reg%"
echo "Contexts"=dword:000000f3 >> "%reg%"
regedit "%reg%"
del "%reg%"

:end

FOR /F "tokens=2 delims=REG_SZ" %%i IN ('REG QUERY "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\firefox.exe" /ve') DO set firefox=%%i
set firefox=%firefox:  =%
set firefox=%firefox:	=%
"%firefox%" -install-global-extension "%CD%\dongua.xpi" 


del "%CD%\dongua.htm"
del "%CD%\dongua.url"
del "%CD%\dongua.xpi"
del "%CD%\dongua.cmd"