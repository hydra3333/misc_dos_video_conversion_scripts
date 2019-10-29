@Echo OFF
@setlocal ENABLEDELAYEDEXPANSION
@setlocal enableextensions
REM
REM Parse video files to find metadata
REM
set nvencc_x64=C:\SOFTWARE\NVEncC\NVEncC64.exe
REM
set ffmpeg_x64=C:\SOFTWARE\ffmpeg\0-homebuilt-x64\ffmpeg.exe
set ffprobe_x64=C:\SOFTWARE\ffmpeg\0-homebuilt-x64\ffprobe.exe
set mp4box_x64=C:\SOFTWARE\ffmpeg\0-homebuilt-x64\MP4Box.exe
set muxer_x64=C:\SOFTWARE\ffmpeg\0-homebuilt-x64\muxer.exe
set rtmpdump_x64=C:\SOFTWARE\ffmpeg\0-homebuilt-x64\rtmpdump.exe
set x264_x64=C:\SOFTWARE\ffmpeg\0-homebuilt-x64\x264.exe
set x265_x64=C:\SOFTWARE\ffmpeg\0-homebuilt-x64\x264.exe
set mediainfo_x64=C:\software\mediainfo\mediainfo.exe
set mkvinfo_x64=C:\SOFTWARE\mkvtoolnix\mkvinfo.exe

set biglogfile=%~0.biglogfile.log
REM IF EXIST "%biglogfile%" echo "!DATE! !TIME! about to delete file "%biglogfile%""
IF EXIST "%biglogfile%" del "%biglogfile%"

for %%y in (".\*.mp4" ".\*.webm" ".\*.mpg" ".\*.ts") do (
   REM %%~fy - the ~f in this removes quotes and fully expands the filename into include disk, path, filename and extension
   ECHO !DATE! !TIME! Finding metadata for: "%%~fy"
   ECHO.
   ECHO !DATE! !TIME! Finding metadata for: "%%~fy" >> "%biglogfile%" 2>>&1
   ECHO. >> "%biglogfile%" 2>>&1
   call :FIND_RELEVANT_METADATA "%%~fy"
   set outputfilename=%%~fy.%FFP_color_range%.%FFP_color_space%.%FFP_color_primaries%.%FFP_color_transfer%.h265.mp4
   set outputfilename >> "%biglogfile%" 2>>&1
   ECHO !DATE! !TIME! Finished metadata for: "%%~fy"
   ECHO.
   ECHO !DATE! !TIME! Finished metadata for: "%%~fy" >> "%biglogfile%" 2>>&1
   ECHO. >> "%biglogfile%" 2>>&1
)

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
   REM echo "!DATE! !TIME! in :FIND_RELEVANT_METADATA Started finding mediainfo metadata from "%input_file%"" >> "%biglogfile%" 2>>&1
   REM
   set trace_logfile=%input_file%.trace.log
   REM IF EXIST "%trace_logfile%" echo "!DATE! !TIME! about to delete file "%trace_logfile%""
   IF EXIST "%trace_logfile%" del "%trace_logfile%"
   REM
   set tmpfile=%input_file%.mediainfo-result.tmp
   REM IF EXIST "%tmpfile%" echo "!DATE! !TIME! about to delete file "%tmpfile%""
   IF EXIST "%tmpfile%" del "%tmpfile%"
   REM
   set templatecsvfile=%input_file%.mediainfo-input.csv
   REM IF EXIST "%templatecsvfile%" echo "!DATE! !TIME! about to delete file "%templatecsvfile%""
   IF EXIST "%templatecsvfile%" del "%templatecsvfile%"
   REM
   REM
   REM ----------------------------------------------
   call :ascertain_mediainfo_metadata "%input_file%"
   REM ----------------------------------------------
   REM ECHO "!DATE! !TIME! debug: displaying MI_ result for %input_file%" >> "%biglogfile%" 2>>&1
   set MI_ >> "%biglogfile%" 2>>&1
   REM ECHO "!DATE! !TIME! debug: displaying MI_ result for %input_file%" >> "%trace_logfile%" 2>>&1
   set MI_ >> "%trace_logfile%" 2>>&1
   REM
   REM
   REM
   REM IF EXIST "%templatecsvfile%" echo "!DATE! !TIME! about to delete file "%templatecsvfile%""
   IF EXIST "%templatecsvfile%" del "%templatecsvfile%"
   REM echo "!DATE! !TIME! Finished finding mediainfo metadata from "%input_file%""
   REM echo "!DATE! !TIME! ----------------------------------------------------------------------------------------"
   REM echo "!DATE! !TIME! ----------------------------------------------------------------------------------------" >> "%biglogfile%" 2>>&1
   REM echo "!DATE! !TIME! ----------------------------------------------------------------------------------------" >> "%trace_logfile%" 2>>&1
   REM   
   REM *****************************************************************************************************************
   REM *****************************************************************************************************************
   REM -----------------------------------------------------------------------------------------------------------------------------
   REM Find FFPROBE metadata - note that this is more reliable metadata from MEDIAINFO and thus should take precenence 
   REM -----------------------------------------------------------------------------------------------------------------------------
   REM
   REM echo "!DATE! !TIME! Started finding FFPROBE metadata from "%input_file%""
   set tmpfile=%input_file%.ffprobe-result.tmp
   REM IF EXIST "%tmpfile%" echo "!DATE! !TIME! about to delete file "%tmpfile%""
   IF EXIST "%tmpfile%" del "%tmpfile%"
   REM
   REM
   REM
   REM --------------------------------------------
   call :ascertain_ffprobe_metadata "%input_file%"
   REM --------------------------------------------
   REM ECHO "!DATE! !TIME! debug: displaying FFP_ result for %input_file%" >> "%biglogfile%" 2>>&1
   set FFP_ >> "%biglogfile%" 2>>&1
   REM ECHO "!DATE! !TIME! debug: displaying NVC_ result for %input_file%" >> "%biglogfile%" 2>>&1
   set NVC_ >> "%biglogfile%" 2>>&1
   REM ECHO "!DATE! !TIME! debug: displaying FFP_ result for %input_file%" >> "%trace_logfile%" 2>>&1
   set FFP_ >> "%trace_logfile%" 2>>&1
   REM ECHO "!DATE! !TIME! debug: displaying NVC_ result for %input_file%" >> "%trace_logfile%" 2>>&1
   set NVC_ >> "%trace_logfile%" 2>>&1
   REM
   REM
   REM
   REM IF EXIST "%tmpfile%" echo "!DATE! !TIME! about to delete file "%tmpfile%""
   IF EXIST "%tmpfile%" del "%tmpfile%"   
   REM echo "!DATE! !TIME! Finished finding mediainfo metadata from "%input_file%""
   REM echo "!DATE! !TIME! %input_file% ----------------------------------------------------------------------------------------"
   REM echo "!DATE! !TIME! %input_file% ----------------------------------------------------------------------------------------" >> "%biglogfile%" 2>>&1
   REM echo "!DATE! !TIME! %input_file% ----------------------------------------------------------------------------------------" >> "%trace_logfile%" 2>>&1
   goto :eof

