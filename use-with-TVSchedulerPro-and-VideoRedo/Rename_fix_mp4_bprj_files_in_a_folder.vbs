Option Explicit
Const powershell_script_filename = ".\Rename_files_selected_folders_ModifyDateStamps.ps1"
Dim Args, p, i
Dim objStdOut
Dim fso, rcount, fcount, acount, bcount
Dim fix_timestamps
Set objStdOut = WScript.StdOut 
Set fso = CreateObject("Scripting.FileSystemObject")
Call Create_powershell_script(powershell_script_filename)
rcount = 0
fcount = 0
acount = 0
bcount = 0
'on error resume next					
WScript.StdOut.WriteLine "Started"
set Args = Wscript.Arguments
if Args.Count < 2 then
	wscript.echo( "? Invalid number of arguments " & Args.Count & " - usage is: ")
	wscript.echo( " cscript this.vbs ""y"" <source_folder1> <source_folder2> <source_folder3> <source_folder4> <source_folder5>" )
	Wscript.Quit 1
end if
for i = 0 to (Args.Count - 1)
	p = Args(i)
	if Right(p,1) = "\" OR Right(p,1) = "/" then
		p = Left(p, Len(p) - 1) 
	end if
	wscript.echo( "arg(" & i & ")=<" & p & ">")
next
if lcase(Args(0)) = "y" then
	fix_timestamps = True
else
	fix_timestamps = False
end if
for i = 1 to (Args.Count - 1)
	p = Args(i)
	if Right(p,1) = "\" OR Right(p,1) = "/" then
		p = Left(p, Len(p) - 1) 
	end if
	Call Do_a_folder(p, fix_timestamps, powershell_script_filename)
next
WScript.StdOut.WriteLine "Files examined=" & acount & " Files matched=" & fcount & " Files renamed=" & rcount & " .bprj Files updated=" & bcount
Set fso = Nothing
Wscript.Quit

Public Sub Do_a_folder (aPath, fix_timestamps, powershell_script_filename)
' inherit global variables fso, rcount, fcount, acount, bcount
Dim fldr, f, objWscriptShell, powershell_cmdline
If NOT fso.FolderExists(aPath) Then
	WScript.StdOut.WriteLine "Folder does NOT EXIST <" & aPath & "> ... not processed"
	Exit Sub
