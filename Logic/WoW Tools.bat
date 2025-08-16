@echo off
REM Load config.txt from the same folder as the script
for /f "usebackq tokens=1,* delims==" %%A in ("%~dp0config.txt") do (
    set "%%A=%%B"
)
if /i "%CONFIGURED%"=="Y" (
    rem Do nothing
) else (
    echo.
    echo !! You have attempted to run WoW Tool while unconfigured! Please follow this setup before trying to open it again !!
    setup.bat
)


::: Yb        dP  dP"Yb  Yb        dP     888888  dP"Yb   dP"Yb  88     .dP"Y8 
:::  Yb  db  dP  dP   Yb  Yb  db  dP        88   dP   Yb dP   Yb 88     `Ybo." 
:::   YbdPYbdP   Yb   dP   YbdPYbdP         88   Yb   dP Yb   dP 88  .o o.`Y8b 
:::    YP  YP     YbodP     YP  YP          88    YbodP   YbodP  88ood8 8bodP' 

COLOR A
for /f "delims=: tokens=*" %%A in ('findstr /b ::: "%~f0"') do @echo(%%A  
echo. 
echo Version %VERSION% - wotlk server management utility
echo Ensure the game server is not already running before running the start command!! 
color F
echo.
echo Please select an option from the list below!   
echo.
echo. (1) Start game server
echo. (2) Stop Server
echo. (3) Make user account (UNAVALIBLE)
echo. (4) Start SQL Database   
echo. (5) Start Apache Server
echo. (6) Start SQL and Apache
echo. (7) Open Warcraft Client
echo. (8) Release Notes
echo. (9) Exit
echo.    
choice /c:123456789 /M "Select option :" /N
set _choice=%errorlevel%
if %_choice% == 1 goto opone
if %_choice% == 2 goto optwo
if %_choice% == 3 goto opthree
if %_choice% == 4 goto opfour
if %_choice% == 5 goto opfive
if %_choice% == 6 goto opsix
if %_choice% == 7 goto opseven
if %_choice% == 8 goto opeight
if %_choice% == 9 goto opnine

:opone
echo. 
cls 
for /f "delims=: tokens=*" %%A in ('findstr /b ::: "%~f0"') do @echo(%%A 
echo.
echo. (1) Starting game server
echo. 
echo. Starting game server... Please wait for a notification
echo.
cd %SERVERDIR%
cd "_Server"
echo. [INFO] Starting SQL Server
start "" mysql\bin\mysqld --defaults-file=mysql\bin\my.cnf  
echo. [LOG] SQL Server Started Successfully!
cd %SERVERDIR%
cd Core
echo.
echo. [INFO] Starting Authentication Server
start authserver.exe
echo. [LOG] Authentication Server Started Successfully!
echo. 
echo. [INFO] Starting Game Server
start worldserver.exe
echo. [LOG] Game Server Started Successfully
timeout /t 20 /nobreak
cd %~dp0
:Notification1
cscript //nologo "%~dp0Notification1.vbs" "%CLIENTDIR%"
cls
"WoW Tools.bat"

:optwo
echo. 
echo. (2) Stopping Server
echo. 
echo. [INFO] Closing Authentication Server
taskkill /F /IM authserver.exe /T  
echo. [LOG] Authentication Server Successfully Closed!
echo.
echo. [INFO] Closing Game Server
taskkill /F /IM worldserver.exe /T
echo. [LOG] Game Server Successfully Closed!
echo.
echo. [INFO] Closing SQL Server   
taskkill /F /IM mysqld.exe /T  
echo. [LOG] SQL Server Successfully Closed! 
echo. 
echo. Server has been shutdown!
cd "%~dp0"
timeout /t 5 /nobreak
cls
"WoW Tools.bat"

:opthree
cls
"WoW Tools.bat"
echo. 
echo. (3) Make user account
echo
cd %SERVERDIR%
cd "_Server"
 
set DB_USER=root
set DB_PASS=ascent
set DB_NAME=auth

REM Prompt for new account credentials
set /p USERNAME=Enter new username: 
set /p PASSWORD=Enter new password: 

mysql -u root -p ascent auth -e "INSERT INTO account (username, sha_pass_hash, gmlevel, expansion) VALUES ('newuser', UPPER(MD5(CONCAT(LOWER('newuser'),':','newpass'))), 0, 2);"

:opfour
echo.
echo. (4) Starting SQL Database
cd %SERVERDIR%
cd "_Server"
start MySQL.bat
echo.
echo. [LOG] SQL Database has started successfully
cd /d "%~dp0"
cls
"WoW Tools.bat"

:opfive
echo.
echo. (5) Starting Apache Server
cd %SERVERDIR%"
cd "_Server"
start Apache.bat
echo.
echo. [LOG] Apache Server has started successfully. View the web interface on 127.0.0.1
cd /d "%~dp0"
cls
"WoW Tools.bat"

:opsix
echo.
echo. (6) Starting SQL Database and Apache Server
cd /d "%WOW%"
cd "_Server"
start Apache.bat
start MySQL.bat
echo.
echo. Successfully started Apache Server and SQL Database!
cd /d "%~dp0"
cls
"WoW Tools.bat"

:opseven
echo. 
echo. (7) Starting the wowlk client
cd %CLIENTDIR%
%CLIENTMOUNTPATH%
start Wow.exe
echo.
echo. Started wowlk client!
cd /d "%~dp0"
cls
timeout /t 3 /nobreak>nul
"WoW Tools.bat"

:opeight
cls
cd "%~dp0\.."
type "Release Notes (4.Z.RC1).txt"
pause
cd %~dp0
cls
"WoW Tools.bat"

echo.

:opnine
