# $files = @(
#     @{
#         name='Hasan' 
#         age = 65
#     }
#     @{
#         name='Ali' 
#         age= 41
#     }

# )

# foreach ($file in $files) {
#     Write-Host $file.name, $file.age
# }

function Get-RectangleArea {
    [CmdletBinding()]
    param (
        # Rectengle height
        [Parameter(Mandatory, ValueFromPipeline)]
        [int]
        $Height,
        # Rectengle Width
        [Parameter(Mandatory)]
        [int]
        $Width
    )
    
    begin {
        $Area = 0
        Write-Verbose "Starting calculation"

    }
    
    process {
        if ($Width -le 0 -or $Height -le 0) {
            Write-Error "Width and Height must be greater than 0"
            return
        }
        # Initialize the area
        $Area = $Width * $Height
        Write-Host $Area
    }
    
    end {
        Write-Verbose "Calculation completed"
    }
}

14, 12 | Get-RectangleArea -Width 5 -Verbose
