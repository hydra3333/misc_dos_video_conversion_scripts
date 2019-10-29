echo on

rem http://ffmpeg.org/trac/ffmpeg/wiki/x264EncodingGuide
rem "C:\SOFTWARE\ffmpeg\0-latest\bin\ffmpeg.exe" -h full > z.txt
rem "C:\SOFTWARE\ffmpeg\0-latest\bin\ffmpeg.exe" -formats >> z.txt
rem "C:\SOFTWARE\ffmpeg\0-latest\bin\ffmpeg.exe" -codecs >> z.txt

REM setlocal enableextensions enabledelayedexpansion

set xpause=pause
set mp3path=.\newmp3

MD "%mp3path%"

for %%f in (*.m*) do (
   CALL :do_with_normalisation "%%f"
REM   CALL :do_without_normalisation "%%f"
)
pause
exit

:do_with_normalisation
echo OFF
@setlocal ENABLEDELAYEDEXPANSION
@setlocal enableextensions

echo %DATE% %TIME% Start "%~1"

REM --- Start audio and other parameters ------------------------------ 
call :000-setup
call :maketempheader
REM
REM set makeaudiotype=aac
set makeaudiotype=mp3
set audiofreq=44100
set audiobitrate=256k
REM +++
SET tempFile=temp_%tempheader%.txt
"!mediainfoexe!" "--Inform=Audio;%%Codec/String%%" "%~dpnx1" > "%tempfile%"
set /p theAudioCodec= < "%tempfile%" 
SET tempFile=temp_%tempheader%.txt
"!mediainfoexe!" "--Inform=Audio;%%BitRate/String%%" "%~dpnx1" > "%tempfile%"
set /p theAudioBitrate= < "%tempfile%" 
SET tempFile=temp_%tempheader%.txt
"!mediainfoexe!" "--Inform=Audio;%%SamplingRate/String%%" "%~dpnx1" > "%tempfile%"
set /p theAudioSamplingRate= < "%tempfile%" 
set theExt=%~x1
IF EXIST "%tempfile%" DEL "%tempfile%"
REM +++
REM --- End audio parameters ------------------------------ 

REM --- Start find loudness adjustment ------------------------------ 
SET aVolFile=.\%~n1.%tempheader%.vol.txt
SET aebur128File=.\%~n1.%tempheader%.ebur.txt
SET vbsVolFile=.\%~n1.%tempheader%.findvolume.vbs
echo %DATE% %TIME% detect required volume increase ---------------------------
@echo on
"%ffmpegexex64%" -hide_banner -y -vn -nostats -i "%~1" -af volumedetect -f null - > "%aVolFile%" 2>&1
"%ffmpegexex64%" -hide_banner -y -vn -nostats -i "%~1" -filter_complex ebur128 -f null - > "%aebur128File%" 2>&1 
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
ECHO       e = instr(s,line,lcase("dB")) - 1 >>  "%vbsVolFile%"
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
ECHO       e = instr(s,line,lcase("LUFS")) - 1 >>  "%vbsVolFile%"
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
@echo ----- FOUND LOUDNESS  adjV=%%i   **adjVOL=%%j**   adjLUFS=%%k   vvvc=%%l   vvvNL=%%m
@echo ----- FOUND LOUDNESS  adjV=%%i   **adjVOL=%%j**   adjLUFS=%%k   vvvc=%%l   vvvNL=%%m
@echo ----- FOUND LOUDNESS  adjV=%%i   **adjVOL=%%j**   adjLUFS=%%k   vvvc=%%l   vvvNL=%%m
@echo ----- FOUND LOUDNESS  adjV=%%i   **adjVOL=%%j**   adjLUFS=%%k   vvvc=%%l   vvvNL=%%m
@echo ----- FOUND LOUDNESS  adjV=%%i   **adjVOL=%%j**   adjLUFS=%%k   vvvc=%%l   vvvNL=%%m
SET adjV=%%i
SET adjVOL=%%j
SET adjLUFS=%%k
)
REM --- End find loudness adjustment ------------------------------ 


