@ECHO off
@setlocal ENABLEDELAYEDEXPANSION
@setlocal enableextensions
REM
REM QuickStreamFix all .TS files in a folder into .mpg/.mp4 files in another folder using a relevant custom profile.
REM Find ads in the .mpg/.mp4 with VRD Ad-Detective and create a .bprj file so can manually edit each file later.
REM 

REM --------- set whether pause statements take effect ----------------------------
SET xPAUSE=REM
REM SET xPAUSE=PAUSE
REM --------- set whether pause statements take effect ----------------------------

REM --------- set whether to do an adscan ----------------------------
set do_adscan=true
REM set do_adscan=false
REM --------- set whether to do an adscan ----------------------------

REM -- Header ---------------------------------------------------------------------
REM --- start set header to date and time
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
ECHO !DATE! !TIME! As at %yyyy%.%mm%.%dd%_%hh%.%min%.%ss%.%ms%  COMPUTERNAME="%COMPUTERNAME%"
set header=%yyyy%.%mm%.%dd%.%hh%.%min%.%ss%.%ms%-%COMPUTERNAME%
ECHO !DATE! !TIME! header="%header%"
REM --- end set header to date and time
REM -- Header ---------------------------------------------------------------------

REM v7 - old
REM SET sourcePath=.\
REM SET MPGpath=T:\HDTV\autoTVS-mpg\
REM SET TSpath=.\autoTVS-ts\
REM SET TSGUpath=.\autoTVS-ts\gave-up\
REM SET ConvertedPath=%MPGpath%Converted\

REM v9 - intermediary stuff go to a scratch folder on SSD - shortcut it and re-use variable "MPGpath" from v7
REM the process is :-
REM    .TS file on source disk ... QSF to  ... temp .mp4/.mpg file on scratch disk
REM    temp .mp4/.mpg file on scratch disk ... audio loudness ... parameters 
REM    temp .mp4/.mpg file on scratch disk ... audio ... temp .aac audio on scratch disk
REM    temp .mp4/.mpg file on scratch disk ... video ... temp .mp4 video on scratch disk
REM    temp .aac/.mp4 audio/video on scratch disk    ... muxed to final .mp4 at "ConvertedPath"
REM    final .mp4 at "ConvertedPath" ... adscan to ... .bprj file at "ConvertedPath"
SET sourcePath=.\
SET TSpath=.\autoTVS-ts\
SET TSGUpath=.\autoTVS-ts\gave-up\
SET targetMPGpathRoot=T:\HDTV\autoTVS-mpg\
SET SCRATCHPATH=D:\temp\SCRATCH\
SET MPGpath=%SCRATCHPATH%
SET ConvertedPath=%targetMPGpathRoot%Converted\

REM --------- resolve any relative paths into absolute paths --------- 
REM --------- ensure nos spaces between brackets and SET statement --------- 
ECHO !DATE! !TIME! before sourcePath="%sourcePath%"
FOR /F %%i IN ("%sourcePath%") DO (SET sourcePath=%%~fi)
ECHO !DATE! !TIME! after sourcePath="%sourcePath%"
ECHO !DATE! !TIME! before MPGpath="%MPGpath%"
FOR /F %%i IN ("%MPGpath%") DO (SET MPGpath=%%~fi)
ECHO !DATE! !TIME! after MPGpath="%MPGpath%"
ECHO !DATE! !TIME! before TSpath="%TSpath%"
FOR /F %%i IN ("%TSpath%") DO (SET TSpath=%%~fi)
ECHO !DATE! !TIME! after TSpath="%TSpath%"
ECHO !DATE! !TIME! before TSGUpath="%TSGUpath%"
FOR /F %%i IN ("%TSGUpath%") DO (SET TSGUpath=%%~fi)
ECHO !DATE! !TIME! after TSGUpath="%TSGUpath%"
ECHO !DATE! !TIME! before ConvertedPath="%ConvertedPath%"
FOR /F %%i IN ("%ConvertedPath%") DO (SET ConvertedPath=%%~fi)
ECHO !DATE! !TIME! after ConvertedPath="%ConvertedPath%"
ECHO !DATE! !TIME! before SCRATCHPATH="%SCRATCHPATH%"
FOR /F %%i IN ("%SCRATCHPATH%") DO (SET SCRATCHPATH=%%~fi)
ECHO !DATE! !TIME! after SCRATCHPATH="%SCRATCHPATH%"
REM ---------------------------------------

REM --------- setup VRD paths ----------------------------
set PTH2adscan=C:\Program Files (x86)\VideoReDoTVSuite6
set PTH2vbs=G:\HDTV
REM --------- setup VRD paths ----------------------------

REM --------- setup LOG file and TEMP filenames ----------------------------
SET vrdlog=%sourcePath%z.vrdlog-%header%.log
ECHO !DATE! !TIME! DEL "%vrdlog%"
DEL "%vrdlog%"
SET tempfile=%SCRATCHPATH%tempfile-%header%.txt
ECHO !DATE! !TIME! DEL "%tempfile%"
DEL "%tempfile%"
REM --------- setup LOG file and TEMP filenames ----------------------------

REM --------- setup exe paths ----------------------------
REM setup exe paths and header etc - after setting up filenames etc
call :000-setup
REM --------- setup exe paths ----------------------------

MD "%SCRATCHPATH%"
MD "%MPGpath%"
MD "%TSpath%"
MD "%TSGUpath%"
MD "%ConvertedPath%"

REM --------- set the final type audio to be produced and whether mpeg2 video should be sharpened ----------------------------
REM set makeaudiotype=mp3
set makeaudiotype=aac
REM 
set sharpenthevideo=true
REM set sharpenthevideo=false
REM --------- set the final type of audio to be produced ----------------------------

@ECHO on
ECHO !DATE! !TIME! ... start summary of Initialised paths etc ... >> "%vrdlog%"
ECHO !DATE! !TIME! COMPUTERNAME="%COMPUTERNAME%" >> "%vrdlog%"
ECHO !DATE! !TIME! sourcePath="%sourcePath%" >> "%vrdlog%"
ECHO !DATE! !TIME! TSpath="%TSpath%" >> "%vrdlog%"
ECHO !DATE! !TIME! TSGUpath="%TSGUpath%" >> "%vrdlog%"
ECHO !DATE! !TIME! targetMPGpathRoot="%targetMPGpathRoot%" >> "%vrdlog%"
ECHO !DATE! !TIME! SCRATCHPATH="%SCRATCHPATH%" >> "%vrdlog%"
ECHO !DATE! !TIME! MPGpath="%MPGpath%" >> "%vrdlog%"
ECHO !DATE! !TIME! ConvertedPath="%ConvertedPath%" >> "%vrdlog%"
ECHO !DATE! !TIME! vrdlog="%vrdlog%" >> "%vrdlog%"
ECHO !DATE! !TIME! tempfile="%tempfile%" >> "%vrdlog%"
ECHO !DATE! !TIME! makeaudiotype="%makeaudiotype%" >> "%vrdlog%"
ECHO !DATE! !TIME! sharpenthevideo="%sharpenthevideo%" >> "%vrdlog%"
ECHO !DATE! !TIME! ... end summary of Initialised paths etc ... >> "%vrdlog%"
@ECHO off

REM ***** PREVENT PC FROM GOING TO SLEEP *****
set iFile=%header%-Insomnia.exe
ECHO copy "C:\SOFTWARE\Insomnia\32-bit\Insomnia.exe" ".\%iFile%" >> "%vrdlog%" 2>&1
copy "C:\SOFTWARE\Insomnia\32-bit\Insomnia.exe" ".\%iFile%" >> "%vrdlog%" 2>&1
REM ***** PREVENT PC FROM GOING TO SLEEP *****
start /min "%iFile%" ".\%iFile%"

REM process the .TS files into .mpg/.mp4 into the "MPGpath"  folder 
REM and then process them into the "converted" subfolder
REM   .TS  files get transferred via VRD    into .mp4 files with unchanged audio
REM   .MPG files get transferred via ffmpeg into .mp4 files with .aac audio
REM   .MP4 files get transferred via ffmpeg into .mp4 files with .aac audio
for %%f in ("%sourcePath%*.TS") do (
   @ECHO on
   ECHO !DATE! !TIME! !DATE! !TIME!
   ECHO !DATE! !TIME! !DATE! !TIME!
   ECHO !DATE! !TIME! >> "%vrdlog%" 2>&1
   ECHO !DATE! !TIME! >> "%vrdlog%" 2>&1
   ECHO !DATE! !TIME! START ------------------ %%f 
   ECHO !DATE! !TIME! START ------------------ %%f >> "%vrdlog%" 2>&1
   ECHO !DATE! !TIME! START ------------------ %%f >> "%vrdlog%" 2>&1
   ECHO !DATE! !TIME! Input .TS              : "%%~f" >> "%vrdlog%" 2>&1
   ECHO !DATE! !TIME! Output VRD intermediate: "%MPGpath%%%~nf" without extension - added later >> "%vrdlog%" 2>&1
   ECHO !DATE! !TIME! ConvertedPath:         : "%ConvertedPath%" >> "%vrdlog%" 2>&1
   REM old = CALL :QSF "%%f" "%MPGpath%%%~nf" "%MPGpath%%%~nf.BPRJ"
   CALL :QSFandCONVERT "%%f"
   MOVE "%%f" "%TSpath%"
   ECHO !DATE! !TIME! END ------------------ %%f >> "%vrdlog%" 2>&1
   ECHO !DATE! !TIME! END ------------------ %%f >> "%vrdlog%" 2>&1
   ECHO !DATE! !TIME! END ------------------ %%f 
)

ECHO !DATE! !TIME! --- START Modify Filenames
ECHO !DATE! !TIME! --- START Modify Filenames >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! cscript //Nologo ".\Rename_fix_mp4_bprj_files_in_a_folder.vbs" "n" "%ConvertedPath%" >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! cscript //Nologo ".\Rename_fix_mp4_bprj_files_in_a_folder.vbs" "n" "%ConvertedPath%"
cscript //Nologo ".\Rename_fix_mp4_bprj_files_in_a_folder.vbs" "y" "%ConvertedPath%" >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! --- END Modify Filenames
ECHO !DATE! !TIME! --- END Modify Filenames >> "%vrdlog%" 2>&1

