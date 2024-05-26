<#
.Synopsis
    To format a match string in a text

.DESCRIPTION
    Sometimes you want to highlight a string in an output text. This function satisfies this
    need.

.EXAMPLE
    Format-MatchString -String 'World' -Pattern 'Hello world dear world' -Color 'Red' -CaseSensetive

.NOTES
    Author bruno@ilearncoding.com, https://ilearncoding.com

#>

function Format-MatchString {
    param(
        [switch]$CaseSensitive,
        [Parameter(Mandatory = $true, ValueFromPipeline)]
        [string]$String,
        [Parameter(Mandatory = $true)]
        [string]$Pattern,
        [string]$Color = 'Green'
    )

    process {
        $option = [System.Text.RegularExpressions.RegexOptions]::None
        if ($CaseSensitive -eq $false) {
            $option = [System.Text.RegularExpressions.RegexOptions]::IgnoreCase
        }
        $match = [regex]::Match($String, $Pattern, $option)
        while ($match.Success) {
            $before = $String.Substring(0, $match.Index)
            $after = $String.Substring($match.Index + $match.Length)
        
            Write-Host $before -NoNewline
            Write-Host $match.Value -NoNewline -ForegroundColor $Color
        
            # Update the string to the remaining part after the match
            $String = $after
        
            # Find the next match in the remaining string
            $match = [regex]::Match($String, $Pattern, $option)
        }
        Write-Host $String
    }
}