ECHO *** !DATE! !TIME! Start Loudness Adjusted Audio conversion to %makeaudiotype%
REM --- Start audio conversion ------------------------------ 
ECHO *** !DATE! !TIME! *** Start ffmpeg %makeaudiotype% AUDIO conversion *** 
REM mp3 audio conversion
IF /I "%makeaudiotype%" == "mp3" (
REM ECHO  mp3 audio conversion "%~f1" ...
echo on
echo "%ffmpegexex64%" -hide_banner -i "%~1" -vn -map_metadata -1 -af volume=volume=!adjVOL!dB:precision=float -c:a libmp3lame -q 0 -cutoff 18000 -ab %audiobitrate% -ar %audiofreq% -y "%mp3path%\%~n1.%audiobitrate%.norm.%theAudioCodec%.%theAudioSamplingRate%%theExt%.mp3" 
"%ffmpegexex64%" -hide_banner -i "%~1" -vn -map_metadata -1 -af volume=volume=!adjVOL!dB:precision=float -c:a libmp3lame -q 0 -cutoff 18000 -ab %audiobitrate% -ar %audiofreq% -y "%mp3path%\%~n1.%audiobitrate%.norm.%theAudioCodec%.%theAudioSamplingRate%%theExt%.mp3" 
SET EL=!ERRORLEVEL!
echo off
IF /I "!EL!" NEQ "0" (
   Echo *** !DATE! !TIME! ***  Error !EL! was found 
   Echo *** !DATE! !TIME! ***  ABORTING ... 
   %xpause%
   EXIT !EL!
)
)
REM aac audio conversion
IF /I "%makeaudiotype%" == "aac" (
REM ECHO  aac audio conversion "%~f1" ...
echo on
echo "%ffmpegexex64%" -hide_banner -i "%~1" -vn -map_metadata -1 -af volume=volume=!adjVOL!dB:precision=float -c:a libfdk_aac -cutoff 18000 -ab %audiobitrate% -ar %audiofreq% -y "%mp3path%\%~n1.%audiobitrate%.norm.%theAudioCodec%.%theAudioSamplingRate%%theExt%.aac" 
"%ffmpegexex64%" -hide_banner -i "%~1" -vn -map_metadata -1 -af volume=volume=!adjVOL!dB:precision=float -c:a libfdk_aac -cutoff 18000 -ab %audiobitrate% -ar %audiofreq% -y "%mp3path%\%~n1.%audiobitrate%.norm.%theAudioCodec%.%theAudioSamplingRate%%theExt%.aac" 
SET EL=!ERRORLEVEL!
echo off
IF /I "!EL!" NEQ "0" (
   Echo *** !DATE! !TIME! ***  Error !EL! was found 
   Echo *** !DATE! !TIME! ***  ABORTING ... 
   %xpause%
   EXIT !EL!
)
)
IF EXIST "%vbsVolFile%" DEL "%vbsVolFile%"
IF EXIST "%aVolFile%" DEL "%aVolFile%"
IF EXIST "%aebur128File%" DEL "%aebur128File%"
ECHO *** !DATE! !TIME! *** End ffmpeg %makeaudiotype% AUDIO conversion  
ECHO *** !DATE! !TIME! *** Input File: "%~1"
REM %xpause%
goto :eof

