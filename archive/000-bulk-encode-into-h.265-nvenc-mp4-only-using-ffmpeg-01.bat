@Echo OFF
@setlocal ENABLEDELAYEDEXPANSION
@setlocal enableextensions
REM
set nvencc_x64=C:\SOFTWARE\NVEncC\NVEncC64.exe
set mp4box_x64=C:\SOFTWARE\ffmpeg\0-homebuilt-x64\MP4Box.exe
set muxer_x64=C:\SOFTWARE\ffmpeg\0-homebuilt-x64\muxer.exe
set rtmpdump_x64=C:\SOFTWARE\ffmpeg\0-homebuilt-x64\rtmpdump.exe
set mediainfo_x64=C:\software\mediainfo\mediainfo.exe
set mkvinfo_x64=C:\SOFTWARE\mkvtoolnix\mkvinfo.exe
REM
set ffmpeg_x64_8bit=C:\SOFTWARE\ffmpeg\0-homebuilt-x64\built_for_generic_opencl\x64\ffmpeg.exe
set ffprobe_x64_8bit=C:\SOFTWARE\ffmpeg\0-homebuilt-x64\built_for_generic_opencl\x64\ffprobe.exe
set x264_x64_8bit=C:\SOFTWARE\ffmpeg\0-homebuilt-x64\built_for_generic_opencl\x64\x264.exe
set x265_x64_8bit=C:\SOFTWARE\ffmpeg\0-homebuilt-x64\built_for_generic_opencl\x64\x265.exe
REM
set ffmpeg_x64_10bit=C:\SOFTWARE\ffmpeg\0-homebuilt-x64\built_for_generic_opencl\x64\ffmpeg.exe
set ffprobe_x64_10bit=C:\SOFTWARE\ffmpeg\0-homebuilt-x64\built_for_generic_opencl\x64\ffprobe.exe
set x264_x64_10bit=C:\SOFTWARE\ffmpeg\0-homebuilt-x64\built_for_generic_opencl\x64\x264.exe
set x265_x64_10bit=C:\SOFTWARE\ffmpeg\0-homebuilt-x64\built_for_generic_opencl\x64\x265.exe
REM
SET OpenCL_device_init=-init_hw_device opencl=ocl:1.0 -filter_hw_device ocl
REM SET OpenCL_device_init=
REM reset defaults to 8bit
set ffmpeg_x64=%ffmpeg_x64_8bit%
set ffprobe_x64=%ffprobe_x64_8bit%
set x264_x64=%x264_x64_8bit%
set x265_x64=%x265_x64_8bit%

REM
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
REM echo As at %yyyy%_%mm%_%dd%_%hh%_%min%_%ss%_%ms%  
set header=%yyyy%_%mm%_%dd%_%hh%_%min%_%ss%_%ms%
REM echo header="%header%"
REM --- end set header to date and time
REM -- Header ---------------------------------------------------------------------
REM --------------------------------------------------------------------------------------------------------------
set biglogfile=%~0.biglogfile.%header%.log
REM IF EXIST "%biglogfile%" echo "!DATE! !TIME! about to delete file "%biglogfile%""
IF EXIST "%biglogfile%" del "%biglogfile%"
set debug_biglogfile=Yes
REM set debug_biglogfile=No
IF /I "%debug_biglogfile%" == "Yes" Echo "!DATE! !TIME! Start of file "%biglogfile%"" > "%biglogfile%"
REM --------------------------------------------------------------------------------------------------------------
set debug_tracelogfile=Yes
REM set debug_tracelogfile=No
REM IF /I "%debug_tracelogfile%" == "Yes" 
REM --------------------------------------------------------------------------------------------------------------
set masterdisplaylogfile=%~0.masterdisplaylogfile.%header%.log
REM IF EXIST "%masterdisplaylogfile%" echo "!DATE! !TIME! about to delete file "%masterdisplaylogfile%""
IF EXIST "%masterdisplaylogfile%" del "%masterdisplaylogfile%"
set debug_masterdisplaylogfile=No
IF /I "%debug_masterdisplaylogfile%" == "Yes" Echo "!DATE! !TIME! Start of file "%masterdisplaylogfile%"" > "%masterdisplaylogfile%"
REM --------------------------------------------------------------------------------------------------------------
IF /I "%debug_biglogfile%" == "Yes" ECHO !DATE! !TIME! -------------------------------------------------------------------------------------------- >> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" ECHO !DATE! !TIME! *** Checking hardware characteristics etc, assume device 0 is the one we will use >> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" ECHO !DATE! !TIME! -------------------------------------------------------------------------------------------- >> "%biglogfile%" 2>>&1
REM See what the nvidia device id is - for my 1050Ti it is 0 on all PCs
IF /I "%debug_biglogfile%" == "Yes" echo "%nvencc_x64%" --check-device >> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" "%nvencc_x64%" --check-device >> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" ECHO !DATE! !TIME! -------------------------------------------------------------------------------------------- >> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" echo "%nvencc_x64%" --check-hw >> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" "%nvencc_x64%" --check-hw >> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" ECHO !DATE! !TIME! -------------------------------------------------------------------------------------------- >> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" echo "%nvencc_x64%" --check-environment >> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" "%nvencc_x64%" --check-environment >> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" ECHO !DATE! !TIME! -------------------------------------------------------------------------------------------- >> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" ECHO !DATE! !TIME! ******************************************************************************************** >> "%biglogfile%" 2>>&1
REM See what the nvidia device id is - for my 1050Ti it is 1.0 on all PCs
IF /I "%debug_biglogfile%" == "Yes" echo "%ffmpeg_x64%" -hide_banner -v verbose -init_hw_device list >> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" "%ffmpeg_x64%" -hide_banner -v verbose -init_hw_device list >> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" ECHO !DATE! !TIME! ******************************************************************************************** >> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" echo "%ffmpeg_x64%" -hide_banner -v verbose -init_hw_device opencl >> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" "%ffmpeg_x64%" -hide_banner -v verbose -init_hw_device opencl >> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" ECHO !DATE! !TIME! ******************************************************************************************** >> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" echo "%ffmpeg_x64%" -hide_banner -v verbose -init_hw_device opencl:1.0  >> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" "%ffmpeg_x64%" -hide_banner -v verbose -init_hw_device opencl:1.0  >> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" ECHO !DATE! !TIME! ******************************************************************************************** >> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" ECHO !DATE! !TIME! ============================================================================================ >> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" echo "%mkvinfo_x64%" --no-gui --help --version --verbose >> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" "%mkvinfo_x64%" --no-gui --help --version --verbose >> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" ECHO !DATE! !TIME! ============================================================================================ >> "%biglogfile%" 2>>&1
REM
REM THIS .BAT FILE makes assumptions which ONLY WORKS FOR .mp4 containing AVC or HEVC in CFR or VFR
REM    ... NOT for .TS 
REM    ... NOT for .webm
REM    ... NOT for .TS 
REM    ... NOT for .MKV
REM

@ECHO ON
net use /delete Q: 
net use Q: \\10.0.0.2\E-5TB-mp4library /persistent:no
set "source_path=Q:\mp4library\to_convert2\"
REM set "source_path=E:\mp4library\oldmovies\"
REM no trailing slash on top_converted_mp4_hevc_path, it will be added to the final to_pathlater
set "top_converted_mp4_hevc_path=.\converted_hevc"
IF not exist "%top_converted_mp4_hevc_path%" (mkdir "%top_converted_mp4_hevc_path%")
@ECHO OFF
REM
for /R "%source_path%" %%a in ("*.mp4") do (
   REM reset defaults to 8bit
   set ffmpeg_x64=%ffmpeg_x64_8bit%
   set ffprobe_x64=%ffprobe_x64_8bit%
   set x264_x64=%x264_x64_8bit%
   set x265_x64=%x265_x64_8bit%
   REM *************************************************************************************************************************
   REM make the local output folder
   REM note: don't touch the percent and exclamations or it all breaks
   set "the_local_file_path=%%~pa"
   set "local_converted_mp4_hevc_path=!top_converted_mp4_hevc_path!!the_local_file_path!"
   REM
   REM *************************************************************************************************************************
   REM make a local copy of the file and use that ...
   REM %%~fa - the ~f in this removes quotes and fully expands the filename into include disk, path, filename and extension
   set lnxa=%%~nxa
   SET local_file_copy=.\!lnxa!.mp4
   IF EXIST "!local_file_copy!" DEL "!local_file_copy!" >> "%biglogfile%" 2>>&1
   IF /I "%debug_biglogfile%" == "Yes" echo !DATE! !TIME! copy /y /z /b "%%~fa" "!local_file_copy!" >> "%biglogfile%" 2>>&1
   copy /y /z /b "%%~fa" "!local_file_copy!" >> "%biglogfile%" 2>>&1
   REM *************************************************************************************************************************
   REM *************************************************************************************************************************
   ECHO !DATE! !TIME! Finding metadata for: "%%~fa"
   IF /I "%debug_biglogfile%" == "Yes" ECHO !DATE! !TIME! Finding metadata for: "%%~fa" >> "%biglogfile%" 2>>&1
   call :FIND_RELEVANT_METADATA "!local_file_copy!"
   REM set FFP_
   REM set MI_
   ECHO !DATE! !TIME! Finished metadata for: "%%~fa"
   IF /I "%debug_biglogfile%" == "Yes" ECHO !DATE! !TIME! Finished metadata for: "%%~fa" >> "%biglogfile%" 2>>&1
   REM *************************************************************************************************************************
   REM *************************************************************************************************************************
   ECHO !DATE! !TIME! Start ffmpeg-nv Encoding "%%~fa" ...
   IF /I "%debug_biglogfile%" == "Yes" ECHO !DATE! !TIME! Start ffmpeg-nv Encoding "%%~fa" ... >> "%biglogfile%" 2>>&1
   REM note: don't touch the percent and exclamations or it all breaks
   if not exist "!local_converted_mp4_hevc_path!" MKDIR "!local_converted_mp4_hevc_path!"
   call :ENCODE_ffmpeg_hevc_MP4_HEVC_AAC "!local_file_copy!" "!local_converted_mp4_hevc_path!"
   ECHO !DATE! !TIME! Finished ffmpeg-nv Encoding "%%~fa" ...
   IF /I "%debug_biglogfile%" == "Yes" ECHO !DATE! !TIME! Finished ffmpeg-nv Encoding "%%~fa" ... >> "%biglogfile%" 2>>&1
   REM *************************************************************************************************************************
   IF EXIST "!local_file_copy!" DEL "!local_file_copy!" >> "%biglogfile%" 2>>&1
)
REM
net use /delete Q: 
pause
exit

:FIND_RELEVANT_METADATA
@echo off
REM @setlocal ENABLEDELAYEDEXPANSION
REM @setlocal enableextensions
   REM parameter 1 is the input filename
   REM %~f1 - the ~f in this removes quotes and fully expands the filename into include disk, path, filename and extension
   REM remember to NOT put any training spaces etc after the following SET substitution
   SET input_file=%~f1
   REM
   REM *****************************************************************************************************************
   REM *****************************************************************************************************************
   REM -----------------------------------------------------------------------------------------------------------------------------
   REM Find MediaInfo metadata - note that this is less reliable than FFPROBE and so metadata from FFPROBE should take precenence 
   REM -----------------------------------------------------------------------------------------------------------------------------
   REM
   REM echo "!DATE! !TIME! in :FIND_RELEVANT_METADATA Started finding mediainfo metadata from "%input_file%""
   REM IF /I "%debug_biglogfile%" == "Yes" echo "!DATE! !TIME! in :FIND_RELEVANT_METADATA Started finding mediainfo metadata from "%input_file%"" >> "%biglogfile%" 2>>&1
   REM
   set tracelogfile=.\%~nx1.trace.%header%.log
   REM IF EXIST "%tracelogfile%" echo "!DATE! !TIME! about to delete file "%tracelogfile%""
   IF EXIST "%tracelogfile%" del "%tracelogfile%"
   REM
   set tmpfile=.\%~nx1.mediainfo-result.%header%.tmp
   REM IF EXIST "%tmpfile%" echo "!DATE! !TIME! about to delete file "%tmpfile%""
   IF EXIST "%tmpfile%" del "%tmpfile%"
   REM
   set templatecsvfile=.\%~nx1.mediainfo-input.%header%.csv
   REM IF EXIST "%templatecsvfile%" echo "!DATE! !TIME! about to delete file "%templatecsvfile%""
   IF EXIST "%templatecsvfile%" del "%templatecsvfile%"
   REM
   REM
   REM ----------------------------------------------
   call :ascertain_mediainfo_metadata "%input_file%"
   REM ----------------------------------------------
   REM IF /I "%debug_biglogfile%" == "Yes" ECHO "!DATE! !TIME! debug: displaying MI_ result for %input_file%" >> "%biglogfile%" 2>>&1
   IF /I "%debug_biglogfile%" == "Yes" set MI_>> "%biglogfile%" 2>>&1
   REM IF /I "%debug_tracelogfile%" == "Yes" ECHO "!DATE! !TIME! debug: displaying MI_ result for %input_file%" >> "%tracelogfile%" 2>>&1
   IF /I "%debug_tracelogfile%" == "Yes" set MI_>> "%tracelogfile%" 2>>&1
   REM
   REM IF EXIST "%templatecsvfile%" echo "!DATE! !TIME! about to delete file "%templatecsvfile%""
   IF EXIST "%templatecsvfile%" del "%templatecsvfile%"
   REM echo "!DATE! !TIME! Finished finding mediainfo metadata from "%input_file%""
   REM echo "!DATE! !TIME! ----------------------------------------------------------------------------------------"
   REM IF /I "%debug_biglogfile%" == "Yes" echo "!DATE! !TIME! ----------------------------------------------------------------------------------------" >> "%biglogfile%" 2>>&1
   REM IF /I "%debug_tracelogfile%" == "Yes" echo "!DATE! !TIME! ----------------------------------------------------------------------------------------" >> "%tracelogfile%" 2>>&1
   REM   
   REM *****************************************************************************************************************
   REM *****************************************************************************************************************
   REM -----------------------------------------------------------------------------------------------------------------------------
   REM Find FFPROBE metadata - note that this is more reliable metadata from MEDIAINFO and thus should take precenence 
   REM -----------------------------------------------------------------------------------------------------------------------------
   REM
   REM echo "!DATE! !TIME! Started finding FFPROBE metadata from "%input_file%""
   set tmpfile=.\%~nx1.ffprobe-result.tmp
   REM IF EXIST "%tmpfile%" echo "!DATE! !TIME! about to delete file "%tmpfile%""
   IF EXIST "%tmpfile%" del "%tmpfile%"
   REM
   REM --------------------------------------------
   call :ascertain_ffprobe_metadata "%input_file%"
   REM --------------------------------------------
   REM IF /I "%debug_biglogfile%" == "Yes" ECHO "!DATE! !TIME! debug: displaying FFP_ result for %input_file%" >> "%biglogfile%" 2>>&1
   IF /I "%debug_biglogfile%" == "Yes" set FFP_>> "%biglogfile%" 2>>&1
   REM IF /I "%debug_tracelogfile%" == "Yes" ECHO "!DATE! !TIME! debug: displaying FFP_ result for %input_file%" >> "%tracelogfile%" 2>>&1
   IF /I "%debug_tracelogfile%" == "Yes" set FFP_>> "%tracelogfile%" 2>>&1
   REM
   REM
   REM
   REM IF EXIST "%tmpfile%" echo "!DATE! !TIME! about to delete file "%tmpfile%""
   IF EXIST "%tmpfile%" del "%tmpfile%"   
   REM echo "!DATE! !TIME! Finished finding mediainfo metadata from "%input_file%""
   REM echo "!DATE! !TIME! %input_file% ----------------------------------------------------------------------------------------"
   REM IF /I "%debug_biglogfile%" == "Yes" echo "!DATE! !TIME! %input_file% ----------------------------------------------------------------------------------------" >> "%biglogfile%" 2>>&1
   REM IF /I "%debug_tracelogfile%" == "Yes" echo "!DATE! !TIME! %input_file% ----------------------------------------------------------------------------------------" >> "%tracelogfile%" 2>>&1
   goto :eof

