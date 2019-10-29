echo on

rem http://ffmpeg.org/trac/ffmpeg/wiki/x264EncodingGuide
rem "C:\SOFTWARE\ffmpeg\0-latest\bin\ffmpeg.exe" -h full > z.txt
rem "C:\SOFTWARE\ffmpeg\0-latest\bin\ffmpeg.exe" -formats >> z.txt
rem "C:\SOFTWARE\ffmpeg\0-latest\bin\ffmpeg.exe" -codecs >> z.txt

REM setlocal enableextensions enabledelayedexpansion

set xpause=
set mp3path=.\newmp3

MD "%mp3path%"

for %%f in (*.m*) do (
REM   CALL :do_with_normalisation "%%f"
   CALL :do_without_normalisation "%%f"
)
pause
exit

:do_with_normalisation
echo OFF
@setlocal ENABLEDELAYEDEXPANSION
@setlocal enableextensions

REM --- Start audio and other parameters ------------------------------ 
REM set makeaudiotype=aac
call :000-setup
REM
set makeaudiotype=mp3
set audiofreq=44100
set audiobitrate=256k
SET lI=-12
SET lTP=0.0
SET lLRA=11
set loudnormfilter=
REM +++
SET tempFile=temp_%header%.txt
"!mediainfoexe!" "--Inform=Audio;%%Codec/String%%" "%~dpnx1" > "%tempfile%"
set /p theAudioCodec= < "%tempfile%" 
SET tempFile=temp_%header%.txt
"!mediainfoexe!" "--Inform=Audio;%%BitRate/String%%" "%~dpnx1" > "%tempfile%"
set /p theAudioBitrate= < "%tempfile%" 
SET tempFile=temp_%header%.txt
"!mediainfoexe!" "--Inform=Audio;%%SamplingRate/String%%" "%~dpnx1" > "%tempfile%"
set /p theAudioSamplingRate= < "%tempfile%" 
set theExt=%~x1
REM +++
REM --- End audio parameters ------------------------------ 

