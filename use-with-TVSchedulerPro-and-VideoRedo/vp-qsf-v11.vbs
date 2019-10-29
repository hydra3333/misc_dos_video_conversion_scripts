'
'  vb.vbs - cscript file to process file with VideoReDo.
'       Copyright (C) 2014, DRD Systems, Inc.
'
'   Usage: cscript //nolog ScanAdndSplit.vbs <source file> <output folder> [/q]
'
' modified: 2014.11.24
' - argument parameter checking is now case independent
' - invoke automatic dimension filters as a part of QSF processing
'   added VideoRedo.FileSetFilterDimensions -1, -1
'   per http://www.videoredo.net/msgBoard/showthread.php?34906-adscan-crash&p=116574#post116574

on error resume next

set Args = Wscript.Arguments
if Args.Count < 2 or Args.Count > 7 then
    wscript.echo( "? Invalid number of arguments - usage is: ")
    wscript.echo( " cscript vp.vbs <source file/project> <destination file/project> [/qsf] [/p <profile>] [/q] [/na] [/e]" )
    wscript.echo("    /qsf = Open file in QSF mode." )
    wscript.echo("    /p <profile> = Profile name or path to profile XML file." )
    wscript.echo("    /q  = Run in Quiet mode.")
    wscript.echo("    /na = Disable audio alert, overrides default set via Tools>Options>Audio Alerts.")
    wscript.echo("    /e  = Path strings are escaped.")
    my_Error_quit  "Invalid number of arguments", 1 , "-" , "-"
end if

' Check for flags.
qsfMode    = false
quietMode  = false
noAudioAlert = false
escapeMode = false
profile    = ""

for i = 2 to args.Count
    p = args(i-1)
' ---------- start modified: 2014.11.24 ... introduce "lcase" ----------
    if lcase(p) = "/qsf" then qsfMode = true
    if lcase(p) = "/q" then quietMode = true
    if lcase(p) = "/na" then noAudioAlert = true
    if lcase(p) = "/e" then escapeMode = true
    if lcase(p) = "/p" then profile = args(i)
' ---------- end modified: 2014.11.24 ... introduce "lcase" ----------
next

sourceFile = args(0)
destFile   = args(1)

if ( escapeMode ) then
    sourceFile = UnEscapeString( sourceFile )
    destFile   = UnEscapeString( destFile )
    profile    = UnEscapeString( profile )
end if

'Create VideoReDo object and open the source project / file.
if  quietMode = true  then
    ' wscript.echo("Running in quiet mode.")
    Set VideoReDoSilent = WScript.CreateObject( "VideoReDo5.VideoReDoSilent" )
    if NOT err.number = 0 then my_Error_quit  "Error creating object quiet VideoReDo5.VideoReDoSilent" , Err.number , Err.Source , Err.Description
    set VideoReDo = VideoReDoSilent.VRDInterface
    if NOT err.number = 0 then my_Error_quit  "Error calling quiet VideoReDoSilent.VRDInterface" , Err.number , Err.Source , Err.Description
else
    Set VideoReDo = WScript.CreateObject( "VideoReDo5.Application" )
    if NOT err.number = 0 then my_Error_quit  "Error creating object non-quiet VideoReDo5.VideoReDoSilent" , Err.number , Err.Source , Err.Description
end if

'openFlag = VideoReDo.FileOpen( sourceFile, qsfMode )
projectFile = "<VideoReDoProject version=""3""><Filename>" & sourceFile & "</Filename></VideoReDoProject>"
openFlag = VideoReDo.FileOpen( projectFile, qsfMode )
EN = Err.Number
ES = Err.Source
ED = Err.Description
if NOT EN = 0 then my_Error_quit  "Error VideoReDo.FileOpen(" & projectFile & "," & qsfMode & ")" , EN , ES , ED
if openFlag = false then
    Wscript.echo( "? openFlag=false, Unable to open file/project: " + projectFile  + " - Error Number: " + EN)
    if NOT EN = 0 then my_Error_quit  "? Unable to open file/project: " & projectFile , 1,  "-" , "-"
