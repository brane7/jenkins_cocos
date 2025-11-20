@echo off
chcp 65001 >nul 2>&1
REM Jenkins Wrapper Script
REM Fix issue where Jenkins bat step cannot find cmd

REM Add System32 to PATH (to find cmd.exe)
set "PATH=%PATH%;C:\Windows\System32"

REM Execute original script
call "%~dp0cmd_build.bat" %*
exit /b %ERRORLEVEL%

