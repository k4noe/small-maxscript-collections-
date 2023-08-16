@echo off
title CoronaRenderer Patcher
SETLOCAL ENABLEDELAYEDEXPANSION 
REM COPY THIS CODE AS BAT FILE AND PUT IT NEXT TO PATCH FILE
REM THIS THING JUST HELP COPY PASTE THING NOT DO BAD THING LIKE PATCHING FILE OR ANYTING

CLS
 ECHO.
 ECHO =============================
 ECHO Running Admin shell
 ECHO =============================

:init
 setlocal DisableDelayedExpansion
 set cmdInvoke=1
 set winSysFolder=System32
 set "batchPath=%~dpnx0"
 rem this works also from cmd shell, other than %~0
 for %%k in (%0) do set batchName=%%~nk
 set "vbsGetPrivileges=%temp%\OEgetPriv_%batchName%.vbs"
 setlocal EnableDelayedExpansion

:checkPrivileges
  NET FILE 1>NUL 2>NUL
  if '%errorlevel%' == '0' ( goto gotPrivileges ) else ( goto getPrivileges )

:getPrivileges
  if '%1'=='ELEV' (echo ELEV & shift /1 & goto gotPrivileges)
  ECHO.
  ECHO **************************************
  ECHO Invoking UAC for Privilege Escalation
  ECHO **************************************

  ECHO Set UAC = CreateObject^("Shell.Application"^) > "%vbsGetPrivileges%"
  ECHO args = "ELEV " >> "%vbsGetPrivileges%"
  ECHO For Each strArg in WScript.Arguments >> "%vbsGetPrivileges%"
  ECHO args = args ^& strArg ^& " "  >> "%vbsGetPrivileges%"
  ECHO Next >> "%vbsGetPrivileges%"
  
  if '%cmdInvoke%'=='1' goto InvokeCmd 

  ECHO UAC.ShellExecute "!batchPath!", args, "", "runas", 1 >> "%vbsGetPrivileges%"
  goto ExecElevation

:InvokeCmd
  ECHO args = "/c """ + "!batchPath!" + """ " + args >> "%vbsGetPrivileges%"
  ECHO UAC.ShellExecute "%SystemRoot%\%winSysFolder%\cmd.exe", args, "", "runas", 1 >> "%vbsGetPrivileges%"

:ExecElevation
 "%SystemRoot%\%winSysFolder%\WScript.exe" "%vbsGetPrivileges%" %*
 exit /B

:gotPrivileges
 setlocal & cd /d %~dp0
 if '%1'=='ELEV' (del "%vbsGetPrivileges%" 1>nul 2>nul  &  shift /1)

REM ::::START::::
REM THE CODE HERE

SET LEGLIB=LegionLib_Release.dll
SET SCATERLIB=ScatterCore.ForScatter_Release.dll
SET "CORVERSION=%PROGRAMFILES%\Corona\Corona Renderer for 3ds Max\"
SET "MAXSTANDALONEPATH=%PROGRAMFILES%\Corona\Corona Renderer for 3ds Max\Standalone"
SET "CORIMGEDITOR=%PROGRAMFILES%\Corona\Corona Renderer for 3ds Max\Image Editor"

SET "MAXEXE=3dsmax.exe"
SET "MAXPATH=%PROGRAMFILES%\Autodesk\3ds Max "
SET "CORSCATERPATH=%PROGRAMFILES%\Chaos Group\Scatter\3ds Max "
SET VER=2020 2021 2022 2023 2024

for %%i in (%VER%) DO (
SET "MAX=!MAXPATH!%%i"

SET "INSTALLEDMAX=!MAX!\!MAXEXE!"

IF EXIST !INSTALLEDMAX! (
::ECHO !INSTALLEDMAX!
REM CEK FOR CORONE RENDERER PATH IF EXIST COPY CRACK 
SET "INSTALLEDCORONA=!CORVERSION!%%i"
SET "INSTALLEDLEGLIB=!INSTALLEDCORONA!\!LEGLIB!"
IF EXIST !INSTALLEDLEGLIB! (
ECHO.    
ECHO CORONA VERSION FOR MAX %%i INSTALLED
ECHO --------======================--------
SET "INSTALLEDSCATTER=!CORSCATERPATH!%%i"

COPY /Y !LEGLIB! "!INSTALLEDCORONA!"
COPY /Y !LEGLIB! "!MAXSTANDALONEPATH!"
COPY /Y !LEGLIB! "!CORIMGEDITOR!"
COPY /Y !SCATERLIB! "!INSTALLEDSCATTER!"

)
)
)


pause
