function Format-MatchString {
    param(
        [switch]$CaseSensitive,
        [Parameter(Mandatory = $true)]
        [string]$String,
        [Parameter(Mandatory = $true)]
        [string]$Pattern,
        [string]$Color = 'Green'
    )

    # if ($CaseSensitive -ne $true) {
    #     $option = 
    # }
    $match = [regex]::Match($String, $Pattern, [System.Text.RegularExpressions.RegexOptions]::IgnoreCase)
    while ($match.Success) {
        $before = $String.Substring(0, $match.Index)
        $after = $String.Substring($match.Index + $match.Length)
    
        Write-Host $before -NoNewline
        Write-Host $match.Value -NoNewline -ForegroundColor $Color
    
        # Update the string to the remaining part after the match
        $String = $after
    
        # Find the next match in the remaining string
        $match = [regex]::Match($String, $Pattern)
    }
    Write-Host $String
}

Format-MatchString -String 'Hello World in second World war' -Pattern 'World' -Color 'Red'
