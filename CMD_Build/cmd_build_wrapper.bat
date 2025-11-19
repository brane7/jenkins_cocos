@echo off
REM Jenkins용 Wrapper 스크립트
REM Jenkins의 bat 단계가 cmd를 찾지 못하는 문제 해결

REM PATH에 System32 추가 (cmd.exe를 찾을 수 있도록)
set "PATH=%PATH%;C:\Windows\System32"

REM 원본 스크립트 실행
call "%~dp0cmd_build.bat" %*
exit /b %ERRORLEVEL%

