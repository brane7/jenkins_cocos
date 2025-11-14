@echo off
setlocal ENABLEDELAYEDEXPANSION
chcp 65001 >nul
set "SCRIPT_DIR=%~dp0"
pushd "%SCRIPT_DIR%" >nul
set "PROJECT_DIR=%CD%"
set "CONFIG_PATH=%PROJECT_DIR%\buildConfig_cocos_cmd.json"
CocosCreator.exe --project "%PROJECT_DIR%" --build "stage=build;configPath=%CONFIG_PATH%;"
set "EXIT_CODE=%ERRORLEVEL%"
popd >nul
if not "%CMDBUILD_NO_PAUSE%"=="1" pause
exit /b %EXIT_CODE%