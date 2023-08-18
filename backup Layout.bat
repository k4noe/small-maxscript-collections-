@echo off

:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------    

SET ver=2022
title Layout %ver% Backuper
SET local="%LOCALAPPDATA%\SketchUp\SketchUp %ver%\LayOut"
SET roaming="%APPDATA%\SketchUp\SketchUp %ver%\LayOut"
SET outLocal="%~dp0\Layout\local"
SET outRoam="%~dp0\Layout\Roaming"

echo Backup in Process..
echo.
copy /y "%roaming%\*.json" "%outRoam%"
copy /y "%roaming%\*.xml" "%outRoam%"
copy /y "%roaming%\*.plo" "%outRoam%"
copy /y "%local%\*.json" "%outLocal%"
echo Layout backup done at : %DATE% in %TIME% >>activity.log
echo Backup complete
echo --------------- >>activity.log
echo.
pause

