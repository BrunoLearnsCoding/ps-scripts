# This script is supposed to archive and copy backup files (.bak) to a remote folder and verify the integrity of the copied files.
# It uses PowerShell to perform the operations and logs the results to the Windows Event Log.


# Define the source and destination directories
$sourceRoot = "E:\SQL Backup for Remote\"
$destinationRoot = "\\172.16.8.90\novinbk\payvast"

# Script name
$scriptName = "Mr. Fallah's Payvast accounting system, archive and copy backup files to remote folder $destinationRoot and verify"

# Helper function to add timestamps to messages
function Write-Log {
    param (
        [Parameter(Mandatory = $true)]
        [string]$Message,
        [ValidateSet("Info", "Error")]
        [string]$Type = "Info"
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss" 
    if ($Type -eq "Info") {
        Write-Host "[$timestamp] $Message"
        Write-EventLog -LogName "BackupLog" -Source "BackupScripts" -EntryType Information -EventId 5000 -Message $Message
    } elseif ($Type -eq "Error") {
        Write-Error "[$timestamp] $Message"
        Write-EventLog -LogName "BackupLog" -Source "BackupScripts" -EntryType Error -EventId 5001 -Message $Message
    }
}

Write-Log -Message "Script started: $scriptName."

if (-not (Get-EventLog -List | Where-Object { $_.LogDisplayName -eq "BackupLog" })) {
    New-EventLog -LogName "BackupLog" -Source "BackupScripts"
}



$persianCalendar = New-Object System.Globalization.PersianCalendar


# Fail early if source directory does not exist
if (-not (Test-Path -Path $sourceRoot)) {
    Write-Log -Message "Source directory '$sourceRoot' does not exist. Exiting script." -Type "Error"
    exit 1
}


# Import credentials
try {
    $credentials = Get-Secret -Name "novinbk"
    Write-Log -Message "Credentials imported successfully."
}
catch {
    Write-Log -Message "Failed to import credentials: $_" -Type "Error"
    exit 1
}

# Restart service and create PSDrive to remove old SMB connections
Restart-Service -Name "LanmanWorkstation" -Force
Write-Log -Message "LanmanWorkstation service restarted."

try {
    New-PSDrive -Name "Z" -PSProvider FileSystem -Root $destinationRoot -Credential $credentials -ErrorAction Stop
    Write-Log -Message "Shared drive created successfully."
}
catch {
    Write-Log -Message "Failed to connect to smb drive: $desinationRoot." -Type "Error"
    exit 1
}


# Create source and destination file names based on the current Persian date
$now = Get-Date
$year = $persianCalendar.GetYear($now)
$month = $persianCalendar.GetMonth($now).ToString("00")
$day = $persianCalendar.GetDayOfMonth($now).ToString("00")

$sourceFile = Join-Path -Path $sourceRoot -ChildPath "$year-$month-$day.zip"
$destinationFile = Join-Path -Path $destinationRoot -ChildPath "$year-$month-$day.zip"

try {
    # Archive only .bak files created today
    $bakFiles = Get-ChildItem -Path $sourceRoot -File -Filter *.bak | Where-Object { $_.CreationTime -ge (Get-Date).Date }
    if (-not $bakFiles) {
        Write-Log -Message "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] No .bak files found in '$sourceRoot' to archive. Exiting script." -Type "Error"
        exit 1
    }

    try {
        $bakFiles | Compress-Archive -DestinationPath $sourceFile -Force -ErrorAction Stop
        Write-Log -Message "Files archived successfully: $sourceFile"
    } catch {
        Write-Log -Message "Failed to archive files: $_" -Type "Error"
        exit 1
    }

    # Calculate hash of the source file
    $sourceFileHash = Get-FileHash $sourceFile
    Write-Log -Message "Source file hash calculated: $($sourceFileHash.Hash)"

    # Copy file to destination
    try {
        Copy-Item $sourceFile -Destination $destinationFile -ErrorAction Stop
        Write-Log -Message "File copied successfully to $destinationFile"
    } catch {
        Write-Log -Message "Failed to copy file to destination: $_" -Type "Error"
        exit 1
    }

    $destinationFileHash = Get-FileHash $destinationFile
    Write-Log -Message "Destination file hash calculated: $($destinationFileHash.Hash)"

    # Verify file integrity
    if ($destinationFileHash.Hash -ne $sourceFileHash.Hash) {
        Write-Log -Message "File verification failed. Source and destination hashes do not match." -Type "Error"
        exit 1
    }

    Write-Log -Message "File verification successful. Source and destination hashes match."

    Remove-PSDrive -Name "Z" -Force
    Write-Log -Message "PSDrive removed successfully."
    Write-Log -Message "Script completed successfully $scritName."


} catch {
    Write-Log -Message "An error occurred while executing $($MyInvocation.MyCommand.Path): $_" -Type "Error"
    exit 1
} finally {
        # Restart service again
        Restart-Service -Name "LanmanWorkstation" -Force
        Write-Log -Message "LanmanWorkstation service restarted again."
}