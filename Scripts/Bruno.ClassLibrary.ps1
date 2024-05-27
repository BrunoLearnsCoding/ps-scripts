class Car {
    [string] $Modle
    [string] $Manufacturer
}

class Person {
    [string] $FirstName
    [string] $LastName
}

function Get-Instance {
    [CmdletBinding()]
    param (
        [Parameter(ParameterSetName = 'CarSet')]
        [switch]
        $Car,

        [Parameter(ParameterSetName = 'PersonSet')]
        [switch]
        $Person
    )    


    process {
        switch ($PSCmdlet.ParameterSetName) {
            'CarSet' {
                return [Person]::new()
            }
            'PersonSet' {
                return [Car]::new()
            }
            Default {}
        }
    }
}