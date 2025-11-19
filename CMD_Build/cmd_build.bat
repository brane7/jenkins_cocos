@echo off
setlocal ENABLEDELAYEDEXPANSION

REM PATH에 System32 추가 (cmd.exe를 찾을 수 있도록)
set "PATH=%PATH%;C:\Windows\System32"

REM cmd.exe 절대 경로 설정 (필요시 사용)
set "CMD_EXE=C:\Windows\System32\cmd.exe"

chcp 65001 >nul
set "SCRIPT_DIR=%~dp0"
pushd "%SCRIPT_DIR%" >nul
set "PROJECT_DIR=%CD%"
set "CONFIG_PATH=%PROJECT_DIR%\buildConfig_cocos_cmd.json"

REM CocosCreator.exe 경로 확인 및 설정
if defined COCOS_ROOT (
    set "COCOS_EXE=%COCOS_ROOT%\CocosCreator.exe"
) else (
    set "COCOS_EXE=C:\CocosCreator\CocosCreator.exe"
)

REM CocosCreator.exe 존재 여부 확인
if not exist "%COCOS_EXE%" (
    echo ERROR: CocosCreator.exe not found at %COCOS_EXE%
    exit /b 1
)

"%COCOS_EXE%" --project "%PROJECT_DIR%" --build "stage=build;configPath=%CONFIG_PATH%;"
set "EXIT_CODE=%ERRORLEVEL%"
popd >nul
if not "%CMDBUILD_NO_PAUSE%"=="1" pause
exit /b %EXIT_CODE%