end if

if noAudioAlert then
    VideoReDo.ProgramSetAudioAlert( false )
    if NOT err.number = 0 then my_Error_quit  "Error calling ProgramSetAudioAlert( false )" , Err.number , Err.Source , Err.Description
end if

' ---------- start modified: 2014.11.24 ----------
if qsfMode then
   VideoReDo.FileSetFilterDimensions -1, -1
   if NOT err.number = 0 then my_Error_quit  "Error calling VideoReDo.FileSetFilterDimensions -1, -1" , Err.number , Err.Source , Err.Description
   Wscript.echo( "INFO: Applying automatic QSF dimensions filter: VideoRedo.FileSetFilterDimensions -1, -1")
end if
' ---------- end modified: 2014.11.24 ----------

' Start saving
outputFlag = VideoRedo.FileSaveAs( destFile, profile )
if NOT err.number = 0 then my_Error_quit  "Error calling VideoRedo.FileSaveAs( destFile, profile )" , Err.number , Err.Source , Err.Description

if outputFlag = false then
    if NOT err.number = 0 then my_Error_quit  "Error saving file after FileSaveAs, outputFlag = false, destFile=" & destFile  , Err.number , Err.Source , Err.Description
end if

' Wait until output done.
last_percent = 0
do while( VideoRedo.OutputGetState <> 0 )
   error_number = err.number
   if NOT error_number = 0 then
      'WScript.Echo error_number & " error in do loop"
      if last_percent < 90 then
         WScript.Echo "."
         my_Error_quit  "Error after calling VideoRedo.OutputGetState when last percent complete LT 90 (" & last_percent & ")" , error_number , Err.Source , Err.Description
      else
         WScript.Echo "."
         Wscript.echo "Warning: " & error_number & " after calling VideoRedo.OutputGetState when last percent complete GT 90 (" & last_percent & ") ... assume it completed."
         'exit do
      end if
   else
      'WScript.Echo "no error in do loop"
   end if
   percent = " Progress: " & Int(VideoReDo.OutputGetPercentComplete()) & "% "
   if NOT err.number = 0 then my_Error_quit  "Error after calling VideoReDo.OutputGetPercentComplete()" , Err.number , Err.Source , Err.Description
   last_percent = percent
   Wscript.StdOut.Write(percent)
   for i = 1 to len(percent)
      Wscript.StdOut.Write(chr(8))
   next
   Wscript.Sleep 2000
loop
' Finnished looping, write the last percentage again, with no backspacing afterward
percent = " Progress: " & Int(VideoReDo.OutputGetPercentComplete()) & "% "
if NOT err.number = 0 then my_Error_quit  "Error after calling final VideoReDo.OutputGetPercentComplete()" , Err.number , Err.Source , Err.Description
Wscript.StdOut.Write(percent)
WScript.Echo " "
'WScript.Echo "istate 1=" & istate
'istate = VideoRedo.OutputGetState
'WScript.Echo "istate 2=" & istate
'WScript.Echo "Finished processing with last_percent=" & last_percent

VideoReDo.ProgramExit()
if NOT err.number = 0 then my_Error_quit  "Error calling VideoReDo.ProgramExit()" , Err.number , Err.Source , Err.Description
WScript.Echo " "

Wscript.Echo( "   Output complete to: " + destFile )
Wscript.quit 0

function UnEscapeString( source )
  dest = ""
  for i = 1 to len(source)
    s = mid(source,i,1)
    if s = "^" then
        c = mid(source,i+1,3)
        dest = dest & chr(c)
        i = i + 3
    else
        dest = dest & s
    end if
  next
  UnEscapeString = dest
end function

Sub my_Error_quit ( my_message, err_number, err_source, err_description )
   on error goto 0
   WScript.Echo " "
   WScript.Echo my_message & ": Error number: " & err_number & " : " & err_source & " : " &  err_description
   WScript.Echo " "
   Wscript.Quit err_number
end sub