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

REM Set environment variables (Electron 앱에서는 NODE_OPTIONS가 제한적이므로 제거)
set COCOS_CREATOR_NO_UPDATE_CHECK=1

REM 스택 오버플로우 방지를 위해 환경 변수 정리
REM 불필요한 환경 변수는 제거하여 스택 사용량 최소화

echo Running CocosCreator...
echo Project Dir: %PROJECT_DIR%
echo Config Path: %CONFIG_PATH%
echo CocosCreator: %COCOS_EXE%

REM CocosCreator 실행 (경로를 따옴표로 감싸서 공백 처리)
REM 직접 실행하여 스택 오버플로우 위험 최소화
"%COCOS_EXE%" --project "%PROJECT_DIR%" --build "stage=build;configPath=%CONFIG_PATH%;"
set EXIT_CODE=%ERRORLEVEL%

if %EXIT_CODE% NEQ 0 (
    echo ERROR: CocosCreator build failed with exit code %EXIT_CODE%
)

popd >nul
if not "%CMDBUILD_NO_PAUSE%"=="1" pause
exit /b %EXIT_CODE%