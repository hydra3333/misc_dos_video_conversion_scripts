Option Explicit
Const maxNumbers = 6
Const initfilesize = 50000
'Const vbTextCompare = 1
'Dim srcExt
'srcExt = lcase(".bmp,.gif,.jpg,.jpeg,.tif,.tiff,.avi,.wmv,.asf,.mpg,.mpeg,.flv,.swf,.3gp,.mov,.mp4,.flv,.vob,.mkv,.vob,")  ' always have a trailing comma in this string
Dim colNArgs, colUArgs, objArg
Dim fso, fldr, fx
Dim n , ii, jjj, before, after, theErr, ns
Dim relFldr
Dim objStdOut
Set objStdOut = WScript.StdOut  

WScript.StdOut.WriteLine "Started."

ReDim dcwF(initfilesize)
ReDim dcwFnew(initfilesize)

'Check for right WSH version
'If WScript.Version <> "5.8" Then 
'   msgbox "Wscript version incorrect " & WScript.Version 
'   Wscript.Quit
'End If
'-------------------------------------------------------
'msgbox "wscript.arguments.Unnamed.Count=" & wscript.arguments.Unnamed.Count
'tmp=""
'If wscript.arguments.Unnamed.Count >= 0  Then
'	for i=0 to wscript.arguments.Unnamed.Count-1
'		tmp=tmp & i 
'		tmp=tmp & "=<" 
'		tmp=tmp & Wscript.Arguments.Item(i) 
'		tmp=tmp & "> "
'	next
'end if
'msgbox tmp
'Wscript.Quit
'-------------------------------------------------------

'Gather arguments passed
Set colNArgs = WScript.Arguments.Named
Set colUArgs = WScript.Arguments.UnNamed
If colNArgs.Count = 0 AND colUArgs.Count = 0 Then Wscript.Quit

'Enumerate Named Arguments
If colNArgs.Count > 0 Then
	If colNArgs.Exists("?") Then ShowHelp
End If

Set fso = CreateObject("Scripting.FileSystemObject")

'Enumerate paths into arrays dcwF and dcwFnew, using counter "n"
WScript.StdOut.WriteLine "Finding files ..."
n=0
If colUArgs.Count > 0 Then
	For Each objArg in colUArgs
		Set fldr = fso.GetFolder(objArg)
		If lcase(left(fldr,2)) = lcase("C:") then
			WScript.StdOut.WriteLine "Sorry, will not operate on the C: drive for safety reasons... " & fldr
		Else
			relFldr = fldr
			RecursivelyFind fldr 
		End If
	Next
End If
ReDim Preserve dcwF(n)
ReDim Preserve dcwFnew(n)
'Dim txtFileName, tsFile
'txtFileName = "c:\temp\dcwDirlist.txt"
'Set tsFile = fso.OpenTextFile(txtFileName, 2, True, -2)
'tsFile.WriteLine "Dump of " & n & " renames"
'for ii=1 to n
'	tsFile.WriteLine "<" & dcwF(ii) & "> <" & dcwFnew(ii) & ">"
'next

