function Set-KeyboardLayout {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [ValidateSet("fa-IR", "en-US", "de-DE")]
        [string[]]$Layout
    )

    # $currentLayout = Get-WinUserLanguageList | Select-Object -ExpandProperty InputMethodTips

    if ($currentLayout -contains $Layout) {
        Write-Host "The keyboard layout is already set to $Layout."
    }
    else {
        Set-WinUserLanguageList -LanguageList $Layout -Force -WarningAction Ignore
        Write-Host "The keyboard layout has been set to $Layout."
    }
}