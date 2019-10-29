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

REM ------------------------------ audio temp files ------------------------------ 
set tmp0=D:\temp
set tmp_folder=%tmp0%%~pnx1_temp_mp3
MD "%tmp0%"
MD "%tmp_folder%"
SET aVolFile=%tmp_folder%\%~n1.vol.txt
SET aebur128File=%tmp_folder%\%~n1.ebur.txt
SET vbsVolFile=%tmp_folder%\findvolume.vbs

REM ------------------------------ detect required volume increase ------------------------------ 
REM Find loudness
@echo on
"%ffmpegexex64%" -y -vn -nostats -threads 8 -i "%~1" -af volumedetect -f null - > "%aVolFile%" 2>&1
"%ffmpegexex64%" -y -vn -nostats -threads 8 -i "%~1" -filter_complex ebur128 -f null - > "%aebur128File%" 2>&1 

@echo off
ECHO ' read vol from ffmpeg file and return the Maximum Volume value only >  "%vbsVolFile%"
ECHO Const ForReading = 1 >>  "%vbsVolFile%"
ECHO Dim objStdOut, objFSO , objFile, line, e, s, v, adj, adjV, adjE, er  >>  "%vbsVolFile%"
ECHO 'Set objStdOut = WScript.StdOut  >>  "%vbsVolFile%"
ECHO Set objFSO = CreateObject("Scripting.FileSystemObject") >>  "%vbsVolFile%"
ECHO Set objFile = objFSO.OpenTextFile("!aVolFile!", ForReading) >>  "%vbsVolFile%"
ECHO er = 1 >>  "%vbsVolFile%"
ECHO v = 0 >>  "%vbsVolFile%"
ECHO adj = 0 >>  "%vbsVolFile%"
ECHO Do Until objFile.AtEndOfStream >>  "%vbsVolFile%"
ECHO    line = lcase(objFile.ReadLine) >>  "%vbsVolFile%"
ECHO    if instr(line,lcase("max_volume:")) ^> 0 then >>  "%vbsVolFile%"
ECHO       s = instr(line,lcase("max_volume:")) + 11 >>  "%vbsVolFile%"
ECHO       e = instr(line,lcase("dB")) - 1 >>  "%vbsVolFile%"
ECHO       'WScript.StdOut.WriteLine "line=" ^& line >>  "%vbsVolFile%"
ECHO       'WScript.StdOut.WriteLine s ^& " " ^& e  >>  "%vbsVolFile%"
ECHO       if s^<=0 or e^<=0 then  >>  "%vbsVolFile%"
ECHO          exit do >>  "%vbsVolFile%"
ECHO       end if >>  "%vbsVolFile%"
ECHO       v = trim(mid(line,s,e-s+1)) >>  "%vbsVolFile%"
ECHO       'WScript.StdOut.WriteLine "string v=" ^& v >>  "%vbsVolFile%"
ECHO       vvvc = v >>  "%vbsVolFile%"
ECHO       v = cdbl(v) >>  "%vbsVolFile%"
ECHO       'WScript.StdOut.WriteLine "cdbl v=" ^& v >>  "%vbsVolFile%"
ECHO       adj = min(abs(v),16) >>  "%vbsVolFile%"
ECHO       'WScript.StdOut.WriteLine "adj=" ^& adj >>  "%vbsVolFile%"
ECHO       er = 0 >>  "%vbsVolFile%"
ECHO       exit do >>  "%vbsVolFile%"
ECHO    end if >>  "%vbsVolFile%"
ECHO Loop >>  "%vbsVolFile%"
ECHO adjV=adj >>  "%vbsVolFile%"
ECHO objFile.Close >>  "%vbsVolFile%"
ECHO set objFile = nothing >>  "%vbsVolFile%"
ECHO 'set objFSO = nothing >>  "%vbsVolFile%"
ECHO 'WScript.StdOut.WriteLine adj >>  "%vbsVolFile%"
ECHO ' read ebur128 from ffmpeg file and return the Integrated Loudness I value only >>  "%vbsVolFile%"
ECHO 'Const ForReading = 1 >>  "%vbsVolFile%"
ECHO 'Dim objStdOut, objFSO , objFile, line, e, s, v, adj, adjV, adjE, er  >>  "%vbsVolFile%"
ECHO ''Set objStdOut = WScript.StdOut  >>  "%vbsVolFile%"
ECHO 'Set objFSO = CreateObject("Scripting.FileSystemObject") >>  "%vbsVolFile%"
ECHO Set objFile = objFSO.OpenTextFile("!aebur128File!", ForReading) >>  "%vbsVolFile%"
ECHO er = 1 >>  "%vbsVolFile%"
ECHO v = 0 >>  "%vbsVolFile%"
ECHO adj = 0 >>  "%vbsVolFile%"
ECHO Do Until objFile.AtEndOfStream >>  "%vbsVolFile%"
ECHO    line = lcase(objFile.ReadLine) >>  "%vbsVolFile%"
ECHO    if instr(line,lcase("Integrated loudness:")) ^> 0 then >>  "%vbsVolFile%"
ECHO       line = lcase(objFile.ReadLine) >>  "%vbsVolFile%"
ECHO       s = instr(line,lcase("I:")) + 2 >>  "%vbsVolFile%"
ECHO       e = instr(line,lcase("LUFS")) - 1 >>  "%vbsVolFile%"
ECHO       'WScript.StdOut.WriteLine "line=" ^& line >>  "%vbsVolFile%"
ECHO       'WScript.StdOut.WriteLine s ^& " " ^& e  >>  "%vbsVolFile%"
ECHO       if s^<=0 or e^<=0 then  >>  "%vbsVolFile%"
ECHO          exit do >>  "%vbsVolFile%"
ECHO       end if >>  "%vbsVolFile%"
ECHO       v = trim(mid(line,s,e-s+1)) >>  "%vbsVolFile%"
ECHO       'WScript.StdOut.WriteLine "string v=" ^& v >>  "%vbsVolFile%"
ECHO       v = cdbl(v) >>  "%vbsVolFile%"
ECHO       'WScript.StdOut.WriteLine "cdbl v=" ^& v >>  "%vbsVolFile%"
ECHO ''' adjust to -19 (-23 is standard) >>  "%vbsVolFile%"
ECHO '''      v = -23 - v >>  "%vbsVolFile%"
ECHO       v = -19 - v >>  "%vbsVolFile%"
ECHO       vvvNL = v >>  "%vbsVolFile%"
ECHO       'WScript.StdOut.WriteLine "-23-v v=" ^& v >>  "%vbsVolFile%"
ECHO       adj = min(abs(max(v,0)),16) >>  "%vbsVolFile%"
ECHO       'WScript.StdOut.WriteLine "adj=" ^& adj >>  "%vbsVolFile%"
ECHO       er = 0 >>  "%vbsVolFile%"
ECHO       exit do >>  "%vbsVolFile%"
ECHO    end if >>  "%vbsVolFile%"
ECHO Loop >>  "%vbsVolFile%"
ECHO adjE=adj >>  "%vbsVolFile%"
ECHO '''adj = max(min(adjV,adjE),0) >>  "%vbsVolFile%"
ECHO adj = adjE >>  "%vbsVolFile%"
ECHO 'WScript.StdOut.WriteLine adj >>  "%vbsVolFile%"
ECHO 'WScript.StdOut.WriteLine adj ^& "," ^& adjV ^& "," ^& adjE >>  "%vbsVolFile%"
ECHO  WScript.StdOut.WriteLine adj ^& "," ^& adjV ^& "," ^& adjE ^& "," ^& vvvc ^& "," ^& vvvnl >>  "%vbsVolFile%"
ECHO objFile.Close >>  "%vbsVolFile%"
ECHO set objFile = nothing >>  "%vbsVolFile%"
ECHO set objFSO = nothing >>  "%vbsVolFile%"
ECHO wscript.quit(er) ' 1=error. 0=ok >>  "%vbsVolFile%"
ECHO function Max(a,b) >>  "%vbsVolFile%"
ECHO     Max = a >>  "%vbsVolFile%"
ECHO     If b ^> a then Max = b >>  "%vbsVolFile%"
ECHO end function >>  "%vbsVolFile%"
ECHO function Min(a,b) >>  "%vbsVolFile%"
ECHO     Min = a >>  "%vbsVolFile%"
ECHO     If b ^< a then Min = b >>  "%vbsVolFile%"
ECHO end function  >>  "%vbsVolFile%"

FOR /F "tokens=1,2,3,4,5 delims=," %%i IN ('cscript //B //NOLOGO  "%vbsVolFile%"') DO ( 
@echo ----- FOUND LOUDNESS  adjV=%%i   adjVOL=%%j   adjLUFS=%%k   vvvc=%%l   vvvNL=%%m
SET adjV=%%i
SET adjVOL=%%j
SET adjLUFS=%%k
)

REM ------------------------------ audio conversion ------------------------------ 
REM echo on
ECHO "%ffmpegexex64%" -i "%~1" -threads 0 -vn -map_metadata -1 -c:a libmp3lame -q 0 -cutoff 18000 -ar %audiofreq% -ab %audiobitrate% -af volume=volume=!adjVOL!dB:precision=float -y "%~1.%audiobitrate%.mp3"
"%ffmpegexex64%" -i "%~1" -threads 0 -vn -map_metadata -1 -c:a libmp3lame -q 0 -cutoff 18000 -ar %audiofreq% -ab %audiobitrate% -af volume=volume=!adjVOL!dB:precision=float -y "%~1.%audiobitrate%.mp3"

DEL "%vbsVolFile%"
DEL "%aVolFile%"
DEL "%aebur128File%"
DEL /F /S /Q "%tmp_folder%\*.*"
RMDIR /S /Q "%tmp_folder%"

ECHO End -----------------------------------------------------------------------------------------

pause