:ascertain_mediainfo_metadata
@echo off
REM @setlocal ENABLEDELAYEDEXPANSION
REM @setlocal enableextensionsecho "!DATE! !TIME! Running mediainfo queries ..."
REM this trickery only works with setlocal disabled :(
set queried_input_file=%~f1
IF /I "%debug_biglogfile%" == "Yes" IF /I "%queried_input_file%" == "" ECHO "!DATE! !TIME! DEBUG: in ascertain_mediainfo_metadata but nothing to do, no media file specified ... Exiting ..."  >> "%biglogfile%" 2>>&1
IF /I "%debug_tracelogfile%" == "Yes" IF /I "%queried_input_file%" == "" ECHO "!DATE! !TIME! DEBUG: in ascertain_mediainfo_metadata but nothing to do, no media file specified ... Exiting ..."  >> "%tracelogfile%" 2>>&1
IF /I "%queried_input_file%" == "" ECHO "!DATE! !TIME! DEBUG: in ascertain_mediainfo_metadata but nothing to do, no media file specified ... Exiting ..."
IF /I "%queried_input_file%" == "" exit 1
REM
REM Assume these variables have already been set before calling this function
REM    mediainfo_x64 = the fully qualified filename to the .exe for mediainfo
REM    ffprobe_x64 = the fully qualified filename to the .exe for ffprobe
REM
REM echo "!DATE! !TIME! ----------------------------------------------------------------------------------------"
REM IF /I "%debug_biglogfile%" == "Yes" echo "!DATE! !TIME! ----------------------------------------------------------------------------------------" >> "%biglogfile%" 2>>&1
REM IF /I "%debug_tracelogfile%" == "Yes" echo "!DATE! !TIME! ----------------------------------------------------------------------------------------" >> "%tracelogfile%" 2>>&1
REM echo "!DATE! !TIME! in ascertain_mediainfo_metadata Starting finding MEDIAINFO metadata from "%queried_input_file%""
REM IF /I "%debug_biglogfile%" == "Yes" echo "!DATE! !TIME! in ascertain_mediainfo_metadata Starting finding MEDIAINFO metadata from "%queried_input_file%"" >> "%biglogfile%" 2>>&1
REM IF /I "%debug_tracelogfile%" == "Yes" echo "!DATE! !TIME! in ascertain_mediainfo_metadata Starting finding MEDIAINFO metadata from "%queried_input_file%"" >> "%tracelogfile%" 2>>&1
REM
REM These ones from mediainfo are generally useful
REM 
Call :ascertain_a_mediainfo_value "General" "MI_G_Format" "Format" "%queried_input_file%"
Call :ascertain_a_mediainfo_value "Video"   "MI_V_Format" "Format" "%queried_input_file%"
Call :ascertain_a_mediainfo_value "Video"   "MI_V_StreamKind" "StreamKind" "%queried_input_file%"
Call :ascertain_a_mediainfo_value "Video"   "MI_V_Codec" "Codec" "%queried_input_file%"
Call :ascertain_a_mediainfo_value "Video"   "MI_V_CodecID" "CodecID" "%queried_input_file%"
Call :ascertain_a_mediainfo_value "Video"   "MI_V_ScanType" "ScanType" "%queried_input_file%"
Call :ascertain_a_mediainfo_value "Video"   "MI_V_ScanType_String" "ScanType/String" "%queried_input_file%"
Call :ascertain_a_mediainfo_value "Video"   "MI_V_Format_Profile" "Format_Profile" "%queried_input_file%"
Call :ascertain_a_mediainfo_value "Video"   "MI_V_Format_Settings_CABAC_String" "Format_Settings_CABAC/String" "%queried_input_file%"
Call :ascertain_a_mediainfo_value "Video"   "MI_V_ColorSpace" "ColorSpace" "%queried_input_file%"
Call :ascertain_a_mediainfo_value "Video"   "MI_V_BitDepth" "BitDepth" "%queried_input_file%"
Call :ascertain_a_mediainfo_value "Video"   "MI_V_ChromaSubsampling" "ChromaSubsampling" "%queried_input_file%"
Call :ascertain_a_mediainfo_value "Video"   "MI_V_Width" "Width" "%queried_input_file%"
Call :ascertain_a_mediainfo_value "Video"   "MI_V_Height" "Height" "%queried_input_file%"
Call :ascertain_a_mediainfo_value "Video"   "MI_V_Rotation" "Rotation" "%queried_input_file%"
Call :ascertain_a_mediainfo_value "Video"   "MI_V_Rotation_String" "Rotation/String" "%queried_input_file%"
Call :ascertain_a_mediainfo_value "Video"   "MI_V_PixelAspectRatio" "PixelAspectRatio" "%queried_input_file%"
Call :ascertain_a_mediainfo_value "Video"   "MI_V_PixelAspectRatio_String" "PixelAspectRatio/String" "%queried_input_file%"
Call :ascertain_a_mediainfo_value "Video"   "MI_V_DisplayAspectRatio" "DisplayAspectRatio" "%queried_input_file%"
Call :ascertain_a_mediainfo_value "Video"   "MI_V_DisplayAspectRatio_String" "DisplayAspectRatio/String" "%queried_input_file%"
Call :ascertain_a_mediainfo_value "Video"   "MI_V_FrameRate_Mode" "FrameRate_Mode" "%queried_input_file%"
Call :ascertain_a_mediainfo_value "Video"   "MI_V_FrameRate_Mode_String" "FrameRate_Mode/String" "%queried_input_file%"
Call :ascertain_a_mediainfo_value "Video"   "MI_V_FrameRate" "FrameRate" "%queried_input_file%"
Call :ascertain_a_mediainfo_value "Video"   "MI_V_FrameRate_Num" "FrameRate_Num" "%queried_input_file%"
Call :ascertain_a_mediainfo_value "Video"   "MI_V_FrameRate_Den" "FrameRate_Den" "%queried_input_file%"
Call :ascertain_a_mediainfo_value "Video"   "MI_V_FrameRate_Nominal" "FrameRate_Nominal" "%queried_input_file%"
Call :ascertain_a_mediainfo_value "Video"   "MI_V_FrameRate_Maximum" "FrameRate_Maximum" "%queried_input_file%"
Call :ascertain_a_mediainfo_value "Video"   "MI_V_FrameRate_Minimum" "FrameRate_Minimum" "%queried_input_file%"
Call :ascertain_a_mediainfo_value "Video"   "MI_V_Delay" "Delay" "%queried_input_file%"
Call :ascertain_a_mediainfo_value "Audio"   "MI_A_Video_Delay" "Video_Delay" "%queried_input_file%"
Call :ascertain_a_mediainfo_value "Video"   "MI_V_colour_range" "colour_range" "%queried_input_file%"
Call :ascertain_a_mediainfo_value "Video"   "MI_V_colour_description_present" "colour_description_present" "%queried_input_file%"
Call :ascertain_a_mediainfo_value "Video"   "MI_V_colour_primaries" "colour_primaries" "%queried_input_file%"
Call :ascertain_a_mediainfo_value "Video"   "MI_V_transfer_characteristics" "transfer_characteristics" "%queried_input_file%"
Call :ascertain_a_mediainfo_value "Video"   "MI_V_matrix_coefficients" "matrix_coefficients" "%queried_input_file%"
REM
REM Example values follow
REM
REM
REM These next ones from mediainfo are usually nul or not so useful
REM
REM Call :ascertain_a_mediainfo_value "General" "MI_G_Format_Version" "Format_Version" "%queried_input_file%"
REM Call :ascertain_a_mediainfo_value "General" "MI_G_Format_Profile" "Format_Profile" "%queried_input_file%"
REM Call :ascertain_a_mediainfo_value "General" "MI_G_Format_Level" "Format_Level" "%queried_input_file%"
REM Call :ascertain_a_mediainfo_value "General" "MI_G_Format_Compression" "Format_Compression" "%queried_input_file%"
REM Call :ascertain_a_mediainfo_value "General" "MI_G_CodecID" "CodecID" "%queried_input_file%"
REM Call :ascertain_a_mediainfo_value "General" "MI_G_CodecID_String" "CodecID/String" "%queried_input_file%"
REM Call :ascertain_a_mediainfo_value "Video"   "MI_V_StreamKind_String" "StreamKind/String" "%queried_input_file%"
REM Call :ascertain_a_mediainfo_value "Video"   "MI_V_Format_Version" "Format_Version" "%queried_input_file%"
REM Call :ascertain_a_mediainfo_value "Video"   "MI_V_Format_Level" "Format_Level" "%queried_input_file%"
REM Call :ascertain_a_mediainfo_value "Video"   "MI_V_Format_Tier" "Format_Tier" "%queried_input_file%"
REM Call :ascertain_a_mediainfo_value "Video"   "MI_V_Format_Compression" "Format_Compression" "%queried_input_file%"
REM Call :ascertain_a_mediainfo_value "Video"   "MI_V_Format_Settings_Pulldown" "Format_Settings_Pulldown" "%queried_input_file%"
REM Call :ascertain_a_mediainfo_value "Video"   "MI_V_Format_Settings_FrameMode" "Format_Settings_FrameMode" "%queried_input_file%"
REM Call :ascertain_a_mediainfo_value "Video"   "MI_V_Format_Settings_PictureString" "Format_Settings_PictureString" "%queried_input_file%"
REM Call :ascertain_a_mediainfo_value "Video"   "MI_V_Format_Settings_QPel" "Format_Settings_QPel" "%queried_input_file%"
REM Call :ascertain_a_mediainfo_value "Video"   "MI_V_Format_Settings_QPel_String" "Format_Settings_QPel/String" "%queried_input_file%"
REM Call :ascertain_a_mediainfo_value "Video"   "MI_V_Format_Settings_CABAC" "Video_Format_Settings_CABAC" "%queried_input_file%"
REM Call :ascertain_a_mediainfo_value "Video"   "MI_V_MuxingMode" "MuxingMode" "%queried_input_file%"
REM Call :ascertain_a_mediainfo_value "Video"   "MI_V_CodecID_String" "CodecID/String" "%queried_input_file%"
REM Call :ascertain_a_mediainfo_value "Video"   "MI_V_FrameRate_Mode_Original" "FrameRate_Mode_Original" "%queried_input_file%"
REM Call :ascertain_a_mediainfo_value "Video"   "MI_V_FrameRate_Mode_Original_String" "FrameRate_Mode_Original/String" "%queried_input_file%"
REM Call :ascertain_a_mediainfo_value "Video"   "MI_V_FrameRate_String" "FrameRate/String" "%queried_input_file%"
REM Call :ascertain_a_mediainfo_value "Video"   "MI_V_FrameRate_Nominal_String" "FrameRate_Nominal/String" "%queried_input_file%"
REM Call :ascertain_a_mediainfo_value "Video"   "MI_V_FrameRate_Minimum_String" "FrameRate_Minimum/String" "%queried_input_file%"
REM Call :ascertain_a_mediainfo_value "Video"   "MI_V_FrameRate_Maximum_String" "FrameRate_Maximum/String" "%queried_input_file%"
REM Call :ascertain_a_mediainfo_value "Video"   "MI_V_Delay_String" "Delay/String" "%queried_input_file%"
REM Call :ascertain_a_mediainfo_value "Video"   "MI_V_Delay_String1" "Delay/String1" "%queried_input_file%"
REM Call :ascertain_a_mediainfo_value "Video"   "MI_V_Delay_String2" "Delay/String2" "%queried_input_file%"
REM Call :ascertain_a_mediainfo_value "Video"   "MI_V_Delay_String3" "Delay/String3" "%queried_input_file%"
REM Call :ascertain_a_mediainfo_value "Video"   "MI_V_Delay_String4" "Delay/String4" "%queried_input_file%"
REM Call :ascertain_a_mediainfo_value "Video"   "MI_V_Delay_String5" "Delay/String5" "%queried_input_file%"
REM Call :ascertain_a_mediainfo_value "Video"   "MI_V_Delay_Settings" "Delay_Settings" "%queried_input_file%"
REM Call :ascertain_a_mediainfo_value "Video"   "MI_V_ChromaSubsampling_String" "ChromaSubsampling/String" "%queried_input_file%"
REM Call :ascertain_a_mediainfo_value "Video"   "MI_V_ChromaSubsampling_Position" "ChromaSubsampling_Position" "%queried_input_file%"
REM Call :ascertain_a_mediainfo_value "Video"   "MI_V_BitDepth_String" "BitDepth/String" "%queried_input_file%"
REM Call :ascertain_a_mediainfo_value "Video"   "MI_V_ScanType_Original" "ScanType_Original" "%queried_input_file%"
REM Call :ascertain_a_mediainfo_value "Video"   "MI_V_ScanType_Original_String" "ScanType_Original/String" "%queried_input_file%"
REM Call :ascertain_a_mediainfo_value "Video"   "MI_V_ScanType_StoreMethod" "ScanType_StoreMethod" "%queried_input_file%"
REM Call :ascertain_a_mediainfo_value "Video"   "MI_V_ScanType_StoreMethod_FieldsPerBlock" "ScanType_StoreMethod_FieldsPerBlock" "%queried_input_file%"
REM Call :ascertain_a_mediainfo_value "Video"   "MI_V_ScanType_StoreMethod_String" "ScanType_StoreMethod/String" "%queried_input_file%"
REM Call :ascertain_a_mediainfo_value "Video"   "MI_V_ScanOrder" "ScanOrder" "%queried_input_file%"
REM Call :ascertain_a_mediainfo_value "Video"   "MI_V_ScanOrder_String" "ScanOrder/String" "%queried_input_file%"
REM Call :ascertain_a_mediainfo_value "Video"   "MI_V_ScanOrder_Stored" "ScanOrder_Stored" "%queried_input_file%"
REM Call :ascertain_a_mediainfo_value "Video"   "MI_V_ScanOrder_Stored_String" "ScanOrder_Stored/String" "%queried_input_file%"
REM Call :ascertain_a_mediainfo_value "Video"   "MI_V_ScanOrder_StoredDisplayedInverted" "ScanOrder_StoredDisplayedInverted" "%queried_input_file%"
REM Call :ascertain_a_mediainfo_value "Video"   "MI_V_ScanOrder_Original" "ScanOrder_Original" "%queried_input_file%"
REM Call :ascertain_a_mediainfo_value "Video"   "MI_V_ScanOrder_Original_String" "ScanOrder_Original/String" "%queried_input_file%"
REM Call :ascertain_a_mediainfo_value "Video"   "MI_V_colour_primaries_Original" "colour_primaries_Original" "%queried_input_file%"
REM Call :ascertain_a_mediainfo_value "Video"   "MI_V_colour_description_present_Original" "colour_description_present_Original" "%queried_input_file%"
REM Call :ascertain_a_mediainfo_value "Video"   "MI_V_colour_primaries_Original" "colour_primaries_Original" "%queried_input_file%"
REM Call :ascertain_a_mediainfo_value "Video"   "MI_V_transfer_characteristics_Original" "transfer_characteristics_Original" "%queried_input_file%"
REM Call :ascertain_a_mediainfo_value "Video"   "MI_V_matrix_coefficients_Original" "matrix_coefficients_Original" "%queried_input_file%"
REM IF /I "%debug_biglogfile%" == "Yes" ECHO "!DATE! !TIME! ---------------------------------------------------------------------------------" >> "%biglogfile%" 2>>&1
REM IF /I "%debug_tracelogfile%" == "Yes" ECHO "!DATE! !TIME! ---------------------------------------------------------------------------------" >> "%tracelogfile%" 2>>&1
REM Dump all mediainfo to the trace file
IF /I "%debug_biglogfile%" == "Yes" echo !DATE! !TIME! "%mediainfo_x64%" --Full "%queried_input_file%"  >> "%biglogfile%" 2>>&1
IF /I "%debug_tracelogfile%" == "Yes" echo !DATE! !TIME! "%mediainfo_x64%" --Full "%queried_input_file%"  >> "%tracelogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" "%mediainfo_x64%" --Full "%queried_input_file%"  >> "%biglogfile%" 2>>&1
IF /I "%debug_tracelogfile%" == "Yes" "%mediainfo_x64%" --Full "%queried_input_file%"  >> "%tracelogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" ECHO "!DATE! !TIME! ---------------------------------------------------------------------------------" >> "%biglogfile%" 2>>&1
IF /I "%debug_tracelogfile%" == "Yes" ECHO "!DATE! !TIME! ---------------------------------------------------------------------------------" >> "%tracelogfile%" 2>>&1
REM
REM IF EXIST "%tmpfile%" echo "!DATE! !TIME! about to delete file "%tmpfile%""
IF EXIST "%tmpfile%" del "%tmpfile%"   
REM  
REM echo "!DATE! !TIME! in ascertain_mediainfo_metadata Finished finding MEDIAINFO metadata from "%queried_input_file%""
REM IF /I "%debug_biglogfile%" == "Yes" echo "!DATE! !TIME! in ascertain_mediainfo_metadata Finished finding MEDIAINFO metadata from "%queried_input_file%"" >> "%biglogfile%" 2>>&1
REM IF /I "%debug_tracelogfile%" == "Yes" echo "!DATE! !TIME! in ascertain_mediainfo_metadata Finished finding MEDIAINFO metadata from "%queried_input_file%"" >> "%tracelogfile%" 2>>&1
REM echo "!DATE! !TIME! ----------------------------------------------------------------------------------------"
REM IF /I "%debug_biglogfile%" == "Yes" echo "!DATE! !TIME! ----------------------------------------------------------------------------------------" >> "%biglogfile%" 2>>&1
REM IF /I "%debug_tracelogfile%" == "Yes" echo "!DATE! !TIME! ----------------------------------------------------------------------------------------" >> "%tracelogfile%" 2>>&1
goto :eof

:ascertain_a_mediainfo_value
@echo off
REM @setlocal ENABLEDELAYEDEXPANSION
REM @setlocal enableextensionsecho "!DATE! !TIME! Running mediainfo queries ..."
REM this trickery only works with setlocal disabled :(
REM ECHO parameter 1 = mediainfo secton type, eg General, Video, Audio ... "%~1"
REM ECHO parameter 2 = name of DOS variable to set
REM ECHO parameter 3 = medianfo name of it's variable to retrieve
REM ECHO parameter 4 = the media filkename to query, eg a.mp4
IF /I "%debug_biglogfile%" == "Yes" IF /I "%~4" == "" ECHO "!DATE! !TIME! DEBUG: in ascertain_mediainfo_value but nothing to do, no media file specified ... Exiting ..."  >> "%biglogfile%" 2>>&1
IF /I "%debug_tracelogfile%" == "Yes" IF /I "%~4" == "" ECHO "!DATE! !TIME! DEBUG: in ascertain_mediainfo_value but nothing to do, no media file specified ... Exiting ..."  >> "%tracelogfile%" 2>>&1
IF /I "%~4" == "" ECHO "!DATE! !TIME! DEBUG: in ascertain_mediainfo_value but nothing to do, no media file specified ... Exiting ..."
IF /I "%~4" == "" exit 1
REM no spaces at the end of these command, please
set amv_the_MI_section=%~1
set amv_the_MI_variable=%~2
set amv_the_MI_value_to_retrieve=%~3
set amv_the_MI_filename=%~f4
set tmp_mediainfo_result=.\%~nx4.tmp.mediainfo.result
IF EXIST "%tmp_mediainfo_result%" DEL "%tmp_mediainfo_result%"
REM no spaces at the end of these command, please
"%mediainfo_x64%" "--Inform=%amv_the_MI_section%;%%%amv_the_MI_value_to_retrieve%%%" "%amv_the_MI_filename%">"%tmp_mediainfo_result%"
REM no spaces at the end of these commands, please
set tmp_local_variable=null
set /p tmp_local_variable=<"%tmp_mediainfo_result%"
IF EXIST "%tmp_mediainfo_result%" DEL "%tmp_mediainfo_result%"
REM IF /I "%debug_biglogfile%" == "Yes" ECHO "!DATE! !TIME! %amv_the_MI_variable%=%tmp_local_variable%">> "%biglogfile%" 2>>&1
REM IF /I "%debug_tracelogfile%" == "Yes" ECHO "!DATE! !TIME! %amv_the_MI_variable%=%tmp_local_variable%">> "%tracelogfile%" 2>>&1
REM now make it global ...
ENDLOCAL & (set "%amv_the_MI_variable%=%tmp_local_variable%")
goto :eof


:ascertain_ffprobe_metadata   
@echo off
REM @setlocal ENABLEDELAYEDEXPANSION
REM @setlocal enableextensionsecho "!DATE! !TIME! Running mediainfo queries ..."
REM this trickery only works with setlocal disabled :(
set queried_input_file=%~f1
REM echo "!DATE! !TIME! ----------------------------------------------------------------------------------------"
REM IF /I "%debug_biglogfile%" == "Yes" echo "!DATE! !TIME! ----------------------------------------------------------------------------------------" >> "%biglogfile%" 2>>&1
REM IF /I "%debug_tracelogfile%" == "Yes" echo "!DATE! !TIME! ----------------------------------------------------------------------------------------" >> "%tracelogfile%" 2>>&1
REM echo "!DATE! !TIME! in ascertain_ffprobe_metadata Starting finding FFPROBE metadata from "%queried_input_file%""
REM IF /I "%debug_biglogfile%" == "Yes" echo "!DATE! !TIME! in ascertain_ffprobe_metadata Starting finding FFPROBE metadata from "%queried_input_file%"" >> "%biglogfile%" 2>>&1
REM IF /I "%debug_tracelogfile%" == "Yes" echo "!DATE! !TIME! in ascertain_ffprobe_metadata Starting finding FFPROBE metadata from "%queried_input_file%"" >> "%tracelogfile%" 2>>&1
REM
REM put ffprobe output into tmpfile to parse into variables
"%ffprobe_x64%" -hide_banner -select_streams V -show_format -show_programs -show_streams -show_private_data -find_stream_info -i "%queried_input_file%" > "%tmpfile%" 2>>&1
REM get the characteristics we are interested in into DOS variables 
REM set defaults first
set FFP_max_average=null
set FFP_max_content=null
set FFP_width=null
set FFP_height=null
set FFP_coded_width=null
set FFP_coded_height=null
set FFP_has_b_frames=null
set FFP_sample_aspect_ratio=null
set FFP_display_aspect_ratio=null
set FFP_pix_fmt=null
set FFP_level=null
set FFP_color_range=null
set FFP_color_space=null
set FFP_color_transfer=null
set FFP_color_primaries=null
set FFP_r_frame_rate=null
set FFP_avg_frame_rate=null
set FFP_side_data_type=null
set FFP_red_x=null
set FFP_red_y=null
set FFP_green_x=null
set FFP_green_y=null
set FFP_blue_x=null
set FFP_blue_y=null
set FFP_white_point_x=null
set FFP_white_point_y=null
set FFP_min_luminance=null
set FFP_max_luminance=null
set FFP_codec_long_name=null
set FFP_profile=null
for /f "tokens=1,2 delims==" %%a in ('find "=" ^<"%tmpfile%"') do (
   set "var="
   for %%c in (%%~a) do set "var=!var!,%%~c"
      set "var=!var:~1!"
      set "val="
      for %%d in (%%~b) do set "val=!val!,%%~d"
      set "val=!val:~1!"
      REM echo .!var!.=.!val!.
      IF /I "%debug_tracelogfile%" == "Yes" echo ***** .!var!.=.!val!.  >> "%tracelogfile%" 2>>&1
      IF /I "%debug_biglogfile%" == "Yes" echo ***** .!var!.=.!val!.  >> "%biglogfile%" 2>>&1
      IF /I "%debug_tracelogfile%" == "Yes" IF /I "!var!" == "max_content" (ECHO ===== max_content set "FFP_!var!=!val!")  >> "%tracelogfile%" 2>>&1
      IF /I "%debug_biglogfile%" == "Yes" IF /I "!var!" == "max_content" (ECHO ===== max_content set "FFP_!var!=!val!")  >> "%biglogfile%" 2>>&1
      IF /I "%debug_tracelogfile%" == "Yes" IF /I "!var!" == "max_average" (ECHO ===== max_average set "FFP_!var!=!val!")  >> "%tracelogfile%" 2>>&1
      IF /I "%debug_biglogfile%" == "Yes" IF /I "!var!" == "max_average" (ECHO ===== max_average set "FFP_!var!=!val!")  >> "%biglogfile%" 2>>&1
      IF /I "!var!" == "max_content" (set "FFP_!var!=!val!")
      IF /I "!var!" == "max_average" (set "FFP_!var!=!val!")
      IF /I "!var!" == "width" (set "FFP_!var!=!val!")
      IF /I "!var!" == "height" (set "FFP_!var!=!val!")
      IF /I "!var!" == "coded_width" (set "FFP_!var!=!val!")
      IF /I "!var!" == "coded_height" (set "FFP_!var!=!val!")
      IF /I "!var!" == "has_b_frames" (set "FFP_!var!=!val!")
      IF /I "!var!" == "sample_aspect_ratio" (set "FFP_!var!=!val!")
      IF /I "!var!" == "display_aspect_ratio" (set "FFP_!var!=!val!")
      IF /I "!var!" == "pix_fmt" (set "FFP_!var!=!val!")
      IF /I "!var!" == "level" (set "FFP_!var!=!val!")
      IF /I "!var!" == "color_range" (set "FFP_!var!=!val!")
      IF /I "!var!" == "color_space" (set "FFP_!var!=!val!")
      IF /I "!var!" == "color_transfer" (set "FFP_!var!=!val!")
      IF /I "!var!" == "color_primaries" (set "FFP_!var!=!val!")
      IF /I "!var!" == "r_frame_rate" (set "FFP_!var!=!val!")
      IF /I "!var!" == "avg_frame_rate" (set "FFP_!var!=!val!")
      IF /I "!var!" == "side_data_type" (set "FFP_!var!=!val!")
      IF /I "!var!" == "red_x" (set "FFP_!var!=!val!")
      IF /I "!var!" == "red_y" (set "FFP_!var!=!val!")
      IF /I "!var!" == "green_x" (set "FFP_!var!=!val!")
      IF /I "!var!" == "green_y" (set "FFP_!var!=!val!")
      IF /I "!var!" == "blue_x" (set "FFP_!var!=!val!")
      IF /I "!var!" == "blue_y" (set "FFP_!var!=!val!")
      IF /I "!var!" == "white_point_x" (set "FFP_!var!=!val!")
      IF /I "!var!" == "white_point_y" (set "FFP_!var!=!val!")
      IF /I "!var!" == "min_luminance" (set "FFP_!var!=!val!")
      IF /I "!var!" == "max_luminance" (set "FFP_!var!=!val!")
      IF /I "!var!" == "codec_name" (set "FFP_!var!=!val!")
      IF /I "!var!" == "codec_long_name" (set "FFP_!var!=!val!")
      IF /I "!var!" == "profile" (set "FFP_!var!=!val!")
   )
)   
REM
REM split off trailing "/" etc from some of them ensuring no trailing spaces
REM for /f "tokens=1,2 delims=/" %%a in ("%FFP_max_content%") do (set "FFP_max_content=%%a")
REM for /f "tokens=1,2 delims=/" %%a in ("%FFP_max_average%") do (set "FFP_max_average=%%a")
REM for /f "tokens=1,2 delims=/" %%a in ("%FFP_width%") do (set "FFP_width=%%a")
REM for /f "tokens=1,2 delims=/" %%a in ("%FFP_height%") do (set "FFP_height=%%a")
REM for /f "tokens=1,2 delims=/" %%a in ("%FFP_coded_width%") do (set "FFP_coded_width=%%a")
REM for /f "tokens=1,2 delims=/" %%a in ("%FFP_coded_height%") do (set "FFP_coded_height=%%a")
REM for /f "tokens=1,2 delims=/" %%a in ("%FFP_has_b_frames%") do (set "FFP_has_b_frames=%%a")
REM for /f "tokens=1,2 delims=/" %%a in ("%FFP_sample_aspect_ratio%") do (set "FFP_sample_aspect_ratio=%%a")
REM for /f "tokens=1,2 delims=/" %%a in ("%FFP_display_aspect_ratio%") do (set "FFP_display_aspect_ratio=%%a")
REM for /f "tokens=1,2 delims=/" %%a in ("%FFP_pix_fmt%") do (set "FFP_pix_fmt=%%a")
REM for /f "tokens=1,2 delims=/" %%a in ("%FFP_level%") do (set "FFP_level=%%a")
REM for /f "tokens=1,2 delims=/" %%a in ("%FFP_color_range%") do (set "FFP_color_range=%%a")
REM for /f "tokens=1,2 delims=/" %%a in ("%FFP_color_space%") do (set "FFP_color_space=%%a")
REM for /f "tokens=1,2 delims=/" %%a in ("%FFP_color_transfer%") do (set "FFP_color_transfer=%%a")
REM for /f "tokens=1,2 delims=/" %%a in ("%FFP_color_primaries%") do (set "FFP_color_primaries=%%a")
REM for /f "tokens=1,2 delims=/" %%a in ("%FFP_r_frame_rate%") do (set "FFP_r_frame_rate=%%a")
REM for /f "tokens=1,2 delims=/" %%a in ("%FFP_avg_frame_rate%") do (set "FFP_avg_frame_rate=%%a")
REM for /f "tokens=1,2 delims=/" %%a in ("%FFP_side_data_type%") do (set "FFP_side_data_type=%%a")
REM for /f "tokens=1,2 delims=/" %%a in ("%FFP_red_x%") do (set "FFP_red_x=%%a")
REM for /f "tokens=1,2 delims=/" %%a in ("%FFP_red_y%") do (set "FFP_red_y=%%a")
REM for /f "tokens=1,2 delims=/" %%a in ("%FFP_green_x%") do (set "FFP_green_x=%%a")
REM for /f "tokens=1,2 delims=/" %%a in ("%FFP_green_y%") do (set "FFP_green_y=%%a")
REM for /f "tokens=1,2 delims=/" %%a in ("%FFP_blue_x%") do (set "FFP_blue_x=%%a")
REM for /f "tokens=1,2 delims=/" %%a in ("%FFP_blue_y%") do (set "FFP_blue_y=%%a")
REM for /f "tokens=1,2 delims=/" %%a in ("%FFP_white_point_x%") do (set "FFP_white_point_x=%%a")
REM for /f "tokens=1,2 delims=/" %%a in ("%FFP_white_point_y%") do (set "FFP_white_point_y=%%a")
REM for /f "tokens=1,2 delims=/" %%a in ("%FFP_min_luminance%") do (set "FFP_min_luminance=%%a")
REM for /f "tokens=1,2 delims=/" %%a in ("%FFP_max_luminance%") do (set "FFP_max_luminance=%%a")
REM for /f "tokens=1,2 delims=/" %%a in ("%FFP_codec_name%") do (set "FFP_codec_name=%%a")
REM for /f "tokens=1,2 delims=/" %%a in ("%FFP_codec_long_name%") do (set "FFP_codec_long_name=%%a")
REM for /f "tokens=1,2 delims=/" %%a in ("%FFP_profile%") do (set "FFP_profile=%%a")
REM
IF /I "%debug_biglogfile%" == "Yes" ECHO "!DATE! !TIME! ---------------------------------------------------------------------------------" >> "%biglogfile%" 2>>&1
IF /I "%debug_tracelogfile%" == "Yes" ECHO "!DATE! !TIME! ---------------------------------------------------------------------------------" >> "%tracelogfile%" 2>>&1
REM Dump all ffprobe Video stream to the trace file
IF /I "%debug_biglogfile%" == "Yes" echo !DATE! !TIME! "%ffprobe_x64%" -hide_banner -select_streams V -show_format -show_programs -show_streams -show_private_data -find_stream_info -i "%queried_input_file%"  >> "%biglogfile%" 2>>&1
IF /I "%debug_tracelogfile%" == "Yes" echo !DATE! !TIME! "%ffprobe_x64%" -hide_banner -select_streams V -show_format -show_programs -show_streams -show_private_data -find_stream_info -i "%queried_input_file%"  >> "%tracelogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" "%ffprobe_x64%" -hide_banner -select_streams V -show_format -show_programs -show_streams -show_private_data -find_stream_info -i "%queried_input_file%"  >> "%biglogfile%" 2>>&1
IF /I "%debug_tracelogfile%" == "Yes" "%ffprobe_x64%" -hide_banner -select_streams V -show_format -show_programs -show_streams -show_private_data -find_stream_info -i "%queried_input_file%"  >> "%tracelogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" ECHO "!DATE! !TIME! ---------------------------------------------------------------------------------" >> "%biglogfile%" 2>>&1
IF /I "%debug_tracelogfile%" == "Yes" ECHO "!DATE! !TIME! ---------------------------------------------------------------------------------" >> "%tracelogfile%" 2>>&1
REM
REM IF EXIST "%tmpfile%" echo "!DATE! !TIME! about to delete file "%tmpfile%""
IF EXIST "%tmpfile%" del "%tmpfile%"   
REM  
REM echo "!DATE! !TIME! in ascertain_ffprobe_metadata Finished finding FFPROBE metadata from "%queried_input_file%""
REM IF /I "%debug_biglogfile%" == "Yes" ECHO "!DATE! !TIME! in ascertain_ffprobe_metadata Finished finding FFPROBE metadata from "%queried_input_file%"" >> "%biglogfile%" 2>>&1
REM IF /I "%debug_tracelogfile%" == "Yes" ECHO "!DATE! !TIME! in ascertain_ffprobe_metadata Finished finding FFPROBE metadata from "%queried_input_file%"" >> "%tracelogfile%" 2>>&1
REM echo "!DATE! !TIME! ----------------------------------------------------------------------------------------"
REM IF /I "%debug_biglogfile%" == "Yes" ECHO "!DATE! !TIME! ----------------------------------------------------------------------------------------" >> "%biglogfile%" 2>>&1
REM IF /I "%debug_tracelogfile%" == "Yes" ECHO "!DATE! !TIME! ----------------------------------------------------------------------------------------" >> "%tracelogfile%" 2>>&1
goto :eof

:ENCODE_ffmpeg_hevc_MP4_HEVC_AAC
REM @setlocal ENABLEDELAYEDEXPANSION
REM @setlocal enableextensionsecho "!DATE! !TIME! Running mediainfo queries ..."
REM this trickery only works with setlocal disabled :(
REM
REM THIS .BAT FILE makes assumptions which ONLY WORKS FOR .mp4 containing AVC or HEVC in CFR or VFR
REM    ... NOT for .TS 
REM    ... NOT for .webm
REM    ... NOT for .TS 
REM    ... NOT for .MKV
REM
REM parameter 1 = the file to convery
REM parameter 2 = the folder path of the target to convert into, including a trailing slash
REM 
SET nvc_input_file=%~f1
set nvc_output_file=%~dp2%~n1.h265.mp4
REM
REM IF /I "%debug_biglogfile%" == "Yes" echo nvc_input_file="%nvc_input_file%" >> "%biglogfile%" 2>>&1
REM IF /I "%debug_tracelogfile%" == "Yes" echo nvc_input_file="%nvc_input_file%" >> "%tracelogfile%" 2>>&1
REM echo nvc_input_file="%nvc_input_file%"
REM IF /I "%debug_biglogfile%" == "Yes" echo nvc_output_file="%nvc_output_file%" >> "%biglogfile%" 2>>&1
REM IF /I "%debug_tracelogfile%" == "Yes" echo nvc_output_file="%nvc_output_file%" >> "%tracelogfile%" 2>>&1
REM echo nvc_output_file="%nvc_output_file%"
REM
set Not_MP4_AVC_HEVC=False
IF /I NOT "%MI_G_Format%" == "MPEG-4" (set Not_MP4_AVC_HEVC=True)
REM
set ORit=False
IF /I     "%MI_V_Codec%" == "AVC"  (set ORit=True)
REM IF /I     "%MI_V_Codec%" == "HEVC" (set ORit=True)
IF /I NOT "%ORit%" == "True"       (set Not_MP4_AVC_HEVC=True)
REM
set ORit=False
IF /I      "%FFP_codec_name%" == "h264" (set ORit=True)
REM IF /I      "%FFP_codec_name%" == "hevc" (set ORit=True)
IF /I NOT "%ORit%" == "True"       (set Not_MP4_AVC_HEVC=True)
REM
IF /I "%Not_MP4_AVC_HEVC" == "True" (
   ECHO "!DATE! !TIME! ---------------------------------------------------------------------------------"
   IF /I "%debug_biglogfile%" == "Yes" ECHO "!DATE! !TIME! ---------------------------------------------------------------------------------" >> "%biglogfile%" 2>>&1
   IF /I "%debug_tracelogfile%" == "Yes" ECHO "!DATE! !TIME! ---------------------------------------------------------------------------------" >> "%tracelogfile%" 2>>&1
   ECHO HALTING ... "%input_file%" is of type "%MI_G_Format%"/"%MI_V_Codec%"/"%FFP_codec_name%"
   IF /I "%debug_biglogfile%" == "Yes" ECHO HALTING ... "%input_file%" is of type "%MI_G_Format%"/"%MI_V_Codec%"/"%FFP_codec_name%" >> "%biglogfile%" 2>>&1
   IF /I "%debug_tracelogfile%" == "Yes" ECHO HALTING ... "%input_file%" is of type "%MI_G_Format%"/"%MI_V_Codec%"/"%FFP_codec_name%" >> "%tracelogfile%" 2>>&1
   ECHO "            but must be an .mp4 file containing only avc or hevc (either CFR or VFR)
   IF /I "%debug_biglogfile%" == "Yes" ECHO "            but must be an .mp4 file containing only avc or hevc (either CFR or VFR) >> "%biglogfile%" 2>>&1
   IF /I "%debug_tracelogfile%" == "Yes" ECHO "            but must be an .mp4 file containing only avc or hevc (either CFR or VFR) >> "%tracelogfile%" 2>>&1
   ECHO "!DATE! !TIME! ---------------------------------------------------------------------------------"
   IF /I "%debug_biglogfile%" == "Yes" ECHO "!DATE! !TIME! ---------------------------------------------------------------------------------" >> "%biglogfile%" 2>>&1
   IF /I "%debug_tracelogfile%" == "Yes" ECHO "!DATE! !TIME! ---------------------------------------------------------------------------------" >> "%tracelogfile%" 2>>&1
   exit 1
)
REM
REM ------------------------------------------------------------------------------------------------
REM Transforms some things into nvc settings
REM 
REM Colour --fullrange
REM
SET NVC_color_range=--fullrange
IF /I "%FFP_color_range%" == "tv"      (set NVC_color_range=)
IF /I "%FFP_color_range%" == "limited" (set NVC_color_range=)
IF /I "%FFP_color_range%" == "unknown" (set NVC_color_range=)
IF /I "%FFP_color_range%" == "null"    (set NVC_color_range=)
IF /I NOT "%NVC_color_range%" == "" (
   REM not the NOT above, this is for full range
   set NVC_ff_color_range=range=full
   set x265_color_range=--range=full
   set ff_color_range=-color_range pc
) ELSE (
   set NVC_ff_color_range=
   set x265_color_range=--range=limited
   set ff_color_range=-color_range tv
)
REM
REM Colour --max-cll and remove if  we don't understand anything
REM
set NVC_max_cll=--max-cll "%FFP_max_content%,%FFP_max_average%"
IF /I "%FFP_max_content%" == ""        (set NVC_max_cll=)
IF /I "%FFP_max_content%" == "null"    (set NVC_max_cll=)
IF /I "%FFP_max_content%" == "unknown" (set NVC_max_cll=)
REM
IF /I "%FFP_max_average%" == ""        (set NVC_max_cll=)
IF /I "%FFP_max_average%" == "null"    (set NVC_max_cll=)
IF /I "%FFP_max_average%" == "unknown" (set NVC_max_cll=)
IF /I "%NVC_max_cll%" == "" (
   set NVC_ff_max_cll=
   set ff_max_cll=
) ELSE (
   set NVC_ff_max_cll=max-cll='%FFP_max_content%,%FFP_max_average%'
   set ff_max_cll=
)
REM
REM Colour --master-display
REM
REM x265 documentation
REM Example for a P3D65 1000-nits monitor, 
REM where G(x=0.265, y=0.690), B(x=0.150, y=0.060), R(x=0.680, y=0.320), WP(x=0.3127, y=0.3290), L(max=1000, min=0.0001):
REM use   G(13250,34500)B(7500,3000)R(34000,16000)WP(15635,16450)L(10000000,1)
REM so the rule of thimb is
REM       1. for G,B,R,WP ... the fraction is multiplied by 50000 to get the integer number
REM       2. for L        ... the fraction is multiplied by  1000 to get the integer number (for the 1000 nits monitor)
REM 
REM so, if the G,B,R,WP value contains a "/" then just remove it and the stuff  after it
REM so, if the L        value contains a "/" ???????????????
REM
REM
REM
IF /I "%debug_biglogfile%" == "Yes" echo before "FFP_red_x"="%FFP_red_x%"  >> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" echo before "FFP_red_y"="%FFP_red_y%" >> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" echo before "FFP_green_x"="%FFP_green_x%" >> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" echo before "FFP_green_y"="%FFP_green_y%" >> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" echo before "FFP_blue_x"="%FFP_blue_x%" >> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" echo before "FFP_blue_y"="%FFP_blue_y%" >> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" echo before "FFP_white_point_x"="%FFP_white_point_x%" >> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" echo before "FFP_white_point_y"="%FFP_white_point_y%" >> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" echo before "FFP_min_luminance"="%FFP_min_luminance%" >> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" echo before "FFP_max_luminance"="%FFP_max_luminance%" >> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" echo before "FFP_max_content,FFP_max_average"="%FFP_max_content%,%FFP_max_average%" >> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" set FFP_>> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" set MI_>> "%biglogfile%" 2>>&1
IF /I "%debug_tracelogfile%" == "Yes" echo before "FFP_red_x"="%FFP_red_x%"  >> "%tracelogfile%" 2>>&1
IF /I "%debug_tracelogfile%" == "Yes" echo before "FFP_red_y"="%FFP_red_y%" >> "%tracelogfile%" 2>>&1
IF /I "%debug_tracelogfile%" == "Yes" echo before "FFP_green_x"="%FFP_green_x%" >> "%tracelogfile%" 2>>&1
IF /I "%debug_tracelogfile%" == "Yes" echo before "FFP_green_y"="%FFP_green_y%" >> "%tracelogfile%" 2>>&1
IF /I "%debug_tracelogfile%" == "Yes" echo before "FFP_blue_x"="%FFP_blue_x%" >> "%tracelogfile%" 2>>&1
IF /I "%debug_tracelogfile%" == "Yes" echo before "FFP_blue_y"="%FFP_blue_y%" >> "%tracelogfile%" 2>>&1
IF /I "%debug_tracelogfile%" == "Yes" echo before "FFP_white_point_x"="%FFP_white_point_x%" >> "%tracelogfile%" 2>>&1
IF /I "%debug_tracelogfile%" == "Yes" echo before "FFP_white_point_y"="%FFP_white_point_y%" >> "%tracelogfile%" 2>>&1
IF /I "%debug_tracelogfile%" == "Yes" echo before "FFP_min_luminance"="%FFP_min_luminance%" >> "%tracelogfile%" 2>>&1
IF /I "%debug_tracelogfile%" == "Yes" echo before "FFP_max_luminance"="%FFP_max_luminance%" >> "%tracelogfile%" 2>>&1
IF /I "%debug_tracelogfile%" == "Yes" echo before "FFP_max_content,FFP_max_average"="%FFP_max_content%,%FFP_max_average%" >> "%tracelogfile%" 2>>&1
IF /I "%debug_tracelogfile%" == "Yes" set FFP_>> "%tracelogfile%" 2>>&1
IF /I "%debug_tracelogfile%" == "Yes" set MI_>> "%tracelogfile%" 2>>&1
IF /I "%debug_masterdisplaylogfile%" == "Yes" ECHO *** "%nvc_input_file%" ***>> "%masterdisplaylogfile%" 2>>&1
IF /I "%debug_masterdisplaylogfile%" == "Yes" echo before "FFP_red_x"="%FFP_red_x%"  >> "%masterdisplaylogfile%" 2>>&1
IF /I "%debug_masterdisplaylogfile%" == "Yes" echo before "FFP_red_y"="%FFP_red_y%" >> "%masterdisplaylogfile%" 2>>&1
IF /I "%debug_masterdisplaylogfile%" == "Yes" echo before "FFP_green_x"="%FFP_green_x%" >> "%masterdisplaylogfile%" 2>>&1
IF /I "%debug_masterdisplaylogfile%" == "Yes" echo before "FFP_green_y"="%FFP_green_y%" >> "%masterdisplaylogfile%" 2>>&1
IF /I "%debug_masterdisplaylogfile%" == "Yes" echo before "FFP_blue_x"="%FFP_blue_x%" >> "%masterdisplaylogfile%" 2>>&1
IF /I "%debug_masterdisplaylogfile%" == "Yes" echo before "FFP_blue_y"="%FFP_blue_y%" >> "%masterdisplaylogfile%" 2>>&1
IF /I "%debug_masterdisplaylogfile%" == "Yes" echo before "FFP_white_point_x"="%FFP_white_point_x%" >> "%masterdisplaylogfile%" 2>>&1
IF /I "%debug_masterdisplaylogfile%" == "Yes" echo before "FFP_white_point_y"="%FFP_white_point_y%" >> "%masterdisplaylogfile%" 2>>&1
IF /I "%debug_masterdisplaylogfile%" == "Yes" echo before "FFP_min_luminance"="%FFP_min_luminance%" >> "%masterdisplaylogfile%" 2>>&1
IF /I "%debug_masterdisplaylogfile%" == "Yes" echo before "FFP_max_luminance"="%FFP_max_luminance%" >> "%masterdisplaylogfile%" 2>>&1
IF /I "%debug_masterdisplaylogfile%" == "Yes" echo before "FFP_max_content,FFP_max_average"="%FFP_max_content%,%FFP_max_average%" >> "%masterdisplaylogfile%" 2>>&1
IF /I "%debug_masterdisplaylogfile%" == "Yes" set FFP_>> "%masterdisplaylogfile%" 2>>&1
IF /I "%debug_masterdisplaylogfile%" == "Yes" set MI_>> "%masterdisplaylogfile%" 2>>&1
REM
for /f "tokens=1,2 delims=/" %%a in ("%FFP_red_x%") do (set "FFP_red_x=%%a")
for /f "tokens=1,2 delims=/" %%a in ("%FFP_red_y%") do (set "FFP_red_y=%%a")
for /f "tokens=1,2 delims=/" %%a in ("%FFP_green_x%") do (set "FFP_green_x=%%a")
for /f "tokens=1,2 delims=/" %%a in ("%FFP_green_y%") do (set "FFP_green_y=%%a")
for /f "tokens=1,2 delims=/" %%a in ("%FFP_blue_x%") do (set "FFP_blue_x=%%a")
for /f "tokens=1,2 delims=/" %%a in ("%FFP_blue_y%") do (set "FFP_blue_y=%%a")
for /f "tokens=1,2 delims=/" %%a in ("%FFP_white_point_x%") do (set "FFP_white_point_x=%%a")
for /f "tokens=1,2 delims=/" %%a in ("%FFP_white_point_y%") do (set "FFP_white_point_y=%%a")
for /f "tokens=1,2 delims=/" %%a in ("%FFP_min_luminance%") do (set "FFP_min_luminance=%%a")
for /f "tokens=1,2 delims=/" %%a in ("%FFP_max_luminance%") do (set "FFP_max_luminance=%%a")
REM
IF /I "%debug_biglogfile%" == "Yes" echo after "FFP_red_x"="%FFP_red_x%"  >> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" echo after "FFP_red_y"="%FFP_red_y%" >> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" echo after "FFP_green_x"="%FFP_green_x%" >> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" echo after "FFP_green_y"="%FFP_green_y%" >> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" echo after "FFP_blue_x"="%FFP_blue_x%" >> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" echo after "FFP_blue_y"="%FFP_blue_y%" >> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" echo after "FFP_white_point_x"="%FFP_white_point_x%" >> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" echo after "FFP_white_point_y"="%FFP_white_point_y%" >> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" echo after "FFP_min_luminance"="%FFP_min_luminance%" >> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" echo after "FFP_max_luminance"="%FFP_max_luminance%" >> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" echo after "FFP_max_content,FFP_max_average"="%FFP_max_content%,%FFP_max_average%" >> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" set FFP_>> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" set MI_>> "%biglogfile%" 2>>&1
IF /I "%debug_tracelogfile%" == "Yes" echo after "FFP_red_x"="%FFP_red_x%"  >> "%tracelogfile%" 2>>&1
IF /I "%debug_tracelogfile%" == "Yes" echo after "FFP_red_y"="%FFP_red_y%" >> "%tracelogfile%" 2>>&1
IF /I "%debug_tracelogfile%" == "Yes" echo after "FFP_green_x"="%FFP_green_x%" >> "%tracelogfile%" 2>>&1
IF /I "%debug_tracelogfile%" == "Yes" echo after "FFP_green_y"="%FFP_green_y%" >> "%tracelogfile%" 2>>&1
IF /I "%debug_tracelogfile%" == "Yes" echo after "FFP_blue_x"="%FFP_blue_x%" >> "%tracelogfile%" 2>>&1
IF /I "%debug_tracelogfile%" == "Yes" echo after "FFP_blue_y"="%FFP_blue_y%" >> "%tracelogfile%" 2>>&1
IF /I "%debug_tracelogfile%" == "Yes" echo after "FFP_white_point_x"="%FFP_white_point_x%" >> "%tracelogfile%" 2>>&1
IF /I "%debug_tracelogfile%" == "Yes" echo after "FFP_white_point_y"="%FFP_white_point_y%" >> "%tracelogfile%" 2>>&1
IF /I "%debug_tracelogfile%" == "Yes" echo after "FFP_min_luminance"="%FFP_min_luminance%" >> "%tracelogfile%" 2>>&1
IF /I "%debug_tracelogfile%" == "Yes" echo after "FFP_max_luminance"="%FFP_max_luminance%" >> "%tracelogfile%" 2>>&1
IF /I "%debug_tracelogfile%" == "Yes" echo after "FFP_max_content,FFP_max_average"="%FFP_max_content%,%FFP_max_average%" >> "%tracelogfile%" 2>>&1
IF /I "%debug_tracelogfile%" == "Yes" set FFP_>> "%tracelogfile%" 2>>&1
IF /I "%debug_tracelogfile%" == "Yes" set MI_>> "%tracelogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" echo after "FFP_red_x"="%FFP_red_x%"  >> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" echo after "FFP_red_y"="%FFP_red_y%" >> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" echo after "FFP_green_x"="%FFP_green_x%" >> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" echo after "FFP_green_y"="%FFP_green_y%" >> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" echo after "FFP_blue_x"="%FFP_blue_x%" >> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" echo after "FFP_blue_y"="%FFP_blue_y%" >> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" echo after "FFP_white_point_x"="%FFP_white_point_x%" >> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" echo after "FFP_white_point_y"="%FFP_white_point_y%" >> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" echo after "FFP_min_luminance"="%FFP_min_luminance%" >> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" echo after "FFP_max_luminance"="%FFP_max_luminance%" >> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" echo after "FFP_max_content,FFP_max_average"="%FFP_max_content%,%FFP_max_average%" >> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" set FFP_>> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" set MI_>> "%biglogfile%" 2>>&1
IF /I "%debug_masterdisplaylogfile%" == "Yes" echo after "FFP_red_x"="%FFP_red_x%"  >> "%masterdisplaylogfile%" 2>>&1
IF /I "%debug_masterdisplaylogfile%" == "Yes" echo after "FFP_red_y"="%FFP_red_y%" >> "%masterdisplaylogfile%" 2>>&1
IF /I "%debug_masterdisplaylogfile%" == "Yes" echo after "FFP_green_x"="%FFP_green_x%" >> "%masterdisplaylogfile%" 2>>&1
IF /I "%debug_masterdisplaylogfile%" == "Yes" echo after "FFP_green_y"="%FFP_green_y%" >> "%masterdisplaylogfile%" 2>>&1
IF /I "%debug_masterdisplaylogfile%" == "Yes" echo after "FFP_blue_x"="%FFP_blue_x%" >> "%masterdisplaylogfile%" 2>>&1
IF /I "%debug_masterdisplaylogfile%" == "Yes" echo after "FFP_blue_y"="%FFP_blue_y%" >> "%masterdisplaylogfile%" 2>>&1
IF /I "%debug_masterdisplaylogfile%" == "Yes" echo after "FFP_white_point_x"="%FFP_white_point_x%" >> "%masterdisplaylogfile%" 2>>&1
IF /I "%debug_masterdisplaylogfile%" == "Yes" echo after "FFP_white_point_y"="%FFP_white_point_y%" >> "%masterdisplaylogfile%" 2>>&1
IF /I "%debug_masterdisplaylogfile%" == "Yes" echo after "FFP_min_luminance"="%FFP_min_luminance%" >> "%masterdisplaylogfile%" 2>>&1
IF /I "%debug_masterdisplaylogfile%" == "Yes" echo after "FFP_max_luminance"="%FFP_max_luminance%" >> "%masterdisplaylogfile%" 2>>&1
IF /I "%debug_masterdisplaylogfile%" == "Yes" echo after "FFP_max_content,FFP_max_average"="%FFP_max_content%,%FFP_max_average%" >> "%masterdisplaylogfile%" 2>>&1
IF /I "%debug_masterdisplaylogfile%" == "Yes" set FFP_>> "%masterdisplaylogfile%" 2>>&1
IF /I "%debug_masterdisplaylogfile%" == "Yes" set MI_>> "%masterdisplaylogfile%" 2>>&1
REM
REM
REM
set NVC_master_display=--master-display "G(%FFP_green_x%,%FFP_green_y%)B(%FFP_blue_x%,%FFP_blue_y%)R(%FFP_red_x%,%FFP_red_y%)WP(%FFP_white_point_x%,%FFP_white_point_y%)L(%FFP_max_luminance%,%FFP_min_luminance%)"
IF /I "%FFP_green_x%" == ""           (set NVC_master_display=)
IF /I "%FFP_green_x%" == "null"       (set NVC_master_display=)
IF /I "%FFP_green_y%" == ""           (set NVC_master_display=)
IF /I "%FFP_green_y%" == "null"       (set NVC_master_display=)
IF /I "%FFP_blue_x%" == ""            (set NVC_master_display=)
IF /I "%FFP_blue_x%" == "null"        (set NVC_master_display=)
IF /I "%FFP_blue_y%" == ""            (set NVC_master_display=)
IF /I "%FFP_blue_y%" == "null"        (set NVC_master_display=)
IF /I "%FFP_red_x%" == ""             (set NVC_master_display=)
IF /I "%FFP_red_x%" == "null"         (set NVC_master_display=)
IF /I "%FFP_red_y%" == ""             (set NVC_master_display=)
IF /I "%FFP_red_y%" == "null"         (set NVC_master_display=)
IF /I "%FFP_white_point_x%" == ""     (set NVC_master_display=)
IF /I "%FFP_white_point_x%" == "null" (set NVC_master_display=)
IF /I "%FFP_white_point_y%" == ""     (set NVC_master_display=)
IF /I "%FFP_white_point_y%" == "null" (set NVC_master_display=)
IF /I "%FFP_max_luminance%" == ""     (set NVC_master_display=)
IF /I "%FFP_max_luminance%" == "null" (set NVC_master_display=)
IF /I "%FFP_min_luminance%" == ""     (set NVC_master_display=)
IF /I "%FFP_min_luminance%" == "null" (set NVC_master_display=)
IF /I "%NVC_master_display%" == "" (
   set NVC_ff_master_display=
   set ff_master_display=
) ELSE (
   set NVC_ff_master_display=master-display='G^(%FFP_green_x%,%FFP_green_y%^)B^(%FFP_blue_x%,%FFP_blue_y%^)R^(%FFP_red_x%,%FFP_red_y%^)WP^(%FFP_white_point_x%,%FFP_white_point_y%^)L^(%FFP_max_luminance%,%FFP_min_luminance%^)'
   set ff_master_display=
)
REM
REM Colour --colormatrix (colour_space)
REM
set NVC_colormatrix=--colormatrix "%FFP_color_space%"
IF /I "%FFP_color_space%" == ""        (set NVC_colormatrix=)
IF /I "%FFP_color_space%" == "null"    (set NVC_colormatrix=)
IF /I "%FFP_color_space%" == "unknown" (set NVC_colormatrix=)
IF /I "%NVC_colormatrix%" == "" (
   set NVC_ff_colormatrix=
   set ff_colormatrix=
) ELSE (
   set NVC_ff_colormatrix=colormatrix=%FFP_color_space%
   set ff_colormatrix=-colorspace %FFP_color_space%
)
REM
REM Colour --colorprim
REM
set NVC_colorprim=--colorprim "%FFP_color_primaries%"
IF /I "%FFP_color_primaries%" == ""        (set NVC_colorprim=)
IF /I "%FFP_color_primaries%" == "null"    (set NVC_colorprim=)
IF /I "%FFP_color_primaries%" == "unknown" (set NVC_colorprim=)
IF /I "%NVC_colorprim%" == "" (
   set NVC_ff_colorprim=
   set ff_colorprim=
) ELSE (
   set NVC_ff_colorprim=colorprim=%FFP_color_primaries%
   set ff_colorprim=-color_primaries %FFP_color_primaries%
)
REM
REM Colour --transfer 
REM
set NVC_transfer=--transfer "%FFP_color_transfer%"
IF /I "%FFP_color_transfer%" == ""        (set NVC_transfer=)
IF /I "%FFP_color_transfer%" == "null"    (set NVC_transfer=)
IF /I "%FFP_color_transfer%" == "unknown" (set NVC_transfer=)
IF /I "%NVC_transfer%" == "" (
   set NVC_ff_transfer=
   set ff_transfer=
) ELSE (
   set NVC_ff_transfer=transfer=%FFP_color_transfer%
   set ff_transfer=-color_trc %FFP_color_transfer%
   IF /I "%FFP_color_transfer%" == "bt470bg" (set ff_transfer=-color_trc gamma28)
   IF /I "%FFP_color_transfer%" == "bt470m"  (set ff_transfer=-color_trc gamma22)
)
REM
REM Frame mmode - Variable Frame Rate (VFR whic us ugly as sin) or Constant Frame Rate (CBR) 
REM (we do not transform it, we preserve it)
REM
IF /I NOT "%MI_V_FrameRate_Mode%" == "CFR" (
   set nvc_InputFrameRate_Mode=VFR
   set x265_ffmpeg_vsync=-vsync 2
) ELSE (
   set nvc_InputFrameRate_Mode=CFR
   set x265_ffmpeg_vsync=
)
REM
set nvc_DisplayAspectRatio=%MI_V_DisplayAspectRatio_String%
set nvc_output_bits=%MI_V_BitDepth%
REM
REM the framerate comes from the input file, rather than %MI_V_FrameRate% so do not specify it
REM
REM define fixed settings for nvencc
REM *** for moderate quality
REM set nvc_vbr_quality=24
REM *** for OK quality
REM set nvc_vbr_quality=22
REM *** for good quality
set nvc_vbr_quality=18
REM intermediate quality
set nvc_vbr_quality=26
REM
set nvc_input_analyze=300
set nvc_lookahead=32
set nvc_aq_strength=1
set nvc_mv_precision=auto
REM These profile settings are for h.265
IF /I "%MI_V_BitDepth%" == "8" (
   set ffmpeg_x64=%ffmpeg_x64_8bit%
   set x264_x64=%x264_x64_8bit%
   set x265_x64=%x265_x64_8bit%
   set x265_pix_fmt=yuv420p
   set ff_hwdl_pixel_format=yuv420p
   set ff_pixel_format=nv12
   set nvc_profile=main
   set nvc_profile_level=5.1
   set nvc_h264_profile=high
   set nvc_h264_profile_level=5.1
) ELSE (
   set ffmpeg_x64=%ffmpeg_x64_10bit%
   set x264_x64=%x264_x64_10bit%
   set x265_x64=%x265_x64_10bit%
   set x265_pix_fmt=yuv420p10le
   set ff_hwdl_pixel_format=yuv444p16le
   set ff_pixel_format=yuv444p16le
   set nvc_profile=main10
   set nvc_profile_level=5.1
   set nvc_h264_profile=high10
   set nvc_h264_profile_level=5.1
)
set nvc_audio_bitrate=384
set nvc_audio_samplerate=48000
set nvc_perm_mon=
REM set nvc_perm_mon=--perf-monitor --perf-monitor-interval 1000
set nvc_perm_mon=
REM
set x265_preset=slow
set nvc_ff_preset=slow
set /a x265_crfmin=%nvc_vbr_quality%-5
set /a x265_crfmax=%nvc_vbr_quality%+5
IF /I NOT "%nvc_output_bits%" == 8 (set x264_hdr=--hdr) else (set x264_hdr=--no-hdr)
REM
REM setup the ffmpeg "-x265_params" string, if any, into variable "nvc_ff_x265_params"
REM
set nvc_ff_x265_params=
IF /I NOT "%NVC_ff_colormatrix%" == "" (
   set cc=
   IF /I NOT "%nvc_ff_x265_params%" == "" (set cc=:)
   set nvc_ff_x265_params=%nvc_ff_x265_params%!cc!!NVC_ff_colormatrix!
)
IF /I NOT "%NVC_ff_colorprim%" == "" (
   set cc=
   IF /I NOT "!nvc_ff_x265_params!" == "" (set cc=:)
   echo cc="%cc%"
   set nvc_ff_x265_params=%nvc_ff_x265_params%!cc!!NVC_ff_colorprim!
)
IF /I NOT "%NVC_ff_transfer%" == "" (
   set cc=
   IF /I NOT "!nvc_ff_x265_params!" == "" (set cc=:)
   set nvc_ff_x265_params=%nvc_ff_x265_params%!cc!!NVC_ff_transfer!
)
IF /I NOT "%NVC_ff_master_display%" == "" (
   set cc=
   IF /I NOT "!nvc_ff_x265_params!" == "" (set cc=:)
   set nvc_ff_x265_params=%nvc_ff_x265_params%!cc!!NVC_ff_master_display!
)
IF /I NOT "%NVC_ff_max_cll%" == "" (
   set cc=
   IF /I NOT "!nvc_ff_x265_params!" == "" (set cc=:)
   set nvc_ff_x265_params=%nvc_ff_x265_params%!cc!!NVC_ff_max_cll!
)
IF /I NOT "%NVC_ff_color_range%" == "" (
   set cc=
   IF /I NOT "!nvc_ff_x265_params!" == "" (set cc=:)
   set nvc_ff_x265_params=%nvc_ff_x265_params%!cc!!NVC_ff_color_range!
)
IF /I NOT "%nvc_ff_x265_params%" == "" (
   set nvc_ff_x265_params=-x265-params "%nvc_ff_x265_params%"
) ELSE (
   set nvc_ff_x265_params=
)
REM
REM Due to this NVENCC error message, "interlaced output is not supported for HEVC codec"
REM if we detect an interlaced input then we'll deinterlace via ffmpeg and pipe it to NVENCC
REM since this doesn't work -
REM      set nvc_interlaced=
REM      IF /I NOT "%MI_V_ScanType%" == "Progressive" (set nvc_interlaced=--interlace TFF)
REM Interlaced input ... assume ot only occurs on CFR material and id TFF
REM
IF /I "%MI_V_ScanType%" == "Progressive" (
   REM OK at this point we have PROGRESSIVE material
   REM OK at this point we have PROGRESSIVE material
   REM OK at this point we have PROGRESSIVE material
   REM --------- anything commented out like this is obsolete but retained for reference purposes
   REM --------- so setup to just feed the inputfile to NVENCC like this
   REM --------- set nvc_cmd_part1="%nvencc_x64%" --device 0 --avhw --avsync %nvc_InputFrameRate_Mode% --input-analyze %nvc_input_analyze% -i "%nvc_input_file%" 
   REM --------- set nvc_cmd_part2=--audio-source "%nvc_input_file%" --audio-codec aac --audio-bitrate %nvc_audio_bitrate% --audio-samplerate %nvc_audio_samplerate% --codec h265 --profile %nvc_profile% --level %nvc_profile_level% --output-depth %nvc_output_bits% --vbr-quality %nvc_vbr_quality% --lookahead %nvc_lookahead% --aq --aq-strength %nvc_aq_strength% --mv-precision %nvc_mv_precision% --aq-temporal --dar %nvc_DisplayAspectRatio% --log-level info %nvc_perm_mon% --chapter-copy --sub-copy %nvc_colormatrix% %nvc_colorprim% %nvc_transfer% %nvc_master_display% %nvc_max_cll% %nvc_color_range% -o "%nvc_output_file%"
   REM
   IF /I "%debug_biglogfile%" == "Yes" ECHO "!DATE! !TIME! Progressive %nvc_input_file%"  >> "%biglogfile%" 2>>&1
   IF /I "%debug_tracelogfile%" == "Yes" ECHO "!DATE! !TIME! Progressive %nvc_input_file%"   >> "%tracelogfile%" 2>>&1
   IF /I "%debug_biglogfile%" == "Yes" ECHO "!DATE! !TIME! nvc_ff_x265_params=%nvc_ff_x265_params%"  >> "%biglogfile%" 2>>&1
   IF /I "%debug_tracelogfile%" == "Yes" ECHO "!DATE! !TIME! nvc_ff_x265_params=%nvc_ff_x265_params%"   >> "%tracelogfile%" 2>>&1
   IF /I "%debug_biglogfile%" == "Yes" set nvc_ff_x265_params>> "%biglogfile%" 2>>&1
   IF /I "%debug_tracelogfile%" == "Yes" set nvc_ff_x265_params>> "%tracelogfile%" 2>>&1
   REM https://ffmpeg.zeranoe.com/forum/viewtopic.php?f=2&t=5475 about pix_fmt
   REM
   REM %ff_color_range% %ff_max_cll% %ff_master_display% %ff_colormatrix% %ff_colorprim% %ff_transfer%
   REM
   set nvc_ff_deinterlace=
   set ff_cmd="%ffmpeg_x64%" -hide_banner -v verbose -strict -1 %OpenCL_device_init% -threads 0 -i "%nvc_input_file%" -threads 0 -sws_flags lanczos+accurate_rnd+full_chroma_int+full_chroma_inp -filter_complex "[0:v]hwupload,unsharp_opencl=lx=3:ly=3:la=0.5:cx=3:cy=3:ca=0.5,hwdownload,format=pix_fmts=%ff_hwdl_pixel_format%" -c:v hevc_nvenc -pix_fmt %ff_pixel_format% -profile:v %nvc_profile% -level %nvc_profile_level% -preset %nvc_ff_preset% -rc vbr_hq -cq %nvc_vbr_quality% -rc-lookahead %nvc_lookahead% -spatial_aq 1 %ff_color_range% %ff_max_cll% %ff_master_display% %ff_colormatrix% %ff_colorprim% %ff_transfer% -c:a libfdk_aac -cutoff 18000 -ab %nvc_audio_bitrate%k -ar %nvc_audio_samplerate% -threads 0 -movflags +faststart -y "%nvc_output_file%"
   REM set ff_cmd_old="%ffmpeg_x64%" -hide_banner -v verbose %OpenCL_device_init% -threads 0 -i "%nvc_input_file%" -threads 0 -c:v copy -c:a libfdk_aac -cutoff 18000 -ab %nvc_audio_bitrate%k -ar %nvc_audio_samplerate% -threads 0 -movflags +faststart -y "%nvc_output_file%.ffmpeg.old.h265.mp4"
   REM set nvc_cmd="%nvencc_x64%" --device 0 --avhw --avsync %nvc_InputFrameRate_Mode% --input-analyze %nvc_input_analyze% -i "%nvc_input_file%" --audio-codec aac --audio-bitrate %nvc_audio_bitrate% --audio-samplerate %nvc_audio_samplerate% --codec h265 --profile %nvc_profile% --level %nvc_profile_level% --output-depth %nvc_output_bits% --vbr-quality %nvc_vbr_quality% --lookahead %nvc_lookahead% --aq --aq-strength %nvc_aq_strength% --mv-precision %nvc_mv_precision% --aq-temporal --dar %nvc_DisplayAspectRatio% --log-level info %nvc_perm_mon% --chapter-copy --sub-copy %nvc_colormatrix% %nvc_colorprim% %nvc_transfer% %nvc_master_display% %nvc_max_cll% %nvc_color_range% -o "%nvc_output_file%"
   REM X265 does not have a DAR like --dar %nvc_DisplayAspectRatio%
   REM we also omitted --open-gop 
   REM set x265_cmd="%ffmpeg_x64%"  -i "%nvc_input_file%" -an -pixel-format yuv420p     -pix_fmt yuv420p     -strict -1 -f yuv4mpegpipe - ^| "%x265_x64%" --input - --y4m --output "%nvc_output_file%" --preset %x265_preset%  --output-depth %nvc_output_bits% --profile %nvc_profile% --level-idc %nvc_profile_level% --crf %nvc_vbr_quality% --crf-min %x265_crfmin% --crf-max %x265_crfmax% --aq-mode 1 --aq-strength %nvc_aq_strength% --rc-lookahead %nvc_lookahead% %x264_hdr% --hrd %x265_color_range% %nvc_colormatrix% %nvc_colorprim% %nvc_transfer% %nvc_master_display% %nvc_max_cll% --info 
   REM set x265_cmd="%ffmpeg_x64%"  -i "%nvc_input_file%" -an -pixel-format yuv420p10le -pix_fmt yuv420p10le -strict -1 -f yuv4mpegpipe - ^| "%x265_x64%" --input - --y4m --output "%nvc_output_file%" --preset %x265_preset%  --output-depth %nvc_output_bits% --profile %nvc_profile% --level-idc %nvc_profile_level% --crf %nvc_vbr_quality% --crf-min %x265_crfmin% --crf-max %x265_crfmax% --aq-mode 1 --aq-strength %nvc_aq_strength% --rc-lookahead %nvc_lookahead% %x264_hdr% --hrd %x265_color_range% %nvc_colormatrix% %nvc_colorprim% %nvc_transfer% %nvc_master_display% %nvc_max_cll% --info 
   REM set x265_cmd_ffmpeg_pipe="%ffmpeg_x64%" -hide_banner -v verbose %OpenCL_device_init% -threads 0 -i "%nvc_input_file%" -threads 0 -an %x265_ffmpeg_vsync% -sws_flags lanczos+accurate_rnd+full_chroma_int+full_chroma_inp -filter_complex "[0:v]yadif=0:0:0" -pix_fmt %x265_pix_fmt% -f yuv4mpegpipe - 
   REM set x265_cmd="%x265_x64%" --input-depth %nvc_output_bits% --y4m -input - --output "%nvc_output_file%.h265" --log-level info --no-interlace --preset %x265_preset%  --output-depth %nvc_output_bits% --profile %nvc_profile% --level-idc %nvc_profile_level% --crf %nvc_vbr_quality% --crf-min %x265_crfmin% --crf-max %x265_crfmax% --aq-mode 1 --aq-strength %nvc_aq_strength% --rc-lookahead %nvc_lookahead% %x264_hdr% --hrd %x265_color_range% %nvc_colormatrix% %nvc_colorprim% %nvc_transfer% %nvc_master_display% %nvc_max_cll% 
   REM notice there's no auidio processing in the x265 command ?????
) ELSE (
   REM OK at this point we have INTERLACED material
   REM OK at this point we have INTERLACED material
   REM OK at this point we have INTERLACED material
   REM we know that Nvidia can't encode h.265 interlaced 
   REM --------- anything commented out like this is obsolete but retained for reference purposes
   REM --------- so setup ffmpeg to deinterlace it and pipe it to ffmpeg-nvenc like this
   REM ---------     ffmpeg -y -i "inputfile" -an -pixel-format yuv420p     -pix_fmt yuv420p     -strict -1 -f yuv4mpegpipe - | NVEncC --y4m -i - 
   REM ---------     ffmpeg -y -i "inputfile" -an -pixel-format yuv420p10le -pix_fmt yuv420p10le -strict -1 -f yuv4mpegpipe - | NVEncC --y4m -i - 
   REM --------- Don't sharpen anything in ffmpeg since we can do that in NVENCC if we wanted to
   REM --------- SET OpenCL_device_init=-init_hw_device opencl=ocl:1.0 -filter_hw_device ocl
   REM --------- SET sharpenthevideo=False
   REM --------- SET sharpenflags=
   REM --------- IF /I "%sharpenthevideo%" == "True" (SET sharpenflags=,hwupload,unsharp_opencl=lx=3:ly=3:la=0.5:cx=3:cy=3:ca=0.5,hwdownload)
   REM --------- for 8 bit (different pix_fmt)
   REM --------- set nvc_cmd_part1="%ffmpeg_x64%" -hide_banner -v verbose %OpenCL_device_init% -threads 0 -i "%nvc_input_file%" -threads 0 -an -sws_flags lanczos+accurate_rnd+full_chroma_int+full_chroma_inp -filter_complex "[0:v]yadif=0:0:0" -pix_fmt yuv420p -strict -1     -f yuv4mpegpipe - ^| "%nvencc_x64%" --y4m -i - 
   REM --------- set nvc_cmd_part2=--codec h265 --profile %nvc_profile% --level %nvc_profile_level% --output-depth %nvc_output_bits% --vbr-quality %nvc_vbr_quality% --lookahead %nvc_lookahead% --aq --aq-strength %nvc_aq_strength% --mv-precision %nvc_mv_precision% --aq-temporal --dar %nvc_DisplayAspectRatio% --log-level info %nvc_perm_mon% --chapter-copy --sub-copy %nvc_colormatrix% %nvc_colorprim% %nvc_transfer% %nvc_master_display% %nvc_max_cll% %nvc_color_range% -o "%nvc_output_file%"
   REM --------- for 10 bit (different pix_fmt)
   REM --------- set nvc_cmd_part1="%ffmpeg_x64%" -hide_banner -v verbose %OpenCL_device_init% -threads 0 -i "%nvc_input_file%" -threads 0 -an -sws_flags lanczos+accurate_rnd+full_chroma_int+full_chroma_inp -filter_complex "[0:v]yadif=0:0:0" -pixel_format yuv420p10le -pix_fmt yuv420p10le -strict -1 -f yuv4mpegpipe - ^| "%nvencc_x64%" --y4m -i - 
   REM --------- set nvc_cmd_part2=--codec h265 --profile %nvc_profile% --level %nvc_profile_level% --output-depth %nvc_output_bits% --vbr-quality %nvc_vbr_quality% --lookahead %nvc_lookahead% --aq --aq-strength %nvc_aq_strength% --mv-precision %nvc_mv_precision% --aq-temporal --dar %nvc_DisplayAspectRatio% --log-level info %nvc_perm_mon% --chapter-copy --sub-copy %nvc_colormatrix% %nvc_colorprim% %nvc_transfer% %nvc_master_display% %nvc_max_cll% %nvc_color_range% -o "%nvc_output_file%"
   REM ...  instead of nvencc ... plain ffmpeg video copy for the time bering
   IF /I "%debug_biglogfile%" == "Yes" ECHO "!DATE! !TIME! Interlaced %nvc_input_file%"  >> "%biglogfile%" 2>>&1
   IF /I "%debug_tracelogfile%" == "Yes" ECHO "!DATE! !TIME! Interlaced %nvc_input_file%"   >> "%tracelogfile%" 2>>&1
   IF /I "%debug_biglogfile%" == "Yes" ECHO "!DATE! !TIME! nvc_ff_x265_params=%nvc_ff_x265_params%"  >> "%biglogfile%" 2>>&1
   IF /I "%debug_tracelogfile%" == "Yes" ECHO "!DATE! !TIME! nvc_ff_x265_params=%nvc_ff_x265_params%"   >> "%tracelogfile%" 2>>&1
   IF /I "%debug_biglogfile%" == "Yes" set nvc_ff_x265_params>> "%biglogfile%" 2>>&1
   IF /I "%debug_tracelogfile%" == "Yes" set nvc_ff_x265_params>> "%tracelogfile%" 2>>&1
   REM https://ffmpeg.zeranoe.com/forum/viewtopic.php?f=2&t=5475 about pix_fmt
   REM
   REM %ff_color_range%
   REM %ff_max_cll%
   REM %ff_master_display%
   REM %ff_colormatrix%
   REM %ff_colorprim%
   REM %ff_transfer%
   REM
   REM set nvc_ff_deinterlace=-sws_flags lanczos+accurate_rnd+full_chroma_int+full_chroma_inp -filter_complex "[0:v]yadif=0:0:0,setdar=dar=%nvc_DisplayAspectRatio%"
   set ff_cmd="%ffmpeg_x64%" -hide_banner -v verbose -strict -1 %OpenCL_device_init% -threads 0 -i "%nvc_input_file%" -threads 0 -sws_flags lanczos+accurate_rnd+full_chroma_int+full_chroma_inp -filter_complex "[0:v]yadif=0:0:0,hwupload,unsharp_opencl=lx=3:ly=3:la=0.5:cx=3:cy=3:ca=0.5,hwdownload,format=pix_fmts=%ff_hwdl_pixel_format%" -c:v hevc_nvenc -pix_fmt %ff_pixel_format% -profile:v %nvc_profile% -level %nvc_profile_level% -preset %nvc_ff_preset% -rc vbr_hq -cq %nvc_vbr_quality% -rc-lookahead %nvc_lookahead% -spatial_aq 1 %ff_color_range% %ff_max_cll% %ff_master_display% %ff_colormatrix% %ff_colorprim% %ff_transfer% -c:a libfdk_aac -cutoff 18000 -ab %nvc_audio_bitrate%k -ar %nvc_audio_samplerate% -threads 0 -movflags +faststart -y "%nvc_output_file%"
   REM set ff_cmd_old="%ffmpeg_x64%" -hide_banner -v verbose %OpenCL_device_init% -threads 0 -i "%nvc_input_file%" -threads 0 -c:v copy -c:a libfdk_aac -cutoff 18000 -ab %nvc_audio_bitrate%k -ar %nvc_audio_samplerate% -threads 0 -movflags +faststart -y "%nvc_output_file%.ffmpeg.old.h265.mp4"
   REM assume interlaced is top field first tff.   
   REM --vpp-afs level=4 means to deinterlace
   REM set nvc_cmd="%nvencc_x64%" --device 0 --avhw --avsync %nvc_InputFrameRate_Mode% --interlace tff --input-analyze %nvc_input_analyze% -i "%nvc_input_file%" --audio-codec aac --audio-bitrate %nvc_audio_bitrate% --audio-samplerate %nvc_audio_samplerate% --vpp-deinterlace adaptive --codec h265 --profile %nvc_profile% --level %nvc_profile_level% --output-depth %nvc_output_bits% --vbr-quality %nvc_vbr_quality% --lookahead %nvc_lookahead% --aq --aq-strength %nvc_aq_strength% --mv-precision %nvc_mv_precision% --aq-temporal --dar %nvc_DisplayAspectRatio% --log-level info %nvc_perm_mon% --chapter-copy --sub-copy %nvc_colormatrix% %nvc_colorprim% %nvc_transfer% %nvc_master_display% %nvc_max_cll% %nvc_color_range% -o "%nvc_output_file%"
   REM X265 does not have a DAR like --dar %nvc_DisplayAspectRatio% ... we also omitted --open-gop 
   REM notice there's no auidio processing in the x265 command ????? so audio has to be done separately and then muxed in
   REM 
   REM for x265, try leaving it as interlaced ...
   REM set x265_cmd_ffmpeg_pipe="%ffmpeg_x64%" -hide_banner -v verbose %OpenCL_device_init% -threads 0 -i "%nvc_input_file%" -threads 0 -an %x265_ffmpeg_vsync% -sws_flags lanczos+accurate_rnd+full_chroma_int+full_chroma_inp -flags +ildct+ilme -top 1 -pix_fmt %x265_pix_fmt% -f yuv4mpegpipe - 
   REM set x265_cmd="%x265_x64%" --input-depth %nvc_output_bits% --y4m -input - --output "%nvc_output_file%.h265" --log-level info --interlace tff --preset %x265_preset%  --output-depth %nvc_output_bits% --profile %nvc_profile% --level-idc %nvc_profile_level% --crf %nvc_vbr_quality% --crf-min %x265_crfmin% --crf-max %x265_crfmax% --aq-mode 1 --aq-strength %nvc_aq_strength% --rc-lookahead %nvc_lookahead% %x264_hdr% --hrd %x265_color_range% %nvc_colormatrix% %nvc_colorprim% %nvc_transfer% %nvc_master_display% %nvc_max_cll% 
   REM
   REM No, dammit it breaks, so try deinterlacing it first to make it progressive
   REM set x265_cmd_ffmpeg_pipe="%ffmpeg_x64%" -hide_banner -v verbose %OpenCL_device_init% -threads 0 -i "%nvc_input_file%" -threads 0 -an %x265_ffmpeg_vsync% -sws_flags lanczos+accurate_rnd+full_chroma_int+full_chroma_inp -filter_complex "[0:v]yadif=0:0:0" -pixel_format %x265_pix_fmt% -pix_fmt %x265_pix_fmt% -f yuv4mpegpipe - 
   REM set x265_cmd="%x265_x64%" --input-depth %nvc_output_bits% --y4m -input - --output "%nvc_output_file%.h265" --log-level info --no-interlace --preset %x265_preset%  --output-depth %nvc_output_bits% --profile %nvc_profile% --level-idc %nvc_profile_level% --crf %nvc_vbr_quality% --crf-min %x265_crfmin% --crf-max %x265_crfmax% --aq-mode 1 --aq-strength %nvc_aq_strength% --rc-lookahead %nvc_lookahead% %x264_hdr% --hrd %x265_color_range% %nvc_colormatrix% %nvc_colorprim% %nvc_transfer% %nvc_master_display% %nvc_max_cll% 
)


IF /I "%debug_biglogfile%" == "Yes" ECHO "!DATE! !TIME! ff_cmd="%ff_cmd%" >> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" ECHO "!DATE! !TIME! ff_cmd="%ff_cmd%" >> "%tracelogfile%" 2>>&1
REM delete the output file first
if exist "%nvc_output_file%" DEL "%nvc_output_file%"
REM do the conversion to MP4 HEVC
ECHO "!DATE! !TIME! ---------------------------------------------------------------------------------"
IF /I "%debug_biglogfile%" == "Yes" ECHO "!DATE! !TIME! ---------------------------------------------------------------------------------" >> "%biglogfile%" 2>>&1
IF /I "%debug_tracelogfile%" == "Yes" ECHO "!DATE! !TIME! ---------------------------------------------------------------------------------" >> "%tracelogfile%" 2>>&1
REM echo "%nvencc_x64%" --device 0 --avhw --avsync %nvc_InputFrameRate_Mode% --input-analyze %nvc_input_analyze% -i "%nvc_input_file%" --audio-codec aac --audio-bitrate %nvc_audio_bitrate% --audio-samplerate %nvc_audio_samplerate% --codec h265 --profile %nvc_profile% --level %nvc_profile_level% --output-depth %nvc_output_bits% --vbr-quality %nvc_vbr_quality% --lookahead %nvc_lookahead% --aq --aq-strength %nvc_aq_strength% --mv-precision %nvc_mv_precision% --aq-temporal --dar %nvc_DisplayAspectRatio% --log-level info %nvc_perm_mon% --chapter-copy --sub-copy %nvc_colormatrix% %nvc_colorprim% %nvc_transfer% %nvc_master_display% %nvc_max_cll% %nvc_color_range% -o "%nvc_output_file%"  
REM IF /I "%debug_biglogfile%" == "Yes" echo "%nvencc_x64%" --device 0 --avhw --avsync %nvc_InputFrameRate_Mode% --input-analyze %nvc_input_analyze% -i "%nvc_input_file%" --audio-codec aac --audio-bitrate %nvc_audio_bitrate% --audio-samplerate %nvc_audio_samplerate% --codec h265 --profile %nvc_profile% --level %nvc_profile_level% --output-depth %nvc_output_bits% --vbr-quality %nvc_vbr_quality% --lookahead %nvc_lookahead% --aq --aq-strength %nvc_aq_strength% --mv-precision %nvc_mv_precision% --aq-temporal --dar %nvc_DisplayAspectRatio% --log-level info %nvc_perm_mon% --chapter-copy --sub-copy %nvc_colormatrix% %nvc_colorprim% %nvc_transfer% %nvc_master_display% %nvc_max_cll% %nvc_color_range% -o "%nvc_output_file%" >> "%biglogfile%" 2>>&1
REM IF /I "%debug_tracelogfile%" == "Yes" echo "%nvencc_x64%" --device 0 --avhw --avsync %nvc_InputFrameRate_Mode% --input-analyze %nvc_input_analyze% -i "%nvc_input_file%" --audio-codec aac --audio-bitrate %nvc_audio_bitrate% --audio-samplerate %nvc_audio_samplerate% --codec h265 --profile %nvc_profile% --level %nvc_profile_level% --output-depth %nvc_output_bits% --vbr-quality %nvc_vbr_quality% --lookahead %nvc_lookahead% --aq --aq-strength %nvc_aq_strength% --mv-precision %nvc_mv_precision% --aq-temporal --dar %nvc_DisplayAspectRatio% --log-level info %nvc_perm_mon% --chapter-copy --sub-copy %nvc_colormatrix% %nvc_colorprim% %nvc_transfer% %nvc_master_display% %nvc_max_cll% %nvc_color_range% -o "%nvc_output_file%" >> "%tracelogfile%" 2>>&1
REM IF /I "%debug_tracelogfile%" == "Yes" "%nvencc_x64%" --device 0 --avhw --avsync %nvc_InputFrameRate_Mode% --input-analyze %nvc_input_analyze% -i "%nvc_input_file%" --audio-codec aac --audio-bitrate %nvc_audio_bitrate% --audio-samplerate %nvc_audio_samplerate% --codec h265 --profile %nvc_profile% --level %nvc_profile_level% --output-depth %nvc_output_bits% --vbr-quality %nvc_vbr_quality% --lookahead %nvc_lookahead% --aq --aq-strength %nvc_aq_strength% --mv-precision %nvc_mv_precision% --aq-temporal --dar %nvc_DisplayAspectRatio% --log-level info %nvc_perm_mon% --chapter-copy --sub-copy %nvc_colormatrix% %nvc_colorprim% %nvc_transfer% %nvc_master_display% %nvc_max_cll% %nvc_color_range% -o "%nvc_output_file%" >> "%tracelogfile%" 2>>&1
REM
REM
REM
IF /I "%debug_biglogfile%" == "Yes" ECHO "!DATE! !TIME! debug: displaying MI_ " >> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" echo set MI_>> "%biglogfile%" 2>>&1
IF /I "%debug_tracelogfile%" == "Yes" ECHO "!DATE! !TIME! debug: displaying MI_ " >> "%tracelogfile%" 2>>&1
IF /I "%debug_tracelogfile%" == "Yes" echo set MI_>> "%tracelogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" ECHO "!DATE! !TIME! debug: displaying adjusted FPP_ " >> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" echo set FFP_>> "%biglogfile%" 2>>&1
IF /I "%debug_tracelogfile%" == "Yes" ECHO "!DATE! !TIME! debug: displaying adjusted FPP_ " >> "%tracelogfile%" 2>>&1
IF /I "%debug_tracelogfile%" == "Yes" echo set FFP_>> "%tracelogfile%" 2>>&1
REM IF /I "%debug_biglogfile%" == "Yes" ECHO "!DATE! !TIME! debug: displaying nvc commandlines nvc_cmd " >> "%biglogfile%" 2>>&1
REM IF /I "%debug_biglogfile%" == "Yes" set nvc_cmd>> "%biglogfile%" 2>>&1
REM IF /I "%debug_tracelogfile%" == "Yes" ECHO "!DATE! !TIME! debug: displaying nvc commandlines nvc_cmd " >> "%tracelogfile%" 2>>&1
REM IF /I "%debug_tracelogfile%" == "Yes" set nvc_cmd>> "%tracelogfile%" 2>>&1
REM IF /I "%debug_biglogfile%" == "Yes" ECHO "!DATE! !TIME! debug: displaying x265 parameters and x625_cmd " >> "%biglogfile%" 2>>&1
REM IF /I "%debug_biglogfile%" == "Yes" set x265_>> "%biglogfile%" 2>>&1
REM IF /I "%debug_tracelogfile%" == "Yes" ECHO "!DATE! !TIME! debug: displaying x265 parameters and x625_cmd " >> "%tracelogfile%" 2>>&1
REM IF /I "%debug_tracelogfile%" == "Yes" set x265_>> "%tracelogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" ECHO "!DATE! !TIME! debug: displaying ffmpeg parameters and ff_cmd " >> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" set ff_>> "%biglogfile%" 2>>&1
IF /I "%debug_tracelogfile%" == "Yes" ECHO "!DATE! !TIME! debug: displaying ffmpeg parameters and ff_cmd " >> "%tracelogfile%" 2>>&1
IF /I "%debug_tracelogfile%" == "Yes" set ff_cmd>> "%tracelogfile%" 2>>&1
REM
REM
IF /I "%debug_biglogfile%" == "Yes" ECHO "!DATE! !TIME! ---------------------------------------------------------------------------------" >> "%biglogfile%" 2>>&1
IF /I "%debug_tracelogfile%" == "Yes" ECHO "!DATE! !TIME! ---------------------------------------------------------------------------------" >> "%tracelogfile%" 2>>&1
REM
REM --------- %nvc_cmd_part1% %nvc_cmd_part2%
REM --------- anything commented out like this is obsolete but retained for reference purposes
REM
REM IF /I "%debug_tracelogfile%" == "Yes" set nvc_cmd>> "%tracelogfile%" 2>>&1
REM IF /I "%debug_tracelogfile%" == "Yes" set x265_cmd>> "%tracelogfile%" 2>>&1
IF /I "%debug_tracelogfile%" == "Yes" set ff_cmd>> "%tracelogfile%" 2>>&1
REM IF /I "%debug_biglogfile%" == "Yes" set nvc_cmd>> "%biglogfile%" 2>>&1
REM IF /I "%debug_biglogfile%" == "Yes" set x265_cmd>> "%biglogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" set ff_cmd>> "%biglogfile%" 2>>&1

IF /I "%debug_tracelogfile%" == "Yes" (
   echo "Running ffmpeg with output to "%tracelogfile%"
   echo "Running ffmpeg with output to "%tracelogfile%" >> "%tracelogfile%" 2>>&1
   IF /I "%debug_biglogfile%" == "Yes" echo "Running ffmpeg with output to trace log "%tracelogfile%" >> "%biglogfile%" 2>>&1
   echo %ff_cmd%>> "%tracelogfile%" 2>>&1
   echo %ff_cmd%
   ECHO ON
   %ff_cmd% >> "%tracelogfile%" 2>>&1
   SET EL=!ERRORLEVEL!
   ECHO OFF
) ELSE (
   IF /I "%debug_biglogfile%" == "Yes" (
      echo "Running ffmpeg with output to "%biglogfile%"
      echo "Running ffmpeg with output to "%biglogfile%" >> "%biglogfile%" 2>>&1
      IF /I "%debug_tracelogfile%" == "Yes" echo "Running ffmpeg with output to trace log "%tracelogfile%" >> "%tracelogfile%" 2>>&1
      echo %ff_cmd%>> "%biglogfile%" 2>>&1
      echo %ff_cmd%
      ECHO ON
      %ff_cmd% >> "%biglogfile%" 2>>&1
      SET EL=!ERRORLEVEL!
      ECHO OFF
   ) ELSE (
      echo "Running ffmpeg with output to "console", no log files created."
      echo %ff_cmd%
      ECHO ON
      %ff_cmd%
      SET EL=!ERRORLEVEL!
      ECHO OFF
   )
)
IF /I "!EL!" NEQ "0" (
   IF /I "%debug_biglogfile%" == "Yes" Echo *********  Error !EL! was found >> "%biglogfile%" 2>>&1
   IF /I "%debug_tracelogfile%" == "Yes" Echo *********  Error !EL! was found >> "%tracelogfile%" 2>>&1
   Echo *********  Error !EL! was found 
   IF /I "%debug_biglogfile%" == "Yes" Echo *********  ABORTING ... >> "%biglogfile%" 2>>&1
   IF /I "%debug_tracelogfile%" == "Yes" Echo *********  ABORTING ... >> "%tracelogfile%" 2>>&1
   Echo *********  ABORTING ... 
   pause
   EXIT !EL!
)
REM
IF /I "%debug_biglogfile%" == "Yes"   ECHO "!DATE! !TIME! ============================================================================================================" >> "%biglogfile%" 2>>&1
IF /I "%debug_tracelogfile%" == "Yes" ECHO "!DATE! !TIME! ============================================================================================================" >> "%tracelogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes"   ECHO "!DATE! !TIME! Characteristics of the resulting output file ..." >> "%biglogfile%" 2>>&1
IF /I "%debug_tracelogfile%" == "Yes" ECHO "!DATE! !TIME! Characteristics of the resulting output file ..." >> "%tracelogfile%" 2>>&1
REM Dump all ffprobe Video stream to the trace file
IF /I "%debug_biglogfile%" == "Yes"   echo !DATE! !TIME! "%ffprobe_x64%" -hide_banner -show_format -show_programs -show_streams -show_private_data -find_stream_info -i "%nvc_output_file%"  >> "%biglogfile%" 2>>&1
IF /I "%debug_tracelogfile%" == "Yes" echo !DATE! !TIME! "%ffprobe_x64%" -hide_banner -show_format -show_programs -show_streams -show_private_data -find_stream_info -i "%nvc_output_file%"  >> "%tracelogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes" "%ffprobe_x64%" -hide_banner -show_format -show_programs -show_streams -show_private_data -find_stream_info -i "%nvc_output_file%"  >> "%biglogfile%" 2>>&1
IF /I "%debug_tracelogfile%" == "Yes" "%ffprobe_x64%" -hide_banner -show_format -show_programs -show_streams -show_private_data -find_stream_info -i "%nvc_output_file%"  >> "%tracelogfile%" 2>>&1
IF /I "%debug_biglogfile%" == "Yes"   ECHO "!DATE! !TIME! ============================================================================================================" >> "%biglogfile%" 2>>&1
IF /I "%debug_tracelogfile%" == "Yes" ECHO "!DATE! !TIME! ============================================================================================================" >> "%tracelogfile%" 2>>&1
ECHO "!DATE! !TIME! ---------------------------------------------------------------------------------"
:after_ffmpeg
IF EXIST "%nvc_input_file%" DEL "%nvc_input_file%"
goto :eof










progressive 8bit
set x265_pix_fmt=yuv420p
progressive 10bit
set x265_pix_fmt=yuv420p10le

then 2 identical lines
set x265_cmd_ffmpeg_pipe="%ffmpeg_x64%" -hide_banner -v verbose %OpenCL_device_init% -threads 0 -i "%nvc_input_file%" -threads 0 -an %x265_ffmpeg_vsync% -sws_flags lanczos+accurate_rnd+full_chroma_int+full_chroma_inp -filter_complex "[0:v]yadif=0:0:0" -pixel_format %x265_pix_fmt% -pix_fmt %x265_pix_fmt% -f yuv4mpegpipe - 
set x265_cmd="%x265_x64%" --input-depth %nvc_output_bits% --y4m -input - --output "%nvc_output_file%" --log-level info --no-interlace --preset %x265_preset%  --output-depth %nvc_output_bits% --profile %nvc_profile% --level-idc %nvc_profile_level% --crf %nvc_vbr_quality% --crf-min %x265_crfmin% --crf-max %x265_crfmax% --aq-mode 1 --aq-strength %nvc_aq_strength% --rc-lookahead %nvc_lookahead% %x264_hdr% --hrd %x265_color_range% %nvc_colormatrix% %nvc_colorprim% %nvc_transfer% %nvc_master_display% %nvc_max_cll% 

and to run it 
%x265_cmd_ffmpeg_pipe% | %x265_cmd%

-----------------

interlaced 8bit deinterlaced by ffmpeg
set x265_pix_fmt=yuv420p
interlaced 10bit deinterlaced by ffmpeg
set x265_pix_fmt=yuv420p10le

then 2 identical lines
set x265_cmd_ffmpeg_pipe="%ffmpeg_x64%" -hide_banner -v verbose %OpenCL_device_init% -threads 0 -i "%nvc_input_file%" -threads 0 -an %x265_ffmpeg_vsync% -sws_flags lanczos+accurate_rnd+full_chroma_int+full_chroma_inp -filter_complex "[0:v]yadif=0:0:0" -pixel_format %x265_pix_fmt% -pix_fmt %x265_pix_fmt% -f yuv4mpegpipe - 
set x265_cmd="%x265_x64%" --input-depth %nvc_output_bits% --y4m -input - --output "%nvc_output_file%" --log-level info --no-interlace --preset %x265_preset%  --output-depth %nvc_output_bits% --profile %nvc_profile% --level-idc %nvc_profile_level% --crf %nvc_vbr_quality% --crf-min %x265_crfmin% --crf-max %x265_crfmax% --aq-mode 1 --aq-strength %nvc_aq_strength% --rc-lookahead %nvc_lookahead% %x264_hdr% --hrd %x265_color_range% %nvc_colormatrix% %nvc_colorprim% %nvc_transfer% %nvc_master_display% %nvc_max_cll% 

and to run it 
%x265_cmd_ffmpeg_pipe% | %x265_cmd%


-----------------

interlaced 8bit remaining interlaced
set x265_pix_fmt=yuv420p
interlaced 10bit remaining interlaced
set x265_pix_fmt=yuv420p10le

set x265_cmd_ffmpeg_pipe="%ffmpeg_x64%" -hide_banner -v verbose %OpenCL_device_init% -threads 0 -i "%nvc_input_file%" -threads 0 -an %x265_ffmpeg_vsync% -sws_flags lanczos+accurate_rnd+full_chroma_int+full_chroma_inp -flags +ildct+ilme -top 1 -pix_fmt %x265_pix_fmt% -f yuv4mpegpipe - 
set x265_cmd="%x265_x64%" --input-depth %nvc_output_bits% --y4m -input - --output "%nvc_output_file%" --log-level info --interlace tff --preset %x265_preset%  --output-depth %nvc_output_bits% --profile %nvc_profile% --level-idc %nvc_profile_level% --crf %nvc_vbr_quality% --crf-min %x265_crfmin% --crf-max %x265_crfmax% --aq-mode 1 --aq-strength %nvc_aq_strength% --rc-lookahead %nvc_lookahead% %x264_hdr% --hrd %x265_color_range% %nvc_colormatrix% %nvc_colorprim% %nvc_transfer% %nvc_master_display% %nvc_max_cll% 

and to run it 
%x265_cmd_ffmpeg_pipe% | %x265_cmd%

-------------------------------------------
in ffmpeg, VFR is known as -vsync 2
-vsync parameter
Video sync method. For compatibility reasons old values can be specified as numbers. Newly added values will have to be specified as strings always.
0, passthrough
Each frame is passed with its timestamp from the demuxer to the muxer.
1, cfr
Frames will be duplicated and dropped to achieve exactly the requested constant frame rate.
2, vfr
Frames are passed through with their timestamp or dropped so as to prevent 2 frames from having the same timestamp.
drop
As passthrough but destroys all timestamps, making the muxer generate fresh timestamps based on frame-rate.
-1, auto

Chooses between 1 and 2 depending on muxer capabilities. This is the default method.


FULLY FFMPEG conversion

non-interlaced h.265
REM output-depth=8
ffmpeg -hide_banner -v verbose -threads 0 -i ??? -c:a copy -c:v libx265 -preset fast -profile:v main -level:v 5.1 -x265-params "no-interlace:crf=20:crf-min=15:crf-max=25:aq-mode=1:aq-strength=1:rc-lookahead=32" -y ???.mp4

interlaced h.265
REM output-depth=8
ffmpeg -hide_banner -v verbose -threads 0 -i ??? -c:a copy -flags +ildct+ilme -top 1 -c:v libx265 -preset fast -profile:v main -level:v 5.1 -x265-params "interlace=tff:crf=20:crf-min=15:crf-max=25:aq-mode=1:aq-strength=1:rc-lookahead=32" -y ???.mp4


******************************************************
this actually worked: ffmpeg into ffmpeg deinterlaced:
******************************************************
"C:\SOFTWARE\ffmpeg\0-homebuilt-x64\built_for_generic_opencl\x64\ffmpeg.exe" -hide_banner -v verbose -threads 0 -i "G:\HDTV\0nvencc\test-mp4-03\ABC HD interlaced.aac.mp4" -threads 0 -an  -sws_flags lanczos+accurate_rnd+full_chroma_int+full_chroma_inp -filter_complex "[0:v]yadif=0:0:0" -pix_fmt yuv420p -strict -1 -f yuv4mpegpipe - 2> .\zzz1.txt | "C:\SOFTWARE\ffmpeg\0-homebuilt-x64\built_for_generic_opencl\x64\ffmpeg.exe" -hide_banner -v verbose -threads 0 -strict -1 -i - -c:v libx264 -crf 23 -an  -y .\zzz.mp4 2> .\zzz2.txt
"C:\SOFTWARE\ffmpeg\0-homebuilt-x64\built_for_generic_opencl\x64\ffmpeg.exe" -hide_banner -v verbose -threads 0 -i "G:\HDTV\0nvencc\test-mp4-03\ABC HD interlaced.aac.mp4" -threads 0 -an  -sws_flags lanczos+accurate_rnd+full_chroma_int+full_chroma_inp -filter_complex "[0:v]yadif=0:0:0" -pixel_format yuv420p10le -pix_fmt yuv420p10le -strict -1 -f yuv4mpegpipe - 2> .\zzz1.txt | "C:\SOFTWARE\ffmpeg\0-homebuilt-x64\built_for_generic_opencl\x64\ffmpeg.exe" -hide_banner -v verbose -threads 0 -strict -1 -i - -c:v libx264 -crf 23 -an  -y .\zzz.mp4 2> .\zzz2.txt


******************************************************
try interlaced ffmpeg into ffmpeg
******************************************************
"C:\SOFTWARE\ffmpeg\0-homebuilt-x64\built_for_generic_opencl\x64\ffmpeg.exe" -hide_banner -v verbose -threads 0 -i "G:\HDTV\0nvencc\test-mp4-03\ABC HD interlaced.aac.mp4" -threads 0 -an  -sws_flags lanczos+accurate_rnd+full_chroma_int+full_chroma_inp -flags +ildct+ilme -top 1 -pix_fmt yuv420p -strict -1 -f yuv4mpegpipe - 2> .\zzz1.txt | "C:\SOFTWARE\ffmpeg\0-homebuilt-x64\built_for_generic_opencl\x64\ffmpeg.exe" -hide_banner -v verbose -threads 0 -strict -1 -i - -c:v libx264 -flags +ildct+ilme -top 1 -crf 23 -an  -y .\zzz.mp4 2> .\zzz2.txt
"C:\SOFTWARE\ffmpeg\0-homebuilt-x64\built_for_generic_opencl\x64\ffmpeg.exe" -hide_banner -v verbose -threads 0 -i "G:\HDTV\0nvencc\test-mp4-03\ABC HD interlaced.aac.mp4" -threads 0 -an  -sws_flags lanczos+accurate_rnd+full_chroma_int+full_chroma_inp -flags +ildct+ilme -top 1 -pixel_format yuv420p10le -pix_fmt yuv420p10le -strict -1 -f yuv4mpegpipe - 2> .\zzz1.txt | "C:\SOFTWARE\ffmpeg\0-homebuilt-x64\built_for_generic_opencl\x64\ffmpeg.exe" -hide_banner -v verbose -threads 0 -strict -1 -i - -c:v libx264 -flags +ildct+ilme -top 1 -crf 23 -an  -y .\zzz.mp4 2> .\zzz2.txt











chroma_sample_location integer (decoding/encoding,video)
Possible values:
‘left’
‘center’
‘topleft’
‘top’
‘bottomleft’
‘bottom’



------------- done -------------
color_range integer (decoding/encoding,video)
If used as input parameter, it serves as a hint to the decoder, which color_range the input has. Possible values:
‘tv’ ‘mpeg’ MPEG (219*2^(n-8))
‘pc’ ‘jpeg’ JPEG (2^n-1)

colorspace integer (decoding/encoding,video)
Possible values:
‘rgb’ RGB
‘bt709’ BT.709
‘fcc’ FCC
‘bt470bg’ BT.470 BG
‘smpte170m’ SMPTE 170 M
‘smpte240m’ SMPTE 240 M
‘ycocg’ YCOCG
‘bt2020nc’ ‘bt2020_ncl’ BT.2020 NCL
‘bt2020c’ ‘bt2020_cl’ BT.2020 CL
‘smpte2085’ SMPTE 2085

color_primaries 
‘bt709’ BT.709
‘bt470m’ BT.470 M
‘bt470bg’ BT.470 BG
‘smpte170m’ SMPTE 170 M
‘smpte240m’ SMPTE 240 M
‘film’ Film
‘bt2020’ BT.2020
‘smpte428’ ‘smpte428_1’ SMPTE ST 428-1
‘smpte431’ SMPTE 431-2
‘smpte432’ SMPTE 432-1
‘jedec-p22’ JEDEC P22

color_trc integer (decoding/encoding,video)
Possible values:
‘bt709’ BT.709
‘gamma22’ BT.470 M
‘gamma28’ BT.470 BG
‘smpte170m’ SMPTE 170 M
‘smpte240m’ SMPTE 240 M
‘linear’ Linear
‘log’ ‘log100’ Log
‘log_sqrt’ ‘log316’ Log square root
‘iec61966_2_4’ ‘iec61966-2-4’ IEC 61966-2-4 
‘bt1361’  ‘bt1361e’ BT.1361
‘iec61966_2_1’ ‘iec61966-2-1’ IEC 61966-2-1
‘bt2020_10’ ‘bt2020_10bit’ BT.2020 - 10 bit
‘bt2020_12’ ‘bt2020_12bit’ BT.2020 - 12 bit
‘smpte2084’ SMPTE ST 2084 
‘smpte428’ ‘smpte428_1’ SMPTE ST 428-1
‘arib-std-b67’ ARIB STD-B67