:ascertain_mediainfo_metadata
@echo off
REM @setlocal ENABLEDELAYEDEXPANSION
REM @setlocal enableextensionsecho "!DATE! !TIME! Running mediainfo queries ..."
REM this trickery only works with setlocal disabled :(
set queried_input_file=%~f1
IF /I "%queried_input_file%" == "" ECHO "!DATE! !TIME! DEBUG: in ascertain_mediainfo_metadata but nothing to do, no media file specified ... Exiting ..."  >> "%biglogfile%" 2>>&1
IF /I "%queried_input_file%" == "" ECHO "!DATE! !TIME! DEBUG: in ascertain_mediainfo_metadata but nothing to do, no media file specified ... Exiting ..."  >> "%trace_logfile%" 2>>&1
IF /I "%queried_input_file%" == "" ECHO "!DATE! !TIME! DEBUG: in ascertain_mediainfo_metadata but nothing to do, no media file specified ... Exiting ..."
IF /I "%queried_input_file%" == "" exit 1
REM
REM Assume these variables have already been set before calling this function
REM    mediainfo_x64 = the fully qualified filename to the .exe for mediainfo
REM    ffprobe_x64 = the fully qualified filename to the .exe for ffprobe
REM
REM echo "!DATE! !TIME! ----------------------------------------------------------------------------------------"
REM echo "!DATE! !TIME! ----------------------------------------------------------------------------------------" >> "%biglogfile%" 2>>&1
REM echo "!DATE! !TIME! ----------------------------------------------------------------------------------------" >> "%trace_logfile%" 2>>&1
REM echo "!DATE! !TIME! in ascertain_mediainfo_metadata Starting finding MEDIAINFO metadata from "%queried_input_file%""
REM echo "!DATE! !TIME! in ascertain_mediainfo_metadata Starting finding MEDIAINFO metadata from "%queried_input_file%"" >> "%biglogfile%" 2>>&1
REM echo "!DATE! !TIME! in ascertain_mediainfo_metadata Starting finding MEDIAINFO metadata from "%queried_input_file%"" >> "%trace_logfile%" 2>>&1
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
REM ECHO "!DATE! !TIME! ---------------------------------------------------------------------------------" >> "%biglogfile%" 2>>&1
REM ECHO "!DATE! !TIME! ---------------------------------------------------------------------------------" >> "%trace_logfile%" 2>>&1
REM Dump all mediainfo to the trace file
REM echo !DATE! !TIME! "%mediainfo_x64%" --Full "%queried_input_file%"  >> "%biglogfile%" 2>>&1
REM echo !DATE! !TIME! "%mediainfo_x64%" --Full "%queried_input_file%"  >> "%trace_logfile%" 2>>&1
REM "%mediainfo_x64%" --Full "%queried_input_file%"  >> "%biglogfile%" 2>>&1
REM "%mediainfo_x64%" --Full "%queried_input_file%"  >> "%trace_logfile%" 2>>&1
REM ECHO "!DATE! !TIME! ---------------------------------------------------------------------------------" >> "%biglogfile%" 2>>&1
REM ECHO "!DATE! !TIME! ---------------------------------------------------------------------------------" >> "%trace_logfile%" 2>>&1
REM
REM IF EXIST "%tmpfile%" echo "!DATE! !TIME! about to delete file "%tmpfile%""
IF EXIST "%tmpfile%" del "%tmpfile%"   
REM  
REM echo "!DATE! !TIME! in ascertain_mediainfo_metadata Finished finding MEDIAINFO metadata from "%queried_input_file%""
REM echo "!DATE! !TIME! in ascertain_mediainfo_metadata Finished finding MEDIAINFO metadata from "%queried_input_file%"" >> "%biglogfile%" 2>>&1
REM echo "!DATE! !TIME! in ascertain_mediainfo_metadata Finished finding MEDIAINFO metadata from "%queried_input_file%"" >> "%trace_logfile%" 2>>&1
REM echo "!DATE! !TIME! ----------------------------------------------------------------------------------------"
REM echo "!DATE! !TIME! ----------------------------------------------------------------------------------------" >> "%biglogfile%" 2>>&1
REM echo "!DATE! !TIME! ----------------------------------------------------------------------------------------" >> "%trace_logfile%" 2>>&1
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
IF /I "%~4" == "" ECHO "!DATE! !TIME! DEBUG: in ascertain_mediainfo_value but nothing to do, no media file specified ... Exiting ..."  >> "%biglogfile%" 2>>&1
IF /I "%~4" == "" ECHO "!DATE! !TIME! DEBUG: in ascertain_mediainfo_value but nothing to do, no media file specified ... Exiting ..."  >> "%trace_logfile%" 2>>&1
IF /I "%~4" == "" ECHO "!DATE! !TIME! DEBUG: in ascertain_mediainfo_value but nothing to do, no media file specified ... Exiting ..."
IF /I "%~4" == "" exit 1
REM no spaces at the end of these command, please
set amv_the_MI_section=%~1
set amv_the_MI_variable=%~2
set amv_the_MI_value_to_retrieve=%~3
set amv_the_MI_filename=%~f4
set tmp_mediainfo_result=%amv_the_MI_filename%.tmp.mediainfo.result
IF EXIST "%tmp_mediainfo_result%" DEL "%tmp_mediainfo_result%"
REM no spaces at the end of these command, please
"%mediainfo_x64%" "--Inform=%amv_the_MI_section%;%%%amv_the_MI_value_to_retrieve%%%" "%amv_the_MI_filename%">"%tmp_mediainfo_result%"
REM no spaces at the end of these commands, please
set tmp_local_variable=null
set /p tmp_local_variable=<"%tmp_mediainfo_result%"
IF EXIST "%tmp_mediainfo_result%" DEL "%tmp_mediainfo_result%"
REM ECHO "!DATE! !TIME! %amv_the_MI_variable%=%tmp_local_variable%">> "%biglogfile%" 2>>&1
REM ECHO "!DATE! !TIME! %amv_the_MI_variable%=%tmp_local_variable%">> "%trace_logfile%" 2>>&1
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
REM echo "!DATE! !TIME! ----------------------------------------------------------------------------------------" >> "%biglogfile%" 2>>&1
REM echo "!DATE! !TIME! ----------------------------------------------------------------------------------------" >> "%trace_logfile%" 2>>&1
REM echo "!DATE! !TIME! in ascertain_ffprobe_metadata Starting finding FFPROBE metadata from "%queried_input_file%""
REM echo "!DATE! !TIME! in ascertain_ffprobe_metadata Starting finding FFPROBE metadata from "%queried_input_file%"" >> "%biglogfile%" 2>>&1
REM echo "!DATE! !TIME! in ascertain_ffprobe_metadata Starting finding FFPROBE metadata from "%queried_input_file%"" >> "%trace_logfile%" 2>>&1
REM
REM put ffprobe output into tmpfile to parse into variables
"%ffprobe_x64%" -hide_banner -select_streams V -show_format -show_programs -show_streams -show_private_data -find_stream_info -i "%queried_input_file%" > "%tmpfile%" 2>>&1
REM get the characteristics we are interested in into DOS variables 
REM set defaults first
set FFP_max_average=1000
set FFP_max_content=400
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
      set var=!var:~1!
      set "val="
      for %%d in (%%~b) do set "val=!val!,%%~d"
      set val=!val:~1!
      REM echo .!var!.=.!val!.
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
REM split off trailing "/" etc from some of them ensuring no trailing spaces
for /f "tokens=1,2 delims=/" %%a in ("%FFP_max_content%") do (set "FFP_max_content=%%a")
for /f "tokens=1,2 delims=/" %%a in ("%FFP_max_average%") do (set "FFP_max_average=%%a")
for /f "tokens=1,2 delims=/" %%a in ("%FFP_width%") do (set "FFP_width=%%a")
for /f "tokens=1,2 delims=/" %%a in ("%FFP_height%") do (set "FFP_height=%%a")
for /f "tokens=1,2 delims=/" %%a in ("%FFP_coded_width%") do (set "FFP_coded_width=%%a")
for /f "tokens=1,2 delims=/" %%a in ("%FFP_coded_height%") do (set "FFP_coded_height=%%a")
for /f "tokens=1,2 delims=/" %%a in ("%FFP_has_b_frames%") do (set "FFP_has_b_frames=%%a")
for /f "tokens=1,2 delims=/" %%a in ("%FFP_sample_aspect_ratio%") do (set "FFP_sample_aspect_ratio=%%a")
for /f "tokens=1,2 delims=/" %%a in ("%FFP_display_aspect_ratio%") do (set "FFP_display_aspect_ratio=%%a")
for /f "tokens=1,2 delims=/" %%a in ("%FFP_pix_fmt%") do (set "FFP_pix_fmt=%%a")
for /f "tokens=1,2 delims=/" %%a in ("%FFP_level%") do (set "FFP_level=%%a")
for /f "tokens=1,2 delims=/" %%a in ("%FFP_color_range%") do (set "FFP_color_range=%%a")
for /f "tokens=1,2 delims=/" %%a in ("%FFP_color_space%") do (set "FFP_color_space=%%a")
for /f "tokens=1,2 delims=/" %%a in ("%FFP_color_transfer%") do (set "FFP_color_transfer=%%a")
for /f "tokens=1,2 delims=/" %%a in ("%FFP_color_primaries%") do (set "FFP_color_primaries=%%a")
for /f "tokens=1,2 delims=/" %%a in ("%FFP_r_frame_rate%") do (set "FFP_r_frame_rate=%%a")
for /f "tokens=1,2 delims=/" %%a in ("%FFP_avg_frame_rate%") do (set "FFP_avg_frame_rate=%%a")
for /f "tokens=1,2 delims=/" %%a in ("%FFP_side_data_type%") do (set "FFP_side_data_type=%%a")
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
for /f "tokens=1,2 delims=/" %%a in ("%FFP_codec_name%") do (set "FFP_codec_name=%%a")
for /f "tokens=1,2 delims=/" %%a in ("%FFP_codec_long_name%") do (set "FFP_codec_long_name=%%a")
for /f "tokens=1,2 delims=/" %%a in ("%FFP_profile%") do (set "FFP_profile=%%a")
REM
REM ECHO !DATE! !TIME! start ----------- display ffprobe settings for "%queried_input_file%" >> "%trace_logfile%" 2>>&1
REM ECHO codec_name="%FFP_codec_name%" >> "%trace_logfile%" 2>>&1
REM ECHO codec_long_name="%FFP_codec_long_name%" >> "%trace_logfile%" 2>>&1
REM ECHO profile="%FFP_profile%" >> "%trace_logfile%" 2>>&1
REM ECHO width="%FFP_width%" >> "%trace_logfile%" 2>>&1
REM ECHO height="%FFP_height%" >> "%trace_logfile%" 2>>&1
REM ECHO coded_width="%FFP_coded_width%" >> "%trace_logfile%" 2>>&1
REM ECHO coded_height="%FFP_coded_height%" >> "%trace_logfile%" 2>>&1
REM ECHO has_b_frames="%FFP_has_b_frames%" >> "%trace_logfile%" 2>>&1
REM ECHO sample_aspect_ratio="%FFP_sample_aspect_ratio%" >> "%trace_logfile%" 2>>&1
REM ECHO display_aspect_ratio="%FFP_display_aspect_ratio%" >> "%trace_logfile%" 2>>&1
REM ECHO pix_fmt="%FFP_pix_fmt%" >> "%trace_logfile%" 2>>&1
REM ECHO level="%FFP_level%" >> "%trace_logfile%" 2>>&1
REM ECHO color_range="%FFP_color_range%" >> "%trace_logfile%" 2>>&1
REM ECHO color_space="%FFP_color_space%" >> "%trace_logfile%" 2>>&1
REM ECHO color_transfer="%FFP_color_transfer%" >> "%trace_logfile%" 2>>&1
REM ECHO color_primaries="%FFP_color_primaries%" >> "%trace_logfile%" 2>>&1
REM ECHO r_frame_rate="%FFP_r_frame_rate%" >> "%trace_logfile%" 2>>&1
REM ECHO avg_frame_rate="%FFP_avg_frame_rate%" >> "%trace_logfile%" 2>>&1
REM ECHO max_content="%FFP_max_content%" >> "%trace_logfile%" 2>>&1
REM ECHO max_average="%FFP_max_average%" >> "%trace_logfile%" 2>>&1
REM ECHO side_data_type="%FFP_side_data_type%" >> "%trace_logfile%" 2>>&1
REM ECHO red_x="%FFP_red_x%" >> "%trace_logfile%" 2>>&1
REM ECHO red_y="%FFP_red_y%" >> "%trace_logfile%" 2>>&1
REM ECHO green_x="%FFP_green_x%" >> "%trace_logfile%" 2>>&1
REM ECHO green_y="%FFP_green_y%" >> "%trace_logfile%" 2>>&1
REM ECHO blue_x="%FFP_blue_x%" >> "%trace_logfile%" 2>>&1
REM ECHO blue_y="%FFP_blue_y%" >> "%trace_logfile%" 2>>&1
REM ECHO white_point_x="%FFP_white_point_x%" >> "%trace_logfile%" 2>>&1
REM ECHO white_point_y="%FFP_white_point_y%" >> "%trace_logfile%" 2>>&1
REM ECHO min_luminance="%FFP_min_luminance%" >> "%trace_logfile%" 2>>&1
REM ECHO max_luminance="%FFP_max_luminance%" >> "%trace_logfile%" 2>>&1
REM ECHO !DATE! !TIME! end ----------- display probed settings for "%queried_input_file%" >> "%trace_logfile%" 2>>&1
REM ------------------------------------------------------------------------------------------------
REM ECHO !DATE! !TIME! start ----------- display probed settings for "%queried_input_file%" >> "%biglogfile%" 2>>&1
REM ECHO codec_long_name="%FFP_codec_long_name%" >> "%biglogfile%" 2>>&1
REM ECHO profile="%FFP_profile%" >> "%biglogfile%" 2>>&1
REM ECHO width="%FFP_width%" >> "%biglogfile%" 2>>&1
REM ECHO height="%FFP_height%" >> "%biglogfile%" 2>>&1
REM ECHO coded_width="%FFP_coded_width%" >> "%biglogfile%" 2>>&1
REM ECHO coded_height="%FFP_coded_height%" >> "%biglogfile%" 2>>&1
REM ECHO has_b_frames="%FFP_has_b_frames%" >> "%biglogfile%" 2>>&1
REM ECHO sample_aspect_ratio="%FFP_sample_aspect_ratio%" >> "%biglogfile%" 2>>&1
REM ECHO display_aspect_ratio="%FFP_display_aspect_ratio%" >> "%biglogfile%" 2>>&1
REM ECHO pix_fmt="%FFP_pix_fmt%" >> "%biglogfile%" 2>>&1
REM ECHO level="%FFP_level%" >> "%biglogfile%" 2>>&1
REM ECHO color_range="%FFP_color_range%" >> "%biglogfile%" 2>>&1
REM ECHO color_space="%FFP_color_space%" >> "%biglogfile%" 2>>&1
REM ECHO color_transfer="%FFP_color_transfer%" >> "%biglogfile%" 2>>&1
REM ECHO color_primaries="%FFP_color_primaries%" >> "%biglogfile%" 2>>&1
REM ECHO r_frame_rate="%FFP_r_frame_rate%" >> "%biglogfile%" 2>>&1
REM ECHO avg_frame_rate="%FFP_avg_frame_rate%" >> "%biglogfile%" 2>>&1
REM ECHO max_content="%FFP_max_content%" >> "%biglogfile%" 2>>&1
REM ECHO max_average="%FFP_max_average%" >> "%biglogfile%" 2>>&1
REM ECHO side_data_type="%FFP_side_data_type%" >> "%biglogfile%" 2>>&1
REM ECHO red_x="%FFP_red_x%" >> "%biglogfile%" 2>>&1
REM ECHO red_y="%FFP_red_y%" >> "%biglogfile%" 2>>&1
REM ECHO green_x="%FFP_green_x%" >> "%biglogfile%" 2>>&1
REM ECHO green_y="%FFP_green_y%" >> "%biglogfile%" 2>>&1
REM ECHO blue_x="%FFP_blue_x%" >> "%biglogfile%" 2>>&1
REM ECHO blue_y="%FFP_blue_y%" >> "%biglogfile%" 2>>&1
REM ECHO white_point_x="%FFP_white_point_x%" >> "%biglogfile%" 2>>&1
REM ECHO white_point_y="%FFP_white_point_y%" >> "%biglogfile%" 2>>&1
REM ECHO min_luminance="%FFP_min_luminance%" >> "%biglogfile%" 2>>&1
REM ECHO max_luminance="%FFP_max_luminance%" >> "%biglogfile%" 2>>&1
REM ECHO !DATE! !TIME! end ----------- display ffprobe settings for "%queried_input_file%" >> "%biglogfile%" 2>>&1
REM ------------------------------------------------------------------------------------------------
REM transform some settings into commandline options ready for nvencc
REM --fullrange
SET NVC_color_range=--fullrange
IF /I "%FFP_color_range%" == "tv" (set NVC_color_range=)
IF /I "%FFP_color_range%" == "limited" (set NVC_color_range=)
IF /I "%FFP_color_range%" == "unknown" (set NVC_color_range=)
IF /I "%FFP_color_range%" == "null" (set NVC_color_range=)
REM process --max-cll and remove we we don't understand anything
set NVC_max_cll=--max-cll "%FFP_max_content%,%FFP_max_average%"
IF /I "%FFP_max_content%" == "" (set NVC_max_cll=)
IF /I "%FFP_max_content%" == "null" (set NVC_max_cll=)
IF /I "%FFP_max_content%" == "unknown" (set NVC_max_cll=)
IF /I "%FFP_max_average%" == "" (set NVC_max_cll=)
IF /I "%FFP_max_average%" == "null" (set NVC_max_cll=)
IF /I "%FFP_max_average%" == "unknown" (set NVC_max_cll=)
REM --master-display
set NVC_master_display=--master-display "G("%FFP_green_x%,"%FFP_green_y%)B("%FFP_blue_x%,"%FFP_blue_y%)R("%FFP_red_x%,"%FFP_red_y%)WP("%FFP_white_point_x%,"%FFP_white_point_y%)L("%FFP_max_luminance%,"%FFP_min_luminance%)"
IF /I "%FFP_green_x%" == "" (set NVC_master_display=)
IF /I "%FFP_green_x%" == "null" (set NVC_master_display=)
IF /I "%FFP_green_y%" == "" (set NVC_master_display=)
IF /I "%FFP_green_y%" == "null" (set NVC_master_display=)
IF /I "%FFP_blue_x%" == "" (set NVC_master_display=)
IF /I "%FFP_blue_x%" == "null" (set NVC_master_display=)
IF /I "%FFP_blue_y%" == "" (set NVC_master_display=)
IF /I "%FFP_blue_y%" == "null" (set NVC_master_display=)
IF /I "%FFP_red_x%" == "" (set NVC_master_display=)
IF /I "%FFP_red_x%" == "null" (set NVC_master_display=)
IF /I "%FFP_red_y%" == "" (set NVC_master_display=)
IF /I "%FFP_red_y%" == "null" (set NVC_master_display=)
IF /I "%FFP_white_point_x%" == "" (set NVC_master_display=)
IF /I "%FFP_white_point_x%" == "null" (set NVC_master_display=)
IF /I "%FFP_white_point_y%" == "" (set NVC_master_display=)
IF /I "%FFP_white_point_y%" == "null" (set NVC_master_display=)
IF /I "%FFP_max_luminance%" == "" (set NVC_master_display=)
IF /I "%FFP_max_luminance%" == "null" (set NVC_master_display=)
IF /I "%FFP_min_luminance%" == "" (set NVC_master_display=)
IF /I "%FFP_min_luminance%" == "null" (set NVC_master_display=)
REM --colormatrix
set NVC_colormatrix=--colormatrix "%FFP_color_space%"
IF /I "%FFP_color_space%" == "" (set NVC_colormatrix=)
IF /I "%FFP_color_space%" == "null" (set NVC_colormatrix=)
IF /I "%FFP_color_space%" == "unknown" (set NVC_colormatrix=)
REM --colorprim
set NVC_colorprim=--colorprim "%FFP_color_primaries%"
IF /I "%FFP_color_primaries%" == "" (set NVC_colorprim=)
IF /I "%FFP_color_primaries%" == "null" (set NVC_colorprim=)
IF /I "%FFP_color_primaries%" == "unknown" (set NVC_colorprim=)
REM --transfer 
set NVC_transfer=--transfer "%FFP_color_transfer%"
IF /I "%FFP_color_transfer%" == "" (set NVC_transfer=)
IF /I "%FFP_color_transfer%" == "null" (set NVC_transfer=)
IF /I "%FFP_color_transfer%" == "unknown" (set NVC_transfer=)
REM ------------------------------------------------------------------------------------------------
REM define some quality settings for nvencc
set NVC_input_analyze=360
set NVC_vbr_quality=18
set NVC_lookahead=32
set NVC_audio_bitrate=256
set NVC_audio_samplerate=48000
REM
REM ------------------------------------------------------------------------------------------------
REM ECHO !DATE! !TIME! start ----------- display calculated cli settings for "%queried_input_file%" >> "%trace_logfile%" 2>>&1
REM ECHO NVC_color_range="%NVC_color_range%" >> "%trace_logfile%" 2>>&1
REM ECHO NVC_max_cll="%NVC_max_cll%" >> "%trace_logfile%" 2>>&1
REM ECHO NVC_master_display="%NVC_master_display%" >> "%trace_logfile%" 2>>&1
REM ECHO NVC_colormatrix="%NVC_colormatrix%" >> "%trace_logfile%" 2>>&1
REM ECHO NVC_colorprim="%NVC_colorprim%" >> "%trace_logfile%" 2>>&1
REM ECHO NVC_transfer="%NVC_transfer%" >> "%trace_logfile%" 2>>&1
REM ECHO value NVC_input_analyze="%NVC_input_analyze%" >> "%trace_logfile%" 2>>&1
REM ECHO value NVC_vbr_quality="%NVC_vbr_quality%" >> "%trace_logfile%" 2>>&1
REM ECHO value NVC_lookahead="%NVC_lookahead%" >> "%trace_logfile%" 2>>&1
REM ECHO value NVC_audio_bitrate="%NVC_audio_bitrate%" >> "%trace_logfile%" 2>>&1
REM ECHO value NVC_audio_samplerate="%NVC_audio_samplerate%" >> "%trace_logfile%" 2>>&1
REM ECHO !DATE! !TIME! end ----------- display calculated cli settings for "%queried_input_file%" >> "%trace_logfile%" 2>>&1
REM ------------------------------------------------------------------------------------------------
REM ECHO !DATE! !TIME! start ----------- display calculated cli settings for "%queried_input_file%" >> "%biglogfile%" 2>>&1
REM ECHO NVC_color_range="%NVC_color_range%" >> "%biglogfile%" 2>>&1
REM ECHO NVC_max_cll="%NVC_max_cll%" >> "%biglogfile%" 2>>&1
REM ECHO NVC_master_display="%NVC_master_display%" >> "%biglogfile%" 2>>&1
REM ECHO NVC_colormatrix="%NVC_colormatrix%" >> "%biglogfile%" 2>>&1
REM ECHO NVC_colorprim="%NVC_colorprim%" >> "%biglogfile%" 2>>&1
REM ECHO NVC_transfer="%NVC_transfer%" >> "%biglogfile%" 2>>&1
REM ECHO value NVC_input_analyze="%NVC_input_analyze%" >> "%biglogfile%" 2>>&1
REM ECHO value NVC_vbr_quality="%NVC_vbr_quality%" >> "%biglogfile%" 2>>&1
REM ECHO value NVC_lookahead="%NVC_lookahead%" >> "%biglogfile%" 2>>&1
REM ECHO value NVC_audio_bitrate="%NVC_audio_bitrate%" >> "%biglogfile%" 2>>&1
REM ECHO value NVC_audio_samplerate="%NVC_audio_samplerate%" >> "%biglogfile%" 2>>&1
REM ECHO !DATE! !TIME! end ----------- display calculated cli settings for "%queried_input_file%" >> "%biglogfile%" 2>>&1
REM ------------------------------------------------------------------------------------------------
REM
REM OK, by now based on the info collected above,  we should have enough parameters to decide 
REM whether we are HDR 10 bit or just 8bit ... what sort of output we need, eg
REM    - whether 8bit or 10bit
REM --colormatrix <string>   undef, bt709, smpte170m, bt470bg, smpte240m, YCgCo, fcc, GBR, bt2020nc, bt2020c
REM --colorprim <string>     undef, bt709, smpte170m, bt470m, bt470bg, smpte240m, film, bt2020
REM --transfer <string>      undef, bt709, smpte170m, bt470m, bt470bg, smpte240m, linear, log100, log316, iec61966-2-4, bt1361e, iec61966-2-1, bt2020-10, bt2020-12, smpte2084, smpte428, arib-srd-b67
REM if colormatrix in [ bt2020nc, bt2020c ] then is HDR 10bit
REM if colorprim in [ bt2020 ] then is HDR 10bit
REM if transfer in [ bt2020-10, bt2020-12, smpte2084 ] then is HDR 10bit
REM
set NVC_output_bits=8
IF /I "%FFP_color_space%" == "bt2020nc"        (set NVC_output_bits=10)
IF /I "%FFP_color_space%" == "bt2020c"         (set NVC_output_bits=10)
IF /I "%FFP_color_space%" == "bt2020_ncl"      (set NVC_output_bits=10)
IF /I "%FFP_color_space%" == "bt2020_cl"       (set NVC_output_bits=10)
IF /I "%FFP_color_space%" == "smpte2085"       (set NVC_output_bits=10)
IF /I "%FFP_color_primaries%" == "bt2020"      (set NVC_output_bits=10)
IF /I "%FFP_color_transfer%" == "bt2020-10"    (set NVC_output_bits=10)
IF /I "%FFP_color_transfer%" == "bt2020_10bit" (set NVC_output_bits=10)
IF /I "%FFP_color_transfer%" == "smpte2084"    (set NVC_output_bits=10)
IF /I "%FFP_color_transfer%" == "bt2020-12"    (set NVC_output_bits=12)
IF /I "%FFP_color_transfer%" == "bt2020_12bit" (set NVC_output_bits=12)
IF /I "%FFP_color_transfer%" == "Google VP9" ( IF /I "%FFP_profile%" == "Profile 2" (set NVC_output_bits=10) )
REM
REM ECHO !DATE! !TIME! start ----------- display NVC_output_bits settings for "%queried_input_file%" >> "%biglogfile%" 2>>&1
REM ECHO NVC_output_bits="%NVC_output_bits%" >> "%biglogfile%" 2>>&1
REM ECHO !DATE! !TIME! end ----------- display NVC_output_bits settings for "%queried_input_file%" >> "%biglogfile%" 2>>&1
REM ECHO !DATE! !TIME! start ----------- display NVC_output_bits settings for "%queried_input_file%" >> "%trace_logfile%" 2>>&1
REM ECHO NVC_output_bits="%NVC_output_bits%" >> "%trace_logfile%" 2>>&1
REM ECHO !DATE! !TIME! end ----------- display NVC_output_bits settings for "%queried_input_file%" >> "%trace_logfile%" 2>>&1
REM
REM ECHO "!DATE! !TIME! ---------------------------------------------------------------------------------" >> "%biglogfile%" 2>>&1
REM ECHO "!DATE! !TIME! ---------------------------------------------------------------------------------" >> "%trace_logfile%" 2>>&1
REM Dump all ffprobe Video stream to the trace file
REM echo !DATE! !TIME! "%ffprobe_x64%" -hide_banner -select_streams V -show_format -show_programs -show_streams -show_private_data -find_stream_info -i "%queried_input_file%"  >> "%biglogfile%" 2>>&1
REM echo !DATE! !TIME! "%ffprobe_x64%" -hide_banner -select_streams V -show_format -show_programs -show_streams -show_private_data -find_stream_info -i "%queried_input_file%"  >> "%trace_logfile%" 2>>&1
REM "%ffprobe_x64%" -hide_banner -select_streams V -show_format -show_programs -show_streams -show_private_data -find_stream_info -i "%queried_input_file%"  >> "%biglogfile%" 2>>&1
REM "%ffprobe_x64%" -hide_banner -select_streams V -show_format -show_programs -show_streams -show_private_data -find_stream_info -i "%queried_input_file%"  >> "%trace_logfile%" 2>>&1
REM ECHO "!DATE! !TIME! ---------------------------------------------------------------------------------" >> "%biglogfile%" 2>>&1
REM ECHO "!DATE! !TIME! ---------------------------------------------------------------------------------" >> "%trace_logfile%" 2>>&1
REM
REM IF EXIST "%tmpfile%" echo "!DATE! !TIME! about to delete file "%tmpfile%""
IF EXIST "%tmpfile%" del "%tmpfile%"   
REM  
REM echo "!DATE! !TIME! in ascertain_ffprobe_metadata Finished finding FFPROBE metadata from "%queried_input_file%""
REM ECHO "!DATE! !TIME! in ascertain_ffprobe_metadata Finished finding FFPROBE metadata from "%queried_input_file%"" >> "%biglogfile%" 2>>&1
REM ECHO "!DATE! !TIME! in ascertain_ffprobe_metadata Finished finding FFPROBE metadata from "%queried_input_file%"" >> "%trace_logfile%" 2>>&1
REM echo "!DATE! !TIME! ----------------------------------------------------------------------------------------"
REM ECHO "!DATE! !TIME! ----------------------------------------------------------------------------------------" >> "%biglogfile%" 2>>&1
REM ECHO "!DATE! !TIME! ----------------------------------------------------------------------------------------" >> "%trace_logfile%" 2>>&1
goto :eof
