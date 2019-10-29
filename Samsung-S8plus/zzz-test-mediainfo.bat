@Echo OFF
REM @setlocal ENABLEDELAYEDEXPANSION
REM @setlocal enableextensions

if "%~f1" == "" ECHO "drag and drop a file on this .bat file"
if "%~f1" == "" exit 1

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

set alogfile=.\zzz-test-mediainfo.log
if exist "%alogfile%" del "%alogfile%"

ECHO "%~f1" >> "%alogfile%" 2>&1
ECHO "---------------------------------------------------------------------------------" >> "%alogfile%" 2>&1

Call :doit "General;General_Format=%%%%Format%%%%" "%~f1"
Call :doit "General;General_Format_Version=%%%%Format_Version%%%%" "%~f1"
Call :doit "General;General_Format_Profile=%%%%Format_Profile%%%%" "%~f1"
Call :doit "General;General_Format_Level=%%%%Format_Level%%%%" "%~f1"
Call :doit "General;General_Format_Compression=%%%%Format_Compression%%%%" "%~f1"
Call :doit "General;General_CodecID=%%%%CodecID%%%%" "%~f1"
Call :doit "General;General_CodecID_String=%%%%CodecID/String%%%%" "%~f1"

Call :doit "Video;Video_StreamKind=%%%%StreamKind%%%%" "%~f1"
Call :doit "Video;Video_StreamKind_String=%%%%StreamKind/String%%%%" "%~f1"
Call :doit "Video;Video_Format=%%%%Format%%%%" "%~f1"
Call :doit "Video;Video_Format_Version=%%%%Format_Version%%%%" "%~f1"
Call :doit "Video;Video_Format_Profile=%%%%Format_Profile%%%%" "%~f1"
Call :doit "Video;Video_Format_Level=%%%%Format_Level%%%%" "%~f1"
Call :doit "Video;Video_Format_Tier=%%%%Format_Tier%%%%" "%~f1"
Call :doit "Video;Video_Format_Compression=%%%%Format_Compression%%%%" "%~f1"
Call :doit "Video;Video_Format_Settings_Pulldown=%%%%Format_Settings_Pulldown%%%%" "%~f1"
Call :doit "Video;Video_Format_Settings_FrameMode=%%%%Format_Settings_FrameMode%%%%" "%~f1"
Call :doit "Video;Video_Format_Settings_PictureString=%%%%Format_Settings_PictureString%%%%" "%~f1"
Call :doit "Video;Video_Format_Settings_QPel=%%%%Format_Settings_QPel%%%%" "%~f1"
Call :doit "Video;Video_Format_Settings_QPel_String=%%%%Format_Settings_QPel/String%%%%" "%~f1"
Call :doit "Video;Video_Format_Settings_CABAC=%%%%Video_Format_Settings_CABAC%%%%" "%~f1"
Call :doit "Video;Video_Format_Settings_CABAC_String=%%%%Format_Settings_CABAC/String%%%%" "%~f1"
Call :doit "Video;Video_MuxingMode=%%%%MuxingMode%%%%" "%~f1"
Call :doit "Video;Video_Codec=%%%%Codec%%%%" "%~f1"
Call :doit "Video;Video_CodecID=%%%%CodecID%%%%" "%~f1"
Call :doit "Video;Video_CodecID_String=%%%%CodecID/String%%%%" "%~f1"
Call :doit "Video;Video_Width=%%%%Width%%%%" "%~f1"
Call :doit "Video;Video_Height=%%%%Height%%%%" "%~f1"
Call :doit "Video;Video_PixelAspectRatio=%%%%PixelAspectRatio%%%%" "%~f1"
Call :doit "Video;Video_PixelAspectRatio_String=%%%%PixelAspectRatio/String%%%%" "%~f1"
Call :doit "Video;Video_DisplayAspectRatio=%%%%DisplayAspectRatio%%%%" "%~f1"
Call :doit "Video;Video_DisplayAspectRatio_String=%%%%DisplayAspectRatio/String%%%%" "%~f1"
Call :doit "Video;Video_Rotation=%%%%Rotation%%%%" "%~f1"
Call :doit "Video;Video_Rotation_String=%%%%Rotation/String%%%%" "%~f1"
Call :doit "Video;Video_FrameRate_Mode=%%%%FrameRate_Mode%%%%" "%~f1"
Call :doit "Video;Video_FrameRate_Mode_String=%%%%FrameRate_Mode/String%%%%" "%~f1"
Call :doit "Video;Video_FrameRate_Mode_Original=%%%%FrameRate_Mode_Original%%%%" "%~f1"
Call :doit "Video;Video_FrameRate_Mode_Original_String=%%%%FrameRate_Mode_Original/String%%%%" "%~f1"
Call :doit "Video;Video_FrameRate=%%%%FrameRate%%%%" "%~f1"
Call :doit "Video;Video_FrameRate_String=%%%%FrameRate/String%%%%" "%~f1"
Call :doit "Video;Video_FrameRate_Num=%%%%FrameRate_Num%%%%" "%~f1"
Call :doit "Video;Video_FrameRate_Den=%%%%FrameRate_Den%%%%" "%~f1"
Call :doit "Video;Video_FrameRate_Nominal=%%%%FrameRate_Nominal%%%%" "%~f1"
Call :doit "Video;Video_FrameRate_Nominal_String=%%%%FrameRate_Nominal/String%%%%" "%~f1"
Call :doit "Video;Video_FrameRate_Minimum=%%%%FrameRate_Minimum%%%%" "%~f1"
Call :doit "Video;Video_FrameRate_Minimum_String=%%%%FrameRate_Minimum/String%%%%" "%~f1"
Call :doit "Video;Video_FrameRate_Maximum=%%%%FrameRate_Maximum%%%%" "%~f1"
Call :doit "Video;Video_FrameRate_Maximum_String=%%%%FrameRate_Maximum/String%%%%" "%~f1"
Call :doit "Video;Video_Delay=%%%%Delay%%%%" "%~f1"
Call :doit "Video;Video_Delay/String=%%%%Delay/String%%%%" "%~f1"
Call :doit "Video;Video_Delay/String1=%%%%Delay/String1%%%%" "%~f1"
Call :doit "Video;Video_Delay/String2=%%%%Delay/String2%%%%" "%~f1"
Call :doit "Video;Video_Delay/String3=%%%%Delay/String3%%%%" "%~f1"
Call :doit "Video;Video_Delay/String4=%%%%Delay/String4%%%%" "%~f1"
Call :doit "Video;Video_Delay/String5=%%%%Delay/String5%%%%" "%~f1"
Call :doit "Video;Video_Delay_Settings=%%%%Delay_Settings%%%%" "%~f1"
Call :doit "Video;Video_ColorSpace=%%%%ColorSpace%%%%" "%~f1"
Call :doit "Video;Video_ChromaSubsampling=%%%%ChromaSubsampling%%%%" "%~f1"
Call :doit "Video;Video_ChromaSubsampling_String=%%%%ChromaSubsampling/String%%%%" "%~f1"
Call :doit "Video;Video_ChromaSubsampling_Position=%%%%ChromaSubsampling_Position%%%%" "%~f1"
Call :doit "Video;Video_BitDepth=%%%%BitDepth%%%%" "%~f1"
Call :doit "Video;Video_BitDepth_String=%%%%BitDepth/String%%%%" "%~f1"
Call :doit "Video;Video_ScanType=%%%%ScanType%%%%" "%~f1"
Call :doit "Video;Video_ScanType_String=%%%%ScanType/String%%%%" "%~f1"
Call :doit "Video;Video_ScanType_Original=%%%%ScanType_Original%%%%" "%~f1"
Call :doit "Video;Video_ScanType_Original_String=%%%%ScanType_Original/String%%%%" "%~f1"
Call :doit "Video;Video_ScanType_StoreMethod=%%%%ScanType_StoreMethod%%%%" "%~f1"
Call :doit "Video;Video_ScanType_StoreMethod_FieldsPerBlock=%%%%ScanType_StoreMethod_FieldsPerBlock%%%%" "%~f1"
Call :doit "Video;Video_ScanType_StoreMethod_String=%%%%ScanType_StoreMethod/String%%%%" "%~f1"
Call :doit "Video;Video_ScanOrder=%%%%ScanOrder%%%%" "%~f1"
Call :doit "Video;Video_ScanOrder/String=%%%%ScanOrder/String%%%%" "%~f1"
Call :doit "Video;Video_ScanOrder_Stored=%%%%ScanOrder_Stored%%%%" "%~f1"
Call :doit "Video;Video_ScanOrder_Stored_String=%%%%ScanOrder_Stored/String%%%%" "%~f1"
Call :doit "Video;Video_ScanOrder_StoredDisplayedInverted=%%%%ScanOrder_StoredDisplayedInverted%%%%" "%~f1"
Call :doit "Video;Video_ScanOrder_Original=%%%%ScanOrder_Original%%%%" "%~f1"
Call :doit "Video;Video_ScanOrder_Original_String=%%%%ScanOrder_Original/String%%%%" "%~f1"
Call :doit "Video;Video_colour_range=%%%%colour_range%%%%" "%~f1"
Call :doit "Video;Video_colour_description_present=%%%%colour_description_present%%%%" "%~f1"
Call :doit "Video;Video_colour_primaries=%%%%colour_primaries%%%%" "%~f1"
Call :doit "Video;Video_transfer_characteristics=%%%%transfer_characteristics%%%%" "%~f1"
Call :doit "Video;Video_matrix_coefficients=%%%%matrix_coefficients%%%%" "%~f1"
Call :doit "Video;Video_colour_primaries_Original=%%%%colour_primaries_Original%%%%" "%~f1"
Call :doit "Video;Video_colour_description_present_Original=%%%%colour_description_present_Original%%%%" "%~f1"
Call :doit "Video;Video_colour_primaries_Original=%%%%colour_primaries_Original%%%%" "%~f1"
Call :doit "Video;Video_transfer_characteristics_Original=%%%%transfer_characteristics_Original%%%%" "%~f1"
Call :doit "Video;Video_matrix_coefficients_Original=%%%%matrix_coefficients_Original%%%%" "%~f1"

