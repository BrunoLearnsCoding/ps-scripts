function Check-ProgramInstalled {
    param (
        [string]$programName
    )
    try {
        $programPath = Get-Command $programName
        Write-Host "$programName is installed at: $($programPath.Source)"
    } 
    catch {
        Write-Host "$programName is not installed."
    }
}

# Example usage:

function Install-Winget {
    $wingitInstalled = Check-ProgramInstalled "winget"
    if ($wingitInstalled -eq $true) {
        Write-Host "Winget is installed."
        return
    }
    $releaseUrl =  "https://api.github.com/repos/microsoft/winget-cli/releases/latest"
    $releaseData = Invoke-RestMethod -Uri $releaseUrl
    $wingetAsset = $ReleaseData.assets | Where-Object { $_.name -eq "Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle" }

    $fileName = "$($Env:TEMP)\$($wingetAsset.name)"
    Invoke-WebRequest -Uri $wingetAsset.browser_download_url -OutFile $fileName 
    Add-AppxPackage -Path $fileName -Register
}
Install-Winget

function Install-Git {
    $gitInstalled = Check-ProgramInstalled "git"
    if ($gitInstalled -eq $true) {
        Write-Host "Git is installed."
        return
    }

    winget install --id Git.Git -e --source winget
}
Install-Git


