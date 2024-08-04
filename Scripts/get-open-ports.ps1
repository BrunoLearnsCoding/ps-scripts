function Get-OpenPorts {
    param (
        [Parameter(Mandatory=$true)]
        [string]$ComputerName,
        
        [Parameter(Mandatory=$true)]
        [int]$StartPort,
        
        [ValidateRange(0, 65536)]
        [int]$EndPort
    )

    if (-not $EndPort) {
        $EndPort = $StartPort
    }

    if ($StartPort -gt $EndPort) {
        Write-Host "StartPort must be less than EndPort"
        return
    }

    $PortRange = $StartPort..$EndPort

    foreach ($port in $PortRange) {
        $result = Test-NetConnection -ComputerName $ComputerName -Port $port -InformationLevel Quiet

        if ($result -eq $true) {
            Write-Host "Port $port is open on $ComputerName"
        }
    }
}

## Get-OpenPorts -ComputerName 8.8.8.8 -StartPort 447 -EndPort 400