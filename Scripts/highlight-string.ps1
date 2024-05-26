function Highlight-String {
    param(
        [Parameter(Mandatory=$true)]
        [string]$String,
        [Parameter(Mandatory=$true)]
        [string]$Pattern,
        [string]$Color = 'Green'
    )

    $match = [regex]::Match($String, $Pattern)

    if ($match.Success) {
        $before = $String.Substring(0, $match.Index)
        $after = $String.Substring($match.Index + $match.Length)

        Write-Host $before -NoNewline
        Write-Host $match.Value -NoNewline -ForegroundColor $Color
        Write-Host $after
    } else {
        Write-Host $String
    }
}