REM +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
REM +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:000-setup
REM Setup variables for executable image paths so they can be commonly used across batch files
REM ------ WIN10 start
REM echo *** !DATE! !TIME! Start of exe path variables ...  
REM -- win32 ---------------------------------------------------------------------
REM set ffmpegexex32=C:\SOFTWARE\ffmpeg\0-latest-x32\bin\ffmpeg.exe
set ffmpegexex32=C:\SOFTWARE\ffmpeg\0-homebuilt-x32\ffmpeg.exe
set mp4boxexex32=C:\SOFTWARE\ffmpeg\0-homebuilt-x32\MP4Box.exe
REM -- win64 ---------------------------------------------------------------------
REM set ffmpegexex64=C:\SOFTWARE\ffmpeg\0-latest-x64\bin\ffmpeg.exe
set ffmpegexex64=C:\SOFTWARE\ffmpeg\0-homebuilt-x64\ffmpeg.exe
set x264exex64=C:\SOFTWARE\ffmpeg\0-homebuilt-x64\x264-mp4.exe
set mp4boxexex64=C:\SOFTWARE\ffmpeg\0-homebuilt-x64\MP4Box.exe
REM -- common ---------------------------------------------------------------------
set mediainfoexe=C:\software\mediainfo\mediainfo.exe
REM ------ WIN10 end
echo -- win32
REM echo "%ffmpegexex32%"
REM echo "%x264exex32%"
REM echo "%mp4boxexex32%"
echo -- win64
REM echo "%ffmpegexex64%"
REM echo "%x264exex64%"
REM echo "%mp4boxexex64%"
echo -- common
REM echo "%mediainfoexe%"
REM echo *** !DATE! !TIME! End of exe path variables ...  
goto :eof

REM +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
REM +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:LoCase
:: Subroutine to convert a variable VALUE to all lower case.
:: The argument for this subroutine is the variable NAME.
FOR %%i IN ("A=a" "B=b" "C=c" "D=d" "E=e" "F=f" "G=g" "H=h" "I=i" "J=j" "K=k" "L=l" "M=m" "N=n" "O=o" "P=p" "Q=q" "R=r" "S=s" "T=t" "U=u" "V=v" "W=w" "X=x" "Y=y" "Z=z") DO CALL SET "%1=%%%1:%%~i%%"
GOTO:EOF
:UpCase
:: Subroutine to convert a variable VALUE to all UPPER CASE.
:: The argument for this subroutine is the variable NAME.
FOR %%i IN ("a=A" "b=B" "c=C" "d=D" "e=E" "f=F" "g=G" "h=H" "i=I" "j=J" "k=K" "l=L" "m=M" "n=N" "o=O" "p=P" "q=Q" "r=R" "s=S" "t=T" "u=U" "v=V" "w=W" "x=X" "y=Y" "z=Z") DO CALL SET "%1=%%%1:%%~i%%"
GOTO:EOF
:TCase
:: Subroutine to convert a variable VALUE to Title Case.
:: The argument for this subroutine is the variable NAME.
FOR %%i IN (" a= A" " b= B" " c= C" " d= D" " e= E" " f= F" " g= G" " h= H" " i= I" " j= J" " k= K" " l= L" " m= M" " n= N" " o= O" " p= P" " q= Q" " r= R" " s= S" " t= T" " u= U" " v= V" " w= W" " x= X" " y= Y" " z= Z") DO CALL SET "%1=%%%1:%%~i%%"
GOTO :EOF

REM +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
REM +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
REM --- start set a temp header to date and time
:maketempheader
set Datex=%DATE%
set yyyy=%Datex:~10,4%
set mm=%Datex:~7,2%
set dd=%Datex:~4,2%
set Timex=%time%
set hh=%Timex:~0,2%
set min=%Timex:~3,2%
set ss=%Timex:~6,2%
set ms=%Timex:~9,2%
REM Strip any leading spaces from hours
Set hh=%hh: =%
REM Ensure the hours have a leading zero
if 1%hh% LSS 20 Set hh=0%hh%
REM echo As at %yyyy%.%mm%.%dd%_%hh%.%min%.%ss%.%ms%  
set tempheader=%yyyy%.%mm%.%dd%.%hh%.%min%.%ss%.%ms%
REM --- end set a temp header to date and time
goto :eof