@Echo on
@setlocal ENABLEDELAYEDEXPANSION
@setlocal enableextensions

REM Parse video files to find metadata

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
if exist "%biglogfile%" echo "about to delete file "%biglogfile%""
if exist "%biglogfile%" del "%biglogfile%"

ECHO OFF
for %%y in (".\*.mp4" ".\*.webm" ".\*.mpg" ".\*.ts") do (
   REM %%~fy - the ~f in this removes quotes and fully expands the filename into include disk, path, filename and extension
   call :parse_my_info "%%~fy"
   ECHO "debug: displaying MI result for %%~fy"
   set MI
)
pause
exit

:parse_my_info
REM @setlocal ENABLEDELAYEDEXPANSION
REM @setlocal enableextensions
   REM parameter 1 is the input filename
   REM %~f1 - the ~f in this removes quotes and fully expands the filename into include disk, path, filename and extension
   REM remember to NOT put any training spaces etc after the following SET substitution
   SET input_file=%~f1
   REM
   echo "Started "%input_file%""
   echo "Started "%input_file%"" >> "%biglogfile%" 2>&1
   REM
   set trace_logfile=%input_file%.trace.log
   if exist "%trace_logfile%" echo "about to delete file "%trace_logfile%""
   if exist "%trace_logfile%" del "%trace_logfile%"
   REM
   set tmpfile=%input_file%.mediainfo-result.tmp
   if exist "%tmpfile%" echo "about to delete file "%tmpfile%""
   if exist "%tmpfile%" del "%tmpfile%"
   REM
   set templatecsvfile=%input_file%.mediainfo-input.csv
   if exist "%templatecsvfile%" echo "about to delete file "%templatecsvfile%""
   if exist "%templatecsvfile%" del "%templatecsvfile%"
   REM
   echo "Started "%input_file%" ----------------------------------------------------------------------------------------" >> "%biglogfile%" 2>&1
   echo "Started "%input_file%" ----------------------------------------------------------------------------------------" >> "%trace_logfile%" 2>&1
   echo "Running mediainfo queries ..."
   echo "Running mediainfo queries ..." >> "%biglogfile%" 2>&1
   echo "Running mediainfo queries ..." >> "%trace_logfile%" 2>&1
   REM *****************************************************************************************************************
   REM *****************************************************************************************************************
   call :ascertain_media_info "%~f1"
   REM *****************************************************************************************************************
   REM *****************************************************************************************************************
   echo "Finished mediainfo queries ..."
   echo "Finished mediainfo queries ..." >> "%biglogfile%" 2>&1
   echo "Finished mediainfo queries ..." >> "%trace_logfile%" 2>&1
   echo "%input_file% ----------------------------------------------------------------------------------------" >> "%biglogfile%" 2>&1
   echo "%input_file% ----------------------------------------------------------------------------------------" >> "%trace_logfile%" 2>&1
   if exist "%templatecsvfile%" echo "about to delete file "%templatecsvfile%""
   if exist "%templatecsvfile%" del "%templatecsvfile%"
   echo General;SET General_Format=%%format%%\r\nSET General_Format_Version=%%format_Version%%\r\nSET General_Format_Profile=%%format_Profile%%\r\nSET General_Format_Level=%%format_Level%%\r\nSET General_Format_Compression=%%format_Compression%%\r\nSET General_CodecID=%%CodecID%%\r\nSET General_CodecID_String=%%CodecID/String%%\r\n>>"%templatecsvfile%"
   echo Video;SET Video_Format=%%format%%\r\nSET Video_Format_Version=%%format_Version%%\r\nSET Video_Format_Profile=%%format_Profile%%\r\nSET Video_Format_Level=%%format_Level%%\r\nSET Video_Format_Tier=%%format_Tier%%\r\nSET Video_Format_Compression=%%format_Compression%%\r\nSET Video_CodecID_String=%%CodecID/String%%\r\nSET Video_ColorSpace=%%ColorSpace%%\r\nSET Video_ChromaSubsampling=%%ChromaSubsampling%%\r\nSET Video_ChromaSubsampling_String=%%ChromaSubsampling/String%%\r\nSET Video_BitDepth=%%BitDepth%%\r\nSET Video_BitDepth_String=%%BitDepth/String%%\r\nSET Video_ScanType=%%ScanType%%\r\nSET Video_ScanType_String=%%ScanType/String%%\r\nSET Video_ScanType_Original =%%ScanType_Original %%\r\nSET Video_ScanType_Original_String=%%ScanType_Original/String%%\r\nSET Video_ScanType_Sto   REMethod=%%ScanType_Sto   REMethod%%\r\nSET Video_ScanType_Sto   REMethod_FieldsPerBlock=%%ScanType_Sto   REMethod_FieldsPerBlock%%\r\nSET Video_ScanType_Sto   REMethod_String=%%ScanType_Sto   REMethod/String%%\r\nSET Video_ScanOrder=%%ScanOrder%%\r\nSET Video_ScanOrder/String=%%ScanOrder/String%%\r\nSET Video_ScanOrder_Stored=%%ScanOrder_Stored%%\r\nSET Video_ScanOrder_Stored_String=%%ScanOrder_Stored/String%%\r\nSET Video_ScanOrder_StoredDisplayedInverted=%%ScanOrder_StoredDisplayedInverted%%\r\nSET Video_ScanOrder_Original=%%ScanOrder_Original%%\r\nSET Video_ScanOrder_Original_String=%%ScanOrder_Original/String%%\r\nSET Video_colour_range=%%colour_range%%\r\nSET Video_colour_description_present=%%colour_description_present%%\r\nSET Video_colour_primaries=%%colour_primaries%%\r\nSET Video_transfer_characteristics=%%transfer_characteristics%%\r\nSET Video_matrix_coefficients=%%matrix_coefficients%%\r\nSET Video_colour_primaries_Original=%%colour_primaries_Original%%\r\nSET Video_colour_description_present_Original=%%colour_description_present_Original%%\r\nSET Video_colour_primaries_Original=%%colour_primaries_Original%%\r\nSET Video_transfer_characteristics_Original=%%transfer_characteristics_Original%%\r\nSET Video_matrix_coefficients_Original=%%matrix_coefficients_Original%%\r\n>>"%templatecsvfile%"
   "%mediainfo_x64%" --Inform="file://%templatecsvfile%" "%input_file%" >> "%biglogfile%" 2>&1
   "%mediainfo_x64%" --Inform="file://%templatecsvfile%" "%input_file%" >> "%trace_logfile%" 2>&1
   REM 
   echo "%input_file% ----------------------------------------------------------------------------------------" >> "%biglogfile%" 2>&1
   echo "%input_file% ----------------------------------------------------------------------------------------" >> "%trace_logfile%" 2>&1
   echo "%mediainfo_x64%" --full "%input_file%" >> "%biglogfile%" 2>&1
   "%mediainfo_x64%" --full "%input_file%" >> "%biglogfile%" 2>&1
   REM
   echo "%mediainfo_x64%" --full "%input_file%" >> "%trace_logfile%" 2>&1
   "%mediainfo_x64%" --full "%input_file%" >> "%trace_logfile%" 2>&1
   REM
   echo "%input_file% ----------------------------------------------------------------------------------------" >> "%biglogfile%" 2>&1
   echo "%input_file% ----------------------------------------------------------------------------------------" >> "%trace_logfile%" 2>&1
   echo "Running ffprobe queries ..."
   echo "Running ffprobe queries ..." >> "%biglogfile%" 2>&1
   echo "Running ffprobe queries ..." >> "%trace_logfile%" 2>&1
   REM put ffprobe output into tmpfile to parse into variables
   "%ffprobe_x64%" -hide_banner -select_streams V -show_format -show_programs -show_streams -show_private_data -find_stream_info -i "%input_file%" > "%tmpfile%" 2>&1
   REM
   REM process ffprobe output into logs too
   echo "%ffprobe_x64%" -hide_banner -select_streams V -show_format -show_programs -show_streams -show_private_data -find_stream_info -i "%input_file%" >> "%biglogfile%" 2>&1
   "%ffprobe_x64%" -hide_banner -select_streams V -show_format -show_programs -show_streams -show_private_data -find_stream_info -i "%input_file%" >> "%biglogfile%" 2>&1
   REM
   echo "%ffprobe_x64%" -hide_banner -select_streams V -show_format -show_programs -show_streams -show_private_data -find_stream_info -i "%input_file%" >> "%trace_logfile%" 2>&1
   "%ffprobe_x64%" -hide_banner -select_streams V -show_format -show_programs -show_streams -show_private_data -find_stream_info -i "%input_file%" >> "%trace_logfile%" 2>&1
   REM
   if exist "%tmpfile%" echo "about to delete file "%tmpfile%""
   if exist "%tmpfile%" del "%tmpfile%"   
   if exist "%templatecsvfile%" echo "about to delete file "%templatecsvfile%""
   if exist "%templatecsvfile%" del "%templatecsvfile%"
   echo "Finished "%input_file%" ----------------------------------------------------------------------------------------" >> "%biglogfile%" 2>&1
   echo "Finished "%input_file%" ----------------------------------------------------------------------------------------" >> "%trace_logfile%" 2>&1
   echo "Finished "%input_file%""
   echo "------------------------------"
)
goto :eof


