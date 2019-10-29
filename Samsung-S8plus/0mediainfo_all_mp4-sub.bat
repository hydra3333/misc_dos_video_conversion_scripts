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

set biglogfile=.\000-biglogfile.log
if exist "!biglogfile!" echo "about to delete file "!biglogfile!""
if exist "!biglogfile!" del "!biglogfile!"

ECHO OFF
for %%y in (".\*.mp4" ".\*.webm" ".\*.ts") do (
   REM %%~fy - the ~f in this removes quotes and fully expands the filename into include disk, path, filename and extension
   call :parse_my_info "%%~fy"
)
pause
exit

:parse_my_info
@setlocal ENABLEDELAYEDEXPANSION
@setlocal enableextensions
   REM parameter 1 is the input filename
   REM %~f1 - the ~f in this removes quotes and fully expands the filename into include disk, path, filename and extension
   REM remember to NOT put any training spaces etc after the following SET substitution
   SET input_file=%~f1
   REM
   echo "Started "!input_file!""
   echo "Started "!input_file!"" >> "!biglogfile!" 2>&1
   REM
   set logfile=!input_file!.log
   if exist "!logfile!" echo "about to delete file "!logfile!""
   if exist "!logfile!" del "!logfile!"
   REM
   set tmpfile=!input_file!.mediainfo-result.tmp
   if exist "!tmpfile!" echo "about to delete file "!tmpfile!""
   if exist "!tmpfile!" del "!tmpfile!"
   REM
   set templatecsvfile=!input_file!.mediainfo-input.csv
   if exist "!templatecsvfile!" echo "about to delete file "!templatecsvfile!""
   if exist "!templatecsvfile!" del "!templatecsvfile!"
   REM
   echo "Started "!input_file!" ----------------------------------------------------------------------------------------" >> "!biglogfile!" 2>&1
   echo "Started "!input_file!" ----------------------------------------------------------------------------------------" >> "!logfile!" 2>&1
   echo "Running mediainfo queries ..."
   echo "Running mediainfo queries ..." >> "!biglogfile!" 2>&1
   echo "Running mediainfo queries ..." >> "!logfile!" 2>&1
   REM
   "%mediainfo_x64%"  "--Inform=Video;%%Codec%%" "!input_file!" >> "!biglogfile!" 2>&1
   "%mediainfo_x64%"  "--Inform=Video;%%Codec%%" "!input_file!" >> "!logfile!" 2>&1
   "%mediainfo_x64%"  "--Inform=Video;%%Codec%%" "!input_file!" > "!tmpfile!" 2>&1
   set MI_Video_Codec=null
   set /p MI_Video_Codec=<"!tmpfile!"
   echo MI_Video_Codec=!MI_Video_Codec! for "!input_file!" >> "!logfile!" 2>&1
   echo MI_Video_Codec=!MI_Video_Codec! for "!input_file!" >> "!biglogfile!" 2>&1
   REM
   "%mediainfo_x64%"  "--Inform=Video;%%CodecID%%" "!input_file!" >> "!biglogfile!" 2>&1
   "%mediainfo_x64%"  "--Inform=Video;%%CodecID%%" "!input_file!" >> "!logfile!" 2>&1
   "%mediainfo_x64%"  "--Inform=Video;%%CodecID%%" "!input_file!" > "!tmpfile!" 2>&1
   set MI_Video_CodecID=null
   set /p MI_Video_CodecID=<"!tmpfile!"
   echo MI_Video_CodecID=!MI_Video_CodecID! for "!input_file!" >> "!logfile!" 2>&1
   echo MI_Video_CodecID=!MI_Video_CodecID! for "!input_file!" >> "!biglogfile!" 2>&1
   REM
   "%mediainfo_x64%"  "--Inform=Video;%%format%%" "!input_file!" >> "!biglogfile!" 2>&1
   "%mediainfo_x64%"  "--Inform=Video;%%format%%" "!input_file!" >> "!logfile!" 2>&1
   "%mediainfo_x64%"  "--Inform=Video;%%format%%" "!input_file!" > "!tmpfile!" 2>&1
   set MI_Video_Format=null
   set /p MI_Video_Format=<"!tmpfile!"
   echo MI_Video_Format=!MI_Video_Format! for "!input_file!" >> "!logfile!" 2>&1
   echo MI_Video_Format=!MI_Video_Format! for "!input_file!" >> "!biglogfile!" 2>&1
   REM
   "%mediainfo_x64%"  "--Inform=Video;%%format_Profile%%" "!input_file!" >> "!biglogfile!" 2>&1
   "%mediainfo_x64%"  "--Inform=Video;%%format_Profile%%" "!input_file!" >> "!logfile!" 2>&1
   "%mediainfo_x64%"  "--Inform=Video;%%format_Profile%%" "!input_file!" > "!tmpfile!" 2>&1
   set MI_Video_Format_Profile=null
   set /p MI_Video_Format_Profile=<"!tmpfile!"
   echo MI_Video_Format_Profile=!MI_Video_Format_Profile! for "!input_file!" >> "!logfile!" 2>&1
   echo MI_Video_Format_Profile=!MI_Video_Format_Profile! for "!input_file!" >> "!biglogfile!" 2>&1
   REM
   "%mediainfo_x64%"  "--Inform=Video;%%format_Version%%" "!input_file!" >> "!biglogfile!" 2>&1
   "%mediainfo_x64%"  "--Inform=Video;%%format_Version%%" "!input_file!" >> "!logfile!" 2>&1
   "%mediainfo_x64%"  "--Inform=Video;%%format_Version%%" "!input_file!" > "!tmpfile!" 2>&1
   set MI_Video_Format_Version=null
   set /p MI_Video_Format_Version=<"!tmpfile!"
   echo MI_Video_Format_Version=!MI_Video_Format_Version! for "!input_file!" >> "!logfile!" 2>&1
   echo MI_Video_Format_Version=!MI_Video_Format_Version! for "!input_file!" >> "!biglogfile!" 2>&1
   REM
   "%mediainfo_x64%"  "--Inform=Video;%%BitDepth%%" "!input_file!" >> "!biglogfile!" 2>&1
   "%mediainfo_x64%"  "--Inform=Video;%%BitDepth%%" "!input_file!" >> "!logfile!" 2>&1
   "%mediainfo_x64%"  "--Inform=Video;%%BitDepth%%" "!input_file!" > "!tmpfile!" 2>&1
   set MI_Video_BitDepth=null
   set /p MI_Video_BitDepth=<"!tmpfile!"
   echo MI_Video_BitDepth=!MI_Video_BitDepth! for "!input_file!" >> "!logfile!" 2>&1
   echo MI_Video_BitDepth=!MI_Video_BitDepth! for "!input_file!" >> "!biglogfile!" 2>&1
   REM
   "%mediainfo_x64%"  "--Inform=Video;%%ScanType%%" "!input_file!" >> "!biglogfile!" 2>&1
   "%mediainfo_x64%"  "--Inform=Video;%%ScanType%%" "!input_file!" >> "!logfile!" 2>&1
   "%mediainfo_x64%"  "--Inform=Video;%%ScanType%%" "!input_file!" > "!tmpfile!" 2>&1
   set MI_Video_ScanType=null
   set /p MI_Video_ScanType=<"!tmpfile!"
   echo MI_Video_ScanType=!MI_Video_ScanType! for "!input_file!" >> "!logfile!" 2>&1
   echo MI_Video_ScanType=!MI_Video_ScanType! for "!input_file!" >> "!biglogfile!" 2>&1
   REM
   "%mediainfo_x64%"  "--Inform=Video;%%ScanOrder%%" "!input_file!" >> "!biglogfile!" 2>&1
   "%mediainfo_x64%"  "--Inform=Video;%%ScanOrder%%" "!input_file!" >> "!logfile!" 2>&1
   "%mediainfo_x64%"  "--Inform=Video;%%ScanOrder%%" "!input_file!" > "!tmpfile!" 2>&1
   set MI_Video_ScanOrder=null
   set /p MI_Video_ScanOrder=<"!tmpfile!"
   echo MI_Video_ScanOrder=!MI_Video_ScanOrder! for "!input_file!" >> "!logfile!" 2>&1
   echo MI_Video_ScanOrder=!MI_Video_ScanOrder! for "!input_file!" >> "!biglogfile!" 2>&1
   REM
   "%mediainfo_x64%"  "--Inform=Video;%%colour_primaries%%" "!input_file!" >> "!biglogfile!" 2>&1
   "%mediainfo_x64%"  "--Inform=Video;%%colour_primaries%%" "!input_file!" >> "!logfile!" 2>&1
   "%mediainfo_x64%"  "--Inform=Video;%%colour_primaries%%" "!input_file!" > "!tmpfile!" 2>&1
   set MI_Video_colour_primaries=null
   set /p MI_Video_colour_primaries=<"!tmpfile!"
   echo MI_Video_colour_primaries=!MI_Video_colour_primaries! for "!input_file!" >> "!logfile!" 2>&1
   echo MI_Video_colour_primaries=!MI_Video_colour_primaries! for "!input_file!" >> "!biglogfile!" 2>&1
   REM 
   echo "!input_file! ----------------------------------------------------------------------------------------" >> "!biglogfile!" 2>&1
   echo "!input_file! ----------------------------------------------------------------------------------------" >> "!logfile!" 2>&1
   if exist "!templatecsvfile!" echo "about to delete file "!templatecsvfile!""
   if exist "!templatecsvfile!" del "!templatecsvfile!"
   echo General;SET General_Format=%%format%%\r\nSET General_Format_Version=%%format_Version%%\r\nSET General_Format_Profile=%%format_Profile%%\r\nSET General_Format_Level=%%format_Level%%\r\nSET General_Format_Compression=%%format_Compression%%\r\nSET General_CodecID=%%CodecID%%\r\nSET General_CodecID_String=%%CodecID/String%%\r\n>>"!templatecsvfile!"
   echo Video;SET Video_Format=%%format%%\r\nSET Video_Format_Version=%%format_Version%%\r\nSET Video_Format_Profile=%%format_Profile%%\r\nSET Video_Format_Level=%%format_Level%%\r\nSET Video_Format_Tier=%%format_Tier%%\r\nSET Video_Format_Compression=%%format_Compression%%\r\nSET Video_CodecID_String=%%CodecID/String%%\r\nSET Video_ColorSpace=%%ColorSpace%%\r\nSET Video_ChromaSubsampling=%%ChromaSubsampling%%\r\nSET Video_ChromaSubsampling_String=%%ChromaSubsampling/String%%\r\nSET Video_BitDepth=%%BitDepth%%\r\nSET Video_BitDepth_String=%%BitDepth/String%%\r\nSET Video_ScanType=%%ScanType%%\r\nSET Video_ScanType_String=%%ScanType/String%%\r\nSET Video_ScanType_Original =%%ScanType_Original %%\r\nSET Video_ScanType_Original_String=%%ScanType_Original/String%%\r\nSET Video_ScanType_Sto   REMethod=%%ScanType_Sto   REMethod%%\r\nSET Video_ScanType_Sto   REMethod_FieldsPerBlock=%%ScanType_Sto   REMethod_FieldsPerBlock%%\r\nSET Video_ScanType_Sto   REMethod_String=%%ScanType_Sto   REMethod/String%%\r\nSET Video_ScanOrder=%%ScanOrder%%\r\nSET Video_ScanOrder/String=%%ScanOrder/String%%\r\nSET Video_ScanOrder_Stored=%%ScanOrder_Stored%%\r\nSET Video_ScanOrder_Stored_String=%%ScanOrder_Stored/String%%\r\nSET Video_ScanOrder_StoredDisplayedInverted=%%ScanOrder_StoredDisplayedInverted%%\r\nSET Video_ScanOrder_Original=%%ScanOrder_Original%%\r\nSET Video_ScanOrder_Original_String=%%ScanOrder_Original/String%%\r\nSET Video_colour_range=%%colour_range%%\r\nSET Video_colour_description_present=%%colour_description_present%%\r\nSET Video_colour_primaries=%%colour_primaries%%\r\nSET Video_transfer_characteristics=%%transfer_characteristics%%\r\nSET Video_matrix_coefficients=%%matrix_coefficients%%\r\nSET Video_colour_primaries_Original=%%colour_primaries_Original%%\r\nSET Video_colour_description_present_Original=%%colour_description_present_Original%%\r\nSET Video_colour_primaries_Original=%%colour_primaries_Original%%\r\nSET Video_transfer_characteristics_Original=%%transfer_characteristics_Original%%\r\nSET Video_matrix_coefficients_Original=%%matrix_coefficients_Original%%\r\n>>"!templatecsvfile!"
   "%mediainfo_x64%" --Inform="file://!templatecsvfile!" "!input_file!" >> "!biglogfile!" 2>&1
   "%mediainfo_x64%" --Inform="file://!templatecsvfile!" "!input_file!" >> "!logfile!" 2>&1
   REM 
   echo "!input_file! ----------------------------------------------------------------------------------------" >> "!biglogfile!" 2>&1
   echo "!input_file! ----------------------------------------------------------------------------------------" >> "!logfile!" 2>&1
   echo "%mediainfo_x64%" --full "!input_file!" >> "!biglogfile!" 2>&1
   "%mediainfo_x64%" --full "!input_file!" >> "!biglogfile!" 2>&1
   REM
   echo "%mediainfo_x64%" --full "!input_file!" >> "!logfile!" 2>&1
   "%mediainfo_x64%" --full "!input_file!" >> "!logfile!" 2>&1
   REM
   echo "!input_file! ----------------------------------------------------------------------------------------" >> "!biglogfile!" 2>&1
   echo "!input_file! ----------------------------------------------------------------------------------------" >> "!logfile!" 2>&1
   echo "Running ffprobe queries ..."
   echo "Running ffprobe queries ..." >> "!biglogfile!" 2>&1
   echo "Running ffprobe queries ..." >> "!logfile!" 2>&1
   REM put ffprobe output into tmpfile to parse into variables
   "%ffprobe_x64%" -hide_banner -select_streams V -show_format -show_programs -show_streams -show_private_data -find_stream_info -i "!input_file!" > "!tmpfile!" 2>&1
   REM
   REM process ffprobe output into logs too
   echo "%ffprobe_x64%" -hide_banner -select_streams V -show_format -show_programs -show_streams -show_private_data -find_stream_info -i "!input_file!" >> "!biglogfile!" 2>&1
   "%ffprobe_x64%" -hide_banner -select_streams V -show_format -show_programs -show_streams -show_private_data -find_stream_info -i "!input_file!" >> "!biglogfile!" 2>&1
   REM
   echo "%ffprobe_x64%" -hide_banner -select_streams V -show_format -show_programs -show_streams -show_private_data -find_stream_info -i "!input_file!" >> "!logfile!" 2>&1
   "%ffprobe_x64%" -hide_banner -select_streams V -show_format -show_programs -show_streams -show_private_data -find_stream_info -i "!input_file!" >> "!logfile!" 2>&1
   REM
   if exist "!tmpfile!" echo "about to delete file "!tmpfile!""
   if exist "!tmpfile!" del "!tmpfile!"   
   if exist "!templatecsvfile!" echo "about to delete file "!templatecsvfile!""
   if exist "!templatecsvfile!" del "!templatecsvfile!"
   echo "Finished "!input_file!" ----------------------------------------------------------------------------------------" >> "!biglogfile!" 2>&1
   echo "Finished "!input_file!" ----------------------------------------------------------------------------------------" >> "!logfile!" 2>&1
   echo "Finished "!input_file!""
   echo "------------------------------"
)
goto :eof