@echo off
chcp 65001 >nul 2>&1
setlocal ENABLEDELAYEDEXPANSION

REM Add System32 to PATH (to find cmd.exe)
set PATH=%PATH%;C:\Windows\System32

REM Set absolute path for cmd.exe (if needed)
set CMD_EXE=C:\Windows\System32\cmd.exe
set SCRIPT_DIR=%~dp0
pushd %SCRIPT_DIR% >nul
set PROJECT_DIR=%CD%
set CONFIG_PATH=%PROJECT_DIR%\buildConfig_cocos_cmd.json

REM Parse parameters (TEMPLATE_KEY and COCOS_VERSION)
set TEMPLATE_KEY=%1
set COCOS_VERSION=%2

REM Check and set CocosCreator.exe path
REM Priority: COCOS_ROOT > COCOS_VERSION parameter > default
if defined COCOS_ROOT (
    set COCOS_EXE=%COCOS_ROOT%\CocosCreator.exe
) else if not "%COCOS_VERSION%"=="" (
    REM Convert version number (e.g., 387 -> 3.8.7)
    if "%COCOS_VERSION:~2,1%"=="" (
        REM If version is less than 3 digits, use default
        set COCOS_EXE=C:\CocosCreator\CocosCreator.exe
    ) else (
        set VERSION_MAJOR=%COCOS_VERSION:~0,1%
        set VERSION_MINOR=%COCOS_VERSION:~1,1%
        set VERSION_PATCH=%COCOS_VERSION:~2,1%
        set COCOS_EXE=C:\ProgramData\cocos\editors\Creator\%VERSION_MAJOR%.%VERSION_MINOR%.%VERSION_PATCH%\CocosCreator.exe
    )
) else (
    set COCOS_EXE=C:\CocosCreator\CocosCreator.exe
)

REM Check if CocosCreator.exe exists
if not exist %COCOS_EXE% (
    echo ERROR: CocosCreator.exe not found at %COCOS_EXE%
    exit /b 1
)

REM Check if config file exists
if not exist %CONFIG_PATH% (
    echo ERROR: Config file not found at %CONFIG_PATH%
    exit /b 1
)

REM Set environment variables to prevent stack overflow
set COCOS_CREATOR_NO_UPDATE_CHECK=1
set NODE_OPTIONS=--max-old-space-size=8192 --stack-size=4096

REM Clear any problematic environment variables
set TEMP=%TEMP%
set TMP=%TMP%

echo Running CocosCreator...
echo Project Dir: %PROJECT_DIR%
echo Config Path: %CONFIG_PATH%
echo CocosCreator: %COCOS_EXE%
echo Template Key: %TEMPLATE_KEY%
echo Cocos Version: %COCOS_VERSION%
echo Node Options: %NODE_OPTIONS%

REM Run CocosCreator with explicit environment
call "%COCOS_EXE%" --project "%PROJECT_DIR%" --build "stage=build;configPath=%CONFIG_PATH%;"
set EXIT_CODE=%ERRORLEVEL%

if %EXIT_CODE% NEQ 0 (
    echo ERROR: CocosCreator build failed with exit code %EXIT_CODE%
)

popd >nul
if not "%CMDBUILD_NO_PAUSE%"=="1" pause
exit /b %EXIT_CODE%