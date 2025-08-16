@echo off
setlocal enabledelayedexpansion

::: Yb        dP  dP"Yb  Yb        dP     888888  dP"Yb   dP"Yb  88     .dP"Y8 
:::  Yb  db  dP  dP   Yb  Yb  db  dP        88   dP   Yb dP   Yb 88     `Ybo." 
:::   YbdPYbdP   Yb   dP   YbdPYbdP         88   Yb   dP Yb   dP 88  .o o.`Y8b 
:::    YP  YP     YbodP     YP  YP          88    YbodP   YbodP  88ood8 8bodP' 

rem --- CONFIG FILE ---
set "configFile=%~dp0config.txt"
set "tempFile=%~dp0config.tmp"

for /f "delims=: tokens=*" %%A in ('findstr /b ::: "%~f0"') do @echo(%%A  
echo. 
echo. Version 4.Z.RC1 - WoW Tools Setup Application
echo.
echo. To setup WoW Tools you will need to specify a few directories to ensure it can interact with your server!
echo. If you are unsure please read the release notes to be guided on how to use this setup!
echo. 
echo. What folder contains your server? (E.G. C:\WoW Server)

rem --- PROMPT FOR NEW VALUES ---
set /p newServerDir=Enter Folder : 
echo. 
echo. What is the drive letter of the drive that has your game client in? (E.G. D) 
set /p newDRIVE=Enter Letter : 
echo. 
echo. What folder contains your game? (E.G. D:\WoW Wrath of the Lich King)
set /p newClientDir=Enter Folder : 

rem --- PROCESS FILE ---
> "%tempFile%" (
    for /f "usebackq delims=" %%A in ("%configFile%") do (
        set "line=%%A"
        set "updated=0"

        rem --- Update SERVERDIR ---
        if defined newServerDir if "!line:~0,10!"=="SERVERDIR=" (
            echo SERVERDIR=!newServerDir!
            set "updated=1"
        )

   rem --- Update 22 ---
        if defined newDRIVE if "!line:~0,5!"=="DRIVE=" (
            echo DRIVE=!newDRIVE!
            set "updated=1"
        )

        

        rem --- Update CLIENTDIR ---
        if !updated! equ 0 if defined newClientDir if "!line:~0,10!"=="CLIENTDIR=" (
            echo CLIENTDIR=!newClientDir!
            set "updated=1"
        )

        rem --- Update CONFIGURED ---
        if !updated! equ 0 if "!line:~0,10!"=="CONFIGURED" (
            echo CONFIGURED=Y
            set "updated=1"
        )

        rem --- Leave unchanged if not updated ---
        if !updated! equ 0 echo !line!
    )
)

rem --- REPLACE ORIGINAL FILE ---
move /y "%tempFile%" "%configFile%"
Notification2
exit
