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
title Sketchup %ver% restore
SET "local=%LOCALAPPDATA%\SketchUp\SketchUp %ver%\SketchUp"
SET "roaming=%APPDATA%\SketchUp\SketchUp %ver%\SketchUp\"
SET "outLocal=%~dp0\SketchUp\local"
SET "outRoam=%~dp0\SketchUp\Roaming"
SET "outName=%~dp0%SketchUp\plugins"
SET "outZIP=%outName%%ver%.rar"
SET "zip=%ProgramFiles%\WinRAR\UnRAR.exe"

echo Restore starting...
echo.
copy /y "!outRoam!\*.json" "!roaming!"
copy /y "!outLocal!\*.json" "!local!"
regedit.exe /s setting.reg
echo.
echo Extracting Plugins Backup
if exist %outZIP% (
			"!zip!" x -r -y "!outZIP!" "!roaming!"
			)
echo.
echo Sketchup restore done at : %DATE% in %TIME% >>activity.log
echo --------------- >>activity.log
echo Restore DONE
pause