Else
	WScript.StdOut.WriteLine "--- STARTED for folder <" & aPath & ">"
	Set fldr = fso.GetFolder(aPath)
	'WScript.StdOut.WriteLine "--- fldr.name=<" & fldr.name & ">"
	for each f in fldr.Files
		acount = acount + 1
		call Rename_File_in_a_Path(f)
	next
	Set fldr = Nothing
	if fix_timestamps = True then
		Set objWscriptShell = CreateObject("Wscript.shell")
		powershell_cmdline = "powershell -NoLogo -ExecutionPolicy Unrestricted -Sta -NonInteractive -WindowStyle Normal -File """ & powershell_script_filename & """ -Folder """ & aPath & """"
		WScript.StdOut.WriteLine "Fixing file dates using:<" & powershell_cmdline & ">"
		objWscriptShell.run(powershell_cmdline)
		Set objWscriptShell = Nothing
		WScript.StdOut.WriteLine "--- FINISHED for folder <" & aPath & ">"
	end if
end if
End Sub

Public sub Rename_File_in_a_Path(byref f)
Dim ext, xbasename, new_basename, new_name, xmlDoc, sts, nNode, txtbefore, i, txtafter
ext = fso.GetExtensionName(f.path)
xbasename = fso.GetBaseName(f.path)
If LCase(ext) = LCase("mp4") or LCase(ext) = LCase("bprj") then
	fcount = fcount + 1
	' replace chars in the filename and if not same then rename the file
	new_basename = xbasename
	If instr(1, new_basename, " - ", vbTextCompare) > 0 then new_basename = Replace(new_basename, " - ", "-", 1, -1, vbTextCompare)
	If instr(1, new_basename, "  ", vbTextCompare) > 0 then new_basename = Replace(new_basename, "  ", " ", 1, -1, vbTextCompare)
	If instr(1, new_basename, "  ", vbTextCompare) > 0 then new_basename = Replace(new_basename, "  ", " ", 1, -1, vbTextCompare)
	If instr(1, new_basename, "  ", vbTextCompare) > 0 then new_basename = Replace(new_basename, "  ", " ", 1, -1, vbTextCompare)
	If instr(1, new_basename, "- ", vbTextCompare) > 0 then new_basename = Replace(new_basename, "- ", "-", 1, -1, vbTextCompare)
	If instr(1, new_basename, " -", vbTextCompare) > 0 then new_basename = Replace(new_basename, " -", "-", 1, -1, vbTextCompare)
	If instr(1, new_basename, "..", vbTextCompare) > 0 then new_basename = Replace(new_basename, "..", ".", 1, -1, vbTextCompare)
	If instr(1, new_basename, "..", vbTextCompare) > 0 then new_basename = Replace(new_basename, "..", ".", 1, -1, vbTextCompare)
	If instr(1, new_basename, "..", vbTextCompare) > 0 then new_basename = Replace(new_basename, "..", ".", 1, -1, vbTextCompare)
	If instr(1, new_basename, "--", vbTextCompare) > 0 then new_basename = Replace(new_basename, "--", "-", 1, -1, vbTextCompare)
	If instr(1, new_basename, "--", vbTextCompare) > 0 then new_basename = Replace(new_basename, "--", "-", 1, -1, vbTextCompare)
	If instr(1, new_basename, "--", vbTextCompare) > 0 then new_basename = Replace(new_basename, "--", "-", 1, -1, vbTextCompare)
	new_name = f.parentfolder & "\" & new_basename & "." & fso.GetExtensionName(f.path)
	If new_basename <> xbasename then ' filename changed sp rename it
		rcount = rcount + 1 ' only set this if something replaced
		WScript.StdOut.WriteLine "Rename <" & f.path & ">"
		WScript.StdOut.WriteLine "    to <" & new_name & ">" 
		fso.MoveFile f.path, new_name '???????????????????????????????????????????????????????????????????????????????????????????????
	end if
	If LCase(ext) = LCase("bprj") then ' alsways process .bprj files whether renamed or not
		bcount = bcount +1
		' open the file and replace the xbasename with new_basename in it
		Set xmlDoc = CreateObject("Microsoft.XMLDOM")
		xmlDoc.async = False
		on error resume next 
		'WScript.StdOut.WriteLine "debug: about to xmlDoc.load file " & new_name
		sts = xmlDoc.load(new_name) '???????????????????????????????????????????????????????????????????????????????????????????????
		'''sts = xmlDoc.load(f.path) '???????????????????????????????????????????????????????????????????????????????????????????????
		on error goto 0 
		If not sts Then
			Dim myErr
			Set myErr = xmlDoc.parseError
			WScript.StdOut.WriteLine "Aborted. Failed to load XML doc .BPRJ file " & new_name
			WScript.StdOut.WriteLine "XML error: " & myErr.errorCode & " : " & myErr.reason
			WScript.Quit 1
		End If
		'WScript.StdOut.WriteLine "debug: loaded xml doc " & new_name
		'Locate the desired node. Note the use of XPATH instead of looping over all the child nodes.
		Set nNode = xmlDoc.selectsinglenode ("//VideoReDoProject/Filename")
		If nNode is Nothing then
			WScript.StdOut.WriteLine "Aborted. Could not find XML node //VideoReDoProject/Filename in file " & new_name
			WScript.quit 1
		End If
		txtbefore = nNode.text
		' find the rightmost \ then replace everything at and it to the start with .\
		' if a \ doesn't exist, add .\ to the start
		i = InStrRev(txtbefore,"\",-1,vbTextCompare)
		if i > 0 then
			txtafter = ".\" & mid(txtbefore,i+1)
		else
			txtafter = ".\" & txtbefore
		end if
		' replace the xbasename portion of the string with the new_basename portion
		txtafter = Replace(txtafter, xbasename, new_basename, 1, -1, vbTextCompare)
		nNode.text = txtafter
		WScript.StdOut.WriteLine "Update bprj xml node before:<" & txtbefore & ">"
		WScript.StdOut.WriteLine "                      after:<" & nNode.text & ">"
		xmlDoc.save(new_name) '???????????????????????????????????????????????????????????????????????????????????????????????
		Set xmlDoc=nothing
	end if
end if
end sub

Public Function Digits2 (val)
	Digits2 = PadDigits(val, 2)
End Function
Public Function Digits4(val)
	Digits4 = PadDigits(val, 4)
End Function
Public Function PadDigits(val, digits)
  PadDigits = Right(String(digits,"0") & val, digits)
End Function

Public Sub Create_powershell_script(pFilename)
' assume fso already created
Dim objFile
Set objFile = fso.CreateTextFile(pFilename,True,True) ' filename,overwrite,unicode
objFile.WriteLine("# Call like this")
objFile.WriteLine("#    powershell -NoLogo -ExecutionPolicy Unrestricted -Sta -NonInteractive -WindowStyle Normal -File """ & pFilename & """ -Folder ""T:\HDTV\autoTVS-mpg\Converted""")
objFile.WriteLine("# capture commandline parameter 1 as a mandatory Folder string with a default")
objFile.WriteLine("param (")
objFile.WriteLine("    [Parameter(Mandatory=$true)] [string]$Folder = ""T:\HDTV\autoTVS-mpg\Converted""")
objFile.WriteLine(")")
objFile.WriteLine("write-output ""Processing Folder: "",$Folder")
objFile.WriteLine("$DateFormat = ""yyyy-MM-dd""")
objFile.WriteLine("# there can only be one -Filter item in Get-ChildItem ")
objFile.WriteLine("#$FileList = Get-ChildItem -LiteralPath $Folder -Filter '*.mp4' -File ")
objFile.WriteLine("$FileList = Get-ChildItem $Folder\* -Include '*.mp4','*.bprj','*.ts' -File ")
objFile.WriteLine("foreach ($FL_Item in $FileList) {")
objFile.WriteLine("    # use regex match to work with the range of file names, find a date in any part of the filename")
objFile.WriteLine("    $Null = $FL_Item.BaseName -match '(?<DateString>\d{4}-\d{2}-\d{2})'")
objFile.WriteLine("    $DateString = $Matches.DateString")
objFile.WriteLine("    $date_from_file = [datetime]::ParseExact($DateString, $DateFormat, $Null)")
objFile.WriteLine("    $FL_Item.CreationTime = $date_from_file")
objFile.WriteLine("    $FL_Item.LastWriteTime = $date_from_file")
objFile.WriteLine("    # show the resulting datetime info")
objFile.WriteLine("    $FL_Item | Select-Object Name,CreationTime,LastWriteTime")
objFile.WriteLine("    }")
objFile.WriteLine("# https://stackoverflow.com/questions/56211626/powershell-change-file-date-created-and-date-modified-based-on-filename")
objFile.Close
Set objFile = Nothing
End Sub