:ascertain_media_info
REM this trickery only works with setlocal disabled :(
REM @setlocal ENABLEDELAYEDEXPANSION
REM @setlocal enableextensions
if "%~f1" == "" ECHO "DEBUG: in ascertain_media_info but nothing to do, no media file specified ... Exiting ..."  >> "%biglogfile%" 2>&1
if "%~f1" == "" ECHO "DEBUG: in ascertain_media_info but nothing to do, no media file specified ... Exiting ..."  >> "%trace_logfile%" 2>&1
if "%~f1" == "" ECHO "DEBUG: in ascertain_media_info but nothing to do, no media file specified ... Exiting ..."
if "%~f1" == "" exit 1
REM
REM Assume these variables have already been set before calling this function
REM    mediainfo_x64 = the fully qualified filename to the .exe for mediainfo
REM    ffprobe_x64 = the fully qualified filename to the .exe for ffprobe
REM
ECHO "Starting MI for %~f1"
ECHO "%~f1" >> "%biglogfile%" 2>&1
ECHO "%~f1" >> "%trace_logfile%" 2>&1
ECHO "---------------------------------------------------------------------------------" >> "%biglogfile%" 2>&1
ECHO "---------------------------------------------------------------------------------" >> "%trace_logfile%" 2>&1
REM
REM These ones from mediainfo are generally useful
REM 
Call :ascertain_mediainfo_value "General" "MI_G_Format" "Format" "%~f1"
Call :ascertain_mediainfo_value "Video"   "MI_V_Format" "Format" "%~f1"
Call :ascertain_mediainfo_value "Video"   "MI_V_StreamKind" "StreamKind" "%~f1"
Call :ascertain_mediainfo_value "Video"   "MI_V_Codec" "Codec" "%~f1"
Call :ascertain_mediainfo_value "Video"   "MI_V_CodecID" "CodecID" "%~f1"
Call :ascertain_mediainfo_value "Video"   "MI_V_ScanType" "ScanType" "%~f1"
Call :ascertain_mediainfo_value "Video"   "MI_V_ScanType_String" "ScanType/String" "%~f1"
Call :ascertain_mediainfo_value "Video"   "MI_V_Format_Profile" "Format_Profile" "%~f1"
Call :ascertain_mediainfo_value "Video"   "MI_V_Format_Settings_CABAC_String" "Format_Settings_CABAC/String" "%~f1"
Call :ascertain_mediainfo_value "Video"   "MI_V_ColorSpace" "ColorSpace" "%~f1"
Call :ascertain_mediainfo_value "Video"   "MI_V_BitDepth" "BitDepth" "%~f1"
Call :ascertain_mediainfo_value "Video"   "MI_V_ChromaSubsampling" "ChromaSubsampling" "%~f1"
Call :ascertain_mediainfo_value "Video"   "MI_V_Width" "Width" "%~f1"
Call :ascertain_mediainfo_value "Video"   "MI_V_Height" "Height" "%~f1"
Call :ascertain_mediainfo_value "Video"   "MI_V_Rotation" "Rotation" "%~f1"
Call :ascertain_mediainfo_value "Video"   "MI_V_Rotation_String" "Rotation/String" "%~f1"
REM Call :ascertain_mediainfo_value "Video"   "MI_V_PixelAspectRatio" "PixelAspectRatio" "%~f1"
REM Call :ascertain_mediainfo_value "Video"   "MI_V_PixelAspectRatio_String" "PixelAspectRatio/String" "%~f1"
REM Call :ascertain_mediainfo_value "Video"   "MI_V_DisplayAspectRatio" "DisplayAspectRatio" "%~f1"
Call :ascertain_mediainfo_value "Video"   "MI_V_DisplayAspectRatio_String" "DisplayAspectRatio/String" "%~f1"
Call :ascertain_mediainfo_value "Video"   "MI_V_FrameRate_Mode" "FrameRate_Mode" "%~f1"
Call :ascertain_mediainfo_value "Video"   "MI_V_FrameRate_Mode_String" "FrameRate_Mode/String" "%~f1"
Call :ascertain_mediainfo_value "Video"   "MI_V_FrameRate" "FrameRate" "%~f1"
Call :ascertain_mediainfo_value "Video"   "MI_V_FrameRate_Num" "FrameRate_Num" "%~f1"
Call :ascertain_mediainfo_value "Video"   "MI_V_FrameRate_Den" "FrameRate_Den" "%~f1"
REM Call :ascertain_mediainfo_value "Video"   "MI_V_FrameRate_Nominal" "FrameRate_Nominal" "%~f1"
Call :ascertain_mediainfo_value "Video"   "MI_V_FrameRate_Maximum" "FrameRate_Maximum" "%~f1"
Call :ascertain_mediainfo_value "Video"   "MI_V_FrameRate_Minimum" "FrameRate_Minimum" "%~f1"
Call :ascertain_mediainfo_value "Audio"   "MI_A_Video_Delay" "Video_Delay" "%~f1"

REM
REM Example values follow
REM
REM
REM These next ones from mediainfo are usually nul or not so useful
REM
REM Call :ascertain_mediainfo_value "General" "MI_G_Format_Version" "Format_Version" "%~f1"
REM Call :ascertain_mediainfo_value "General" "MI_G_Format_Profile" "Format_Profile" "%~f1"
REM Call :ascertain_mediainfo_value "General" "MI_G_Format_Level" "Format_Level" "%~f1"
REM Call :ascertain_mediainfo_value "General" "MI_G_Format_Compression" "Format_Compression" "%~f1"
REM Call :ascertain_mediainfo_value "General" "MI_G_CodecID" "CodecID" "%~f1"
REM Call :ascertain_mediainfo_value "General" "MI_G_CodecID_String" "CodecID/String" "%~f1"
REM Call :ascertain_mediainfo_value "Video"   "MI_V_StreamKind_String" "StreamKind/String" "%~f1"
REM Call :ascertain_mediainfo_value "Video"   "MI_V_Format_Version" "Format_Version" "%~f1"
REM Call :ascertain_mediainfo_value "Video"   "MI_V_Format_Level" "Format_Level" "%~f1"
REM Call :ascertain_mediainfo_value "Video"   "MI_V_Format_Tier" "Format_Tier" "%~f1"
REM Call :ascertain_mediainfo_value "Video"   "MI_V_Format_Compression" "Format_Compression" "%~f1"
REM Call :ascertain_mediainfo_value "Video"   "MI_V_Format_Settings_Pulldown" "Format_Settings_Pulldown" "%~f1"
REM Call :ascertain_mediainfo_value "Video"   "MI_V_Format_Settings_FrameMode" "Format_Settings_FrameMode" "%~f1"
REM Call :ascertain_mediainfo_value "Video"   "MI_V_Format_Settings_PictureString" "Format_Settings_PictureString" "%~f1"
REM Call :ascertain_mediainfo_value "Video"   "MI_V_Format_Settings_QPel" "Format_Settings_QPel" "%~f1"
REM Call :ascertain_mediainfo_value "Video"   "MI_V_Format_Settings_QPel_String" "Format_Settings_QPel/String" "%~f1"
REM Call :ascertain_mediainfo_value "Video"   "MI_V_Format_Settings_CABAC" "Video_Format_Settings_CABAC" "%~f1"
REM Call :ascertain_mediainfo_value "Video"   "MI_V_MuxingMode" "MuxingMode" "%~f1"
REM Call :ascertain_mediainfo_value "Video"   "MI_V_CodecID_String" "CodecID/String" "%~f1"
REM Call :ascertain_mediainfo_value "Video"   "MI_V_FrameRate_Mode_Original" "FrameRate_Mode_Original" "%~f1"
REM Call :ascertain_mediainfo_value "Video"   "MI_V_FrameRate_Mode_Original_String" "FrameRate_Mode_Original/String" "%~f1"
REM Call :ascertain_mediainfo_value "Video"   "MI_V_FrameRate_String" "FrameRate/String" "%~f1"
REM Call :ascertain_mediainfo_value "Video"   "MI_V_FrameRate_Nominal_String" "FrameRate_Nominal/String" "%~f1"
REM Call :ascertain_mediainfo_value "Video"   "MI_V_FrameRate_Minimum_String" "FrameRate_Minimum/String" "%~f1"
REM Call :ascertain_mediainfo_value "Video"   "MI_V_FrameRate_Maximum_String" "FrameRate_Maximum/String" "%~f1"
Call :ascertain_mediainfo_value "Video"   "MI_V_Delay" "Delay" "%~f1"
REM Call :ascertain_mediainfo_value "Video"   "MI_V_Delay_String" "Delay/String" "%~f1"
REM Call :ascertain_mediainfo_value "Video"   "MI_V_Delay_String1" "Delay/String1" "%~f1"
REM Call :ascertain_mediainfo_value "Video"   "MI_V_Delay_String2" "Delay/String2" "%~f1"
REM Call :ascertain_mediainfo_value "Video"   "MI_V_Delay_String3" "Delay/String3" "%~f1"
REM Call :ascertain_mediainfo_value "Video"   "MI_V_Delay_String4" "Delay/String4" "%~f1"
REM Call :ascertain_mediainfo_value "Video"   "MI_V_Delay_String5" "Delay/String5" "%~f1"
REM Call :ascertain_mediainfo_value "Video"   "MI_V_Delay_Settings" "Delay_Settings" "%~f1"
REM Call :ascertain_mediainfo_value "Video"   "MI_V_ChromaSubsampling_String" "ChromaSubsampling/String" "%~f1"
REM Call :ascertain_mediainfo_value "Video"   "MI_V_ChromaSubsampling_Position" "ChromaSubsampling_Position" "%~f1"
REM Call :ascertain_mediainfo_value "Video"   "MI_V_BitDepth_String" "BitDepth/String" "%~f1"
REM Call :ascertain_mediainfo_value "Video"   "MI_V_ScanType_Original" "ScanType_Original" "%~f1"
REM Call :ascertain_mediainfo_value "Video"   "MI_V_ScanType_Original_String" "ScanType_Original/String" "%~f1"
REM Call :ascertain_mediainfo_value "Video"   "MI_V_ScanType_StoreMethod" "ScanType_StoreMethod" "%~f1"
REM Call :ascertain_mediainfo_value "Video"   "MI_V_ScanType_StoreMethod_FieldsPerBlock" "ScanType_StoreMethod_FieldsPerBlock" "%~f1"
REM Call :ascertain_mediainfo_value "Video"   "MI_V_ScanType_StoreMethod_String" "ScanType_StoreMethod/String" "%~f1"
REM Call :ascertain_mediainfo_value "Video"   "MI_V_ScanOrder" "ScanOrder" "%~f1"
REM Call :ascertain_mediainfo_value "Video"   "MI_V_ScanOrder_String" "ScanOrder/String" "%~f1"
REM Call :ascertain_mediainfo_value "Video"   "MI_V_ScanOrder_Stored" "ScanOrder_Stored" "%~f1"
REM Call :ascertain_mediainfo_value "Video"   "MI_V_ScanOrder_Stored_String" "ScanOrder_Stored/String" "%~f1"
REM Call :ascertain_mediainfo_value "Video"   "MI_V_ScanOrder_StoredDisplayedInverted" "ScanOrder_StoredDisplayedInverted" "%~f1"
REM Call :ascertain_mediainfo_value "Video"   "MI_V_ScanOrder_Original" "ScanOrder_Original" "%~f1"
REM Call :ascertain_mediainfo_value "Video"   "MI_V_ScanOrder_Original_String" "ScanOrder_Original/String" "%~f1"
Call :ascertain_mediainfo_value "Video"   "MI_V_colour_range" "colour_range" "%~f1"
Call :ascertain_mediainfo_value "Video"   "MI_V_colour_description_present" "colour_description_present" "%~f1"
Call :ascertain_mediainfo_value "Video"   "MI_V_colour_primaries" "colour_primaries" "%~f1"
Call :ascertain_mediainfo_value "Video"   "MI_V_transfer_characteristics" "transfer_characteristics" "%~f1"
Call :ascertain_mediainfo_value "Video"   "MI_V_matrix_coefficients" "matrix_coefficients" "%~f1"
REM Call :ascertain_mediainfo_value "Video"   "MI_V_colour_primaries_Original" "colour_primaries_Original" "%~f1"
REM Call :ascertain_mediainfo_value "Video"   "MI_V_colour_description_present_Original" "colour_description_present_Original" "%~f1"
REM Call :ascertain_mediainfo_value "Video"   "MI_V_colour_primaries_Original" "colour_primaries_Original" "%~f1"
REM Call :ascertain_mediainfo_value "Video"   "MI_V_transfer_characteristics_Original" "transfer_characteristics_Original" "%~f1"
REM Call :ascertain_mediainfo_value "Video"   "MI_V_matrix_coefficients_Original" "matrix_coefficients_Original" "%~f1"
ECHO "---------------------------------------------------------------------------------" >> "%biglogfile%" 2>&1
ECHO "---------------------------------------------------------------------------------" >> "%trace_logfile%" 2>&1
ECHO "%~f1" >> "%biglogfile%" 2>&1
ECHO "%~f1" >> "%trace_logfile%" 2>&1
SET MI >> "%biglogfile%" 2>&1
SET MI >> "%trace_logfile%" 2>&1
ECHO "---------------------------------------------------------------------------------" >> "%biglogfile%" 2>&1
ECHO "---------------------------------------------------------------------------------" >> "%trace_logfile%" 2>&1
REM Dump all mediainfo to the trace file
echo "%mediainfo_x64%" --Full "%~f1"  >> "%biglogfile%" 2>&1
echo "%mediainfo_x64%" --Full "%~f1"  >> "%trace_logfile%" 2>&1
"%mediainfo_x64%" --Full "%~f1"  >> "%biglogfile%" 2>&1
"%mediainfo_x64%" --Full "%~f1"  >> "%trace_logfile%" 2>&1
ECHO "---------------------------------------------------------------------------------" >> "%biglogfile%" 2>&1
ECHO "---------------------------------------------------------------------------------" >> "%trace_logfile%" 2>&1
REM Dump all ffprobe Video stream to the trace file
echo "%ffprobe_x64%" -hide_banner -select_streams V -show_format -show_programs -show_streams -show_private_data -find_stream_info -i "%~f1"  >> "%biglogfile%" 2>&1
echo "%ffprobe_x64%" -hide_banner -select_streams V -show_format -show_programs -show_streams -show_private_data -find_stream_info -i "%~f1"  >> "%trace_logfile%" 2>&1
"%ffprobe_x64%" -hide_banner -select_streams V -show_format -show_programs -show_streams -show_private_data -find_stream_info -i "%~f1"  >> "%biglogfile%" 2>&1
"%ffprobe_x64%" -hide_banner -select_streams V -show_format -show_programs -show_streams -show_private_data -find_stream_info -i "%~f1"  >> "%trace_logfile%" 2>&1
ECHO "---------------------------------------------------------------------------------" >> "%biglogfile%" 2>&1
ECHO "---------------------------------------------------------------------------------" >> "%trace_logfile%" 2>&1
ECHO "Ending MI for %~f1"
goto :eof

:ascertain_mediainfo_value
REM this trickery only works with setlocal disabled :(
REM @setlocal ENABLEDELAYEDEXPANSION
REM @setlocal enableextensions
@echo off
REM ECHO parameter 1 = mediainfo secton type, eg General, Video, Audio ... "%~1"
REM ECHO parameter 2 = name of DOS variable to set
REM ECHO parameter 3 = medianfo name of it's variable to retrieve
REM ECHO parameter 4 = the media filkename to query, eg a.mp4
if "%~4" == "" ECHO "DEBUG: in ascertain_mediainfo_value but nothing to do, no media file specified ... Exiting ..."  >> "%biglogfile%" 2>&1
if "%~4" == "" ECHO "DEBUG: in ascertain_mediainfo_value but nothing to do, no media file specified ... Exiting ..."  >> "%trace_logfile%" 2>&1
if "%~4" == "" ECHO "DEBUG: in ascertain_mediainfo_value but nothing to do, no media file specified ... Exiting ..."
if "%~4" == "" exit 1
REM no spaces at the end of these command, please
set amv_the_MI_section=%~1
set amv_the_MI_variable=%~2
set amv_the_MI_value_to_retrieve=%~3
set amv_the_MI_filename=%~f4
set tmp_mediainfo_result=%amv_the_MI_filename%.tmp.mediainfo.result
if exist "%tmp_mediainfo_result%" DEL "%tmp_mediainfo_result%"
REM no spaces at the end of these command, please
"%mediainfo_x64%" "--Inform=%amv_the_MI_section%;%%%amv_the_MI_value_to_retrieve%%%" "%amv_the_MI_filename%">"%tmp_mediainfo_result%"
REM no spaces at the end of these commands, please
set tmp_local_variable=null
set /p tmp_local_variable=<"%tmp_mediainfo_result%"
if exist "%tmp_mediainfo_result%" DEL "%tmp_mediainfo_result%"
REM ECHO "%amv_the_MI_variable%=%tmp_local_variable%">> "%biglogfile%" 2>&1
REM ECHO "%amv_the_MI_variable%=%tmp_local_variable%">> "%trace_logfile%" 2>&1
REM now make it global ...
ENDLOCAL & (set "%amv_the_MI_variable%=%tmp_local_variable%")
goto :eof