ECHO *** !DATE! !TIME! Start Loudness Adjusted Audio conversion to %makeaudiotype%
REM --- Start Find audio characteristics ------------------------------ 
REM to adjust Audio volume. find the loudness parameters in a first pass
ECHO *** !DATE! !TIME! *** Start Find Audio Loudness ***
call :maketempheader
SET jsonFile=%~dpn1-%tempheader%.json
echo on
"%ffmpegexex64%" -nostats -hide_banner -nostdin -y -i "%~1" -vn -af loudnorm=I=%lI%:TP=%lTP%:LRA=%lLRA%:print_format=json -f null - 2> "%jsonFile%"  
SET EL=!ERRORLEVEL!
echo off
IF /I "!EL!" NEQ "0" (
   Echo *** !DATE! !TIME! ***  Error !EL! was found 
   Echo *** !DATE! !TIME! ***  ABORTING ... 
   %xpause%
   EXIT !EL!
)
REM all the trickery below is simply to remove quotes and tabs and spaces from the json single-level response
set input_i=
set input_tp=
set input_lra=
set input_thresh=
set target_offset=
for /f "tokens=1,2 delims=:, " %%a in (' find ":" ^< "%jsonFile%" ') do (
   set "var="
   for %%c in (%%~a) do set "var=!var!,%%~c"
   set var=!var:~1!
   set "val="
   for %%d in (%%~b) do set "val=!val!,%%~d"
   set val=!val:~1!
REM   echo .!var!.=.!val!.
   IF "!var!" == "input_i"         set !var!=!val!
   IF "!var!" == "input_tp"        set !var!=!val!
   IF "!var!" == "input_lra"       set !var!=!val!
   IF "!var!" == "input_thresh"    set !var!=!val!
   IF "!var!" == "target_offset"   set !var!=!val!
)
REM ECHO *** !DATE! !TIME! input_i=%input_i% 
REM ECHO *** !DATE! !TIME! input_tp=%input_tp% 
REM ECHO *** !DATE! !TIME! input_lra=%input_lra% 
REM ECHO *** !DATE! !TIME! input_thresh=%input_thresh% 
REM ECHO *** !DATE! !TIME! target_offset=%target_offset% 
REM check for bad loudnorm values ... if baddies found, use dynaudnorm instead
set AUDprocess=loudnorm
IF /I "%input_i%" == "inf" (set AUDprocess=dynaudnorm)
IF /I "%input_i%" == "-inf" (set AUDprocess=dynaudnorm)
IF /I "%input_tp%" == "inf" (set AUDprocess=dynaudnorm)
IF /I "%input_tp%" == "-inf" (set AUDprocess=dynaudnorm)
IF /I "%input_lra%" == "inf" (set AUDprocess=dynaudnorm)
IF /I "%input_lra%" == "-inf" (set AUDprocess=dynaudnorm)
IF /I "%input_thresh%" == "inf" (set AUDprocess=dynaudnorm)
IF /I "%input_thresh%" == "-inf" (set AUDprocess=dynaudnorm)
IF /I "%target_offset%" == "inf" (set AUDprocess=dynaudnorm)
IF /I "%target_offset%" == "-inf" (set AUDprocess=dynaudnorm)
REM
REM later, in an encoding pass we MUST down-convert from 192k (loadnorm upsamples it to 192k whis is way way too high ... use  -ar 48k or -ar 48000
REM
IF /I "%AUDprocess%" == "loudnorm" (
   ECHO *** !DATE! !TIME! "Proceeding with normal LOUDNORM audio normalisation ..."
   set loudnormfilter=loudnorm=I=%lI%:TP=%lTP%:LRA=%lLRA%:measured_I=%input_i%:measured_LRA=%input_lra%:measured_TP=%input_tp%:measured_thresh=%input_thresh%:offset=%target_offset%:linear=true:print_format=summary
) ELSE (
   ECHO *** !DATE! !TIME! *** ERROR VALUES DETECTED FROM LOUDNORM - Doing dynaudnorm instead ..." 
   set loudnormfilter=dynaudnorm
)
REM ECHO *** !DATE! !TIME! "loudnormfilter=%loudnormfilter%" 
IF EXIST "%jsonFile%" DEL "%jsonFile%"
ECHO *** !DATE! !TIME! *** End Find Audio Loudness ***
REM --- End Find audio characteristics ------------------------------ 

REM --- Start audio conversion ------------------------------ 
ECHO *** !DATE! !TIME! *** Start ffmpeg %makeaudiotype% AUDIO conversion *** 
REM mp3 audio conversion
IF /I "%makeaudiotype%" == "mp3" (
REM ECHO  mp3 audio conversion "%~f1" ...
echo on
"%ffmpegexex64%" -hide_banner -i "%~1" -vn -map_metadata -1 -af %loudnormfilter% -c:a libmp3lame -q 0 -cutoff 18000 -ab %audiobitrate% -ar %audiofreq% -y "%mp3path%\%~n1.%audiobitrate%.%theAudioCodec%.%theAudioSamplingRate%%theExt%.mp3" 
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
"%ffmpegexex64%" -hide_banner -i "%~1" -vn -map_metadata -1 -af %loudnormfilter% -c:a libfdk_aac -cutoff 18000 -ab %audiobitrate% -ar %audiofreq% -y "%mp3path%\%~n1.%audiobitrate%.%theAudioCodec%.%theAudioSamplingRate%%theExt%.aac"
SET EL=!ERRORLEVEL!
echo off
IF /I "!EL!" NEQ "0" (
   Echo *** !DATE! !TIME! ***  Error !EL! was found 
   Echo *** !DATE! !TIME! ***  ABORTING ... 
   %xpause%
   EXIT !EL!
)
)
ECHO *** !DATE! !TIME! *** End ffmpeg %makeaudiotype% AUDIO conversion  
ECHO *** !DATE! !TIME! *** Input File: %~1
%xpause%
goto :eof


:do_without_normalisation
echo OFF
@setlocal ENABLEDELAYEDEXPANSION
@setlocal enableextensions

REM --- Start audio and other parameters ------------------------------ 
REM set makeaudiotype=aac
call :000-setup
REM
set makeaudiotype=mp3
set audiofreq=44100
set audiobitrate=256k
SET lI=-12
SET lTP=0.0
SET lLRA=11
set loudnormfilter=
REM --- End audio parameters ------------------------------ 

REM --- Start audio conversion ------------------------------ 
ECHO *** !DATE! !TIME! *** Start ffmpeg %makeaudiotype% AUDIO conversion *** 
REM mp3 audio conversion
IF /I "%makeaudiotype%" == "mp3" (
REM ECHO  mp3 audio conversion "%~f1" ...
echo on
"%ffmpegexex64%" -hide_banner -i "%~1" -vn -map_metadata -1 -c:a libmp3lame -q 0 -cutoff 18000 -ab %audiobitrate% -ar %audiofreq% -y "%mp3path%\%~n1.%audiobitrate%.%theAudioCodec%.%theAudioSamplingRate%%theExt%.mp3" 
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
"%ffmpegexex64%" -hide_banner -i "%~1" -vn -map_metadata -1 -c:a libfdk_aac -cutoff 18000 -ab %audiobitrate% -ar %audiofreq% -y "%mp3path%\%~n1.%audiobitrate%.%theAudioCodec%.%theAudioSamplingRate%%theExt%.aac"
SET EL=!ERRORLEVEL!
echo off
IF /I "!EL!" NEQ "0" (
   Echo *** !DATE! !TIME! ***  Error !EL! was found 
   Echo *** !DATE! !TIME! ***  ABORTING ... 
   %xpause%
   EXIT !EL!
)
)
ECHO *** !DATE! !TIME! *** End ffmpeg %makeaudiotype% AUDIO conversion  
ECHO *** !DATE! !TIME! *** Input File: %~1
%xpause%
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