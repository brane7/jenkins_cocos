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

REM Check and set CocosCreator.exe path
if defined COCOS_ROOT (
    set COCOS_EXE=%COCOS_ROOT%\CocosCreator.exe
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

REM Check Node.js installation (CocosCreator 빌드에 필요할 수 있음)
where node >nul 2>&1
if !ERRORLEVEL! NEQ 0 (
    echo WARNING: Node.js not found in PATH. CocosCreator may need Node.js for build process.
    echo Checking common Node.js installation paths...
    if exist "C:\Program Files\nodejs\node.exe" (
        set "PATH=!PATH!;C:\Program Files\nodejs"
        echo Node.js found at C:\Program Files\nodejs and added to PATH
    ) else if exist "C:\Program Files (x86)\nodejs\node.exe" (
        set "PATH=!PATH!;C:\Program Files (x86)\nodejs"
        echo Node.js found at C:\Program Files (x86)\nodejs and added to PATH
    ) else (
        echo WARNING: Node.js not found. This may cause build failures.
    )
) else (
    echo Node.js found in PATH
    node --version
)

echo Running CocosCreator...
echo Project Dir: %PROJECT_DIR%
echo Config Path: %CONFIG_PATH%
echo CocosCreator: %COCOS_EXE%

%COCOS_EXE% --project %PROJECT_DIR% --build "stage=build;configPath=%CONFIG_PATH%;"
set EXIT_CODE=%ERRORLEVEL%

if %EXIT_CODE% NEQ 0 (
    echo ERROR: CocosCreator build failed with exit code %EXIT_CODE%
)

popd >nul
if not "%CMDBUILD_NO_PAUSE%"=="1" pause
exit /b %EXIT_CODE%