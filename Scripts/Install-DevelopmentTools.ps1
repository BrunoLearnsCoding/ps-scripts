# $programName = "git"

# $installedPrograms = Get-WmiObject -Class Win32_Product | Select-Object -ExpandProperty Name 

# foreach ($installedProgram in $installedPrograms) {
#     if ($installedProgram -match $programName) {
#         Write-Host "$installedProgram is installed."
#     }
# }
# a function to install winget cli
function Install-Winget {
    $releaseUrl =  "https://api.github.com/repos/microsoft/winget-cli/releases/latest"
    $releaseData = Invoke-RestMethod -Uri $releaseUrl
    $assets = $ReleaseData.assets | Where-Object { $_.name -eq "Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle" }

    $assets

    foreach ($asset in $assets) {
        Invoke-WebRequest -Uri $asset.browser_download_url -OutFile "$($Env:TEMP)\$($asset.name)" 
    }

}
Install-Winget



