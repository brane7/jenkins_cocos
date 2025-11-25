@echo off
chcp 65001 >nul 2>&1
setlocal ENABLEDELAYEDEXPANSION

REM Add System32 to PATH (to find cmd.exe)
set PATH=%PATH%;C:\Windows\System32

REM Set absolute path for cmd.exe (if needed)
set CMD_EXE=C:\Windows\System32\cmd.exe
set SCRIPT_DIR=%~dp0
REM CMD_Build 폴더가 실제 Cocos Creator 프로젝트 폴더
set PROJECT_DIR=%SCRIPT_DIR%
REM buildConfig_cocos_cmd.json은 루트 폴더에 존재
set CONFIG_PATH=%SCRIPT_DIR%buildConfig_cocos_cmd.json

REM Set CocosCreator.exe path (로컬 테스트용 절대 경로)
set COCOS_EXE=C:\ProgramData\cocos\editors\Creator\3.8.7\CocosCreator.exe

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

echo Running CocosCreator...
echo Project Dir: %PROJECT_DIR%
echo Config Path: %CONFIG_PATH%
echo CocosCreator: %COCOS_EXE%


%COCOS_EXE% --project %PROJECT_DIR% --build "stage=build;configPath=%CONFIG_PATH%;"
set EXIT_CODE=%ERRORLEVEL%

if %EXIT_CODE% NEQ 0 (
    echo ERROR: CocosCreator build failed with exit code %EXIT_CODE%
)

if not "%CMDBUILD_NO_PAUSE%"=="1" pause
exit /b %EXIT_CODE%