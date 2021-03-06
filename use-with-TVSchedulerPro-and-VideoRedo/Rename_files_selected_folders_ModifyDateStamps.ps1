# Call like this
#    powershell -NoLogo -ExecutionPolicy Unrestricted -Sta -NonInteractive -WindowStyle Normal -File ".\Rename_files_selected_folders_ModifyDateStamps.ps1" -Folder "T:\HDTV\autoTVS-mpg\Converted"
# capture commandline parameter 1 as a mandatory Folder string with a default
param (
    [Parameter(Mandatory=$true)] [string]$Folder = "T:\HDTV\autoTVS-mpg\Converted"
)
write-output "Processing Folder: ",$Folder
$DateFormat = "yyyy-MM-dd"
# there can only be one -Filter item in Get-ChildItem 
#$FileList = Get-ChildItem -LiteralPath $Folder -Filter '*.mp4' -File 
$FileList = Get-ChildItem $Folder\* -Include '*.mp4','*.bprj','*.ts' -File 
foreach ($FL_Item in $FileList) {
    # use regex match to work with the range of file names, find a date in any part of the filename
    $Null = $FL_Item.BaseName -match '(?<DateString>\d{4}-\d{2}-\d{2})'
    $DateString = $Matches.DateString
    $date_from_file = [datetime]::ParseExact($DateString, $DateFormat, $Null)
    $FL_Item.CreationTime = $date_from_file
    $FL_Item.LastWriteTime = $date_from_file
    # show the resulting datetime info
    $FL_Item | Select-Object Name,CreationTime,LastWriteTime
    }
# https://stackoverflow.com/questions/56211626/powershell-change-file-date-created-and-date-modified-based-on-filename
