@echo off
setlocal ENABLEDELAYEDEXPANSION

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
title Layout %ver% setting restore
SET "local=%LOCALAPPDATA%\SketchUp\SketchUp %ver%\LayOut"
SET "roaming=%APPDATA%\SketchUp\SketchUp %ver%\LayOut"

SET "outLocal=%~dp0Layout\local"
SET "outRoam=%~dp0Layout\Roaming"

echo Restore starting...

copy /y "!outRoam!\*.json" "!roaming!"
copy /y "!outRoam!\*.xml" "!roaming!"
copy /y "!outRoam!\*.plo" "!roaming!"
copy /y "!outLocal!\*.json" "!local!"
echo Layout restore done at : %DATE% in %TIME% >>activity.log
echo --------------- >>activity.log
echo Restore DONE
pause