ECHO !DATE! !TIME! --- START Modify DateCreated and DateModified Timestamps
ECHO !DATE! !TIME! --- START Modify DateCreated and DateModified Timestamps >> "%vrdlog%" 2>&1
set ps1_file=%sourcePath%%~n0-Modify_File_Date_Timestamps-%header%.ps1
DEL "%ps1_file%" > NUL: 2>&1
@echo off
ECHO # In a chosen folder ^(and recursed subfolders^) set the DateCreated and DateModified Timestamps >> "%ps1_file%" 2>&1
ECHO # on filenames with a matching date in the format yyyy-dmm-dd to that date. >> "%ps1_file%" 2>&1
ECHO # Call like this : >> "%ps1_file%" 2>&1
ECHO #	powershell -NoLogo -ExecutionPolicy Unrestricted -Sta -NonInteractive -WindowStyle Normal -File ".\Rename_files_selected_folders_ModifyDateStamps.ps1" -Folder "K:\mp4library\MOVIES" >> "%ps1_file%" 2>&1
ECHO #	powershell -NoLogo -ExecutionPolicy Unrestricted -Sta -NonInteractive -WindowStyle Normal -File ".\Rename_files_selected_folders_ModifyDateStamps.ps1" -Folder "T:\HDTV\autoTVS-mpg\Converted" >> "%ps1_file%" 2>&1
ECHO # 1. capture a commandline parameter 1 as a mandatory "Folder string" with a default value >> "%ps1_file%" 2>&1
ECHO param ^( [Parameter(Mandatory=$true)] [string]$Folder = "T:\HDTV\autoTVS-mpg\Converted" ^) >> "%ps1_file%" 2>&1
ECHO [console]::BufferWidth = 512 >> "%ps1_file%" 2>&1
ECHO $DateFormat = "yyyy-MM-dd" >> "%ps1_file%" 2>&1
ECHO write-output "Processing Folder: ",$Folder  >> "%ps1_file%" 2>&1
ECHO # 2. Iterate the files >> "%ps1_file%" 2>&1
ECHO $FileList = Get-ChildItem -Recurse $Folder -Include '*.mp4','*.bprj','*.ts' -File >> "%ps1_file%" 2>&1
ECHO foreach ^($FL_Item in $FileList^) { >> "%ps1_file%" 2>&1
ECHO 	$ixxx = $FL_Item.BaseName -match '^(^?^<DateString^>\d{4}-\d{2}-\d{2}^)' >> "%ps1_file%" 2>&1
ECHO     if^($ixxx^){ >> "%ps1_file%" 2>&1
ECHO         #write-output $FL_Item.FullName >> "%ps1_file%" 2>&1
ECHO         $DateString = $Matches.DateString >> "%ps1_file%" 2>&1
ECHO         $date_from_file = [datetime]::ParseExact^($DateString, $DateFormat, $Null^) >> "%ps1_file%" 2>&1
ECHO 		$FL_Item.CreationTime = $date_from_file >> "%ps1_file%" 2>&1
ECHO 		$FL_Item.LastWriteTime = $date_from_file >> "%ps1_file%" 2>&1
ECHO 		$FL_Item ^| Select-Object FullName,CreationTime,LastWriteTime >> "%ps1_file%" 2>&1
ECHO     } >> "%ps1_file%" 2>&1
ECHO } >> "%ps1_file%" 2>&1
ECHO # https://stackoverflow.com/questions/56211626/powershell-change-file-date-created-and-date-modified-based-on-filename >> "%ps1_file%" 2>&1
ECHO # Remember, when using a batch file to create the .ps1 file, we have to "escape" certain characters using the "hat" character >> "%ps1_file%" 2>&1
@echo on
ECHO powershell -NoLogo -ExecutionPolicy Unrestricted -Sta -NonInteractive -WindowStyle Normal -File "%ps1_file%" -Folder "T:\HDTV\autoTVS-mpg\Converted" >> "%vrdlog%" 2>&1
powershell -NoLogo -ExecutionPolicy Unrestricted -Sta -NonInteractive -WindowStyle Normal -File "%ps1_file%" -Folder "T:\HDTV\autoTVS-mpg\Converted" >> "%vrdlog%" 2>&1
REM ECHO powershell -NoLogo -ExecutionPolicy Unrestricted -Sta -NonInteractive -WindowStyle Normal -File "%ps1_file%" -Folder "K:\mp4library\MOVIES"  >> "%vrdlog%" 2>&1
REM powershell -NoLogo -ExecutionPolicy Unrestricted -Sta -NonInteractive -WindowStyle Normal -File "%ps1_file%" -Folder "K:\mp4library\MOVIES"  >> "%vrdlog%" 2>&1
DEL "%ps1_file%" > NUL: 2>&1
ECHO !DATE! !TIME! --- END Modify DateCreated and DateModified Timestamps
ECHO !DATE! !TIME! --- END Modify DateCreated and DateModified Timestamps >> "%vrdlog%" 2>&1

REM ***** ALLOW PC TO GO TO SLEEP AGAIN *****
REM "C:\000-PStools\pskill.exe" -t -nobanner "%iFile%" >> "%vrdlog%" 2>&1
taskkill /t /f /im "%iFile%" >> "%vrdlog%" 2>&1
del ".\%iFile%" >> "%vrdlog%" 2>&1
REM ***** ALLOW PC TO GO TO SLEEP AGAIN *****

%xPAUSE%

REM IF /I "%xPAUSE%" NEQ "PAUSE" (
REM    ECHO "!DATE! !TIME! Commencing hibernate shutdown /h" >> "%vrdlog%" 2>&1
REM    shutdown /h  >> "%vrdlog%" 2>&1
REM )

exit
REM -----------------------------------------------------------------------------------------------

