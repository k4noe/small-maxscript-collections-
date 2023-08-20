@echo off
setlocal ENABLEDELAYEDEXPANSION

REM This script need WINRAR to work , please install it first
REM This script just backup all sketchup extension and rar them in neat place
REM just execute them 


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
rem change 2022 to your skp version
SET ver=2022 
title Sketchup %ver% Backuper
SET "local=%LOCALAPPDATA%\SketchUp\SketchUp %ver%\SketchUp"
SET "roaming=%APPDATA%\SketchUp\SketchUp %ver%\SketchUp"
SET "outLocal=%~dp0\SketchUp\local"
SET "outRoam=%~dp0\SketchUp\Roaming"
SET "outName=%~dp0%SketchUp\plugins"
SET "outZIP=%outName%%ver%.rar"
SET "backFile=%~dp0%SketchUp\plugins!ver!.rar.bak"

SET "zip=%ProgramFiles%\WinRAR\Rar.exe"

echo Backup starting...
copy /y "%roaming%\*.json" "%outRoam%"
copy /y "%local%\*.json" "%outLocal%"
echo Backing up registry
regedit /e "%~dp0\setting_%ver%.reg" "HKEY_CURRENT_USER\SOFTWARE\SketchUp\SketchUp %ver%"
echo.
echo Creating Plugins Backup
if exist "%outZIP%" ren "%outZIP%" plugins!ver!.rar.bak
"%zip%" a -apPlugins -ep1 -ac -ed -r  -m5 -ma5 -s -md32 -t "%outZIP%" "%roaming%\Plugins\"
if exist %backFile% del /q %backFile%
echo Sketchup backup done at : %DATE% in %TIME% >>activity.log
echo.
echo Backup DONE
echo --------------- >>activity.log
pause

