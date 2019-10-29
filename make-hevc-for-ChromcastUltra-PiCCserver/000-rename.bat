@Echo OFF
@setlocal ENABLEDELAYEDEXPANSION
@setlocal enableextensions

set logfile=%~f0.log
if exist "%logfile%" del "%logfile%" 
echo ECHO ON  >> "%logfile%"
for /R ".\" %%a in ("*.mp4") do (
  call :check_and_rename_me "%%a"
)
ECHO PAUSE >> "%logfile%"
pause
exit

:check_and_rename_me
REM cleanup a filename and rename it
REM echo on
set "filename1=%~f1"
set "filename2=%~f1"
set ssearch=.mp3
set sreplace=.aac
REM set filename2
REM set ssearch
REM set sreplace
set "filename2=!filename2:%ssearch%=%sreplace%!"
REM set filename2
REM
set ssearch=.mp4.mp4
set sreplace=.mp4
REM set filename2
REM set ssearch
REM set sreplace
set "filename2=!filename2:%ssearch%=%sreplace%!"
REM set filename2
REM
set ssearch=MP4.h265.mp4
set sreplace=h265.mp4
REM set filename2
REM set ssearch
REM set sreplace
set "filename2=!filename2:%ssearch%=%sreplace%!"
REM set filename2
if /i NOT "%~f1" == "%filename2%" ECHO logging: move /y "%filename1%" "%filename2%"
if /i NOT "%~f1" == "%filename2%" ECHO move /y "%filename1%" "%filename2%" >> "%logfile%"
REM echo off
goto :eof