:QSFandCONVERT
@setlocal ENABLEDELAYEDEXPANSION
@setlocal enableextensions
ECHO !DATE! !TIME! 
ECHO !DATE! !TIME! 
ECHO !DATE! !TIME! ***************************** start SUBROUTINE :QSFandCONVERT ***************************** 
ECHO !DATE! !TIME!  >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME!  >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! ***************************** start SUBROUTINE :QSFandCONVERT ***************************** >> "%vrdlog%" 2>&1
rem parameter 1 = input filename (.TS file)
REM %~1  -  expands %1 removing any surrounding quotes (") 
REM %~f1  -  expands %1 to a fully qualified path name 
REM %~d1  -  expands %1 to a drive letter only 
REM %~p1  -  expands %1 to a path only 
REM %~n1  -  expands %1 to a file name only 
REM %~x1  -  expands %1 to a file extension only 
REM %~s1  -  expanded path contains short names only 
REM %~a1  -  expands %1 to file attributes 
REM %~t1  -  expands %1 to date/time of file 
REM %~z1  -  expands %1 to size of file 
REM The modifiers can be combined to get compound results:
REM %~dp1  -  expands %1 to a drive letter and path only 
REM %~nx1  -  expands %1 to a file name and extension only 
REM ------------------------------ set audio parameters ------------------------------ 
set audiofreq=48000
set audiobitrate=384k
SET audiodelayadjms=010
set AudioDelayms=000
REM audiodelayadjms delays audio just a tad extra .01s so that it comes out after the lips move
REM AudioDelayms    is the final calculated delay for audio wioth audiodelayadjms added to it
SET lI=-16
SET lTP=0.0
SET lLRA=11
REM ------------------------------ Start set video parameters ------------------------------ 
set FPS=25
SET CRF=22
REM nvenc -preset slow :-
REM     hq                           E..V.... 
REM     slow                         E..V.... hq 2 passes
REM SET nv_preset=hq
SET nv_preset=slow
REM
REM configure the sharpen flags
SET sharpenflags=
REM pre-2017.11.27 IF /I "!sharpenthevideo!" == "true" (SET sharpenflags=,unsharp=opencl=1:luma_msize_x=3:luma_msize_y=3:luma_amount=0.5:chroma_msize_x=3:chroma_msize_y=3:chroma_amount=0.5)
IF /I "!sharpenthevideo!" == "true" (SET sharpenflags=,hwupload,unsharp_opencl=lx=3:ly=3:la=0.5:cx=3:cy=3:ca=0.5,hwdownload)
REM 2017.11.27 ... This OpenCL works on a 750Ti and 1050Ti
REM 2017.11.27 ... the new FFMPEG 3.5 has a new OpenCL way of doing things - the old method is obsolete and doesn't work
REM 2017.11.27 ... replace  these
REM 2017.11.27 ...        -nostats -opencl_options platform_idx=0:device_idx=0
REM 2017.11.27 ...        -filter:v yadif=0:0:0!sharpenflags!,setdar=dar=%theAR%
REM 2017.11.27 ... with these
REM 2017.11.27 ...        -hide_banner -nostats -v verbose -init_hw_device opencl=ocl:0.0 -filter_hw_device ocl
REM 2017.11.27 ...        -filter_complex "[0:v]yadif=0:0:0,hwupload,unsharp_opencl=lx=3:ly=3:la=0.5:cx=3:cy=3:ca=0.5,hwdownload,setdar=dar=16/9"
REM 2017.11.27 ...        -filter_complex "[0:v]yadif=0:0:0%sharpenflags%,setdar=dar=%theAR%"
REM
REM configure the b-frame, gop, back/forward reference flags
SET bfflags=
SET bfflags=-bf 2 -g 50
SET refsflags=
IF /I "%COMPUTERNAME%" == "3900X" SET refsflags=-refs 3
REM
REM See what the nvidica device id is - for my 750Ti and 1050Ti it is 0.0 as at 2018.12.06
ECHO !DATE! !TIME! >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! 1. "%ffmpegexex64%" -hide_banner -v verbose -init_hw_device list >> "%vrdlog%" 2>&1
"%ffmpegexex64%" -hide_banner -v verbose -init_hw_device list >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! 2. "%ffmpegexex64%" -hide_banner -v verbose -init_hw_device opencl >> "%vrdlog%" 2>&1
"%ffmpegexex64%" -hide_banner -v verbose -init_hw_device opencl >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! 3. "%ffmpegexex64%" -hide_banner -v verbose -init_hw_device opencl:0.0  >> "%vrdlog%" 2>&1
"%ffmpegexex64%" -hide_banner -v verbose -init_hw_device opencl:0.0  >> "%vrdlog%" 2>&1
REM ECHO !DATE! !TIME! >> "%vrdlog%" 2>&1
REM ECHO !DATE! !TIME! 4 "%ffmpegexex64%" -hide_banner -v verbose -h encoder=h264_nvenc  >> "%vrdlog%" 2>&1
REM "%ffmpegexex64%" -hide_banner -v verbose -h encoder=h264_nvenc  >> "%vrdlog%" 2>&1
REM ECHO !DATE! !TIME! >> "%vrdlog%" 2>&1
REM ECHO !DATE! !TIME! 5 "%ffmpegexex64%" -hide_banner -v verbose -h filter=yadif  >> "%vrdlog%" 2>&1
REM "%ffmpegexex64%" -hide_banner -v verbose -h filter=yadif  >> "%vrdlog%" 2>&1
REM ECHO !DATE! !TIME! >> "%vrdlog%" 2>&1
REM ECHO !DATE! !TIME! 6 "%ffmpegexex64%" -hide_banner -v verbose -h filter=unsharp_opencl  >> "%vrdlog%" 2>&1
REM "%ffmpegexex64%" -hide_banner -v verbose -h filter=unsharp_opencl  >> "%vrdlog%" 2>&1
SET OpenCL_device_init=-init_hw_device opencl=ocl:0.0 -filter_hw_device ocl
REM
ECHO !DATE! !TIME! sharpenthevideo="!sharpenthevideo!"
ECHO !DATE! !TIME! sharpenthevideo="!sharpenthevideo!" >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! sharpenflags="!sharpenflags!" 
ECHO !DATE! !TIME! sharpenflags="!sharpenflags!" >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! bfflags="!bfflags!" 
ECHO !DATE! !TIME! bfflags="!bfflags!" >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! refsflags="!refsflags!" 
ECHO !DATE! !TIME! refsflags="!refsflags!" >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! nv_preset="!nv_preset!" 
ECHO !DATE! !TIME! nv_preset="!nv_preset!" >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! OpenCL_device_init="!OpenCL_device_init!" 
ECHO !DATE! !TIME! OpenCL_device_init="!OpenCL_device_init!" >> "%vrdlog%" 2>&1
REM ------------------------------ End set video parameters ------------------------------ 
REM -------------------- find and set the codec type in the .TS file --------------------
REM set default QSF to mpeg2, and over-write those settings below as required
set vrd_profile=zzz-MPEG2ps-VRD6
set vrd_ext=.mpg
ECHO !DATE! !TIME! "!mediainfoexe!" --Legacy "--Inform=Video;%%Codec%%" "%~dpnx1" >> "%vrdlog%" 2>&1
"!mediainfoexe!" --Legacy "--Inform=Video;%%Codec%%" "%~dpnx1"
ECHO !DATE! !TIME! "!mediainfoexe!" --Legacy "--Inform=Video;%%Codec%%" "%~dpnx1" into file "%vrdlog%" >> "%vrdlog%" 2>&1
"!mediainfoexe!" --Legacy "--Inform=Video;%%Codec%%" "%~dpnx1" >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! "!mediainfoexe!" --Legacy "--Inform=Video;%%Codec%%" "%~dpnx1" into file "%tempfile%" >> "%vrdlog%" 2>&1
"!mediainfoexe!" --Legacy "--Inform=Video;%%Codec%%" "%~dpnx1" > "%tempfile%"
set /p theCodec= < "%tempfile%" 
ECHO !DATE! !TIME! TYPE "%tempfile%"
TYPE "%tempfile%" 
ECHO !DATE! !TIME! TYPE "%tempfile%" " >> "%vrdlog%" 2>&1
TYPE "%tempfile%"  >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! theCodec="!theCodec!" for "%~dpnx1"  
ECHO !DATE! !TIME! theCodec="!theCodec!" for "%~dpnx1"  >> "%vrdlog%" 2>&1
IF /I "!theCodec!" == "AVC" (
   set vrd_profile=zzz-H.264-MP4-general-VRD6
   set vrd_ext=.mp4
) 
IF /I "!theCodec!" == "MPEG-2V" (
   set vrd_profile=zzz-MPEG2ps-VRD6
   set vrd_ext=.mpg
)
ECHO !DATE! !TIME! vrd_ext="%vrdlog%" for "%~dpnx1"
ECHO !DATE! !TIME! vrd_ext="%vrdlog%" for "%~dpnx1"  >> "%vrdlog%" 2>&1
REM -------------------- find the audio delay (usually negative) in the .TS file --------------------
REM audiodelayadjms delays audio just a tad extra .01s so that it comes out after the lips move
REM AudioDelayms    is the final calculated delay for audio with audiodelayadjms added to 
"!mediainfoexe!" --Legacy "--Inform=Audio;%%Video_Delay%%" "%~dpnx1"  
ECHO !DATE! !TIME! "!mediainfoexe!" --Legacy "--Inform=Audio;%%Video_Delay%%" "%~dpnx1" >> "%vrdlog%" 2>&1
"!mediainfoexe!" --Legacy "--Inform=Audio;%%Video_Delay%%" "%~dpnx1" >> "%vrdlog%" 2>&1
"!mediainfoexe!" --Legacy "--Inform=Audio;%%Video_Delay%%" "%~dpnx1"  > "%tempfile%"
set /p AudioDelayms=< "%tempfile%"
ECHO !DATE! !TIME! type  "%tempfile%" >> "%vrdlog%" 2>&1
type  "%tempfile%"
type  "%tempfile%" >> "%vrdlog%" 2>&1
IF /I "!AudioDelayms!" == "" (set AudioDelayms=0)
ECHO !DATE! !TIME! unadjusted AudioDelayms=!AudioDelayms! in file "%~dpnx1" 
ECHO !DATE! !TIME! unadjusted AudioDelayms=!AudioDelayms! in file "%~dpnx1" >> "%vrdlog%" 2>&1
REM seems to need a 10ms adjustment, so add 10ms to the already negative delay
ECHO !DATE! !TIME! AudioDelayms="!AudioDelayms!" 
ECHO !DATE! !TIME! AudioDelayms="!AudioDelayms!" >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! audiodelayadjms="!audiodelayadjms!" 
ECHO !DATE! !TIME! audiodelayadjms="!audiodelayadjms!" >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! set /a AudioDelayms+=!audiodelayadjms! >> "%vrdlog%" 2>&1
set /a AudioDelayms+=!audiodelayadjms!
ECHO !DATE! !TIME! adjusted AudioDelayms=!AudioDelayms! in file "%~dpnx1" 
ECHO !DATE! !TIME! adjusted AudioDelayms=!AudioDelayms! in file "%~dpnx1" >> "%vrdlog%" 2>&1
REM since we use .mp4 intermediary files, simply use the notional 10ms adjustment and nothing more
set AudioDelayms=
set AudioDelayms=!audiodelayadjms!
ECHO !DATE! !TIME! re-adjusted AudioDelayms=!AudioDelayms! back to !audiodelayadjms! in file "%~dpnx1" 
ECHO !DATE! !TIME! re-adjusted AudioDelayms=!AudioDelayms! back to !audiodelayadjms! in file "%~dpnx1" >> "%vrdlog%" 2>&1
REM --------------------------------------------------------------------------
set inputTS=%~1
set intermediateVRDoutput=%MPGpath%%~n1%vrd_ext%
set convertedoutputMP4=%ConvertedPath%%~n1%.mp4
set convertedoutputBPRJ=%ConvertedPath%%~n1%.BPRJ
ECHO !DATE! !TIME! inputTS              ="%inputTS%" >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! intermediateVRDoutput="%intermediateVRDoutput%" >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! convertedoutputMP4   ="%convertedoutputMP4%" >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! convertedoutputBPRJ  ="%convertedoutputBPRJ%" >> "%vrdlog%" 2>&1
REM --------------------------------------------------------------------------
:try_qsf
REM attempt (retry) it up to 5 times because sometimes VRD crashes on output 
set /A c=1
:retry_qsf
ECHO !DATE! !TIME! -------------------- start processing "%~1" -------------------- >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! -------------------- start processing "%~1" -------------------- >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! -------------------- start processing "%~1" -------------------- >> "%vrdlog%" 2>&1
DEL "%intermediateVRDoutput%" >> "%vrdlog%" 2>&1
REM note we use a slightly modified vp.vbs which sets dimensions to filter for, etc. Check it at every VRD version change.
REM  old = cscript //Nologo "%PTH2adscan%\vp.vbs" "%inputTS%" "%intermediateVRDoutput%" /qsf /p %vrd_profile% /q /na
ECHO !DATE! !TIME! ***************************** start qsf on inputTS="%inputTS%" ***************************** >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! >> "%vrdlog%" 2>&1
REM ECHO !DATE! !TIME! START "cscript-!header!" /B /WAIT /NORMAL cscript //Nologo "%PTH2vbs%\vp-qsf-vrd6-v12.vbs" "%inputTS%" "%intermediateVRDoutput%" /qsf /p %vrd_profile% /q /na >> "%vrdlog%" 2>&1
REM START "cscript-!header!" /B /WAIT /NORMAL cscript //Nologo "%PTH2vbs%\vp-qsf-vrd6-v12.vbs" "%inputTS%" "%intermediateVRDoutput%" /qsf /p %vrd_profile% /q /na  >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! cscript //Nologo "%PTH2vbs%\vp-qsf-vrd6-v12.vbs" "%inputTS%" "%intermediateVRDoutput%" /qsf /p %vrd_profile% /q /na >> "%vrdlog%" 2>&1
cscript //Nologo "%PTH2vbs%\vp-qsf-vrd6-v12.vbs" "%inputTS%" "%intermediateVRDoutput%" /qsf /p %vrd_profile% /q /na  >> "%vrdlog%" 2>&1
SET EL=!ERRORLEVEL!
ECHO !DATE! !TIME! >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! ***************************** end qsf on inputTS="%inputTS%" ***************************** >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! ******** QSF ERRORLEVEL is !EL!  for "%intermediateVRDoutput%" >> "%vrdlog%" 2>&1
IF /I "!EL!" == "0" GOTO end_qsf
ECHO !DATE! !TIME! ******** non-zero QSF ERRORLEVEL !EL!  for "%intermediateVRDoutput%" >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! Error detected, at attempt number %c% about to try again ...  >> "%vrdlog%" 2>&1
del "%intermediateVRDoutput%"
ECHO !DATE! !TIME! --- renaming and copying to ensure a new set of disk block are used ...  >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! DEL "%inputTS%.vrd.tmp"  >> "%vrdlog%" 2>&1
DEL "%intermediateVRDoutput%.vrd.tmp"
ECHO !DATE! !TIME! MOVE /Y "%inputTS%" "%inputTS%.vrd.tmp" >> "%vrdlog%" 2>&1
MOVE /Y "%inputTS%" "%inputTS%.vrd.tmp" >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! COPY /B /V /Y /Z "%inputTS%.vrd.tmp" "%inputTS%" >> "%vrdlog%" 2>&1
COPY /B /V /Y /Z "%inputTS%.vrd.tmp" "%inputTS%" 
ECHO !DATE! !TIME! DEL "%inputTS%.vrd.tmp"
DEL "%inputTS%.vrd.tmp"
set /A c += 1
if %c% LSS 50 goto :retry_qsf
set /A c = c - 1
ECHO !DATE! !TIME! %inputTS% ?????????????? given up re-trying ...   >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! %inputTS% ?????????????? given up re-trying ...   >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! %inputTS% ?????????????? given up re-trying ...   >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! COPY /B /V /Y /Z "%inputTS%" "%TSGUpath%" >> "%vrdlog%" 2>&1
COPY /B /V /Y /Z "%inputTS%" "%TSGUpath%" 
ECHO !DATE! !TIME! -------------------- end gave up "%~1" -------------------- >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! -------------------- end gave up "%~1" -------------------- >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME!  >> "%vrdlog%" 2>&1
REM
goto :eof
:end_qsf
ECHO !DATE! !TIME! if we made it this far then the QSF worked and we have a valid intermediate .mpg or .mp4 file "%intermediateVRDoutput%"  >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! now use brute force ffmpeg to convert the intermediate file to a loudness-levelled .mp4  >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! intermediateVRDoutput=%intermediateVRDoutput% >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! ConvertedPath=%ConvertedPath% >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! theCodec="!theCodec!" so about to make "call" below based on that, for codec one of "AVC" or "MPEG-2V" >> "%vrdlog%" 2>&1
IF /I "!theCodec!" == "AVC" (
   ECHO !DATE! !TIME! theCodec="!theCodec!" so making call to ":avc_to_mp4" >> "%vrdlog%" 2>&1
   CALL :avc_to_mp4 "%intermediateVRDoutput%" "%convertedoutputMP4%"
   ECHO !DATE! !TIME! theCodec="!theCodec!" so made   call to ":avc_to_mp4" >> "%vrdlog%" 2>&1
) 
IF /I "!theCodec!" == "MPEG-2V" (
   ECHO !DATE! !TIME! theCodec="!theCodec!" so making call to ":mpg_to_mp4" >> "%vrdlog%" 2>&1
   CALL :mpg_to_mp4 "%intermediateVRDoutput%" "%convertedoutputMP4%"
   ECHO !DATE! !TIME! theCodec="!theCodec!" so made   call to ":mpg_to_mp4" >> "%vrdlog%" 2>&1
)
ECHO !DATE! !TIME! theCodec="!theCodec!" so should have made "call" above based on that, for codec one of "AVC" or "MPEG-2V" >> "%vrdlog%" 2>&1
:try_adscan
ECHO !DATE! !TIME! ***************************** start adscan on convertedoutputMP4="%convertedoutputMP4%" ***************************** >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! ....        makeaudiotype= "%makeaudiotype%" >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! ....   convertedoutputMP4= "%convertedoutputMP4%" >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! ....  convertedoutputBPRJ= "%convertedoutputBPRJ%" >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! del "%convertedoutputBPRJ%" >> "%vrdlog%" 2>&1
del "%convertedoutputBPRJ%" >> "%vrdlog%" 2>&1

IF /I "!do_adscan!" == "true" ( 
   REM ECHO !DATE! !TIME! START "cscript-!header!" /B /WAIT /NORMAL cscript //Nologo "%PTH2adscan%\adscan.vbs" "%convertedoutputMP4%" "%convertedoutputBPRJ%" /q >> "%vrdlog%" 2>&1
   REM START "cscript-!header!" /B /WAIT /NORMAL cscript //Nologo "%PTH2adscan%\adscan.vbs" "%convertedoutputMP4%" "%convertedoutputBPRJ%" /q  >> "%vrdlog%" 2>&1
   ECHO !DATE! !TIME! cscript //Nologo "%PTH2adscan%\adscan.vbs" "%convertedoutputMP4%" "%convertedoutputBPRJ%" /q >> "%vrdlog%" 2>&1
   cscript //Nologo "%PTH2adscan%\adscan.vbs" "%convertedoutputMP4%" "%convertedoutputBPRJ%" /q  >> "%vrdlog%" 2>&1
   SET EL=!ERRORLEVEL!
) ELSE (
   SET EL=0
)

IF /I "!EL!" NEQ "0" (
   ECHO !DATE! !TIME! *********  Error !EL! was found >> "%vrdlog%" 2>&1
   ECHO !DATE! !TIME! *********  Error !EL! was found >> "%vrdlog%" 2>&1
   ECHO !DATE! !TIME! *********  Error !EL! was found 
   ECHO !DATE! !TIME! *********  ABORTING ... >> "%vrdlog%" 2>&1
   %xpause%
   EXIT !EL!
)
ECHO !DATE! !TIME! >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! ***************************** end adscan on convertedoutputMP4="%convertedoutputMP4%" ***************************** >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! -------------------- end   "%~1" -------------------- >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! -------------------- end   "%~1" -------------------- >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME!  >> "%vrdlog%" 2>&1
DEL "%intermediateVRDoutput%"   >> "%vrdlog%" 2>&1
REM ------------------------------ finished  qsf and adscan ------------------------------ 
ECHO !DATE! !TIME! ***************************** end SUBROUTINE :QSFandCONVERT ***************************** >> "%vrdlog%" 2>&1
goto :eof





REM +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
REM +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
REM input is an AVC MP4 file - copy the video, convert the audio
REM +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
REM +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:avc_to_mp4
@setlocal ENABLEDELAYEDEXPANSION
@setlocal enableextensions
ECHO !DATE! !TIME! ***************************** start SUBROUTINE :avc_to_mp4 ***************************** >> "%vrdlog%" 2>&1
REM ------------------------------ final output file ------------------------------ 
REM assume parameter 2 isproperly set with its extension before this subroutine is called
set PARmp3mp4=%~f2
set PARaacmp4=%~f2
ECHO !DATE! !TIME! .... inside subroutine,     PARmp3mp4="%PARmp3mp4%" >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! .... inside subroutine,     PARaacmp4="%PARaacmp4%" >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! .... inside subroutine, makeaudiotype="%makeaudiotype%" >> "%vrdlog%" 2>&1
REM ------------------------------ temporary files ------------------------------ 
set PARtemp=%~dpn1%-temp.MP4
REM
set paraac=%~dpn1%-temp.aac
set parmp3=%~dpn1%-temp.mp3
REM
set PARF1tmp=%~dpn1%-temp.txt
SET jsonFile=%~dpn1%-temp.json
REM ------------------------------ video characteristics ------------------------------ 
"!mediainfoexe!" --Legacy --Inform=Video;%%FrameCount%% "%PARF1%" 
"!mediainfoexe!" --Legacy --Inform=Video;%%FrameCount%% "%PARF1%" > "%PARF1tmp%"
FOR /F "usebackq tokens=1" %%G IN ( "%PARF1tmp%" ) DO SET FRAMES=%%G
REM --frames "%FRAMES%" 
"!mediainfoexe!" --Legacy "--Inform=Video;%%FrameRate%%" "%~dpnx1"
"!mediainfoexe!" --Legacy "--Inform=Video;%%FrameRate%%" "%~dpnx1" > "%PARF1tmp%"
set /p fr=< "%PARF1tmp%"
REM
"!mediainfoexe!" --Legacy "--Inform=Video;%%Width%%" "%~dpnx1"
"!mediainfoexe!" --Legacy "--Inform=Video;%%Width%%" "%~dpnx1" > "%PARF1tmp%"
set /p w=< "%PARF1tmp%"
REM
"!mediainfoexe!" --Legacy "--Inform=Video;%%Height%%" "%~dpnx1"
"!mediainfoexe!" --Legacy "--Inform=Video;%%Height%%" "%~dpnx1" > "%PARF1tmp%"
set /p h=< "%PARF1tmp%"
REM
"!mediainfoexe!" --Legacy "--Inform=Video;%%DisplayAspectRatio/String%%" "%~dpnx1" 
"!mediainfoexe!" --Legacy "--Inform=Video;%%DisplayAspectRatio/String%%" "%~dpnx1" > "%PARF1tmp%"
set /p darS=< "%PARF1tmp%"
DEL "%PARF1tmp%"

set vbs2=.\evalAR.vbs
del "%vbs2%" > NUL: 2>&1
ECHO option explicit >> "%vbs2%"
ECHO dim inp, ninp >> "%vbs2%"
ECHO '''WScript.ECHO Eval(WScript.Arguments(0)) >> "%vbs2%"
ECHO inp = rtrim(ltrim(WScript.Arguments(0))) >> "%vbs2%"
ECHO if inp="16:9" then >> "%vbs2%"
ECHO    inp = "16/9" >> "%vbs2%"
ECHO elseif inp="4:3" then >> "%vbs2%"
ECHO    inp = "4/3" >> "%vbs2%"
ECHO else >> "%vbs2%"
ECHO    ninp = CDbl(inp) >> "%vbs2%"
ECHO    if ninp ^> 1.6 then >> "%vbs2%"
ECHO       inp = "16/9" >> "%vbs2%"
ECHO    else >> "%vbs2%"
ECHO       inp = "4/3" >> "%vbs2%"
ECHO    end if >> "%vbs2%"
ECHO end if >> "%vbs2%"
ECHO WScript.ECHO inp >> "%vbs2%"
for /f %%n in ('cscript //nologo "%vbs2%" "%darS%"') do (set theAR=%%n)
ECHO  !DATE! !TIME!  theAR="%theAR%"
del "%vbs2%"
REM set the SAR depending on PAL or not (eg NTSC framerate)
REM IF "%fr%"=="25.000" (
REM    IF "%theAR%"=="16/9" (SET theSAR=64:45)
REM    IF "%theAR%"=="16/9" (SET theSARs=64_45)
REM    IF "%theAR%"=="4/3"  (SET theSAR=12:11)
REM    IF "%theAR%"=="4/3"  (SET theSARs=12_11)
REM ) ELSE (
REM    IF "%theAR%"=="16/9" (SET theSAR=40:33)
REM    IF "%theAR%"=="16/9" (SET theSARs=40_33)
REM    IF "%theAR%"=="4/3"  (SET theSAR=10:11)
REM    IF "%theAR%"=="16/9" (SET theSARs=10_11)
REM )
REM IF %w% GEQ 720 (SET theSAR=1:1)
REM IF %w% GEQ 720 (SET theSARs=1_1)
IF "%fr%"=="25.000" (
   IF "%theAR%"=="16/9" (SET theSAR=64:45)
   IF "%theAR%"=="16/9" (SET theSARs=64_45)
   IF "%theAR%"=="4/3"  (SET theSAR=12:11)
   IF "%theAR%"=="4/3"  (SET theSARs=12_11)
REM over-ride 16:9 for the time being with 1:1
   IF "%theAR%"=="16/9" (SET theSAR=1:1)
   IF "%theAR%"=="16/9" (SET theSARs=1_1)
) ELSE (
   IF "%theAR%"=="16/9" (SET theSAR=40:33)
   IF "%theAR%"=="16/9" (SET theSARs=40_33)
   IF "%theAR%"=="4/3"  (SET theSAR=10:11)
   IF "%theAR%"=="16/9" (SET theSARs=10_11)
REM over-ride 16:9 for the time being with 1:1
   IF "%theAR%"=="16/9" (SET theSAR=1:1)
   IF "%theAR%"=="16/9" (SET theSARs=1_1)
)
ECHO !DATE! !TIME! adjusting theSAR based on clip width - w="%w%"  h="%h%" >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! fr="%fr%" >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! darS="%darS%" >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! theAR="%theAR%" >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! theSAR="%theSAR%" >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! theSARs="%theSARs%" >> "%vrdlog%" 2>&1
IF %w% GEQ 720 (SET theSAR=1:1) 
IF %w% GEQ 720 (SET theSARs=1_1)
ECHO !DATE! !TIME! after adjustment theSAR="%theSAR%" >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! after adjustment theSARs="%theSARs%" >> "%vrdlog%" 2>&1
REM ------------------------------ audio characteristics ------------------------------ 
REM to adjust Audio volume. find the loudness parameters in a first pass
ECHO !DATE! !TIME! ***************************** start Find Audio Loudness ***************************** >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME!  "%~f1" ...
ECHO !DATE! !TIME! "%ffmpegexex64%" -nostats -nostdin -y -hide_banner -i "%~1" -threads 0 -vn -af loudnorm=I=%lI%:TP=%lTP%:LRA=%lLRA%:print_format=json -f null - >> "%vrdlog%" 2>&1
"%ffmpegexex64%" -nostats -nostdin -y -hide_banner -i "%~1" -threads 0 -vn -af loudnorm=I=%lI%:TP=%lTP%:LRA=%lLRA%:print_format=json -f null - 2> "%jsonFile%"  
SET EL=!ERRORLEVEL!
IF /I "!EL!" NEQ "0" (
   ECHO !DATE! !TIME! *********  Error !EL! was found >> "%vrdlog%" 2>&1
   ECHO !DATE! !TIME! *********  Error !EL! was found >> "%vrdlog%" 2>&1
   ECHO !DATE! !TIME! *********  Error !EL! was found 
   ECHO !DATE! !TIME! *********  ABORTING ... >> "%vrdlog%" 2>&1
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
REM   ECHO !DATE! !TIME! .!var!.=.!val!.
   IF "!var!" == "input_i"         set !var!=!val!
   IF "!var!" == "input_tp"        set !var!=!val!
   IF "!var!" == "input_lra"       set !var!=!val!
   IF "!var!" == "input_thresh"    set !var!=!val!
   IF "!var!" == "target_offset"   set !var!=!val!
)
ECHO !DATE! !TIME! input_i=%input_i% >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! input_tp=%input_tp% >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! input_lra=%input_lra% >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! input_thresh=%input_thresh% >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! target_offset=%target_offset% >> "%vrdlog%" 2>&1
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
REM later, in a second encoding pass we MUST down-convert from 192k (loadnorm upsamples it to 192k whis is way way too high ... use  -ar 48k or -ar 48000
REM
IF /I "%AUDprocess%" == "loudnorm" (
   ECHO !DATE! !TIME! "Proceeding with normal LOUDNORM audio normalisation ..."  >> "%vrdlog%" 2>&1
   ECHO !DATE! !TIME! "Proceeding with normal LOUDNORM audio normalisation ..."
   set loudnormfilter=loudnorm=I=%lI%:TP=%lTP%:LRA=%lLRA%:measured_I=%input_i%:measured_LRA=%input_lra%:measured_TP=%input_tp%:measured_thresh=%input_thresh%:offset=%target_offset%:linear=true:print_format=summary
   ECHO !DATE! !TIME! "loudnormfilter=%loudnormfilter%" >> "%vrdlog%" 2>&1
) ELSE (
   ECHO !DATE! !TIME! "********* ERROR VALUES DETECTED FROM LOUDNORM - Doing UNUSUAL dynaudnorm audio normalisation instead ..." >> "%vrdlog%" 2>&1
   ECHO !DATE! !TIME! "********* ERROR VALUES DETECTED FROM LOUDNORM - Doing UNUSUAL dynaudnorm audio normalisation instead ..." >> "%vrdlog%" 2>&1
   ECHO !DATE! !TIME! "********* ERROR VALUES DETECTED FROM LOUDNORM - Doing UNUSUAL dynaudnorm audio normalisation instead ..."
   ECHO !DATE! !TIME! "********* ERROR VALUES DETECTED FROM LOUDNORM - Doing UNUSUAL dynaudnorm audio normalisation instead ..."
   set loudnormfilter=dynaudnorm
   ECHO !DATE! !TIME! "loudnormfilter=%loudnormfilter% (Should be dynaudnorm)" >> "%vrdlog%" 2>&1
)
ECHO !DATE! !TIME! ***************************** end Find Audio Loudness ***************************** >> "%vrdlog%" 2>&1
REM ------------------------------ audio conversion ------------------------------ 
REM ----- from v12, no separate audio conversion defer it to doing combined audio/video conversion -----
REM ECHO !DATE! !TIME! ***************************** start ffmpeg %makeaudiotype% AUDIO conversion ***************************** >> "%vrdlog%" 2>&1
REM aac audio conversion "%~f1" ...
REM IF /I "%makeaudiotype%" == "aac" (
REM ECHO !DATE! !TIME!  aac audio conversion "%~f1" ... >> "%vrdlog%" 2>&1
REM ECHO !DATE! !TIME!  aac audio conversion "%~f1" ...
REM ECHO !DATE! !TIME! "%ffmpegexex64%" -nostats -i "%~1" -vn -map_metadata -1 -af %loudnormfilter% -c:a libfdk_aac -cutoff 18000 -ab %audiobitrate% -ar %audiofreq% -y "%paraac%"  >> "%vrdlog%" 2>&1
REM "%ffmpegexex64%" -nostats -i "%~1" -vn -map_metadata -1 -af %loudnormfilter% -c:a libfdk_aac -cutoff 18000 -ab %audiobitrate% -ar %audiofreq% -y "%paraac%"  >> "%vrdlog%" 2>&1
REM SET EL=!ERRORLEVEL!
REM IF /I "!EL!" NEQ "0" (
REM    ECHO !DATE! !TIME! *********  Error !EL! was found >> "%vrdlog%" 2>&1
REM    ECHO !DATE! !TIME! *********  Error !EL! was found >> "%vrdlog%" 2>&1
REM    ECHO !DATE! !TIME! *********  Error !EL! was found 
REM    ECHO !DATE! !TIME! *********  ABORTING ... >> "%vrdlog%" 2>&1
REM    %xpause%
REM    EXIT !EL!
REM )
REM )
REM ECHO !DATE! !TIME! ***************************** end ffmpeg %makeaudiotype% AUDIO conversion ***************************** >> "%vrdlog%" 2>&1
REM ------------------------------ video conversion ------------------------------ 
ECHO !DATE! !TIME! ***************************** start ffmpeg combined AUDIO/VIDEO conversion ***************************** >> "%vrdlog%" 2>&1
REM overriding video stream copy aspect ratio with -aspect %theAR% may produce invalid streams, so don't
ECHO !DATE! !TIME! don't forget audio sync won't work unless the output file here is a ".mp4" ... >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME!  "%~f1" ...
REM ECHO !DATE! !TIME! "%ffmpegexex64%"  -nostats -i "%~1" -an -map_metadata -1 -c:v copy -map_metadata -1 -strict experimental -movflags +faststart+write_colr -y "%%PARtemp%" >> "%vrdlog%" 2>&1
REM "%ffmpegexex64%" -nostats -i "%~1" -an -map_metadata -1 -c:v copy -map_metadata -1 -strict experimental -movflags +faststart+write_colr -y "%%PARtemp%"  >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! "%ffmpegexex64%"  -nostats -i "%~1" -map_metadata -1 -c:v copy -map_metadata -1 -af %loudnormfilter% -c:a libfdk_aac -cutoff 18000 -ab %audiobitrate% -ar %audiofreq% -strict experimental -movflags +faststart+write_colr -y "%PARaacmp4%" >> "%vrdlog%" 2>&1
"%ffmpegexex64%" -nostats -i "%~1" -map_metadata -1 -c:v copy -map_metadata -1 -af %loudnormfilter% -c:a libfdk_aac -cutoff 18000 -ab %audiobitrate% -ar %audiofreq% -strict experimental -movflags +faststart+write_colr -y "%PARaacmp4%"  >> "%vrdlog%" 2>&1
SET EL=!ERRORLEVEL!
IF /I "!EL!" NEQ "0" (
   ECHO !DATE! !TIME! *********  Error !EL! was found >> "%vrdlog%" 2>&1
   ECHO !DATE! !TIME! *********  Error !EL! was found >> "%vrdlog%" 2>&1
   ECHO !DATE! !TIME! *********  Error !EL! was found 
   ECHO !DATE! !TIME! *********  ABORTING ... >> "%vrdlog%" 2>&1
   %xpause%
   EXIT !EL!
)
ECHO !DATE! !TIME! ***************************** end ffmpeg combined AUDIO/VIDEO conversion ***************************** >> "%vrdlog%" 2>&1
REM ------------------------------ MUX the video and audio ------------------------------ 
REM ----- from v12, no separate MUXing required, audio/video are now done "as one" -----
REM ECHO !DATE! !TIME! ***************************** start mp4box %makeaudiotype% muxing ***************************** >> "%vrdlog%" 2>&1
REM ECHO !DATE! !TIME! https://gpac.wp.mines-telecom.fr/mp4box/mp4box-documentation/ >> "%vrdlog%" 2>&1
REM aac video conversion
REM IF /I "%makeaudiotype%" == "aac" (
REM ECHO !DATE! !TIME!  aac muxing "%~f1" ... >> "%vrdlog%" 2>&1
REM ECHO !DATE! !TIME!  aac muxing "%~f1" ...
REM ECHO !DATE! !TIME! "%mp4boxexex64%" -add "%PARtemp%":lang=eng -add "%paraac%":lang=eng:delay=!AudioDelayms! -isma -new "%PARaacmp4%" >> "%vrdlog%" 2>&1
REM "%mp4boxexex64%" -add "%PARtemp%":lang=eng -add "%paraac%":lang=eng:delay=!AudioDelayms! -isma -new "%PARaacmp4%" >> "%vrdlog%" 2>&1
REM SET EL=!ERRORLEVEL!
REM IF /I "!EL!" NEQ "0" (
REM    ECHO !DATE! !TIME! *********  Error !EL! was found >> "%vrdlog%" 2>&1
REM    ECHO !DATE! !TIME! *********  Error !EL! was found >> "%vrdlog%" 2>&1
REM    ECHO !DATE! !TIME! *********  Error !EL! was found 
REM    ECHO !DATE! !TIME! *********  ABORTING ... >> "%vrdlog%" 2>&1
REM    %xpause%
REM    EXIT !EL!
REM )
REM ECHO !DATE! !TIME! ...  MP4BOX wrote file = "!PARaacmp4!" >> "%vrdlog%" 2>&1
REM ECHO !DATE! !TIME! ... convertedoutputMP4 = "!convertedoutputMP4!" >> "%vrdlog%" 2>&1
REM ECHO !DATE! !TIME! ...     makeaudiotype = "!makeaudiotype!" >> "%vrdlog%" 2>&1
REM )
REM ECHO !DATE! !TIME! ***************************** end mp4box %makeaudiotype% muxing ***************************** >> "%vrdlog%" 2>&1
REM 
DEL "%PARtemp%"
DEL "%parmp3%"
DEL "%paraac%"
DEL "%jsonFile%"
DEL "%tempfile%"
REM ------------------------------ finished  mp4 to mp4 ------------------------------ 
ECHO !DATE! !TIME! ***************************** end SUBROUTINE :avc_to_mp4 ***************************** >> "%vrdlog%" 2>&1
goto :eof





REM +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
REM +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
REM input is an MPEG2 MPG file - convert the video, convert the audio
REM +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
REM +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:mpg_to_mp4
@setlocal ENABLEDELAYEDEXPANSION
@setlocal enableextensions
ECHO !DATE! !TIME! ***************************** start SUBROUTINE :mpg_to_mp4 ***************************** >> "%vrdlog%" 2>&1
REM ------------------------------ final output file ------------------------------ 
REM assume parameter 2 is properly set with its extension before this subroutine is called
set PARmp3mp4=%~f2
set PARaacmp4=%~f2
ECHO !DATE! !TIME! .... inside subroutine,     PARmp3mp4="%PARmp3mp4%" >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! .... inside subroutine,     PARaacmp4="%PARaacmp4%" >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! .... inside subroutine, makeaudiotype="%makeaudiotype%" >> "%vrdlog%" 2>&1
REM ------------------------------ temporary files ------------------------------ 
set PARtemp=%~dpn1%-temp.MP4
REM
set paraac=%~dpn1%-temp.aac
set parmp3=%~dpn1%-temp.mp3
REM
set PARF1tmp=%~dpn1%-temp.txt
SET jsonFile=%~dpn1%-temp.json
REM ------------------------------ video characteristics ------------------------------ 
"!mediainfoexe!" --Legacy --Inform=Video;%%FrameCount%% "%PARF1%" 
"!mediainfoexe!" --Legacy --Inform=Video;%%FrameCount%% "%PARF1%" > "%PARF1tmp%"
FOR /F "usebackq tokens=1" %%G IN ( "%PARF1tmp%" ) DO SET FRAMES=%%G
REM --frames "%FRAMES%" 
"!mediainfoexe!" --Legacy "--Inform=Video;%%FrameRate%%" "%~dpnx1"
"!mediainfoexe!" --Legacy "--Inform=Video;%%FrameRate%%" "%~dpnx1" > "%PARF1tmp%"
set /p fr=< "%PARF1tmp%"
REM
"!mediainfoexe!" --Legacy "--Inform=Video;%%Width%%" "%~dpnx1"
"!mediainfoexe!" --Legacy "--Inform=Video;%%Width%%" "%~dpnx1" > "%PARF1tmp%"
set /p w=< "%PARF1tmp%"
REM
"!mediainfoexe!" --Legacy "--Inform=Video;%%Height%%" "%~dpnx1"
"!mediainfoexe!" --Legacy "--Inform=Video;%%Height%%" "%~dpnx1" > "%PARF1tmp%"
set /p h=< "%PARF1tmp%"
REM
"!mediainfoexe!" --Legacy "--Inform=Video;%%DisplayAspectRatio/String%%" "%~dpnx1" 
"!mediainfoexe!" --Legacy "--Inform=Video;%%DisplayAspectRatio/String%%" "%~dpnx1" > "%PARF1tmp%"
set /p darS=< "%PARF1tmp%"
DEL "%PARF1tmp%"

set vbs2=.\evalAR.vbs
del "%vbs2%" > NUL: 2>&1
ECHO  option explicit >> "%vbs2%"
ECHO  dim inp, ninp >> "%vbs2%"
ECHO  '''WScript.ECHO  Eval(WScript.Arguments(0)) >> "%vbs2%"
ECHO  inp = rtrim(ltrim(WScript.Arguments(0))) >> "%vbs2%"
ECHO  if inp="16:9" then >> "%vbs2%"
ECHO     inp = "16/9" >> "%vbs2%"
ECHO  elseif inp="4:3" then >> "%vbs2%"
ECHO     inp = "4/3" >> "%vbs2%"
ECHO  else >> "%vbs2%"
ECHO     ninp = CDbl(inp) >> "%vbs2%"
ECHO     if ninp ^> 1.6 then >> "%vbs2%"
ECHO        inp = "16/9" >> "%vbs2%"
ECHO     else >> "%vbs2%"
ECHO        inp = "4/3" >> "%vbs2%"
ECHO     end if >> "%vbs2%"
ECHO  end if >> "%vbs2%"
ECHO  WScript.ECHO  inp >> "%vbs2%"
for /f %%n in ('cscript //nologo "%vbs2%" "%darS%"') do (set theAR=%%n)
ECHO !DATE! !TIME! theAR="%theAR%"
del "%vbs2%"
REM set the SAR depending on PAL or not (eg NTSC framerate)
REM IF "%fr%"=="25.000" (
REM    IF "%theAR%"=="16/9" (SET theSAR=64:45)
REM    IF "%theAR%"=="16/9" (SET theSARs=64_45)
REM    IF "%theAR%"=="4/3"  (SET theSAR=12:11)
REM    IF "%theAR%"=="4/3"  (SET theSARs=12_11)
REM ) ELSE (
REM    IF "%theAR%"=="16/9" (SET theSAR=40:33)
REM    IF "%theAR%"=="16/9" (SET theSARs=40_33)
REM    IF "%theAR%"=="4/3"  (SET theSAR=10:11)
REM    IF "%theAR%"=="16/9" (SET theSARs=10_11)
REM )
REM IF %w% GEQ 720 (SET theSAR=1:1)
REM IF %w% GEQ 720 (SET theSARs=1_1)
IF "%fr%"=="25.000" (
   IF "%theAR%"=="16/9" (SET theSAR=64:45)
   IF "%theAR%"=="16/9" (SET theSARs=64_45)
   IF "%theAR%"=="4/3"  (SET theSAR=12:11)
   IF "%theAR%"=="4/3"  (SET theSARs=12_11)
REM over-ride 16:9 for the time being with 1:1
   IF "%theAR%"=="16/9" (SET theSAR=1:1)
   IF "%theAR%"=="16/9" (SET theSARs=1_1)
) ELSE (
   IF "%theAR%"=="16/9" (SET theSAR=40:33)
   IF "%theAR%"=="16/9" (SET theSARs=40_33)
   IF "%theAR%"=="4/3"  (SET theSAR=10:11)
   IF "%theAR%"=="16/9" (SET theSARs=10_11)
REM over-ride 16:9 for the time being with 1:1
   IF "%theAR%"=="16/9" (SET theSAR=1:1)
   IF "%theAR%"=="16/9" (SET theSARs=1_1)
)
ECHO !DATE! !TIME! adjusting theSAR based on clip width - w="%w%"  h="%h%" >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! fr="%fr%" >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! darS="%darS%" >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! theAR="%theAR%" >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! theSAR="%theSAR%" >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! theSARs="%theSARs%" >> "%vrdlog%" 2>&1
IF %w% GEQ 720 (SET theSAR=1:1) 
IF %w% GEQ 720 (SET theSARs=1_1)
ECHO !DATE! !TIME! after adjustment theSAR="%theSAR%" >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! after adjustment theSARs="%theSARs%" >> "%vrdlog%" 2>&1
REM ------------------------------ audio characteristics ------------------------------ 
REM to adjust Audio volume. find the loudness parameters in a first pass
ECHO !DATE! !TIME! ***************************** start Find Audio Loudness ***************************** >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME!  "%~f1" ...
ECHO !DATE! !TIME! "%ffmpegexex64%" -nostats -nostdin -y -hide_banner -i "%~1" -threads 0 -vn -af loudnorm=I=%lI%:TP=%lTP%:LRA=%lLRA%:print_format=json -f null - >> "%vrdlog%" 2>&1
"%ffmpegexex64%" -nostats -nostdin -y -hide_banner -i "%~1" -threads 0 -vn -af loudnorm=I=%lI%:TP=%lTP%:LRA=%lLRA%:print_format=json -f null - 2> "%jsonFile%"  
SET EL=!ERRORLEVEL!
IF /I "!EL!" NEQ "0" (
   ECHO !DATE! !TIME! *********  Error !EL! was found >> "%vrdlog%" 2>&1
   ECHO !DATE! !TIME! *********  Error !EL! was found >> "%vrdlog%" 2>&1
   ECHO !DATE! !TIME! *********  Error !EL! was found 
   ECHO !DATE! !TIME! *********  ABORTING ... >> "%vrdlog%" 2>&1
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
REM   ECHO !DATE! !TIME! .!var!.=.!val!.
   IF "!var!" == "input_i"         set !var!=!val!
   IF "!var!" == "input_tp"        set !var!=!val!
   IF "!var!" == "input_lra"       set !var!=!val!
   IF "!var!" == "input_thresh"    set !var!=!val!
   IF "!var!" == "target_offset"   set !var!=!val!
)
ECHO !DATE! !TIME! input_i=%input_i% >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! input_tp=%input_tp% >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! input_lra=%input_lra% >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! input_thresh=%input_thresh% >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! target_offset=%target_offset% >> "%vrdlog%" 2>&1
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
REM later, in a second encoding pass we MUST down-convert from 192k (loadnorm upsamples it to 192k whis is way way too high ... use  -ar 48k or -ar 48000
REM
IF /I "%AUDprocess%" == "loudnorm" (
   ECHO !DATE! !TIME! "Proceeding with normal LOUDNORM audio normalisation ..."  >> "%vrdlog%" 2>&1
   ECHO !DATE! !TIME! "Proceeding with normal LOUDNORM audio normalisation ..."
   set loudnormfilter=loudnorm=I=%lI%:TP=%lTP%:LRA=%lLRA%:measured_I=%input_i%:measured_LRA=%input_lra%:measured_TP=%input_tp%:measured_thresh=%input_thresh%:offset=%target_offset%:linear=true:print_format=summary
   ECHO !DATE! !TIME! "loudnormfilter=%loudnormfilter%" >> "%vrdlog%" 2>&1
) ELSE (
   ECHO !DATE! !TIME! "********* ERROR VALUES DETECTED FROM LOUDNORM - Doing UNUSUAL dynaudnorm audio normalisation instead ..." >> "%vrdlog%" 2>&1
   ECHO !DATE! !TIME! "********* ERROR VALUES DETECTED FROM LOUDNORM - Doing UNUSUAL dynaudnorm audio normalisation instead ..." >> "%vrdlog%" 2>&1
   ECHO !DATE! !TIME! "********* ERROR VALUES DETECTED FROM LOUDNORM - Doing UNUSUAL dynaudnorm audio normalisation instead ..."
   ECHO !DATE! !TIME! "********* ERROR VALUES DETECTED FROM LOUDNORM - Doing UNUSUAL dynaudnorm audio normalisation instead ..."
   set loudnormfilter=dynaudnorm
   ECHO !DATE! !TIME! "loudnormfilter=%loudnormfilter% (Should be dynaudnorm)" >> "%vrdlog%" 2>&1
)
ECHO !DATE! !TIME! ***************************** end Find Audio Loudness ***************************** >> "%vrdlog%" 2>&1
REM ------------------------------ audio conversion ------------------------------ 
REM ----- from v12, no separate audio conversion defer it to doing combined audio/video conversion -----
REM ECHO !DATE! !TIME! ***************************** start ffmpeg %makeaudiotype% AUDIO conversion ***************************** >> "%vrdlog%" 2>&1
REM aac audio conversion
REM IF /I "%makeaudiotype%" == "aac" (
REM ECHO !DATE! !TIME!  aac audio conversion "%~f1" ... >> "%vrdlog%" 2>&1
REM ECHO !DATE! !TIME!  aac audio conversion "%~f1" ...
REM ECHO !DATE! !TIME! "%ffmpegexex64%" -nostats -i "%~1" -vn -map_metadata -1 -af %loudnormfilter% -c:a libfdk_aac -cutoff 18000 -ab %audiobitrate% -ar %audiofreq% -y "%paraac%"  >> "%vrdlog%" 2>&1
REM "%ffmpegexex64%" -nostats -i "%~1" -vn -map_metadata -1 -af %loudnormfilter% -c:a libfdk_aac -cutoff 18000 -ab %audiobitrate% -ar %audiofreq% -y "%paraac%"  >> "%vrdlog%" 2>&1
REM SET EL=!ERRORLEVEL!
REM IF /I "!EL!" NEQ "0" (
REM    ECHO !DATE! !TIME! *********  Error !EL! was found >> "%vrdlog%" 2>&1
REM    ECHO !DATE! !TIME! *********  Error !EL! was found >> "%vrdlog%" 2>&1
REM    ECHO !DATE! !TIME! *********  Error !EL! was found 
REM    ECHO !DATE! !TIME! *********  ABORTING ... >> "%vrdlog%" 2>&1
REM    %xpause%
REM    EXIT !EL!
REM )
REM )
REM ECHO !DATE! !TIME! ***************************** end ffmpeg %makeaudiotype% AUDIO conversion  ***************************** >> "%vrdlog%" 2>&1
REM ------------------------------ video conversion ------------------------------ 
ECHO !DATE! !TIME! ***************************** start ffmpeg combined AUDIO/VIDEO conversion ***************************** >> "%vrdlog%" 2>&1
REM PROCESS VIDEO with ffmpeg encoder
REM https://developer.nvidia.com/nvidia-video-codec-sdk ... shows encoding speed comparisons between cards
REM https://developer.nvidia.com/search/gss/nvenc
REM http://forums.guru3d.com/showthread.php?p=5369397
REM ffmpeg -h encoder=h264_nvenc
REM -refs 1 = limit to one reference frame (for broader H.264 player compatibility). Apparently 3 for more quality.
REM -bf 2   = add B-frames. These are the most efficient frames in the H.264 standard. 
REM -g 50   = limit to GOP size.
REM Try these :-
REM -bf 2 -g 25 -refs 1
REM -bf 2 -g 50 -refs 1
REM -bf 2 -g 75 -refs 1   <-- sweet spot
REM -bf 3 -g 25 -refs 1
REM -bf 3 -g 50 -refs 1
REM -bf 3 -g 75 -refs 1
REM
REM DEINTERLACE with yadif, slightly sharpen luma and chroma, encode with h264_nvenc
ECHO !DATE! !TIME! about to convert video, sharpenflags="!sharpenflags!" 
ECHO !DATE! !TIME! about to convert video, sharpenflags="!sharpenflags!" >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! "%~f1" ...
REM i4670 and i3820 both use -opencl_options platform_idx=0:device_idx=0
REM old ...
REM ECHO !DATE! !TIME! "%ffmpegexex64%" -nostats -opencl_options platform_idx=0:device_idx=0 -i "%~1" -an -map_metadata -1 -sws_flags lanczos+accurate_rnd+full_chroma_int+full_chroma_inp -filter:v yadif=0:0:0!sharpenflags!,setdar=dar=%theAR% -c:v h264_nvenc -pix_fmt nv12 -preset %nv_preset% !bfflags! !refsflags! -rc:v constqp -global_quality %crf% -coder cabac -strict experimental -movflags +faststart+write_colr -profile:v high -level 5.1  -y "%PARtemp%" >> "%vrdlog%" 2>&1
REM "%ffmpegexex64%" -nostats -opencl_options platform_idx=0:device_idx=0 -i "%~1" -an -map_metadata -1 -sws_flags lanczos+accurate_rnd+full_chroma_int+full_chroma_inp -filter:v yadif=0:0:0!sharpenflags!,setdar=dar=%theAR% -c:v h264_nvenc -pix_fmt nv12 -preset %nv_preset% !bfflags! !refsflags! -rc:v constqp -global_quality %crf% -coder cabac -strict experimental -movflags +faststart+write_colr -profile:v high -level 5.1  -y "%PARtemp%" >> "%vrdlog%" 2>&1
REM SET EL=!ERRORLEVEL!
REM 
REM new ... doesn't work on a 650 card :( but does on a 750Ti and 1050Ti
REM ECHO !DATE! !TIME! "%ffmpegexex64%" -nostats -opencl_options platform_idx=0:device_idx=0 -i "%~1" -an -map_metadata -1 -sws_flags lanczos+accurate_rnd+full_chroma_int+full_chroma_inp -filter:v yadif=0:0:0!sharpenflags!,setdar=dar=%theAR% -c:v h264_nvenc -pix_fmt nv12 -preset %nv_preset% !bfflags! !refsflags! -rc:v vbr_hq -rc-lookahead:v 32 -cq 22 -qmin 16 -qmax 25 -coder cabac -strict experimental -movflags +faststart+write_colr -profile:v high -level 5.1  -y "%PARtemp%" >> "%vrdlog%" 2>&1
REM "%ffmpegexex64%" -nostats -opencl_options platform_idx=0:device_idx=0 -i "%~1" -an -map_metadata -1 -sws_flags lanczos+accurate_rnd+full_chroma_int+full_chroma_inp -filter:v yadif=0:0:0!sharpenflags!,setdar=dar=%theAR% -c:v h264_nvenc -pix_fmt nv12 -preset %nv_preset% !bfflags! !refsflags! -rc:v vbr_hq -rc-lookahead:v 32 -cq 22 -qmin 16 -qmax 25 -coder cabac -strict experimental -movflags +faststart+write_colr -profile:v high -level 5.1  -y "%PARtemp%" >> "%vrdlog%" 2>&1
REM 
REM this is the new ffmpeg 3.5 usage of OpenCL
REM ECHO !DATE! !TIME! "%ffmpegexex64%" -hide_banner -nostats -v verbose !OpenCL_device_init! -i "%~1" -an -map_metadata -1 -sws_flags lanczos+accurate_rnd+full_chroma_int+full_chroma_inp -filter_complex "[0:v]yadif=0:0:0!sharpenflags!,format=pix_fmts=yuv420p,setdar=dar=!theAR!" -c:v h264_nvenc -pix_fmt nv12 -preset !nv_preset! !bfflags! !refsflags! -rc:v vbr_hq -rc-lookahead:v 32 -cq 22 -qmin 16 -qmax 25 -coder cabac -strict experimental -movflags +faststart+write_colr -profile:v high -level 5.1  -y "%PARtemp%" >> "%vrdlog%" 2>&1
REM "%ffmpegexex64%" -hide_banner -nostats -v verbose !OpenCL_device_init! -i "%~1" -an -map_metadata -1 -sws_flags lanczos+accurate_rnd+full_chroma_int+full_chroma_inp -filter_complex "[0:v]yadif=0:0:0!sharpenflags!,format=pix_fmts=yuv420p,setdar=dar=!theAR!" -c:v h264_nvenc -pix_fmt nv12 -preset !nv_preset! !bfflags! !refsflags! -rc:v vbr_hq -rc-lookahead:v 32 -cq 22 -qmin 16 -qmax 25 -coder cabac -strict experimental -movflags +faststart+write_colr -profile:v high -level 5.1  -y "%PARtemp%" >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! "%ffmpegexex64%" -hide_banner -nostats -v verbose !OpenCL_device_init! -i "%~1" -map_metadata -1 -sws_flags lanczos+accurate_rnd+full_chroma_int+full_chroma_inp -filter_complex "[0:v]yadif=0:0:0!sharpenflags!,format=pix_fmts=yuv420p,setdar=dar=!theAR!" -c:v h264_nvenc -pix_fmt nv12 -preset !nv_preset! !bfflags! !refsflags! -rc:v vbr_hq -rc-lookahead:v 32 -cq 22 -qmin 16 -qmax 25 -coder cabac -strict experimental -movflags +faststart+write_colr -profile:v high -level 5.1 -af %loudnormfilter% -c:a libfdk_aac -cutoff 18000 -ab %audiobitrate% -ar %audiofreq%  -y "%PARaacmp4%" >> "%vrdlog%" 2>&1
"%ffmpegexex64%" -hide_banner -nostats -v verbose !OpenCL_device_init! -i "%~1" -map_metadata -1 -sws_flags lanczos+accurate_rnd+full_chroma_int+full_chroma_inp -filter_complex "[0:v]yadif=0:0:0!sharpenflags!,format=pix_fmts=yuv420p,setdar=dar=!theAR!" -c:v h264_nvenc -pix_fmt nv12 -preset !nv_preset! !bfflags! !refsflags! -rc:v vbr_hq -rc-lookahead:v 32 -cq 22 -qmin 16 -qmax 25 -coder cabac -strict experimental -movflags +faststart+write_colr -profile:v high -level 5.1 -af %loudnormfilter% -c:a libfdk_aac -cutoff 18000 -ab %audiobitrate% -ar %audiofreq% -y "%PARaacmp4%" >> "%vrdlog%" 2>&1
SET EL=!ERRORLEVEL!
IF /I "!EL!" NEQ "0" (
   ECHO !DATE! !TIME! *********  Error !EL! was found >> "%vrdlog%" 2>&1
   ECHO !DATE! !TIME! *********  Error !EL! was found >> "%vrdlog%" 2>&1
   ECHO !DATE! !TIME! *********  Error !EL! was found 
   ECHO !DATE! !TIME! *********  ABORTING ... >> "%vrdlog%" 2>&1
   %xpause%
   EXIT !EL!
)
REM ------------------------
ECHO !DATE! !TIME! ***************************** end ffmpeg combined AUDIO/VIDEO conversion ***************************** >> "%vrdlog%" 2>&1
REM ------------------------------ MUX the video and audio ------------------------------ 
REM ECHO !DATE! !TIME! ***************************** start mp4box %makeaudiotype% muxing ***************************** >> "%vrdlog%" 2>&1
REM ECHO !DATE! !TIME! https://gpac.wp.mines-telecom.fr/mp4box/mp4box-documentation/ >> "%vrdlog%" 2>&1
REM aac muxing
REM IF /I "%makeaudiotype%" == "aac" (
REM ECHO "%mp4boxexex64%" -add "%PARtemp%":lang=eng -add "%paraac%":lang=eng:delay=!AudioDelayms! -isma -new "%PARaacmp4%" >> "%vrdlog%" 2>&1
REM "%mp4boxexex64%" -add "%PARtemp%":lang=eng -add "%paraac%":lang=eng:delay=!AudioDelayms! -isma -new "%PARaacmp4%" >> "%vrdlog%" 2>&1
REM SET EL=!ERRORLEVEL!
REM IF /I "!EL!" NEQ "0" (
REM    ECHO *********  Error !EL! was found >> "%vrdlog%" 2>&1
REM    ECHO *********  Error !EL! was found >> "%vrdlog%" 2>&1
REM    ECHO *********  Error !EL! was found 
REM    ECHO *********  ABORTING ... >> "%vrdlog%" 2>&1
REM    %xpause%
REM    EXIT !EL!
REM )
REM ECHO !DATE! !TIME! ...  MP4BOX wrote file = "!PARaacmp4!" >> "%vrdlog%" 2>&1
REM ECHO !DATE! !TIME! ... convertedoutputMP4 = "!convertedoutputMP4!" >> "%vrdlog%" 2>&1
REM ECHO !DATE! !TIME! ...     makeaudiotype = "!makeaudiotype!" >> "%vrdlog%" 2>&1
REM )
REM ECHO !DATE! !TIME! ***************************** end mp4box %makeaudiotype% muxing  >> "%vrdlog%" 2>&1
REM
DEL "%PARtemp%"
DEL "%parmp3%"
DEL "%paraac%"
DEL "%jsonFile%"
DEL "%tempfile%"
REM ------------------------------ finished  mpg to mp4 ------------------------------ 
ECHO !DATE! !TIME! ***************************** end SUBROUTINE :mpg_to_mp4 ***************************** >> "%vrdlog%" 2>&1
goto :eof





REM +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
REM +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
:000-setup
ECHO !DATE! !TIME! ***************************** start SUBROUTINE :000-setup ***************************** >> "%vrdlog%" 2>&1
REM Setup variables for executable image paths so they can be commonly used across batch files
REM ------ WIN10 start
ECHO !DATE! !TIME! ... start of exe path variables ...  >> "%vrdlog%" 2>&1
REM SET X264EXEx32=C:\SOFTWARE\X264\from-VIDEOLAN\x264-x32.exe
REM SET X264EXEx64=C:\SOFTWARE\X264\from-VIDEOLAN\x264-x64.exe
SET avisynth_path=C:\Program Files (x86)\AviSynth 2.5
REM -- win32 ---------------------------------------------------------------------
REM set ffmpegexex32=C:\SOFTWARE\ffmpeg\0-latest-x32\bin\ffmpeg.exe
set ffmpegexex32=C:\SOFTWARE\ffmpeg\0-homebuilt-x32\ffmpeg.exe
set ffprobeexe32=C:\SOFTWARE\ffmpeg\0-homebuilt-x32\ffprobe.exe
REM
REM set x264exex32=C:\SOFTWARE\X264\from-VIDEOLAN\x264-x32.exe
set x264exex32=C:\SOFTWARE\ffmpeg\0-homebuilt-x32\x264-mp4.exe
REM
REM set mp4boxexex32=C:\SOFTWARE\mp4box\MP4Box.exe
set mp4boxexex32=C:\SOFTWARE\ffmpeg\0-homebuilt-x32\MP4Box.exe
REM -- win64 ---------------------------------------------------------------------
REM set ffmpegexex64=C:\SOFTWARE\ffmpeg\0-latest-x64\bin\ffmpeg.exe
set ffmpegexex64=C:\SOFTWARE\ffmpeg\0-homebuilt-x64\ffmpeg.exe
set ffprobeexe64=C:\SOFTWARE\ffmpeg\0-homebuilt-x64\ffprobe.exe
REM
REM set x264exex64=C:\SOFTWARE\X264\from-VIDEOLAN\x264-x64.exe
set x264exex64=C:\SOFTWARE\ffmpeg\0-homebuilt-x64\x264-mp4.exe
REM
REM set mp4boxexex64=C:\SOFTWARE\mp4box\MP4Box.exe
set mp4boxexex64=C:\SOFTWARE\ffmpeg\0-homebuilt-x64\MP4Box.exe
REM -- common ---------------------------------------------------------------------
set avs2yuvexe=C:\software\avs2yuv\avs2yuv.exe
set mediainfoexe=C:\software\mediainfo\mediainfo.exe
REM -- Vapoursynth 32bit ---------------------------------------------------------------------
set VSpath=C:\SOFTWARE\Vapoursynth
set VSpathDLL=C:\SOFTWARE\Vapoursynth\vapoursynth32\plugins\dll-to-choose-from
set VSdgindexnvEXE=C:\SOFTWARE\Vapoursynth\DGIndex\DGIndexNV.exe
set VSdgdecodenvDLL=C:\SOFTWARE\Vapoursynth\DGIndex\DGDecodeNV.dll
set VSdgindexEXE=C:\SOFTWARE\DGindex\DGIndex.exe
set VSdgdecodeDLL=C:\SOFTWARE\DGindex\DGDecode.dll
set VSpipeEXE=C:\SOFTWARE\Vapoursynth\VSPipe.exe
set VSeditEXE=C:\SOFTWARE\Vapoursynth\vsedit-32bit.exe
REM -- Vapoursynth 64bit ---------------------------------------------------------------------
set VSpath64=C:\SOFTWARE\Vapoursynth-x64
set VSpathDLL64=C:\SOFTWARE\Vapoursynth-x64\vapoursynth64\plugins\dll-to-choose-from
set VSdgindexnvEXE64=C:\SOFTWARE\Vapoursynth-x64\DGIndex\DGIndexNV.exe
set VSdgdecodenvDLL64=C:\SOFTWARE\Vapoursynth-x64\DGIndex\DGDecodeNV.dll
set VSdgindexEXE64=C:\SOFTWARE\DGindex\DGIndex.exe
set VSdgdecodeDLL64=nothing
set VSpipeEXE64=C:\SOFTWARE\Vapoursynth-x64\VSPipe.exe
set VSeditEXE64=nothing
REM ------ WIN10 end
REM -- Header ---------------------------------------------------------------------
REM --- start set header to date and time
set Datex=%date%
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
ECHO !DATE! !TIME! As at %yyyy%.%mm%.%dd%_%hh%.%min%.%ss%.%ms%
set header=%yyyy%.%mm%.%dd%.%hh%.%min%.%ss%.%ms%-%COMPUTERNAME%
REM --- end set header to date and time
ECHO !DATE! !TIME! ... start of exe path variables ...
REM CALL ".\000-setup-exe-paths.bat"
ECHO !DATE! !TIME! "%avisynth_path%"
ECHO !DATE! !TIME! -- win32
ECHO !DATE! !TIME! "%ffmpegexex32%"
ECHO !DATE! !TIME! "%ffprobeexe32%"
ECHO !DATE! !TIME! "%x264exex32%"
ECHO !DATE! !TIME! "%mp4boxexex64%"
ECHO !DATE! !TIME! -- win64
ECHO !DATE! !TIME! "%ffmpegexex64%"
ECHO !DATE! !TIME! "%ffprobeexe64%"
ECHO !DATE! !TIME! "%x264exex64%"
ECHO !DATE! !TIME! "%mp4boxexex64%"
ECHO !DATE! !TIME! -- common
ECHO !DATE! !TIME! "%avs2yuvexe%"
ECHO !DATE! !TIME! "%mediainfoexe%"
ECHO !DATE! !TIME! -- VS 32bit
ECHO !DATE! !TIME! "%VSpath%"
ECHO !DATE! !TIME! "%VSpathDLL%"
ECHO !DATE! !TIME! "%VSdgindexnvEXE%"
ECHO !DATE! !TIME! "%VSdgdecodenvDLL%"
ECHO !DATE! !TIME! "%VSdgindexEXE%"
ECHO !DATE! !TIME! "%VSdgdecodeDLL%"
ECHO !DATE! !TIME! "%VSpipeEXE%"
ECHO !DATE! !TIME! "%VSeditEXE%"
ECHO !DATE! !TIME! -- VS 64bit
ECHO !DATE! !TIME! "%VSpath64%"
ECHO !DATE! !TIME! "%VSpathDLL64%"
ECHO !DATE! !TIME! "%VSdgindexnvEXE64%"
ECHO !DATE! !TIME! "%VSdgdecodenvDLL64%"
ECHO !DATE! !TIME! "%VSdgindexEXE64%"
ECHO !DATE! !TIME! "%VSdgdecodeDLL64%"
ECHO !DATE! !TIME! "%VSpipeEXE64%"
ECHO !DATE! !TIME! "%VSeditEXE64%"
ECHO !DATE! !TIME! -- header
ECHO !DATE! !TIME! "%header%"
ECHO !DATE! !TIME! ... end of exe path variables ...  >> "%vrdlog%" 2>&1
ECHO !DATE! !TIME! ***************************** end SUBROUTINE :000-setup ***************************** >> "%vrdlog%" 2>&1
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
GOTO:EOF


REM +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
REM +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
REM --- start set a temp header to date and time
:maketempheader
@ECHO on
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
ECHO !DATE! !TIME! As at %yyyy%.%mm%.%dd%_%hh%.%min%.%ss%.%ms%  COMPUTERNAME="%COMPUTERNAME%"
set tempheader=%yyyy%.%mm%.%dd%.%hh%.%min%.%ss%.%ms%
REM --- end set a temp header to date and time
@ECHO off
goto :eof