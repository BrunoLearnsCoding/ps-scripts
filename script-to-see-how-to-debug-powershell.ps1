$files = @(
    @{
        name='Hasan' 
        age = 65
    }
    @{
        name='Ali' 
        age= 41
    }

)

foreach ($file in $files) {
    Write-Host $file.name
}