'-------------------------
'-------------------------
'-------------------------
'tsFile.WriteLine "Starting renames"
WScript.StdOut.WriteLine "Starting renames"
for ii=1 to n
'---
   ns = instr(StrReverse(dcwF(ii)),"\") - 1
   if lcase(right(dcwF(ii),ns)) <> lcase(dcwFnew(ii)) then ' rename only if need to
'	tsFile.WriteLine ii & " - About to rename <" & dcwF(ii) & "> to <" & dcwFnew(ii) & ">"
	WScript.StdOut.WriteLine ii & " - About to rename <" & dcwF(ii) & "> to <" & dcwFnew(ii) & ">"
'	WScript.StdOut.WriteLine "<" & dcwF(ii) & ">"
'	WScript.StdOut.WriteLine "<" & dcwFnew(ii) & ">"
	set fx = fso.GetFile(dcwF(ii))
	jjj = 0
	theErr = 999
	do while (jjj<100) and (theErr<>0) 
	   theErr = 0
	   on error resume next
	   'if jjj=0 then fx.name = dcwFnew(ii)
	   fx.name = dcwFnew(ii)
	   theErr = Err.Number
	   Err.Clear
	   on error goto 0
	   if (theErr <> 0) Then
		WScript.StdOut.WriteLine ii & " ERROR " & theErr & " encountered - during rename <" & dcwF(ii) & "> to <" & dcwFnew(ii) & ">"
		jjj=jjj+1
		if len(dcwFnew(ii)) < 4 then 
			after = "." & dcwFnew(ii)
		else
			after = left(dcwFnew(ii),(len(dcwFnew(ii))-4)) & "." & right(dcwFnew(ii),4)
		end if
		WScript.StdOut.WriteLine "ErrorFix: About to rename <" & dcwF(ii) & "> was <" & dcwFnew(ii) & "> now <" & after & ">"
		dcwFnew(ii) = after
	   else
		theErr = 0
	   end if
	loop
	set fx = Nothing
	on error goto 0
   else ' rename only if need to
	'WScript.StdOut.WriteLine ii & " - No need to rename <" & dcwF(ii) & ">"
   end if ' rename only if need to
next
'---
'WScript.echo "quitting"
'Wscript.Quit
'tsFile.Close
'-------------------------
Set fldr = Nothing
Set fso = Nothing
WScript.StdOut.WriteLine "done files = " & n
Wscript.Quit
'-----------------------------------------------------
'-----------------------------------------------------
Public Sub RecursivelyFind(ByRef fldr)
   dim subfolders,files,folder,file, ext, newname

   Set subfolders = fldr.SubFolders
   Set files = fldr.Files

   'Display the path and all of the folders.
'   WScript.StdOut.WriteLine "---Folders--- in " & fldr.Path
'   For Each folder in subfolders
'      WScript.StdOut.WriteLine folder.Name
'   Next
 
   'Put all of the files into an array andrename them as we go
'   WScript.StdOut.WriteLine "---Files--- in " & fldr.Path
   For Each file in files
'''	WScript.StdOut.WriteLine n & " " & file.path & " parentfolder " & file.ParentFolder
'''	Wscript.Quit
' don't examine the extension - rename everything
'	ext = "." & fso.GetExtensionName(file.name) & ","
'	If instr(srcExt, lcase(ext)) > 0 then '<<<<<<<<<<<<---------------
'		WScript.StdOut.WriteLine file.name 
		n = n + 1
		If n > UBound(dcwF) Then 
			ReDim Preserve dcwF(n+initfilesize)
			ReDim Preserve dcwFnew(n+initfilesize)
		End if
		dcwF(n) = file.ParentFolder & "\" & file.name
'*******************************************************************
		Call aNewNameForTheFile(file,newname)
'*******************************************************************
'		dcwFnew(n) = file.ParentFolder & "\" & newname
		dcwFnew(n) = newname
'		WScript.StdOut.WriteLine n & " <" & dcwF(n) & "> <" & dcwFnew(n) & ">"
'	End If
   Next  
   'Recurse all of the subfolders.
   For Each folder in subfolders
      RecursivelyFind  folder
   Next  
   'Cleanup current recursion level
   Set subfolders = Nothing
   Set files = Nothing
End Sub
'-----------------------------------------------------
'-----------------------------------------------------
Sub aNewNameForTheFile(fi,resultname)
Dim thePath, folderprefix, theFilename, theExt, tmp, prefix, before, after, i, ch
	'before = lcase(fi.name)
	before = fi.name
	after = ""
    for i=1 to len(before)
	   ch = mid(before, i, 1)
	   if (ch < "a" or ch > "z") and (ch < "A" or ch > "Z") and (ch < "0" or ch > "9") and (ch  <> "_" ) and (ch  <> "-" ) and (ch  <> " ") and (ch  <> "." ) and (ch  <> "!" ) then
		ch = ""
	   end if
	   if (ch = "!" ) then
		ch = "0"
	   end if
'	   if (ch = "_" ) then
'		ch = "."
'	   end if
       after = after & ch
    next
        'after = lcase(after)
        ' vbTextCompare means case insensitive
	after = Replace(after,"babysitter","19yo",1,-1,vbTextCompare)
	after = Replace(after,"unisitter","19yo",1,-1,vbTextCompare)
	after = Replace(after,"youngster","",1,-1,vbTextCompare)
	after = Replace(after,"young","",1,-1,vbTextCompare)
	after = Replace(after,"schoolgirl","uni",1,-1,vbTextCompare)
	after = Replace(after,"school","uni",1,-1,vbTextCompare)
	after = Replace(after,"daughter","uni",1,-1,vbTextCompare)
	after = Replace(after,"seventeen","19yo",1,-1,vbTextCompare)
	after = Replace(after,"students","19yo",1,-1,vbTextCompare)
	after = Replace(after,"student","uni",1,-1,vbTextCompare)
	after = Replace(after,"homework","uni",1,-1,vbTextCompare)
	after = Replace(after,"baby","19yo",1,-1,vbTextCompare)
	after = Replace(after,"teenagers","babe",1,-1,vbTextCompare)
	after = Replace(after,"teenager","babe",1,-1,vbTextCompare)
	after = Replace(after,"teenage","babe",1,-1,vbTextCompare)
	after = Replace(after,"teeny","babe",1,-1,vbTextCompare)
	after = Replace(after,"teenie","babe",1,-1,vbTextCompare)
	after = Replace(after,"teens","babe",1,-1,vbTextCompare)
	after = Replace(after,"teen","babe",1,-1,vbTextCompare)
	after = Replace(after,"small","babe",1,-1,vbTextCompare)
	after = Replace(after,"little","babe",1,-1,vbTextCompare)
	after = Replace(after,"tiny","babe",1,-1,vbTextCompare)
	after = Replace(after,"juvenile","babe",1,-1,vbTextCompare)
	after = Replace(after,"juve","babe",1,-1,vbTextCompare)
	after = Replace(after,"diminutive","babe",1,-1,vbTextCompare)
	after = Replace(after,"daughter","babe",1,-1,vbTextCompare)
	after = Replace(after,"sister","babe",1,-1,vbTextCompare)
	after = Replace(after,"brother","man",1,-1,vbTextCompare)
	after = Replace(after,"stepsis","babe",1,-1,vbTextCompare)
	after = Replace(after,"sis","babe",1,-1,vbTextCompare)
	after = Replace(after,"step","babe",1,-1,vbTextCompare)
	after = Replace(after,"dad","man",1,-1,vbTextCompare)
	after = Replace(after,"father","man",1,-1,vbTextCompare)
	after = Replace(after,"family","babe",1,-1,vbTextCompare)
	after = Replace(after,"girl","babe",1,-1,vbTextCompare)
	after = Replace(after,"youthful","babe",1,-1,vbTextCompare)
	after = Replace(after,"youth","babe",1,-1,vbTextCompare)
	after = Replace(after,"incest","",1,-1,vbTextCompare)
	after = Replace(after,"defloweration","babe",1,-1,vbTextCompare)
	after = Replace(after,"deflower","babe",1,-1,vbTextCompare)
	after = Replace(after,"virginity","babe",1,-1,vbTextCompare)
	after = Replace(after,"virgin","babe",1,-1,vbTextCompare)
	after = Replace(after,"bestial","",1,-1,vbTextCompare)
	after = Replace(after,"beast","",1,-1,vbTextCompare)
	after = Replace(after,"ager","",1,-1,vbTextCompare)
	after = Replace(after,"anus","",1,-1,vbTextCompare)
	after = Replace(after,"anal","other",1,-1,vbTextCompare)
	after = Replace(after,"rough","",1,-1,vbTextCompare)
	after = Replace(after,"little","",1,-1,vbTextCompare)
	after = Replace(after,"small","",1,-1,vbTextCompare)
	after = Replace(after,"'s","",1,-1,vbTextCompare)
	after = Replace(after,"pornhub.com","",1,-1,vbTextCompare)
	after = Replace(after,"nubile_films","",1,-1,vbTextCompare)
	after = Replace(after,"joymii","",1,-1,vbTextCompare)
        '
	for i = 1 to 50 ' replace replaces all anyway, however we want to re-replace any remaining ones, so loop
           after = Replace(after,"  "," ",1,-1,vbTextCompare)
           after = Replace(after,"..",".",1,-1,vbTextCompare)
           after = Replace(after,"--","-",1,-1,vbTextCompare)
           after = Replace(after,"__","_",1,-1,vbTextCompare)
           after = Replace(after,"_-_","-",1,-1,vbTextCompare)
           after = Replace(after,"-_-","-",1,-1,vbTextCompare)
           after = Replace(after,"-_","-",1,-1,vbTextCompare)
           after = Replace(after,"_-","-",1,-1,vbTextCompare)
           after = Replace(after,"._",".",1,-1,vbTextCompare)
           after = Replace(after,"_.",".",1,-1,vbTextCompare)
           after = Replace(after,".-",".",1,-1,vbTextCompare)
           after = Replace(after,"-.",".",1,-1,vbTextCompare)
           after = Replace(after,". ",".",1,-1,vbTextCompare)
           after = Replace(after," .",".",1,-1,vbTextCompare)
	next
'
	for i = 1 to 50
	   if left(after,1)="-" OR left(after,1)="_" OR left(after,1)=" " OR left(after,2)=".." OR left(after,2)="._" OR left(after,2)=".-" then 
		after = right(after, (len(after)-1))
	   end if
	next
        resultname = after
End Sub
'-----------------------------------------------------
'-----------------------------------------------------
Sub ShowHelp()
	msgbox "ThisScript.vbs [/?] [Path, [...]]" & Chr(34) & " path   - Directory, comma separated values" 
	Wscript.Quit
End Sub