ECHO "---------------------------------------------------------------------------------" >> "%alogfile%" 2>&1
ECHO "%~f1" >> "%alogfile%" 2>&1
ECHO "---------------------------------------------------------------------------------" >> "%alogfile%" 2>&1
echo "%mediainfo_x64%" --Full "%~f1"  >> "%alogfile%" 2>&1
"%mediainfo_x64%" --Full "%~f1"  >> "%alogfile%" 2>&1
ECHO "---------------------------------------------------------------------------------" >> "%alogfile%" 2>&1
echo "%ffprobe_x64%" -hide_banner -select_streams V -show_format -show_programs -show_streams -show_private_data -find_stream_info -i "%~f1"  >> "%alogfile%" 2>&1
"%ffprobe_x64%" -hide_banner -select_streams V -show_format -show_programs -show_streams -show_private_data -find_stream_info -i "%~f1"  >> "%alogfile%" 2>&1
ECHO "---------------------------------------------------------------------------------" >> "%alogfile%" 2>&1
pause
exit

:doit
@echo off
REM ECHO "parameter 1="%~1"
REM ECHO "parameter 2="%~2"
REM echo ----------- mediainfo call in sub below
"%mediainfo_x64%" "--Inform=%~1" "%~2" >> "%alogfile%" 2>&1
REM @echo on
"%mediainfo_x64%" "--Inform=%~1" "%~2"
REM @echo off
REM echo ----------- mediainfo call in sub above
goto :eof