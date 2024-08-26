
@echo off
IF EXIST ./pathToSD.txt  (
    set /p SDpath=<./pathToSD.txt
) ELSE (
    set /p SDpath=Path to EdgeTX Sim SD card Folder:
)
::Does string have a trailing slash? if so remove it 
IF %SDpath:~-1%==\ SET SDpath=%SDpath:~0,-1%
echo %SDpath%> ./pathToSD.txt
echo path: %SDpath%
xcopy /s .\src\LOGS\* %SDpath%\LOGS /L /U /Y
xcopy /s .\src\SCRIPTS\* %SDpath%\SCRIPTS /L /U /Y
xcopy /s .\src\WIDGETS\* %SDpath%\WIDGETS /L /U /Y