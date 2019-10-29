@ECHO ON
REM "C:\SOFTWARE\ffmpeg\0-latest-x64\bin\ffmpeg.exe"  -y -i "%~1" -map_metadata -1 -f mp3 -vn -acodec libmp3lame -ar 44100 -ab 256k "%~1.256.MP3"
REM PAUSE
REM exit

@echo off
setlocal ENABLEDELAYEDEXPANSION
ECHO Start -----------------------------------------------------------------------------------------

REM ------------------------------ audio parameters ------------------------------ 
set ffmpegexex64=C:\SOFTWARE\ffmpeg\0-latest-x64\bin\ffmpeg.exe
set audiofreq=44100
set audiobitrate=256k

REM ------------------------------ audio conversion ------------------------------ 
REM echo on
ECHO "%ffmpegexex64%" -i "%~1" -threads 0 -vn -map_metadata -1 -c:a libmp3lame -q 0 -cutoff 18000 -ar %audiofreq% -ab %audiobitrate% -y "%~1.%audiobitrate%.mp3"
"%ffmpegexex64%" -i "%~1" -threads 0 -vn -map_metadata -1 -c:a libmp3lame -q 0 -cutoff 18000 -ar %audiofreq% -ab %audiobitrate% -y "%~1.%audiobitrate%.mp3"

ECHO End -----------------------------------------------------------------------------------------

pause