#
#

CLS
$myDir = Split-Path -Parent $MyInvocation.MyCommand.Path


function init

{

    #-------------------------------------------------
    #  Variables
    #-------------------------------------------------



    # Import email settings from config file
    [xml]$ConfigFile = Get-Content "$MyDir\Settings.xml"


    $startTime = Get-Date
    $Computer = Get-Content env:computername


    $backupLoc = $ConfigFile.Settings.destination.path


    #start doing work

    $backupFolderDate = $backupLoc + "\$(get-date -f yyyy-MM-dd)\"

    New-FolderCreator -path $backupFolderDate


    #Get the 
    foreach ($entry in $ConfigFile.Settings.directory)
    {
        if($entry.backup -eq 1)
        {
            Write-Host "Name: " $entry.Name
            Write-Host "Path: " $entry.Path

            $backupFolder = $backupLoc + "\$(get-date -f yyyy-MM-dd)\" + [string]$entry.Name
            Write-Host "Backup Location: " $backupFolder


            New-FolderCreator -path $backupFolder

            Set-Robocopycopy -source $entry.Path -dest $backupFolder


        
        }

    }





}



## Copy without deleting source
function Set-Robocopycopy
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true)]
		[string]$source,
		[Parameter(Mandatory = $true)]
		[string]$dest,
		[Parameter(Mandatory = $false)]
		[string]$log = "log.txt"
	)

	$flags = '/E /R:3 /W:5 /log+:"' + $log + '"'
	$cmd = 'ROBOCOPY "' + $source + '" "' + $dest + '" ' + $flags
	invoke-expression $cmd
}

## create folder if not exist, given fullpath
function New-FolderCreator
{
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true)]
		[string]$path
	)
	
	if (-not (Test-Path $path))
	{		
		$ret = New-Item -Path $path -ItemType directory
	}
	
}


init